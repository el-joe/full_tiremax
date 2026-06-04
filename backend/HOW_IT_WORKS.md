# Iraq Max Tire — Full Project Documentation

> Stack: **Laravel 13 · Livewire 4 · Tailwind CSS 4 · Vite · JWT Auth · Spatie Permission · Astrotomic Translatable**  
> Languages: **Arabic (RTL default) · English**  
> Theme: **Dark stone-950 background + yellow-500 accent**

---

## Table of Contents

1. [Tech Stack & Setup](#1-tech-stack--setup)
2. [Authentication Architecture](#2-authentication-architecture)
3. [Database Tables & Relations](#3-database-tables--relations)
4. [API Reference](#4-api-reference)
5. [Admin Panel](#5-admin-panel)
6. [Seeders & Default Data](#6-seeders--default-data)
7. [Services (Business Logic)](#7-services-business-logic)
8. [Deployment Checklist](#8-deployment-checklist)

---

## 1. Tech Stack & Setup

### Install & Run

```bash
# Install PHP dependencies
composer install

# Install JS dependencies & build assets
npm install && npm run build   # or: yarn && yarn build

# Copy and configure environment
cp .env.example .env
php artisan key:generate

# Configure .env:
#   APP_URL=http://yourdomain.com
#   DB_DATABASE=tiermax
#   DB_USERNAME=...
#   DB_PASSWORD=...
#   JWT_SECRET=...  (run: php artisan jwt:secret)

# Run all migrations and seed default data
php artisan migrate:fresh --seed

# Start dev server
php artisan serve
```

### Key Packages

| Package | Purpose |
|---|---|
| `tymon/jwt-auth` | Stateless JWT tokens for the mobile/API layer |
| `spatie/laravel-permission` | Role & permission system for the `admin` guard |
| `astrotomic/laravel-translatable` | AR/EN translations on a separate `*_translations` table per model |
| `livewire/livewire` v4 | Full-stack reactive components for the admin panel |
| `sweetalert2` (CDN) | Toast notifications & delete-confirmation dialogs |

---

## 2. Authentication Architecture

The project runs **two separate auth guards**:

### 2a. Admin Guard (`admin`)

- Model: `App\Models\Admin` (table: `admins`)
- Guard: `admin` (session-based, defined in `config/auth.php`)
- Login route: `GET/POST /admin/login` → Livewire `Admin\Auth\Login`
- The `AdminAuthenticate` middleware protects all `/admin/*` routes (except login/logout/locale)
- On login: checks `is_active`, calls `Auth::guard('admin')->attempt()`, updates `last_login_at`, regenerates session
- Roles & permissions via Spatie Permission with `guard_name = 'admin'`
- Four roles: `super-admin`, `branch-manager`, `content-manager`, `support`

### 2b. Customer Guard (JWT)

- Model: `App\Models\Customer` (table: `customers`)
- Guard: `api` (stateless JWT, defined in `config/auth.php`)
- All API routes under `/api/v1/` use the `JwtAuthenticate` middleware
- Tokens issued via `tymon/jwt-auth`, refreshable at `POST /api/v1/auth/refresh`
- Guest routes (no token required): `home`, `brands`, `products`, `vehicles`, `fitments`, `governorates`, `services`, `branches`
- Auth required: `cart`, `orders`, `bookings`, `favorites`, `reviews`, `auth/me`

### 2c. Locale Middleware

`SetLocale` reads `Accept-Language` header (API) or `session('locale')` (web/admin).  
Toggle via `POST /admin/locale/{locale}` (web) or `Accept-Language: ar` header (API).  
Supported: `ar` (default, RTL) and `en`.

---

## 3. Database Tables & Relations

### 3a. Entity Relationship Overview

```
admins ────────────────────────────── (Spatie) model_has_roles → roles → permissions
customers ──────────────────────────┐
  ├─ orders ──────────────────────┐ │
  │   ├─ order_items              │ │
  │   ├─ order_status_logs        │ │
  │   └─ bookings (order_id FK)   │ │
  ├─ bookings                     │ │
  ├─ cart ─── cart_items          │ │
  ├─ favorites                    │ │
  ├─ reviews                      │ │
  ├─ whatsapp_logs                │ │
  └─ automation_settings          │ │
                                  │ │
products ───────────────────────────┤ │
  ├─ product_translations         │ │
  ├─ product_images               │ │
  ├─ product_badges               │ │
  ├─ tire_specs (1:1)             │ │
  ├─ battery_specs (1:1)          │ │
  ├─ fitments ─── vehicles        │ │
  │   └─ fitment_translations     │ │
  ├─ favorites ───────────────────┘ │
  ├─ reviews ────────────────────────┘
  ├─ cart_items
  ├─ order_items
  ├─ offer_product
  └─ product_views

vehicles ─── vehicle_models ─── vehicle_makes
  └─ vehicle_translations / model_translations / make_translations

branches ─── branch_translations
  ├─ branch_schedules
  ├─ branch_service (pivot) ─── services
  ├─ orders
  └─ bookings

governorates ─── governorate_translations
  ├─ orders
  └─ carts

brands ─── brand_translations ─── products
categories ─── category_translations ─── products

offers ─── offer_translations
  ├─ offer_product (pivot)
  ├─ offer_governorate (pivot)
  └─ offer_customer (pivot)

whatsapp_templates ─── whatsapp_template_translations ─── whatsapp_logs

settings ─── setting_translations
audit_logs (polymorphic actor → admin or customer)
daftra_sync_logs ─── orders
```

---

### 3b. Table Schemas

#### `admins`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| name | string | |
| email | string unique | |
| phone | string nullable | |
| password | string | bcrypt |
| avatar | string nullable | |
| is_active | boolean | default true |
| last_login_at | timestamp nullable | |
| remember_token | string nullable | |
| created_at / updated_at | timestamps | |
| deleted_at | timestamp nullable | soft delete |

**Relations:** `hasMany(AuditLog)`, Spatie `HasRoles` trait (guard: `admin`)

---

#### `customers`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| name | string | |
| email | string nullable unique | |
| phone | string unique | primary login identifier |
| password | string | |
| locale | string(5) | `ar` \| `en`, default `ar` |
| address | string nullable | |
| is_active | boolean | default true |
| phone_verified_at | timestamp nullable | |
| email_verified_at | timestamp nullable | |
| remember_token | string nullable | |
| created_at / updated_at | timestamps | |
| deleted_at | timestamp nullable | soft delete |

**Relations:** `hasMany(Order)`, `hasMany(Booking)`, `hasOne(Cart)`, `hasMany(Favorite)`, `hasMany(Review)`, `hasMany(WhatsappLog)`, `hasOne(AutomationSetting)`

---

#### `branches` + `branch_translations`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| code | string unique | e.g. `BAS-MAIN` |
| phone | string nullable | |
| email | string nullable | |
| latitude / longitude | decimal(10,7) | GPS coords |
| is_main | boolean | main Basra branch flag |
| is_active | boolean | |
| default_capacity | smallint | bookings per slot |
| auto_confirm_bookings | boolean | |

**Translations (branch_translations):** `name`, `address`, `description`

**Relations:** `hasMany(BranchSchedule)`, `belongsToMany(Service)` via `branch_service`, `hasMany(Order)`, `hasMany(Booking)`

---

#### `branch_schedules`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| branch_id | FK → branches | |
| day_of_week | tinyint | 0=Sunday … 6=Saturday |
| opens_at | time nullable | |
| closes_at | time nullable | |
| capacity | smallint | concurrent bookings |
| is_closed | boolean | holiday override |

Unique: `(branch_id, day_of_week)`

---

#### `governorates` + `governorate_translations`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| code | string unique | e.g. `BAS`, `BGD` |
| is_basra | boolean | Basra = pickup branch, fee=0 |
| shipping_fee | decimal(12,2) | IQD, 0 for Basra |
| is_active | boolean | |
| sort_order | int | display order |

**Translations:** `name`  
18 governorates pre-seeded (see [Seeders](#6-seeders--default-data))

---

#### `brands` + `brand_translations`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| slug | string unique | URL-safe identifier |
| logo | string nullable | storage path |
| country | string nullable | |
| is_active | boolean | |
| sort_order | int | |

**Translations:** `name`, `description`  
**Relations:** `hasMany(Product)`

---

#### `categories` + `category_translations`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| slug | string unique | |
| product_type | string(20) | `tire` \| `battery` |
| icon | string nullable | |
| is_active | boolean | |
| sort_order | int | |

**Translations:** `name`, `description`  
**Relations:** `hasMany(Product)`

---

#### `vehicle_makes` + `vehicle_make_translations`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| slug | string unique | |
| logo | string nullable | |
| is_active | boolean | |
| sort_order | int | |

**Translations:** `name`  
**Relations:** `hasMany(VehicleModel)`

---

#### `vehicle_models` + `vehicle_model_translations`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| vehicle_make_id | FK → vehicle_makes | |
| slug | string | unique per make |
| is_active | boolean | |
| sort_order | int | |

**Translations:** `name`  
**Relations:** `belongsTo(VehicleMake)`, `hasMany(Vehicle)`

---

#### `vehicles` + `vehicle_translations`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| vehicle_model_id | FK → vehicle_models | |
| year_from | smallint | e.g. 2018 |
| year_to | smallint nullable | null = current |
| trim_code | string nullable | e.g. `LE`, `XLE` |
| engine | string nullable | e.g. `2.0L` |
| is_active | boolean | |

**Translations:** `trim_name`, `notes`  
**Relations:** `belongsTo(VehicleModel)`, `hasMany(Fitment)`

---

#### `products` + `product_translations`

Core product table — handles both **tires** and **batteries**.

| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| type | string(20) | `tire` \| `battery` |
| sku | string unique | |
| brand_id | FK → brands | |
| category_id | FK → categories nullable | |
| price | decimal(12,2) | base price IQD |
| sale_price | decimal(12,2) nullable | discounted price |
| cost | decimal(12,2) nullable | purchase cost |
| stock | int | current qty |
| low_stock_threshold | int | default 5 |
| manufacture_year | smallint nullable | |
| manufacturer_warranty_months | smallint nullable | |
| agency_warranty_months | smallint nullable | |
| expert_rating | decimal(3,1) nullable | 0.0–5.0 |
| virtual_sales_count | int | displayed count (marketing) |
| virtual_views_count | int | displayed count (marketing) |
| real_sales_count | int | actual sales |
| real_views_count | int | actual views |
| sort_order | int | |
| is_active | boolean | |
| is_featured | boolean | |

**Translations (product_translations):** `name`, `short_description`, `description`, `pattern_name`, `usage_notes`, `meta_title`, `meta_description`

**Relations:**
- `belongsTo(Brand)`, `belongsTo(Category)`
- `hasOne(TireSpec)` — only set when `type = tire`
- `hasOne(BatterySpec)` — only set when `type = battery`
- `hasMany(ProductImage)`, `hasMany(ProductBadge)`
- `hasMany(Fitment)`, `hasMany(Favorite)`, `hasMany(Review)`
- `belongsToMany(Offer)` via `offer_product`

---

#### `tire_specs` (extends products)
| Column | Type | Notes |
|---|---|---|
| product_id | FK unique | 1:1 with products |
| width | smallint | e.g. 225 |
| aspect_ratio | tinyint | e.g. 45 |
| rim_diameter | tinyint | e.g. 17 |
| load_index | string(10) nullable | e.g. `91V` |
| speed_rating | string(5) nullable | e.g. `V`, `W` |
| usage_type | string(30) nullable | `sport`\|`comfort`\|`off-road`\|`all-season` |
| runflat | boolean | |

Indexed on `(width, aspect_ratio, rim_diameter)` for size-based lookup.

---

#### `battery_specs` (extends products)
| Column | Type | Notes |
|---|---|---|
| product_id | FK unique | 1:1 with products |
| voltage | tinyint | default 12 |
| ampere_hour | smallint | Ah capacity |
| cca | smallint nullable | cold cranking amps |
| battery_type | string(30) nullable | `AGM`\|`EFB`\|`lead-acid` |
| terminal_position | string(20) nullable | `L`\|`R` |
| size_code | string(30) nullable | e.g. `DIN60` |

---

#### `fitments` + `fitment_translations`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| vehicle_id | FK → vehicles | |
| product_id | FK → products | |
| year_from | smallint nullable | sub-range within vehicle years |
| year_to | smallint nullable | |
| trim | string nullable | specific trim override |
| is_alternative | boolean | not OEM but compatible |
| is_excluded | boolean | explicitly incompatible |
| is_oem | boolean | factory-fitted match |

**Translations:** `notes`  
One vehicle can have multiple fitments (OEM + alternatives), one product can fit many vehicles.

---

#### `services` + `service_translations`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| slug | string unique | |
| icon | string nullable | |
| duration_minutes | smallint | default 30 |
| price | decimal(12,2) | base price IQD |
| is_active | boolean | |
| sort_order | int | |

**Translations:** `name`, `description`  
**Relations:** `belongsToMany(Branch)` via `branch_service` (with `price_override` pivot)

---

#### `branch_service` (pivot)
| Column | Notes |
|---|---|
| branch_id | FK |
| service_id | FK |
| price_override | decimal nullable — branch can override service price |
| is_active | boolean |

---

#### `bookings`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| reference | string unique | auto-generated (e.g. `BK-20260501-XXXX`) |
| customer_id | FK → customers | |
| branch_id | FK → branches | |
| service_id | FK → services | |
| order_id | FK → orders nullable | linked if booking tied to a product order |
| scheduled_at | datetime | |
| duration_minutes | smallint | copied from service at time of booking |
| status | string(20) | `pending`\|`confirmed`\|`in_progress`\|`completed`\|`cancelled`\|`no_show` |
| customer_notes | text nullable | |
| admin_notes | text nullable | |

Indexed on `(branch_id, scheduled_at)` and `customer_id` and `status`.

---

#### `carts`
| Column | Notes |
|---|---|
| id | bigint PK |
| customer_id | FK nullable — null for guest sessions |
| session_id | string indexed — identifies guest cart |
| governorate_id | FK nullable — for shipping fee calc |

**Relations:** `hasMany(CartItem)`, `belongsTo(Governorate)`, `belongsTo(Customer)`

---

#### `cart_items`
| Column | Notes |
|---|---|
| cart_id | FK → carts |
| product_id | FK → products |
| quantity | int default 1 |
| unit_price | decimal — locked at time of add |

Unique: `(cart_id, product_id)` — one row per product per cart.

---

#### `orders`
| Column | Type | Notes |
|---|---|---|
| id | bigint PK | |
| reference | string unique | e.g. `ORD-20260501-XXXX` |
| customer_id | FK → customers | |
| governorate_id | FK nullable | |
| branch_id | FK nullable | set for Basra pickup orders |
| type | string(20) | `basra` (pickup) \| `delivery` |
| status | string(30) | see statuses below |
| payment_method | string(30) | `cod` \| future gateways |
| payment_status | string(20) | `pending`\|`paid`\|`refunded` |
| subtotal | decimal(14,2) | |
| discount | decimal(14,2) | from offer code |
| shipping_fee | decimal(14,2) | 0 for Basra |
| installation_fee | decimal(14,2) | |
| total | decimal(14,2) | subtotal − discount + shipping + installation |
| customer_name / phone / email | string | snapshot at order time |
| shipping_address | string nullable | |
| tracking_number | string nullable | |
| daftra_invoice_id/url | string nullable | Daftra ERP integration |
| daftra_meta | json nullable | |
| notes | text nullable | |
| placed_at | timestamp nullable | |

**Order Statuses:**
`pending` → `confirmed` → `processing` → `shipped` → `delivered` → `cancelled` / `refunded`

**Relations:** `belongsTo(Customer)`, `belongsTo(Governorate)`, `belongsTo(Branch)`, `hasMany(OrderItem)`, `hasMany(OrderStatusLog)`, `hasOne(Booking)`

---

#### `order_items`
| Column | Notes |
|---|---|
| order_id | FK |
| product_id | FK |
| product_name | snapshot of name at order time |
| product_sku | snapshot |
| quantity | int |
| unit_price | decimal |
| total | decimal |

---

#### `order_status_logs`
| Column | Notes |
|---|---|
| order_id | FK |
| from_status | string nullable |
| to_status | string |
| note | text nullable |
| actor_type / actor_id | polymorphic (Admin or Customer) |

---

#### `favorites`
Unique `(customer_id, product_id)` — toggle via API.

---

#### `reviews`
| Column | Notes |
|---|---|
| customer_id | FK nullable |
| product_id | FK |
| order_id | FK nullable — enforces "verified purchase" |
| type | `customer` \| `expert` |
| rating | tinyint 1–5 |
| comment | text nullable |
| is_approved | boolean — admin must approve |

---

#### `offers` + `offer_translations`
| Column | Notes |
|---|---|
| code | string unique — promo code entered by customer |
| discount_type | `percent` \| `fixed` |
| discount_value | decimal |
| min_subtotal | decimal — minimum cart value |
| usage_limit | int nullable — null = unlimited |
| used_count | int |
| starts_at / ends_at | datetime nullable |
| is_active | boolean |

**Translations:** `title`, `description`  
**Pivot tables:** `offer_product`, `offer_governorate`, `offer_customer` — scope offer to specific products/regions/customers

---

#### `whatsapp_templates` + `whatsapp_template_translations`
| Column | Notes |
|---|---|
| key | string unique — e.g. `order_confirmed`, `after_3_days`, `after_3_months` |
| trigger_after_days | int nullable — for automated follow-ups |
| is_active | boolean |
| variables | json — list of `{{variable}}` placeholders |

**Translations:** `subject`, `body` (body contains `{{name}}`, `{{order_ref}}` etc.)

---

#### `whatsapp_logs`
| Column | Notes |
|---|---|
| customer_id | FK nullable |
| order_id | FK nullable |
| whatsapp_template_id | FK nullable |
| phone | string — destination number |
| status | `pending`\|`sent`\|`delivered`\|`read`\|`failed` |
| provider_message_id | string nullable |
| body | text — final rendered message |
| response | json — API response from provider |
| sent_at | timestamp nullable |

---

#### `settings` + `setting_translations`
| Column | Notes |
|---|---|
| group | string(50) — e.g. `general`, `shipping`, `whatsapp` |
| key | string unique — e.g. `site_name`, `whatsapp_api_key` |
| value | text nullable — for non-translatable settings |
| cast | `string`\|`int`\|`float`\|`bool`\|`json` |
| is_translatable | boolean |

**Translations (setting_translations):** `value` — for translatable settings (e.g. site description)

---

#### `audit_logs`
| Column | Notes |
|---|---|
| admin_id | FK nullable |
| action | `create`\|`update`\|`delete`\|`login`\|`logout` |
| subject_type / subject_id | polymorphic |
| changes | json — before/after snapshot |
| ip | string(45) |
| user_agent | string |

---

#### `daftra_sync_logs`
| Column | Notes |
|---|---|
| order_id | FK nullable |
| action | `create_invoice`\|`update_status`\|`deduct_stock` |
| status | `pending`\|`success`\|`failed` |
| payload / response | json |
| attempts | smallint |

---

#### `product_views`
| Column | Notes |
|---|---|
| product_id | FK |
| customer_id | FK nullable |
| ip | string(45) |
| user_agent | string |

Indexed on `(product_id, created_at)` for trending queries.

---

#### `cart_abandonments`
| Column | Notes |
|---|---|
| cart_id | FK |
| reminder_sent_at | timestamp nullable |
| recovered | boolean |

Used to trigger WhatsApp re-engagement after cart abandonment.

---

#### `automation_settings`
One row per customer. `is_disabled = true` opts out of all automated WhatsApp messages.

---

## 4. API Reference

Base URL: `/api/v1`  
Auth header (when required): `Authorization: Bearer {jwt_token}`  
Locale: `Accept-Language: ar` or `Accept-Language: en`

All responses follow the envelope:
```json
{
  "success": true,
  "data": { ... },
  "message": "...",
  "meta": { "pagination": {...} }
}
```

### 4a. Auth Endpoints

| Method | URL | Auth | Description |
|---|---|---|---|
| POST | `/auth/register` | — | Register customer (name, phone, email, password) |
| POST | `/auth/login` | — | Login → returns JWT `access_token` + `refresh_token` |
| POST | `/auth/refresh` | Bearer | Refresh expired token |
| GET | `/auth/me` | Bearer | Get current customer profile |
| PUT | `/auth/me` | Bearer | Update name / email / address / locale |
| POST | `/auth/logout` | Bearer | Invalidate token |

---

### 4b. Catalog Endpoints (Public)

| Method | URL | Description |
|---|---|---|
| GET | `/home` | Featured products, top brands, active offers |
| GET | `/brands` | All active brands |
| GET | `/products` | Products list — filters: `type`, `brand_id`, `category_id`, `width`, `aspect_ratio`, `rim_diameter`, `min_price`, `max_price`, `sort`, `search` |
| GET | `/products/{product}` | Product detail with spec, images, badges, fitments |
| GET | `/products/{product}/related` | Related products by type + brand |
| GET | `/governorates` | All active governorates with shipping fees |
| GET | `/branches` | All active branches with schedules |
| GET | `/services` | All active services |

---

### 4c. Vehicle & Fitment Endpoints (Public)

| Method | URL | Description |
|---|---|---|
| GET | `/vehicles/makes` | All active vehicle makes |
| GET | `/vehicles/makes/{make}/models` | Models for a make |
| GET | `/vehicles/models/{model}/years` | Distinct year range for a model |
| GET | `/vehicles` | Vehicles list — filter: `make_id`, `model_id`, `year` |
| GET | `/vehicles/{vehicle}` | Vehicle detail |
| GET | `/fitments/by-vehicle/{vehicle}` | Fitments for a vehicle (tires + batteries) |
| GET | `/fitments/by-size` | Fitments by tire size (`width`, `aspect_ratio`, `rim`) |

---

### 4d. Cart Endpoints (Auth)

| Method | URL | Description |
|---|---|---|
| GET | `/cart` | View current cart with totals |
| POST | `/cart/items` | Add item (`product_id`, `quantity`) |
| PUT | `/cart/items/{item}` | Update quantity |
| DELETE | `/cart/items/{item}` | Remove item |
| DELETE | `/cart` | Clear cart |
| POST | `/cart/apply-offer` | Apply promo code (`code`) |

---

### 4e. Order Endpoints (Auth)

| Method | URL | Description |
|---|---|---|
| GET | `/orders` | Customer's order history |
| POST | `/orders` | Place order from cart (`type`, `governorate_id`, `branch_id`, `notes`) |
| GET | `/orders/{order}` | Order detail |
| POST | `/orders/{order}/cancel` | Customer cancels order |

---

### 4f. Booking Endpoints (Auth)

| Method | URL | Description |
|---|---|---|
| GET | `/bookings` | Customer's bookings |
| POST | `/bookings` | Create booking (`branch_id`, `service_id`, `scheduled_at`, `order_id?`) |
| GET | `/bookings/{booking}` | Booking detail |
| GET | `/bookings/branch/{branch}/slots` | Available time slots for a date (`?date=YYYY-MM-DD`, `service_id`) |
| POST | `/bookings/{booking}/cancel` | Customer cancels booking |

---

### 4g. Other Auth Endpoints

| Method | URL | Description |
|---|---|---|
| GET | `/favorites` | Customer's favorites list |
| POST | `/favorites/{product}/toggle` | Toggle favorite (add/remove) |
| GET | `/reviews/{product}` | Approved reviews for a product |
| POST | `/reviews/{product}` | Submit review (`rating`, `comment`, `order_id?`) |

---

## 5. Admin Panel

URL: `/admin`  
Technology: **Livewire 4** full-stack components, **Tailwind CSS 4**, **SweetAlert2**  
Layout: Dark (`stone-950`) background, yellow (`yellow-500`) accent  
Direction: RTL when Arabic, LTR when English (auto via `dir` attribute on `<html>`)

### 5a. Login

URL: `/admin/login`  
Component: `App\Livewire\Admin\Auth\Login`

- Fields: Email + Password + Remember Me
- Guards: `admin` guard only
- Checks `is_active` flag — inactive admins get an error message
- Updates `last_login_at` on success
- Redirects to `admin.dashboard` (or `intended` URL)

---

### 5b. Dashboard

URL: `/admin` or `/admin/dashboard`  
Component: `App\Livewire\Admin\Dashboard`

**KPI Cards (8 metrics):**
1. Orders Today
2. Pending Orders
3. Revenue This Month (IQD)
4. Bookings Today
5. Low Stock Products (`stock <= low_stock_threshold`)
6. Out of Stock Products (`stock = 0`)
7. Total Customers
8. Total Products

**Bottom Lists:**
- Latest 7 Orders (reference, customer, total, status)
- Latest 7 Bookings (reference, customer, service, scheduled date, status)

---

### 5c. Products

**List page** — URL: `/admin/products`  
Component: `App\Livewire\Admin\Products\ProductManager`

- Search by SKU or name (AR/EN)
- Filter by `type` (tire / battery) and `brand`
- Sortable columns, paginated (15 per page)
- Inline **Toggle Active** button
- Action buttons: Edit → `/admin/products/{id}/edit`, Delete (with confirm)

**Create/Edit form** — URLs: `/admin/products/create`, `/admin/products/{productId}/edit`  
Component: `App\Livewire\Admin\Products\ProductForm`

- General section: SKU, type (tire/battery), brand, category, prices (price, sale_price, cost), stock, low_stock_threshold, warranties, expert rating, sort order, featured flag
- Conditional spec section:
  - **Tire**: width × aspect_ratio × rim_diameter, load index, speed rating, usage type, runflat toggle
  - **Battery**: voltage, Ah, CCA, battery type, terminal position, size code
- Marketing section: virtual sales/views count, badges multi-select (best_seller, best_choice, special_offer, new)
- Translations section: AR + EN tabs — name, short_description, description, pattern_name, usage_notes, meta_title, meta_description
- Save uses `DB::transaction` — atomically persists product + spec + translations + badges

---

### 5d. Fitments

URL: `/admin/fitments`  
Component: `App\Livewire\Admin\Fitments\FitmentManager`

- Filter by Make → Model → Vehicle (cascading dropdowns, URL-bound via `#[Url]`)
- Table shows vehicle, product, year range, trim, OEM/ALT/EXCL flag chips
- Modal form: vehicle selector, product selector (tire/battery filtered), year_from/to, trim, flag toggles, notes (AR/EN)

---

### 5e. Vehicles

**Makes** — URL: `/admin/vehicles/makes`  
Component: `VehicleMakeManager` — CRUD for brands of cars (Toyota, Kia…)

**Models** — URL: `/admin/vehicles/models`  
Component: `VehicleModelManager` — CRUD filtered by make

**Vehicles** — URL: `/admin/vehicles`  
Component: `VehicleManager` — CRUD with cascading Make → Model → year_from/to + trim/engine

---

### 5f. Brands

URL: `/admin/brands`  
Component: `App\Livewire\Admin\Brands\BrandManager`  
CRUD: slug, country, sort_order, is_active, logo upload, AR/EN name + description

---

### 5g. Categories

URL: `/admin/categories`  
Component: `App\Livewire\Admin\Categories\CategoryManager`  
CRUD: slug, product_type (tire/battery), sort_order, is_active, AR/EN name + description

---

### 5h. Orders

URL: `/admin/orders`  
Component: `App\Livewire\Admin\Orders\OrderManager`

- Filter by status and date range
- Inline status pill navigation (each valid next-state clickable)
- Detail modal: customer info, items table, totals breakdown (subtotal / shipping / discount / installation / total), timeline of status changes
- Status changes go through `OrderService::changeStatus` which handles stock restoration on cancellation

**Order Status Flow:**
```
pending → confirmed → processing → shipped → delivered
                                         ↘ cancelled
                              ↘ cancelled
                   ↘ cancelled
         ↘ cancelled
                                    delivered → refunded
```

---

### 5i. Bookings

URL: `/admin/bookings`  
Component: `App\Livewire\Admin\Bookings\BookingManager`

- Filter by branch, status, date
- Inline status `<select>` per row for quick updates
- Statuses: `pending` → `confirmed` → `in_progress` → `completed` / `cancelled` / `no_show`

---

### 5j. Customers

URL: `/admin/customers`  
Component: `App\Livewire\Admin\Customers\CustomerManager`

- Search by name / phone / email
- Toggle `is_active` inline
- Soft-delete support

---

### 5k. Branches

URL: `/admin/branches`  
Component: `App\Livewire\Admin\Branches\BranchManager`

- CRUD: code, GPS coords, capacity, auto_confirm flag, is_main, is_active
- AR/EN name, address, description
- Schedule tab: set opens_at / closes_at / capacity / is_closed for each day of week

---

### 5l. Governorates

URL: `/admin/governorates`  
Component: `App\Livewire\Admin\Governorates\GovernorateManager`

- CRUD: code, shipping_fee (IQD), is_basra flag, sort_order, is_active
- AR/EN name

---

### 5m. Services

URL: `/admin/services`  
Component: `App\Livewire\Admin\Services\ServiceManager`

- CRUD: slug, duration_minutes, price, is_active, sort_order
- AR/EN name + description
- Multi-branch assignment with price override

---

### 5n. Offers

URL: `/admin/offers`  
Component: `App\Livewire\Admin\Offers\OfferManager`

- CRUD: code, discount_type (percent/fixed), discount_value, min_subtotal, usage_limit, starts_at, ends_at, is_active
- AR/EN title + description
- Scope to specific products / governorates / customers via pivot tables

---

### 5o. Admin Panel UX Patterns

**Toast Notifications:**  
Dispatched from PHP: `$this->dispatch('toast', icon: 'success', title: __('messages.saved'))`  
Displayed via SweetAlert2 (`position: top-start` for RTL, `top-end` for LTR)

**Delete Confirmation:**  
PHP side: `$this->dispatch('confirm-delete', id: $id)`  
JS side: SweetAlert confirm dialog → on confirm → `Livewire.dispatch('delete-confirmed', { id })`  
PHP side: `#[On('delete-confirmed')]` method performs the soft/hard delete

**WithCrudList Trait** (`app/Livewire/Concerns/WithCrudList.php`):  
All list components use this shared trait providing:
- `WithPagination` (resets on search change)
- `#[Url(as: 'q')] public string $search` — URL-bound search
- `public string $sortBy = 'id'`, `$sortDir = 'desc'`
- `public ?int $editingId` — tracks which row's modal is open
- `sort($column)` — toggles direction
- `toast($message, $icon)` helper

---

## 6. Seeders & Default Data

Run with: `php artisan db:seed` (or `php artisan migrate:fresh --seed`)

### Execution Order (DatabaseSeeder.php)
1. `RolePermissionSeeder`
2. `AdminSeeder`
3. `GovernorateSeeder`
4. `BrandSeeder`
5. `CategorySeeder`
6. `BranchAndServiceSeeder`

---

### RolePermissionSeeder
Creates **15 permissions** (guard: `admin`):

| Permission |
|---|
| view products / manage products |
| view orders / manage orders |
| view bookings / manage bookings |
| view customers / manage customers |
| view reports |
| manage branches / manage services |
| manage vehicles / manage fitments |
| manage offers |
| manage settings |

Creates **4 roles** (guard: `admin`) with assigned permissions:

| Role | Permissions |
|---|---|
| `super-admin` | All 15 permissions |
| `branch-manager` | view/manage bookings, view/manage orders, view customers, manage branches, manage services |
| `content-manager` | view/manage products, manage vehicles, manage fitments, manage offers |
| `support` | view orders, view bookings, view customers, view reports |

---

### AdminSeeder
Creates the default super-admin account:

| Field | Value |
|---|---|
| Name | Admin |
| Email | `admin@iraqmaxtire.iq` |
| Password | `password` (**change in production!**) |
| Role | `super-admin` |
| is_active | true |

---

### GovernorateSeeder
18 Iraqi governorates with shipping fees (IQD):

| Code | Name (AR) | Shipping Fee |
|---|---|---|
| BAS | البصرة | 0 (is_basra=true) |
| BGD | بغداد | 25,000 |
| NJF | النجف | 20,000 |
| KAR | كربلاء | 20,000 |
| DHQ | ذي قار | 18,000 |
| MUT | المثنى | 22,000 |
| MYS | ميسان | 18,000 |
| WAS | واسط | 18,000 |
| BAB | بابل | 20,000 |
| QAD | القادسية | 20,000 |
| DIY | ديالى | 22,000 |
| ANB | الأنبار | 28,000 |
| SAL | صلاح الدين | 25,000 |
| NIN | نينوى | 30,000 |
| KIR | كركوك | 27,000 |
| ERB | أربيل | 30,000 |
| SUL | السليمانية | 30,000 |
| DUH | دهوك | 32,000 |

---

### BrandSeeder
14 brands (12 tire + 2 battery):

**Tires:** Michelin, Bridgestone, Continental, Pirelli, Goodyear, Dunlop, Yokohama, Hankook, Kumho, Toyo, Falken, Maxxis  
**Batteries:** Varta, Bosch

---

### CategorySeeder
6 categories:

| Slug | Type | AR Name |
|---|---|---|
| summer-tires | tire | إطارات صيفية |
| winter-tires | tire | إطارات شتوية |
| off-road-tires | tire | إطارات طرق وعرة |
| all-season-tires | tire | إطارات جميع المواسم |
| standard-batteries | battery | بطاريات عادية |
| agm-batteries | battery | بطاريات AGM |

---

### BranchAndServiceSeeder
**Main Branch (Basra):**
- Code: `BAS-MAIN`
- Location: 30.5081° N, 47.7804° E
- `is_main = true`, `auto_confirm_bookings = false`, capacity: 3

**6 Services:**

| Service | Duration | Price (IQD) |
|---|---|---|
| Tire Installation | 30 min | 5,000 |
| Wheel Balancing | 20 min | 7,000 |
| Wheel Alignment | 45 min | 15,000 |
| Battery Replacement | 20 min | 5,000 |
| Tire Rotation | 30 min | 5,000 |
| Puncture Repair | 20 min | 3,000 |

---

## 7. Services (Business Logic)

All service classes live in `app/Services/`.

### AuthService
- `register(array $data): Customer` — creates customer, hashes password
- `login(array $credentials): string` — validates credentials, returns JWT token
- `refresh(): string` — refreshes token via jwt-auth
- `logout(): void` — invalidates current token
- `updateProfile(Customer $customer, array $data): Customer`

### ProductService
- `getList(array $filters)` — paginated, filterable, translatable
- `getById(int $id): Product`
- `getRelated(Product $product): Collection`
- `incrementView(Product $product, ?Customer $customer, string $ip): void`

### VehicleService
- `getMakes()`, `getModels(VehicleMake $make)`, `getYears(VehicleModel $model)`
- `getList(array $filters)`, `getById(int $id): Vehicle`

### FitmentService
- `byVehicle(Vehicle $vehicle): Collection`
- `bySize(int $width, int $aspectRatio, int $rim): Collection`

### CartService
- `getOrCreate(Customer $customer): Cart`
- `addItem(Cart $cart, int $productId, int $qty): CartItem`
- `updateItem(CartItem $item, int $qty): CartItem`
- `removeItem(CartItem $item): void`
- `clear(Cart $cart): void`
- `applyOffer(Cart $cart, string $code): Cart` — validates offer rules, stores on session
- `totals(Cart $cart): array` — returns `subtotal`, `discount`, `shipping_fee`, `installation_fee`, `total`

### OrderService
- `placeFromCart(Cart $cart, array $data, Customer $customer): Order` — wraps in `DB::transaction`, deducts stock, clears cart, dispatches `OrderPlaced` event, triggers Daftra sync queue job
- `changeStatus(Order $order, string $status): Order` — validates transition, logs to `order_status_logs`, restores stock on cancellation, dispatches WhatsApp notification
- `cancel(Order $order, Customer $customer): Order`

### BookingService
- `availableSlots(Branch $branch, Service $service, string $date): array` — checks schedule, existing bookings, capacity
- `book(array $data, Customer $customer): Booking`
- `changeStatus(Booking $booking, string $status): Booking`
- `cancel(Booking $booking, Customer $customer): Booking`

---

## 8. Deployment Checklist

```bash
# 1. Clone & install
git clone ... && cd tiermax
composer install --no-dev --optimize-autoloader
npm install && npm run build

# 2. Environment
cp .env.example .env
php artisan key:generate
php artisan jwt:secret
# Edit .env: DB_*, APP_URL, QUEUE_CONNECTION=database (or redis)

# 3. Database
php artisan migrate --force --seed

# 4. Storage
php artisan storage:link
chmod -R 775 storage bootstrap/cache

# 5. Cache
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache

# 6. Queue worker (for WhatsApp / Daftra sync jobs)
php artisan queue:work --tries=3 --timeout=60

# 7. Scheduler (for automation reminders)
# Add to crontab:
# * * * * * cd /var/www/tiermax && php artisan schedule:run >> /dev/null 2>&1

# 8. CHANGE DEFAULT ADMIN PASSWORD
# Login at /admin/login with admin@iraqmaxtire.iq / password
# Change immediately via profile settings
```

### Required `.env` Keys

```env
APP_NAME="Iraq Max Tire"
APP_URL=https://yourdomain.com
APP_LOCALE=ar

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=tiermax
DB_USERNAME=...
DB_PASSWORD=...

JWT_SECRET=...          # php artisan jwt:secret
JWT_TTL=1440            # token lifetime in minutes (24h)
JWT_REFRESH_TTL=20160   # refresh window in minutes (2 weeks)

QUEUE_CONNECTION=database

# WhatsApp API (Meta / 3rd-party provider)
WHATSAPP_API_URL=...
WHATSAPP_API_TOKEN=...
WHATSAPP_FROM_NUMBER=...

# Daftra ERP
DAFTRA_API_URL=...
DAFTRA_API_KEY=...
DAFTRA_ACCOUNT_HASH=...
```

---

*Generated: May 2026 | Iraq Max Tire v1.0*
