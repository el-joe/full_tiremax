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


    }
}
