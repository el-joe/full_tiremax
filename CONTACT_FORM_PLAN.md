# Contact Form: API + Admin CRUD + Frontend Wiring

## Findings
- `frontend/components/shared/ContactUsForm.tsx` only does `console.log(data)`. The inputs aren't registered with react-hook-form.
- No contact endpoint, model, migration or admin module exists in `backend/`.
- Backend: Laravel, JSON API under `/api/v1` (`backend/routes/api.php`), responses via `App\Support\ApiResponse`.
- Admin: Livewire managers in `app/Livewire/Admin/*` using the `WithCrudList` and `AuthorizesAdmin` traits.
  - Views are in `resources/views/livewire/admin/*`.
  - Routes are in `routes/web.php`, e.g. `reviews`, guarded with `can:reviews.view`.
  - Permissions are seeded in `database/seeders/RolePermissionSeeder.php`.
  - `ReviewManager` is the closest reference.
- Frontend: Next.js, Chakra, react-hook-form, react-query, `utils/axiosInstance`, zod schemas in `frontend/Schemas/`. See `WriteReviewForm.tsx` for the useMutation + toast pattern. Read `frontend/AGENTS.md` first.

## API contract (shared by both agents)
`POST /api/v1/contact-messages`
- Public, no auth. Throttled with `throttle:5,1`.
- Body: `name` (required, max 120), `phone` (required, max 30), `subject` (required, max 190), `message` (required, max 5000).
- Success: 201 `ApiResponse::created(null, __('messages.contact_message_sent'))`.
- Validation errors: 422 in the standard Laravel format.
- Optionally attach `customer_id` if a JWT user is present (`jwt.optional`).

Table `contact_messages`:
- `id`
- `customer_id` (nullable FK, nullOnDelete)
- `name`
- `phone`
- `subject`
- `message` (text)
- `status` (enum/string: `new`|`read`|`replied`|`archived`, default `new`)
- `admin_notes` (text, nullable)
- `ip_address` (nullable)
- timestamps

## Task A: Backend (agent 1)
1. Migration, `ContactMessage` model (fillable, `NormalizesPhone` if it fits) and `StoreContactMessageRequest`.
2. `Api/ContactMessageController@store` and the route in `api.php`.
3. Lang keys (en and ar) in `lang/*/messages.php`: `contact_message_sent` and all admin labels (`admin.contact_messages`, `subject`, `message`, `new`, `read`, `replied`, `archived`, `admin_notes`, and so on). Reuse existing keys where they exist.
4. Admin CRUD module `ContactMessages/ContactMessageManager` plus a blade view:
   - List with search (name, phone, subject), status filter, sort, pagination.
   - View modal or detail with the full message.
   - Change status, edit admin notes, delete with confirm.
   - Mark as read when opened.
   - Create is not needed because messages come from the public form.
5. Permissions `contact_messages.view`, `contact_messages.manage`, `contact_messages.delete`. Add them to the seeder for the relevant roles and write a migration or seeder step so existing DBs get them. Check how `migrate_manage_permissions_to_granular` does it.
6. Admin route in `web.php` and a sidebar nav entry (find where reviews is listed in the admin layout), with a count badge of `new` messages if the sidebar supports badges.
7. Add the endpoint to `TireMax_API.postman_collection.json`.
8. Verify: run `php artisan migrate` (check the DB config first and say so if it can't run), `php artisan route:list --path=contact`, and hit the endpoint (valid and invalid payloads) with curl or a tinker test. Confirm the Livewire component renders (a feature test or tinker is enough). Run the existing test suite if one exists.

## Task B: Frontend (agent 2)
1. Add `frontend/Schemas/contactSchema.ts` (zod, matching the contract; messages via i18n if the other schemas do it).
2. Rewrite `ContactUsForm.tsx`:
   - Register all 4 fields with `register`, `err` and `errMes`, using the zod resolver.
   - `useMutation` that POSTs to `contact-messages` through `axiosInstance`.
   - Disable the button and show loading while pending.
   - Success: toast and `reset()`.
   - Error: toast the server message and map 422 field errors onto the form.
   - Keep the existing layout and styling unchanged.
3. Add any new strings (success, error, validation) to `locale/en.json` and `locale/ar.json`.
4. Verify with `npx tsc --noEmit` and `npm run lint` on touched files. Don't run a full build unless it's cheap.

## Task C: Integration check (main agent)
- Review both diffs, run the backend and frontend checks, and post a real submission to the endpoint.
- Confirm that it appears in the admin list.
- Report any step that couldn't be verified.
