<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // \App\Models\User::factory(10)->create();
        $this->call(UsersTableSeeder::class);
        $this->call(BranchTableSeeder::class);
        $this->call(BranchRoomTableSeeder::class);
        $this->call(CompanyTableSeeder::class);
        $this->call(CustomersTableSeeder::class);
        $this->call(DepartmentsTableSeeder::class);
        $this->call(InvoiceDetailTableSeeder::class);
        $this->call(InvoiceMasterTableSeeder::class);
        $this->call(JobTitleTableSeeder::class);
        $this->call(ModelHasPermissionsTableSeeder::class);
        $this->call(ModelHasRolesTableSeeder::class);
        $this->call(OrderDetailTableSeeder::class);
        $this->call(OrderMasterTableSeeder::class);
        $this->call(PeriodTableSeeder::class);
        $this->call(PeriodStockTableSeeder::class);
        $this->call(PermissionsTableSeeder::class);
        $this->call(SettingsTableSeeder::class);
        $this->call(RolesTableSeeder::class);
        $this->call(RoleHasPermissionsTableSeeder::class);
        $this->call(UsersBranchTableSeeder::class);
        $this->call(ProductSkuTableSeeder::class);
        $this->call(ProductBrandTableSeeder::class);
        $this->call(ProductCategoryTableSeeder::class);
    }
}
