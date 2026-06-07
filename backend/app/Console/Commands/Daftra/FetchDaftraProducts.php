<?php

namespace App\Console\Commands\Daftra;

use App\Integrations\Daftra;
use Illuminate\Console\Attributes\Description;
use Illuminate\Console\Attributes\Signature;
use Illuminate\Console\Command;

#[Signature('daftra:fetch-products {--page=1 : Page number} {--limit=50 : Items per page}')]
#[Description('Fetch products from Daftra and display them')]
class FetchDaftraProducts extends Command
{
    public function handle(): int
    {
        $page = (int) $this->option('page');
        $limit = (int) $this->option('limit');

        $this->info("Fetching Daftra products (page {$page}, limit {$limit})...");

        try {
            $response = app(Daftra::class)->listProducts($page, $limit);
        } catch (\RuntimeException $e) {
            $this->error($e->getMessage());
            return Command::FAILURE;
        }
        $products = $response['data'] ?? [];
        $pagination = $response['pagination'] ?? [];

        if (empty($products)) {
            $this->warn('No products found.');
            return Command::SUCCESS;
        }

        $rows = [];
        foreach ($products as $item) {
            $p = $item['Product'] ?? $item;
            $stock = (int) array_sum(array_column($p['ProductStock'] ?? [], 'balance'));
            $catName = $p['ProductCategory'][0]['name'] ?? '-';

            $rows[] = [
                $p['id'],
                mb_strimwidth($p['name'] ?? '', 0, 40, '…'),
                $p['brand'] ?: '-',
                $catName,
                $p['product_code'] ?: '-',
                $p['unit_price'] ?? '-',
                $p['buy_price'] ?? '-',
                $stock,
            ];
        }

        $this->table(
            ['ID', 'Name', 'Brand', 'Category', 'SKU', 'Price', 'Cost', 'Stock'],
            $rows
        );

        $this->line(sprintf(
            '<fg=cyan>Page %d of %d</> | Total: <fg=yellow>%d</> products',
            $pagination['page'] ?? $page,
            $pagination['page_count'] ?? 1,
            $pagination['total_results'] ?? count($rows)
        ));

        return Command::SUCCESS;
    }
}
