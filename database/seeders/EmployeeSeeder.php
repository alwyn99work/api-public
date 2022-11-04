<?php

namespace Database\Seeders;

use App\Models\Employee;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\File;

class EmployeeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Employee::truncate();
  
        $json = File::get("database/seeders/data/employee.json");
        $countries = json_decode($json);
  
        foreach ($countries as $key => $value) {
            Employee::create([
                "employee_id" => $value->id,
                "employee_name" => $value->name,
                "employee_manager_id" => $value->manager_id
            ]);
        }
    }
}
