#requires -Version 5.1
<#
  SIP-IB - Pembangun struktur target Laravel (tanpa kode implementasi)
  Jalankan di ROOT Project-Laravel-main:
  powershell -NoProfile -ExecutionPolicy Bypass -File .\setup-sipib.ps1
  Optional: -TanpaOpsional / -TanpaTandaiFileLama
  Owner: Anggota 4 (koordinasi semua anggota)
#>
[CmdletBinding()]
param(
    [switch]$TanpaOpsional,
    [switch]$TanpaTandaiFileLama
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding($false)
if (-not (Test-Path -LiteralPath (Join-Path $root "artisan") -PathType Leaf) -or
    -not (Test-Path -LiteralPath (Join-Path $root "composer.json") -PathType Leaf)) {
    throw "Letakkan setup-sipib.ps1 di ROOT folder Laravel yang memiliki artisan dan composer.json."
}

# File penting yang tidak boleh dibuat sebagai file kosong jika proyek Laravel tidak lengkap.
$criticalCore = @(
    'artisan',
    'composer.json',
    'composer.lock',
    'package.json',
    'package-lock.json',
    'phpunit.xml',
    'vite.config.js',
    'public/index.php',
    'bootstrap/app.php',
    'bootstrap/providers.php'
)

# Daftar folder diambil dari STRUKTUR_FOLDER_SIP_IB_4_ANGGOTA.md.
$folders = @(
    @{ Path = '.github'; Scope = 'Wajib' }
    @{ Path = 'app'; Scope = 'Wajib' }
    @{ Path = 'bootstrap'; Scope = 'Wajib' }
    @{ Path = 'config'; Scope = 'Wajib' }
    @{ Path = 'database'; Scope = 'Wajib' }
    @{ Path = 'docs'; Scope = 'Wajib' }
    @{ Path = 'public'; Scope = 'Wajib' }
    @{ Path = 'resources'; Scope = 'Wajib' }
    @{ Path = 'routes'; Scope = 'Wajib' }
    @{ Path = 'storage'; Scope = 'Wajib' }
    @{ Path = 'tests'; Scope = 'Wajib' }
    @{ Path = '.github/workflows'; Scope = 'Wajib' }
    @{ Path = 'app/Enums'; Scope = 'Wajib' }
    @{ Path = 'app/Http'; Scope = 'Wajib' }
    @{ Path = 'app/Models'; Scope = 'Wajib' }
    @{ Path = 'app/Policies'; Scope = 'Wajib' }
    @{ Path = 'app/Providers'; Scope = 'Wajib' }
    @{ Path = 'app/Scopes'; Scope = 'Wajib' }
    @{ Path = 'app/Services'; Scope = 'Wajib' }
    @{ Path = 'app/Support'; Scope = 'Wajib' }
    @{ Path = 'app/Traits'; Scope = 'Wajib' }
    @{ Path = 'bootstrap/cache'; Scope = 'Wajib' }
    @{ Path = 'database/factories'; Scope = 'Wajib' }
    @{ Path = 'database/migrations'; Scope = 'Wajib' }
    @{ Path = 'database/seeders'; Scope = 'Wajib' }
    @{ Path = 'docs/architecture'; Scope = 'Wajib' }
    @{ Path = 'docs/business-rules'; Scope = 'Wajib' }
    @{ Path = 'docs/database'; Scope = 'Wajib' }
    @{ Path = 'docs/interoperability'; Scope = 'Opsional' }
    @{ Path = 'docs/setup'; Scope = 'Wajib' }
    @{ Path = 'docs/verification'; Scope = 'Wajib' }
    @{ Path = 'public/images'; Scope = 'Wajib' }
    @{ Path = 'resources/css'; Scope = 'Wajib' }
    @{ Path = 'resources/js'; Scope = 'Wajib' }
    @{ Path = 'resources/views'; Scope = 'Wajib' }
    @{ Path = 'storage/app'; Scope = 'Wajib' }
    @{ Path = 'storage/framework'; Scope = 'Wajib' }
    @{ Path = 'storage/logs'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature'; Scope = 'Wajib' }
    @{ Path = 'tests/Unit'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Middleware'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Resources'; Scope = 'Opsional' }
    @{ Path = 'app/Services/Audit'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Auth'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Exports'; Scope = 'Opsional' }
    @{ Path = 'app/Services/Imports'; Scope = 'Opsional' }
    @{ Path = 'app/Services/Inventory'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Reports'; Scope = 'Wajib' }
    @{ Path = 'resources/views/auth'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client'; Scope = 'Wajib' }
    @{ Path = 'resources/views/components'; Scope = 'Wajib' }
    @{ Path = 'resources/views/errors'; Scope = 'Wajib' }
    @{ Path = 'resources/views/layouts'; Scope = 'Wajib' }
    @{ Path = 'resources/views/partials'; Scope = 'Wajib' }
    @{ Path = 'resources/views/platform'; Scope = 'Wajib' }
    @{ Path = 'storage/app/private'; Scope = 'Wajib' }
    @{ Path = 'storage/app/public'; Scope = 'Wajib' }
    @{ Path = 'storage/framework/cache'; Scope = 'Wajib' }
    @{ Path = 'storage/framework/sessions'; Scope = 'Wajib' }
    @{ Path = 'storage/framework/testing'; Scope = 'Wajib' }
    @{ Path = 'storage/framework/views'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Api'; Scope = 'Opsional' }
    @{ Path = 'tests/Feature/Auth'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Inventory'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Master'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Platform'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Reports'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Security'; Scope = 'Wajib' }
    @{ Path = 'tests/Unit/Services'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Api'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Controllers/Auth'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Platform'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Auth'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Platform'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Resources/Api'; Scope = 'Opsional' }
    @{ Path = 'resources/views/client/account'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/dashboard'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/reports'; Scope = 'Wajib' }
    @{ Path = 'resources/views/platform/audit-logs'; Scope = 'Opsional' }
    @{ Path = 'resources/views/platform/clients'; Scope = 'Wajib' }
    @{ Path = 'resources/views/platform/dashboard'; Scope = 'Wajib' }
    @{ Path = 'storage/framework/cache/data'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Api/V1'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Controllers/Client/Exports'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Controllers/Client/Imports'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Controllers/Client/Inventory'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Master'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Reports'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Inventory'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Master'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Reports'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Resources/Api/V1'; Scope = 'Opsional' }
    @{ Path = 'resources/views/client/inventory/adjustments'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/balances'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/history'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/low-stock'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/opening'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/opnames'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/stock-in'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/stock-out'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/transfers'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/warehouses'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/brands'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/categories'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/items'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/units'; Scope = 'Wajib' }
)

# Setiap baris: path relatif, PIC, lingkup. Semua file dari struktur sumber tercakup.
$files = @(
    @{ Path = '.github/workflows/tests.yml'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = '.github/pull_request_template.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Enums/UserRole.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'app/Enums/StockTransactionType.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'app/Enums/StockOpnameStatus.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'app/Enums/OpnameItemStatus.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Controller.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Auth/LoginController.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Auth/RegisterClientController.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Auth/LogoutController.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Platform/DashboardController.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Platform/ClientController.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/DashboardController.php'; Pic = 'Anggota 1 & 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/AccountController.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Master/CategoryController.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Master/BrandController.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Master/UnitController.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Master/ItemController.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Inventory/WarehouseController.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Inventory/StockBalanceController.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Inventory/OpeningStockController.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Inventory/StockInController.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Inventory/StockOutController.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Inventory/StockTransferController.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Inventory/StockAdjustmentController.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Inventory/StockHistoryController.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Inventory/StockOpnameController.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Inventory/StockOpnameDetailController.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Reports/StockReportController.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Reports/InOutReportController.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Reports/ItemHistoryReportController.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Reports/WarehouseTransferReportController.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Client/Reports/ReportSummaryController.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Middleware/EnsureUserIsActive.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Middleware/EnsureClientIsActive.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Middleware/EnsureUserRole.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Middleware/SetClientContext.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Auth/LoginRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Auth/RegisterClientRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Platform/UpdateClientStatusRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/UpdateAccountRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Master/StoreCategoryRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Master/UpdateCategoryRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Master/StoreBrandRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Master/UpdateBrandRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Master/StoreUnitRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Master/UpdateUnitRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Master/StoreItemRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Master/UpdateItemRequest.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Inventory/StoreWarehouseRequest.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Inventory/UpdateWarehouseRequest.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Inventory/StoreOpeningStockRequest.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Inventory/StoreStockInRequest.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Inventory/StoreStockOutRequest.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Inventory/StoreStockTransferRequest.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Inventory/StoreStockAdjustmentRequest.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Inventory/StoreStockOpnameRequest.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Inventory/UpdateStockOpnameDetailRequest.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Inventory/ConfirmStockOpnameRequest.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Requests/Client/Reports/ReportFilterRequest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/Client.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/User.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/Category.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/Brand.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/Unit.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/Warehouse.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/Item.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/StockBalance.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/StockTransaction.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/StockOpname.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/StockOpnameDetail.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Models/AuditLog.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Policies/ClientPolicy.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Policies/UserPolicy.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Policies/CategoryPolicy.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Policies/BrandPolicy.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Policies/UnitPolicy.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Policies/ItemPolicy.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Policies/WarehousePolicy.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Policies/StockTransactionPolicy.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Policies/StockOpnamePolicy.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Policies/ReportPolicy.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Providers/AppServiceProvider.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Scopes/ClientScope.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Auth/ClientRegistrationService.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Inventory/StockMovementService.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Inventory/OpeningStockService.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Inventory/StockTransferService.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Inventory/StockAdjustmentService.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Inventory/StockOpnameService.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Reports/StockReportService.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Reports/StockMovementReportService.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Reports/WarehouseTransferReportService.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Services/Audit/AuditLogService.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Support/ClientContext.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'app/Traits/BelongsToClient.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'bootstrap/app.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'bootstrap/providers.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'bootstrap/cache/.gitignore'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/app.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/auth.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/broadcasting.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/cache.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/database.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/filesystems.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/logging.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/mail.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/queue.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/reverb.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/services.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/session.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'config/sipib.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/factories/ClientFactory.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/factories/UserFactory.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/factories/CategoryFactory.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/factories/BrandFactory.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/factories/UnitFactory.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/factories/WarehouseFactory.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/factories/ItemFactory.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/factories/StockBalanceFactory.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/factories/StockOpnameFactory.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/0001_01_01_000000_create_users_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/0001_01_01_000001_create_cache_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/0001_01_01_000002_create_jobs_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000001_create_tb_clients_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000002_create_tb_users_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000003_create_tb_categories_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000004_create_tb_brands_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000005_create_tb_units_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000006_create_tb_warehouses_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000007_create_tb_items_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000008_create_tb_stock_balances_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000009_create_tb_stock_transactions_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000010_create_tb_stock_opnames_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000011_create_tb_stock_opname_details_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/migrations/2026_10_29_000012_create_tb_audit_logs_table.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/seeders/DatabaseSeeder.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/seeders/PlatformAdminSeeder.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/seeders/DemoClientSeeder.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/seeders/DemoMasterSeeder.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/seeders/DemoInventorySeeder.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'database/.gitignore'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/README.md'; Pic = 'Anggota 1 & 4'; Scope = 'Wajib' }
    @{ Path = 'docs/setup/INSTALL_WINDOWS.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/setup/DATABASE_LOCAL.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/setup/GIT_WORKFLOW.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/architecture/STRUCTURE.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/architecture/MODULE_OWNERS.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/architecture/ROUTE_MAP.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/architecture/DATABASE_DESIGN.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/architecture/CLIENT_ISOLATION.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/business-rules/STOCK_MUTATION.md'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'docs/business-rules/STOCK_TRANSFER.md'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'docs/business-rules/STOCK_OPNAME.md'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'docs/verification/REQUIREMENT_TEST_MATRIX.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/verification/TEST_RESULTS.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/verification/DEMO_SCENARIOS.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'docs/database/sip_ib_multi_client.sql'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'public/.htaccess'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'public/index.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'public/favicon.ico'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'public/robots.txt'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'public/images/logo-sipib.svg'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'public/images/empty-state.svg'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/css/app.css'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/css/auth.css'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/css/layout.css'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/css/components.css'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/css/master.css'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/css/inventory.css'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/css/reports.css'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/js/app.js'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/js/echo.js'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/js/confirm-actions.js'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/js/form-validation.js'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/js/table-filters.js'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/js/stock-opname.js'; Pic = 'Anggota 1 & 3'; Scope = 'Wajib' }
    @{ Path = 'resources/js/report-filters.js'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/welcome.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/layouts/app.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/layouts/guest.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/layouts/platform.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/layouts/client.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/components/⚡counter.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/components/flash-message.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/components/form-errors.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/components/status-badge.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/components/stock-status-badge.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/components/empty-state.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/components/confirm-modal.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/components/pagination.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/partials/navbar.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/partials/sidebar-platform.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/partials/sidebar-client.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/partials/breadcrumbs.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/partials/footer.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/auth/login.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/auth/register-client.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/platform/dashboard/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/platform/clients/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/platform/clients/show.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/dashboard/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/account/edit.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/categories/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/categories/create.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/categories/edit.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/brands/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/brands/create.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/brands/edit.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/units/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/units/create.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/units/edit.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/items/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/items/create.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/items/edit.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/master/items/show.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/warehouses/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/warehouses/create.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/warehouses/edit.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/warehouses/show.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/balances/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/balances/by-warehouse.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/balances/by-item.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/opening/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/opening/create.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/stock-in/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/stock-in/create.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/stock-in/show.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/stock-out/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/stock-out/create.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/stock-out/show.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/transfers/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/transfers/create.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/transfers/show.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/adjustments/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/adjustments/create.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/adjustments/show.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/opnames/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/opnames/create.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/opnames/count.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/opnames/show.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/history/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/history/show.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/inventory/low-stock/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/reports/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/reports/stock.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/reports/in-out.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/reports/item-history.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/reports/warehouse-transfer.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/client/reports/summary.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/errors/403.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/errors/404.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/errors/419.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'resources/views/errors/500.blade.php'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'routes/web.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'routes/auth.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'routes/platform.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'routes/client.php'; Pic = 'Anggota 2'; Scope = 'Wajib' }
    @{ Path = 'routes/inventory.php'; Pic = 'Anggota 3'; Scope = 'Wajib' }
    @{ Path = 'routes/reports.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'routes/channels.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'routes/console.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/TestCase.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/ExampleTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Auth/LoginTest.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Auth/LogoutTest.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Auth/RegisterClientTest.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Auth/RoleAuthorizationTest.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Platform/ClientListTest.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Platform/ClientStatusTest.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Master/CategoryTest.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Master/BrandTest.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Master/UnitTest.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Master/ItemTest.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Master/ItemSearchFilterTest.php'; Pic = 'Anggota 2 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Inventory/WarehouseTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Inventory/StockBalanceTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Inventory/OpeningStockTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Inventory/StockInTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Inventory/StockOutTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Inventory/StockTransferTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Inventory/StockAdjustmentTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Inventory/StockOpnameTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Inventory/StockHistoryTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Inventory/LowStockTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Reports/StockReportTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Reports/InOutReportTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Reports/ItemHistoryReportTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Reports/WarehouseTransferReportTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Reports/ReportFilterTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Security/ClientDataIsolationTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Security/CrossClientTransferTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Security/DirectUrlAuthorizationTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Feature/Security/StockNonNegativeTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Unit/Services/StockMovementServiceTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Unit/Services/StockTransferServiceTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Unit/Services/StockOpnameServiceTest.php'; Pic = 'Anggota 3 & 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Unit/ClientScopeTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'tests/Unit/ExampleTest.php'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = '.editorconfig'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = '.env.example'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = '.gitattributes'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = '.gitignore'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = '.npmrc'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'AGENTS.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'CLAUDE.md'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'artisan'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'composer.json'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'composer.lock'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'package.json'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'package-lock.json'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'phpunit.xml'; Pic = 'Anggota 4'; Scope = 'Wajib' }
    @{ Path = 'README.md'; Pic = 'Anggota 1 & 4'; Scope = 'Wajib' }
    @{ Path = 'vite.config.js'; Pic = 'Anggota 1'; Scope = 'Wajib' }
    @{ Path = 'app/Http/Controllers/Api/V1/ItemApiController.php'; Pic = 'Anggota 2, 3 & 4'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Controllers/Api/V1/WarehouseApiController.php'; Pic = 'Anggota 2, 3 & 4'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Controllers/Api/V1/StockApiController.php'; Pic = 'Anggota 2, 3 & 4'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Controllers/Client/Imports/ItemImportController.php'; Pic = 'Anggota 2'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Controllers/Client/Exports/ReportExportController.php'; Pic = 'Anggota 4'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Controllers/Platform/AuditLogController.php'; Pic = 'Anggota 4'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Resources/Api/V1/ItemResource.php'; Pic = 'Anggota 4'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Resources/Api/V1/WarehouseResource.php'; Pic = 'Anggota 4'; Scope = 'Opsional' }
    @{ Path = 'app/Http/Resources/Api/V1/StockBalanceResource.php'; Pic = 'Anggota 4'; Scope = 'Opsional' }
    @{ Path = 'app/Services/Imports/ItemCsvImportService.php'; Pic = 'Anggota 2'; Scope = 'Opsional' }
    @{ Path = 'app/Services/Exports/StockCsvExportService.php'; Pic = 'Anggota 4'; Scope = 'Opsional' }
    @{ Path = 'app/Services/Exports/StockPdfExportService.php'; Pic = 'Anggota 4'; Scope = 'Opsional' }
    @{ Path = 'resources/views/client/master/items/import.blade.php'; Pic = 'Anggota 1'; Scope = 'Opsional' }
    @{ Path = 'resources/views/platform/audit-logs/index.blade.php'; Pic = 'Anggota 1'; Scope = 'Opsional' }
    @{ Path = 'routes/api.php'; Pic = 'Anggota 4'; Scope = 'Opsional' }
    @{ Path = 'tests/Feature/Api/ItemApiTest.php'; Pic = 'Anggota 4'; Scope = 'Opsional' }
    @{ Path = 'tests/Feature/Api/WarehouseApiTest.php'; Pic = 'Anggota 4'; Scope = 'Opsional' }
    @{ Path = 'tests/Feature/Api/ClientApiIsolationTest.php'; Pic = 'Anggota 4'; Scope = 'Opsional' }
    @{ Path = 'docs/interoperability/API_SPEC.md'; Pic = 'Anggota 4'; Scope = 'Opsional' }
)

function Get-Header([string]$relativePath, [string]$pic, [string]$scope) {
    $label = "SIP-IB | PIC: $pic | Lingkup: $scope | Isi implementasi oleh PIC"
    if ($relativePath.EndsWith(".blade.php")) { return "{{-- $label --}}" }
    $ext = [IO.Path]::GetExtension($relativePath).ToLowerInvariant()
    if ($ext -eq ".php" -or $relativePath -eq "artisan") { return "// $label" }
    if ($ext -eq ".js" -or $ext -eq ".css") { return "/* $label */" }
    if ($ext -eq ".sql") { return "-- $label" }
    if ($ext -eq ".md" -or $ext -eq ".svg") { return "<!-- $label -->" }
    if ($ext -eq ".yml" -or $ext -eq ".yaml" -or $ext -eq ".sh") { return "# $label" }
    if ($relativePath -eq ".htaccess" -or $relativePath -eq ".npmrc" -or
        $relativePath -eq ".env.example" -or $relativePath -eq ".gitignore" -or
        $relativePath -eq ".gitattributes" -or $relativePath -eq ".editorconfig" -or
        $relativePath.EndsWith("/.gitignore")) { return "# $label" }
    return $null  # JSON, XML, .ico dan format lain: PIC ada di CSV, jangan merusak format
}

function Save-NewPlaceholder([string]$target, [string]$relativePath, [string]$header) {
    if ($null -eq $header) {
        if ([IO.Path]::GetExtension($relativePath).ToLowerInvariant() -eq ".json") {
            [IO.File]::WriteAllText($target, "{}" + [Environment]::NewLine, $utf8)
        } else {
            [IO.File]::WriteAllBytes($target, [byte[]]@())
        }
        return
    }
    $newline = [Environment]::NewLine
    if ([IO.Path]::GetExtension($relativePath).ToLowerInvariant() -eq ".php" -and
        -not $relativePath.EndsWith(".blade.php")) {
        $content = "<?php" + $newline + $newline + $header + $newline
    } else {
        $content = $header + $newline
    }
    [IO.File]::WriteAllText($target, $content, $utf8)
}

function Add-OwnerToExistingFile([string]$target, [string]$relativePath, [string]$header) {
    if ($null -eq $header) { return $false }
    # File komponen Livewire bawaan bisa memiliki aturan kompilasi khusus.
    if ($relativePath -like "resources/views/components/*counter.blade.php") { return $false }
    $original = [IO.File]::ReadAllText($target, [Text.Encoding]::UTF8)
    if ($original.Contains("SIP-IB | PIC:")) { return $false }
    $newline = if ($original.Contains("`r`n")) { "`r`n" } else { "`n" }
    if (($relativePath.EndsWith(".php") -and -not $relativePath.EndsWith(".blade.php")) -or
        $relativePath -eq "artisan") {
        $m = [regex]::Match($original, "<\?php[ \t]*\r?\n")
        if (-not $m.Success) { return $false }
        # Setelah tag <?php agar tidak menyebabkan output sebelum PHP/HTTP headers.
        $newText = $original.Insert($m.Index + $m.Length, $header + $newline)
    } elseif ($relativePath -eq ".env.example" -or $relativePath.EndsWith(".yml")) {
        $newText = $header + $newline + $original
    } else {
        $newText = $header + $newline + $original
    }
    [IO.File]::WriteAllText($target, $newText, $utf8)
    return $true
}

$dirsCreated = 0
$filesCreated = 0
$filesTagged = 0
$filesUnchanged = 0
$filesSkipped = 0
$inventory = New-Object "System.Collections.Generic.List[object]"

foreach ($entry in $folders) {
    $relativePath = [string]$entry.Path
    $scope = [string]$entry.Scope
    if ($TanpaOpsional -and $scope -eq "Opsional") { continue }
    $target = Join-Path $root ($relativePath.Replace("/", [IO.Path]::DirectorySeparatorChar))
    if (-not [IO.Directory]::Exists($target)) {
        [void][IO.Directory]::CreateDirectory($target)
        $dirsCreated++
    }
}

foreach ($entry in $files) {
    $relativePath = [string]$entry.Path
    $pic = [string]$entry.Pic
    $scope = [string]$entry.Scope
    if ($TanpaOpsional -and $scope -eq "Opsional") { continue }
    $target = Join-Path $root ($relativePath.Replace("/", [IO.Path]::DirectorySeparatorChar))
    $parent = [IO.Path]::GetDirectoryName($target)
    if (-not [IO.Directory]::Exists($parent)) { [void][IO.Directory]::CreateDirectory($parent); $dirsCreated++ }
    $header = Get-Header $relativePath $pic $scope
    $state = "Sudah ada; tetap"
    if ([IO.File]::Exists($target)) {
        if (-not $TanpaTandaiFileLama -and (Add-OwnerToExistingFile $target $relativePath $header)) {
            $filesTagged++; $state = "Sudah ada; diberi komentar PIC"
        } else {
            $filesUnchanged++; $state = "Sudah ada; PIC di CSV"
        }
    } elseif ($criticalCore -contains $relativePath) {
        Write-Warning "File inti Laravel tidak ditemukan; tidak membuat placeholder palsu: $relativePath"
        $filesSkipped++; $state = "File inti belum ada; dilewati"
    } else {
        Save-NewPlaceholder $target $relativePath $header
        $filesCreated++; $state = "Baru dibuat; siap diisi"
    }
    $inventory.Add([pscustomobject]@{
        File = $relativePath
        PenanggungJawab = $pic
        Lingkup = $scope
        Kondisi = $state
    })
}

$manifest = Join-Path $root "docs/FILE_OWNERSHIP.csv"
$inventory | Export-Csv -LiteralPath $manifest -Delimiter ";" -NoTypeInformation -Encoding UTF8
Write-Host ""
Write-Host "========== SIP-IB: Struktur siap diisi ==========" -ForegroundColor Green
Write-Host "Root                 : $root"
Write-Host "Folder baru          : $dirsCreated"
Write-Host "File placeholder baru: $filesCreated"
Write-Host "File lama diberi PIC : $filesTagged"
Write-Host "File lama tetap      : $filesUnchanged"
Write-Host "File inti dilewati   : $filesSkipped"
Write-Host "Total PIC terdaftar  : $($inventory.Count)"
Write-Host "Daftar kepemilikan   : docs/FILE_OWNERSHIP.csv" -ForegroundColor Cyan
Write-Host "Catatan: placeholder belum berisi implementasi. Jangan php artisan migrate sampai migration diisi." -ForegroundColor Yellow
Write-Host "Jangan commit .env / vendor / node_modules / data sensitif." -ForegroundColor Yellow
