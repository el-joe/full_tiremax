<?php

namespace Tests\Feature\Admin;

use App\Livewire\Admin\WhatsappTemplates\WhatsappTemplateManager;
use Database\Seeders\WhatsappTemplateSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class WhatsappTemplatePageTest extends TestCase
{
    use RefreshDatabase, ActingAsAdmin;

    public function test_shows_translated_names_variables_and_trigger_days(): void
    {
        $this->seed(WhatsappTemplateSeeder::class);
        $this->actingAsAdmin(['whatsapp.view', 'whatsapp.update']);

        Livewire::test(WhatsappTemplateManager::class)
            ->assertSee('Booking Reminder')
            ->assertSee('Review Request')
            ->assertSee('customer_name')
            ->assertSee(__('messages.admin.trigger_after_days'));
    }
}
