<?php

namespace Tests\Feature\Admin;

use App\Livewire\Admin\ContactMessages\ContactMessageManager;
use App\Models\ContactMessage;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class ContactMessageTest extends TestCase
{
    use RefreshDatabase, ActingAsAdmin;

    private array $payload = ['name' => 'Ali', 'phone' => '+9647701234567', 'subject' => 'Hi', 'message' => 'Hello'];

    public function test_public_endpoint_stores_message(): void
    {
        $this->postJson('/api/v1/contact-messages', $this->payload)->assertCreated()->assertJsonPath('success', true);
        $this->assertDatabaseHas('contact_messages', ['name' => 'Ali', 'status' => 'new']);
    }

    public function test_public_endpoint_validates(): void
    {
        $this->postJson('/api/v1/contact-messages', [])->assertStatus(422)
            ->assertJsonValidationErrors(['name', 'phone', 'subject', 'message']);
    }

    public function test_manager_lists_filters_views_and_deletes(): void
    {
        $this->actingAsAdmin(['contact_messages.view', 'contact_messages.manage', 'contact_messages.delete']);
        $a = ContactMessage::create($this->payload);
        $b = ContactMessage::create([...$this->payload, 'name' => 'Zed', 'status' => 'archived']);

        Livewire::test(ContactMessageManager::class)
            ->assertSee('Ali')->assertSee('Zed')
            ->set('status', 'archived')->assertDontSee('Ali')->assertSee('Zed')
            ->set('status', '')->set('search', 'Ali')->assertSee('Ali')->assertDontSee('Zed')
            ->call('view', $a->id)->assertSee('Hello')
            ->set('adminNotes', 'called')->call('saveNotes')
            ->call('setStatus', $a->id, 'replied')
            ->call('delete', $b->id);

        $this->assertSame('replied', $a->fresh()->status);
        $this->assertSame('called', $a->fresh()->admin_notes);
        $this->assertNull($b->fresh());
    }

    public function test_requires_permission(): void
    {
        $this->actingAsAdmin(['contact_messages.view']);
        $m = ContactMessage::create($this->payload);
        Livewire::test(ContactMessageManager::class)->call('delete', $m->id)->assertForbidden();
        $this->assertNotNull($m->fresh());
    }
}
