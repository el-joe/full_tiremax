<?php

namespace App\Integrations;

use App\Models\Setting;
use Illuminate\Http\Client\PendingRequest;
use Illuminate\Http\Client\Response;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use RuntimeException;

/**
 * Daftra ERP API client.
 *
 * All methods map 1-to-1 to Daftra REST endpoints.
 * Credentials are resolved from the `settings` table via the helpers below.
 * Throw RuntimeException when the integration is disabled or unconfigured.
 *
 * Daftra base URL pattern:  https://{account_hash}.daftra.com/api2
 * Auth header:              Apikey {api_key}
 */
class Daftra
{
    private string $baseUrl;
    private string $apiKey;

    public function __construct(?string $baseUrl = null, ?string $apiKey = null)
    {
        $this->baseUrl = rtrim($baseUrl ?? Setting::where('group', 'daftra')->where('key', 'api_url')->value('value') ?? '', '/');
        $this->apiKey = $apiKey ?? Setting::where('group', 'daftra')->where('key', 'api_key')->value('value') ?? '';

        if (empty($this->baseUrl) || empty($this->apiKey)) {
            throw new RuntimeException('Daftra integration is not configured (missing api_url or api_key).');
        }
    }

    // ──────────────────────────────────────────────────────────────────────────
    // HTTP client
    // ──────────────────────────────────────────────────────────────────────────

    private function http($version = 'v1'): PendingRequest
    {
        if ($version === 'v2') {
            $url = str_replace('/api2', '/v2/api', $this->baseUrl);
            return Http::baseUrl($url)
                ->withHeaders(['Apikey' => $this->apiKey])
                ->acceptJson()
                ->timeout(30);
        }
        return Http::baseUrl($this->baseUrl)
            ->withHeaders(['Apikey' => $this->apiKey])
            ->acceptJson()
            ->timeout(30);
    }

    /**
     * Throw on non-2xx; return the decoded body.
     */
    private function unwrap(Response $response): array
    {
        if ($response->failed()) {
            Log::error('Daftra API error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);
            $response->throw();
        }

        return $response->json() ?? [];
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Clients  /clients
    // ──────────────────────────────────────────────────────────────────────────

    /** List all clients (paginated). */
    public function listClients(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/clients', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single client. */
    public function getClient(int $id): array
    {
        return $this->unwrap($this->http()->get("/clients/{$id}"));
    }

    /** Create a new client. */
    public function createClient(array $data): array
    {
        return $this->unwrap($this->http()->post('/clients', ['Client' => $data]));
    }

    /** Update an existing client. */
    public function updateClient(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/clients/{$id}", ['Client' => $data]));
    }

    /** Delete a client. */
    public function deleteClient(int $id): array
    {
        return $this->unwrap($this->http()->delete("/clients/{$id}"));
    }

    /** Search clients by keyword. */
    public function searchClients(string $query, int $page = 1): array
    {
        return $this->unwrap($this->http()->get('/clients', ['search' => $query, 'page' => $page]));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Invoices  /invoices
    // ──────────────────────────────────────────────────────────────────────────

    /** List all invoices. */
    public function listInvoices(int $page = 1, int $limit = 50, array $filters = []): array
    {
        return $this->unwrap($this->http()->get('/invoices', array_merge(['page' => $page, 'limit' => $limit], $filters)));
    }

    /** Get a single invoice. */
    public function getInvoice(int $id): array
    {
        return $this->unwrap($this->http()->get("/invoices/{$id}"));
    }

    /** Create a sales invoice. */
    public function createInvoice(array $data): array
    {
        return $this->unwrap($this->http()->post('/invoices', ['Invoice' => $data]));
    }

    /** Update an invoice. */
    public function updateInvoice(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/invoices/{$id}", ['Invoice' => $data]));
    }

    /** Delete an invoice. */
    public function deleteInvoice(int $id): array
    {
        return $this->unwrap($this->http()->delete("/invoices/{$id}"));
    }

    /** Send an invoice by email. */
    public function sendInvoiceByEmail(int $id, string $email): array
    {
        return $this->unwrap($this->http()->post("/invoices/{$id}/send_by_email", ['email' => $email]));
    }

    /** Get the public view URL for an invoice. */
    public function getInvoiceUrl(int $id): string
    {
        $data = $this->getInvoice($id);
        return $data['Invoice']['invoice_url'] ?? "{$this->baseUrl}/invoices/{$id}";
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Payments  /payments (receipts)
    // ──────────────────────────────────────────────────────────────────────────

    /** List all payments/receipts. */
    public function listPayments(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/payments', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single payment. */
    public function getPayment(int $id): array
    {
        return $this->unwrap($this->http()->get("/payments/{$id}"));
    }

    /** Create a payment record. */
    public function createPayment(array $data): array
    {
        return $this->unwrap($this->http()->post('/payments', ['Payment' => $data]));
    }

    /** Update a payment. */
    public function updatePayment(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/payments/{$id}", ['Payment' => $data]));
    }

    /** Delete a payment. */
    public function deletePayment(int $id): array
    {
        return $this->unwrap($this->http()->delete("/payments/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Products  /products
    // ──────────────────────────────────────────────────────────────────────────

    /** List all products. */
    public function listProducts(int $page = 1, int $limit = 50, array $filters = []): array
    {
        return $this->unwrap($this->http()->get('/products', array_merge(['page' => $page, 'limit' => $limit], $filters)));
    }

    /** Get a single product. */
    public function getProduct(int $id): array
    {
        return $this->unwrap($this->http()->get("/products/{$id}"));
    }

    /** Create a product. */
    public function createProduct(array $data): array
    {
        return $this->unwrap($this->http()->post('/products', ['Product' => $data]));
    }

    /** Update a product. */
    public function updateProduct(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/products/{$id}", ['Product' => $data]));
    }

    /** Delete a product. */
    public function deleteProduct(int $id): array
    {
        return $this->unwrap($this->http()->delete("/products/{$id}"));
    }

    /** Search products. */
    public function searchProducts(string $query, int $page = 1): array
    {
        return $this->unwrap($this->http()->get('/products', ['search' => $query, 'page' => $page]));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Stock / Inventory  /stock_transactions
    // ──────────────────────────────────────────────────────────────────────────

    /** List stock transactions. */
    public function listStockTransactions(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/stock_transactions', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single stock transaction. */
    public function getStockTransaction(int $id): array
    {
        return $this->unwrap($this->http()->get("/stock_transactions/{$id}"));
    }

    /** Create a stock transaction (e.g. purchase/receive). */
    public function createStockTransaction(array $data): array
    {
        return $this->unwrap($this->http()->post('/stock_transactions', ['StockTransaction' => $data]));
    }

    /** Update a stock transaction. */
    public function updateStockTransaction(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/stock_transactions/{$id}", ['StockTransaction' => $data]));
    }

    /** Delete a stock transaction. */
    public function deleteStockTransaction(int $id): array
    {
        return $this->unwrap($this->http()->delete("/stock_transactions/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Expenses  /expenses
    // ──────────────────────────────────────────────────────────────────────────

    /** List expenses. */
    public function listExpenses(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/expenses', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single expense. */
    public function getExpense(int $id): array
    {
        return $this->unwrap($this->http()->get("/expenses/{$id}"));
    }

    /** Create an expense. */
    public function createExpense(array $data): array
    {
        return $this->unwrap($this->http()->post('/expenses', ['Expense' => $data]));
    }

    /** Update an expense. */
    public function updateExpense(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/expenses/{$id}", ['Expense' => $data]));
    }

    /** Delete an expense. */
    public function deleteExpense(int $id): array
    {
        return $this->unwrap($this->http()->delete("/expenses/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Suppliers  /suppliers
    // ──────────────────────────────────────────────────────────────────────────

    /** List suppliers. */
    public function listSuppliers(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/suppliers', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single supplier. */
    public function getSupplier(int $id): array
    {
        return $this->unwrap($this->http()->get("/suppliers/{$id}"));
    }

    /** Create a supplier. */
    public function createSupplier(array $data): array
    {
        return $this->unwrap($this->http()->post('/suppliers', ['Supplier' => $data]));
    }

    /** Update a supplier. */
    public function updateSupplier(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/suppliers/{$id}", ['Supplier' => $data]));
    }

    /** Delete a supplier. */
    public function deleteSupplier(int $id): array
    {
        return $this->unwrap($this->http()->delete("/suppliers/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Purchase Orders  /purchase_invoices
    // ──────────────────────────────────────────────────────────────────────────

    /** List purchase invoices. */
    public function listPurchaseInvoices(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/purchase_invoices', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single purchase invoice. */
    public function getPurchaseInvoice(int $id): array
    {
        return $this->unwrap($this->http()->get("/purchase_invoices/{$id}"));
    }

    /** Create a purchase invoice. */
    public function createPurchaseInvoice(array $data): array
    {
        return $this->unwrap($this->http()->post('/purchase_invoices', ['PurchaseInvoice' => $data]));
    }

    /** Update a purchase invoice. */
    public function updatePurchaseInvoice(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/purchase_invoices/{$id}", ['PurchaseInvoice' => $data]));
    }

    /** Delete a purchase invoice. */
    public function deletePurchaseInvoice(int $id): array
    {
        return $this->unwrap($this->http()->delete("/purchase_invoices/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Accounts / Chart of Accounts  /accounts
    // ──────────────────────────────────────────────────────────────────────────

    /** List accounts. */
    public function listAccounts(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/accounts', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single account. */
    public function getAccount(int $id): array
    {
        return $this->unwrap($this->http()->get("/accounts/{$id}"));
    }

    /** Create an account. */
    public function createAccount(array $data): array
    {
        return $this->unwrap($this->http()->post('/accounts', ['Account' => $data]));
    }

    /** Update an account. */
    public function updateAccount(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/accounts/{$id}", ['Account' => $data]));
    }

    /** Delete an account. */
    public function deleteAccount(int $id): array
    {
        return $this->unwrap($this->http()->delete("/accounts/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Journal Entries  /journal_entries
    // ──────────────────────────────────────────────────────────────────────────

    /** List journal entries. */
    public function listJournalEntries(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/journal_entries', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single journal entry. */
    public function getJournalEntry(int $id): array
    {
        return $this->unwrap($this->http()->get("/journal_entries/{$id}"));
    }

    /** Create a journal entry. */
    public function createJournalEntry(array $data): array
    {
        return $this->unwrap($this->http()->post('/journal_entries', ['JournalEntry' => $data]));
    }

    /** Update a journal entry. */
    public function updateJournalEntry(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/journal_entries/{$id}", ['JournalEntry' => $data]));
    }

    /** Delete a journal entry. */
    public function deleteJournalEntry(int $id): array
    {
        return $this->unwrap($this->http()->delete("/journal_entries/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Taxes  /taxes
    // ──────────────────────────────────────────────────────────────────────────

    /** List taxes. */
    public function listTaxes(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/taxes', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single tax. */
    public function getTax(int $id): array
    {
        return $this->unwrap($this->http()->get("/taxes/{$id}"));
    }

    /** Create a tax. */
    public function createTax(array $data): array
    {
        return $this->unwrap($this->http()->post('/taxes', ['Tax' => $data]));
    }

    /** Update a tax. */
    public function updateTax(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/taxes/{$id}", ['Tax' => $data]));
    }

    /** Delete a tax. */
    public function deleteTax(int $id): array
    {
        return $this->unwrap($this->http()->delete("/taxes/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Price Lists  /price_lists
    // ──────────────────────────────────────────────────────────────────────────

    /** List price lists. */
    public function listPriceLists(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/price_lists', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single price list. */
    public function getPriceList(int $id): array
    {
        return $this->unwrap($this->http()->get("/price_lists/{$id}"));
    }

    /** Create a price list. */
    public function createPriceList(array $data): array
    {
        return $this->unwrap($this->http()->post('/price_lists', ['PriceList' => $data]));
    }

    /** Update a price list. */
    public function updatePriceList(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/price_lists/{$id}", ['PriceList' => $data]));
    }

    /** Delete a price list. */
    public function deletePriceList(int $id): array
    {
        return $this->unwrap($this->http()->delete("/price_lists/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Employees  /employees
    // ──────────────────────────────────────────────────────────────────────────

    /** List employees. */
    public function listEmployees(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/employees', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single employee. */
    public function getEmployee(int $id): array
    {
        return $this->unwrap($this->http()->get("/employees/{$id}"));
    }

    /** Create an employee. */
    public function createEmployee(array $data): array
    {
        return $this->unwrap($this->http()->post('/employees', ['Employee' => $data]));
    }

    /** Update an employee. */
    public function updateEmployee(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/employees/{$id}", ['Employee' => $data]));
    }

    /** Delete an employee. */
    public function deleteEmployee(int $id): array
    {
        return $this->unwrap($this->http()->delete("/employees/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Warehouses  /warehouses
    // ──────────────────────────────────────────────────────────────────────────

    /** List warehouses. */
    public function listWarehouses(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/warehouses', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single warehouse. */
    public function getWarehouse(int $id): array
    {
        return $this->unwrap($this->http()->get("/warehouses/{$id}"));
    }

    /** Create a warehouse. */
    public function createWarehouse(array $data): array
    {
        return $this->unwrap($this->http()->post('/warehouses', ['Warehouse' => $data]));
    }

    /** Update a warehouse. */
    public function updateWarehouse(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/warehouses/{$id}", ['Warehouse' => $data]));
    }

    /** Delete a warehouse. */
    public function deleteWarehouse(int $id): array
    {
        return $this->unwrap($this->http()->delete("/warehouses/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Quotations (Sales Estimates)  /quotations
    // ──────────────────────────────────────────────────────────────────────────

    /** List quotations. */
    public function listQuotations(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/quotations', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single quotation. */
    public function getQuotation(int $id): array
    {
        return $this->unwrap($this->http()->get("/quotations/{$id}"));
    }

    /** Create a quotation. */
    public function createQuotation(array $data): array
    {
        return $this->unwrap($this->http()->post('/quotations', ['Quotation' => $data]));
    }

    /** Update a quotation. */
    public function updateQuotation(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/quotations/{$id}", ['Quotation' => $data]));
    }

    /** Delete a quotation. */
    public function deleteQuotation(int $id): array
    {
        return $this->unwrap($this->http()->delete("/quotations/{$id}"));
    }

    /** Convert a quotation into an invoice. */
    public function convertQuotationToInvoice(int $id): array
    {
        return $this->unwrap($this->http()->post("/quotations/{$id}/convert_to_invoice"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Credit Notes  /credit_notes
    // ──────────────────────────────────────────────────────────────────────────

    /** List credit notes. */
    public function listCreditNotes(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/credit_notes', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single credit note. */
    public function getCreditNote(int $id): array
    {
        return $this->unwrap($this->http()->get("/credit_notes/{$id}"));
    }

    /** Create a credit note (return / refund). */
    public function createCreditNote(array $data): array
    {
        return $this->unwrap($this->http()->post('/credit_notes', ['CreditNote' => $data]));
    }

    /** Update a credit note. */
    public function updateCreditNote(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/credit_notes/{$id}", ['CreditNote' => $data]));
    }

    /** Delete a credit note. */
    public function deleteCreditNote(int $id): array
    {
        return $this->unwrap($this->http()->delete("/credit_notes/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Debit Notes  /debit_notes
    // ──────────────────────────────────────────────────────────────────────────

    /** List debit notes. */
    public function listDebitNotes(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/debit_notes', ['page' => $page, 'limit' => $limit]));
    }

    /** Get a single debit note. */
    public function getDebitNote(int $id): array
    {
        return $this->unwrap($this->http()->get("/debit_notes/{$id}"));
    }

    /** Create a debit note. */
    public function createDebitNote(array $data): array
    {
        return $this->unwrap($this->http()->post('/debit_notes', ['DebitNote' => $data]));
    }

    /** Update a debit note. */
    public function updateDebitNote(int $id, array $data): array
    {
        return $this->unwrap($this->http()->put("/debit_notes/{$id}", ['DebitNote' => $data]));
    }

    /** Delete a debit note. */
    public function deleteDebitNote(int $id): array
    {
        return $this->unwrap($this->http()->delete("/debit_notes/{$id}"));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Reports  (read-only)
    // ──────────────────────────────────────────────────────────────────────────

    /** Profit & loss report. */
    public function profitAndLoss(string $startDate, string $endDate): array
    {
        return $this->unwrap($this->http()->get('/reports/profit_and_loss', [
            'start_date' => $startDate,
            'end_date' => $endDate,
        ]));
    }

    /** Balance sheet report. */
    public function balanceSheet(string $date): array
    {
        return $this->unwrap($this->http()->get('/reports/balance_sheet', ['date' => $date]));
    }

    /** Trial balance report. */
    public function trialBalance(string $startDate, string $endDate): array
    {
        return $this->unwrap($this->http()->get('/reports/trial_balance', [
            'start_date' => $startDate,
            'end_date' => $endDate,
        ]));
    }

    /** Cash flow statement. */
    public function cashFlow(string $startDate, string $endDate): array
    {
        return $this->unwrap($this->http()->get('/reports/cash_flow', [
            'start_date' => $startDate,
            'end_date' => $endDate,
        ]));
    }

    /** Inventory/stock report. */
    public function stockReport(array $filters = []): array
    {
        return $this->unwrap($this->http()->get('/reports/stock', $filters));
    }

    /** Sales report. */
    public function salesReport(string $startDate, string $endDate, array $filters = []): array
    {
        return $this->unwrap($this->http()->get('/reports/sales', array_merge([
            'start_date' => $startDate,
            'end_date' => $endDate,
        ], $filters)));
    }

    /** Client statement (aged receivables). */
    public function clientStatement(int $clientId, string $startDate, string $endDate): array
    {
        return $this->unwrap($this->http()->get('/reports/client_statement', [
            'client_id' => $clientId,
            'start_date' => $startDate,
            'end_date' => $endDate,
        ]));
    }

    /** Supplier statement (aged payables). */
    public function supplierStatement(int $supplierId, string $startDate, string $endDate): array
    {
        return $this->unwrap($this->http()->get('/reports/supplier_statement', [
            'supplier_id' => $supplierId,
            'start_date' => $startDate,
            'end_date' => $endDate,
        ]));
    }

    // ──────────────────────────────────────────────────────────────────────────
    // High-level helpers used by the rest of the application
    // ──────────────────────────────────────────────────────────────────────────

    /**
     * Push a TireMax order to Daftra as a sales invoice.
     *
     * Returns the created invoice array on success.
     * The caller is responsible for persisting daftra_invoice_id / daftra_invoice_url.
     *
     * @param  array  $order  Associative array with keys:
     *                        client_id, date, currency_id, invoice_lines[],
     *                        discount, notes, reference_no, etc.
     */
    public function pushOrder(array $order): array
    {
        return $this->createInvoice($order);
    }

    /**
     * Find or create a Daftra client for the given customer data.
     * Searches by email first; creates if not found.
     *
     * @param  array  $customer  Keys: name, email, phone, address, …
     */
    public function findOrCreateClient(array $customer): array
    {
        $results = $this->searchClients($customer['email'] ?? $customer['name']);
        $list = $results['Client'] ?? $results['data'] ?? [];

        if (!empty($list)) {
            return \is_array($list[0]) ? $list[0] : $list;
        }

        $created = $this->createClient($customer);
        return $created['Client'] ?? $created;
    }

    /**
     * Categories CRUD, stock sync, and other helpers can be added here as needed.
     */

    public function listCategories(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http()->get('/product_categories', ['page' => $page, 'limit' => $limit]));
    }

    /**
     * list brands https://.daftra.com/v2/api/entity/brand/list/{{format}}'
     */

    public function listBrands(int $page = 1, int $limit = 50): array
    {
        return $this->unwrap($this->http('v2')->get('/entity/brand/list', ['page' => $page, 'limit' => $limit]));
    }
}
