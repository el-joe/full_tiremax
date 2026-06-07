<?php

namespace App\Console\Commands\Daftra;

use App\Integrations\Daftra;
use App\Services\DaftraProductSyncService;
use Illuminate\Console\Attributes\Description;
use Illuminate\Console\Attributes\Signature;
use Illuminate\Console\Command;
use RuntimeException;

#[Signature('daftra:sync-products
    {--page= : Sync a single specific page (omit to sync all pages)}
    {--limit=50 : Items per page}')]
#[Description('Sync products, brands and categories from Daftra into the local database')]
class SyncDaftraProducts extends Command
{
    public function handle(DaftraProductSyncService $service): int
    {
        try {
            $daftra = app(Daftra::class); // triggers config validation early
        } catch (RuntimeException $e) {
            $this->error($e->getMessage());
            return Command::FAILURE;
        }

        $limit = (int) $this->option('limit');
        $page  = $this->option('page') ? (int) $this->option('page') : null;

        if ($page !== null) {
            return $this->syncSinglePage($service, $page, $limit);
        }

        return $this->syncAllPages($service, $limit);
    }

    // ──────────────────────────────────────────────────────────────────────────

    private function syncSinglePage(DaftraProductSyncService $service, int $page, int $limit): int
    {
        $this->info("Syncing page {$page} (limit {$limit})…");

        $result = $service->syncPage($page, $limit);

        $this->printPageResult($page, $result);

        return $result['errors'] > 0 ? Command::FAILURE : Command::SUCCESS;
    }

    private function syncAllPages(DaftraProductSyncService $service, int $limit): int
    {
        $this->info("Starting full product sync from Daftra (limit {$limit} per page)…");

        $bar = null;

        $result = $service->syncAll($limit, function (int $page, array $pageResult) use (&$bar) {
            $pageCount    = (int) ($pageResult['pagination']['page_count']   ?? 1);
            $totalResults = (int) ($pageResult['pagination']['total_results'] ?? 0);

            if ($bar === null && $pageCount > 1) {
                $bar = $this->output->createProgressBar($pageCount);
                $bar->setFormat(' %current%/%max% pages [%bar%] %percent:3s%%  synced: %message%');
                $bar->start();
            }

            if ($bar) {
                $bar->setMessage($pageResult['synced'] . ' ok, ' . $pageResult['errors'] . ' err');
                $bar->advance();
            } else {
                $this->printPageResult($page, $pageResult);
            }
        });

        if ($bar) {
            $bar->finish();
            $this->newLine();
        }

        $this->info(sprintf(
            'Done. Synced: <fg=green>%d</> | Errors: <fg=red>%d</>',
            $result['synced'],
            $result['errors']
        ));

        return $result['errors'] > 0 ? Command::FAILURE : Command::SUCCESS;
    }

    private function printPageResult(int $page, array $result): void
    {
        $pag = $result['pagination'];

        $this->line(sprintf(
            '  Page <fg=cyan>%d/%d</>  synced=<fg=green>%d</>  errors=<fg=red>%d</>  total=%d',
            $pag['page']         ?? $page,
            $pag['page_count']   ?? '?',
            $result['synced'],
            $result['errors'],
            $pag['total_results'] ?? '?'
        ));
    }
}
