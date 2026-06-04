<?php

namespace Database\Seeders;

use App\Models\Fitment;
use App\Models\Product;
use App\Models\Vehicle;
use App\Models\VehicleMake;
use App\Models\VehicleModel;
use Illuminate\Database\Seeder;

class FitmentSeeder extends Seeder
{
    public function run(): void
    {
        // ── Product lookup by SKU ──────────────────────────────────────────
        $p = Product::all()->keyBy('sku');

        // ── Vehicle lookup helper ─────────────────────────────────────────
        // Returns Vehicle given [make_slug, model_slug, year_from, trim_code]
        $vehicle = function (string $make, string $model, int $yearFrom, string $trim) {
            $makeModel = VehicleModel::whereHas('make', fn($q) => $q->where('slug', $make))
                ->where('slug', $model)
                ->first();
            return $makeModel
                ? Vehicle::where('vehicle_model_id', $makeModel->id)
                    ->where('year_from', $yearFrom)
                    ->where('trim_code', $trim)
                    ->first()
                : null;
        };

        // ── Fitment map: [product_sku, make, model, year_from, trim, is_oem, is_alt, is_excl] ──
        $fitments = [
            // ── 195/65R15 tires ──────────────────────────────────────────
            // Bridgestone T005 195/65R15
            ['BRG-TUR-T005-195-65-15', 'toyota', 'corolla', 2014, 'EX', true, false, false, 'OEM fit for Corolla 2014-2019'],
            ['BRG-TUR-T005-195-65-15', 'toyota', 'corolla', 2020, 'SE', false, true, false, null],
            ['BRG-TUR-T005-195-65-15', 'kia', 'cerato', 2013, 'LX', true, false, false, 'OEM fit for Cerato 2013-2018'],
            ['BRG-TUR-T005-195-65-15', 'hyundai', 'elantra', 2011, 'GL', true, false, false, null],
            ['BRG-TUR-T005-195-65-15', 'nissan', 'sunny', 2011, 'SV', true, false, false, null],

            // Goodyear EGP2 195/65R15
            ['GDY-EGP2-195-65-15', 'toyota', 'corolla', 2014, 'EX', false, true, false, null],
            ['GDY-EGP2-195-65-15', 'kia', 'cerato', 2013, 'LX', false, true, false, null],
            ['GDY-EGP2-195-65-15', 'hyundai', 'elantra', 2011, 'GL', false, true, false, null],
            ['GDY-EGP2-195-65-15', 'nissan', 'sunny', 2011, 'SV', false, true, false, null],

            // Hankook KE2 195/65R15
            ['HNK-KE2-195-65-15', 'toyota', 'corolla', 2014, 'EX', false, true, false, null],
            ['HNK-KE2-195-65-15', 'kia', 'cerato', 2013, 'LX', false, true, false, null],
            ['HNK-KE2-195-65-15', 'hyundai', 'elantra', 2011, 'GL', false, true, false, null],

            // ── 205/55R16 tires ──────────────────────────────────────────
            // Michelin Primacy 4 205/55R16
            ['MCH-PRI4-205-55-16', 'kia', 'cerato', 2019, 'EX', true, false, false, 'OEM fit for Cerato 2019+'],
            ['MCH-PRI4-205-55-16', 'hyundai', 'elantra', 2017, 'GLS', true, false, false, null],
            ['MCH-PRI4-205-55-16', 'honda', 'accord', 2013, 'EX', false, true, false, null],
            ['MCH-PRI4-205-55-16', 'nissan', 'altima', 2013, 'S', false, true, false, null],
            ['MCH-PRI4-205-55-16', 'toyota', 'camry', 2012, 'GL', false, true, false, null],

            // Continental PC6 205/55R16
            ['CNT-PC6-205-55-16', 'kia', 'cerato', 2019, 'EX', false, true, false, null],
            ['CNT-PC6-205-55-16', 'hyundai', 'elantra', 2017, 'GLS', false, true, false, null],
            ['CNT-PC6-205-55-16', 'honda', 'accord', 2013, 'EX', false, true, false, null],
            ['CNT-PC6-205-55-16', 'nissan', 'altima', 2013, 'S', false, true, false, null],

            // Pirelli CP7 205/55R16
            ['PIR-CP7-205-55-16', 'toyota', 'camry', 2012, 'GL', false, true, false, null],
            ['PIR-CP7-205-55-16', 'hyundai', 'sonata', 2015, 'GLS', true, false, false, null],
            ['PIR-CP7-205-55-16', 'nissan', 'altima', 2013, 'S', false, true, false, null],

            // ── 225/45R17 sport tires ─────────────────────────────────────
            // Michelin PS4 225/45R17
            ['MCH-PS4-225-45-17', 'toyota', 'camry', 2018, 'SE', true, false, false, 'OEM sport package'],
            ['MCH-PS4-225-45-17', 'honda', 'accord', 2018, 'SPT', true, false, false, null],
            ['MCH-PS4-225-45-17', 'nissan', 'altima', 2019, 'SV', true, false, false, null],
            ['MCH-PS4-225-45-17', 'hyundai', 'sonata', 2020, 'SEL', false, true, false, null],
            ['MCH-PS4-225-45-17', 'kia', 'sportage', 2022, 'GT', false, true, false, null],

            // Kumho PS71 225/45R17
            ['KUM-PS71-225-45-17', 'toyota', 'camry', 2018, 'SE', false, true, false, null],
            ['KUM-PS71-225-45-17', 'honda', 'accord', 2018, 'SPT', false, true, false, null],
            ['KUM-PS71-225-45-17', 'nissan', 'altima', 2019, 'SV', false, true, false, null],
            ['KUM-PS71-225-45-17', 'dodge', 'charger', 2015, 'SXT', false, true, false, null],

            // ── 265/65R17 SUV tires ───────────────────────────────────────
            // Continental CrossContact LX2 265/65R17
            ['CNT-CCLX2-265-65-17', 'toyota', 'land-cruiser', 2016, 'GXR', true, false, false, 'OEM for Land Cruiser GXR'],
            ['CNT-CCLX2-265-65-17', 'toyota', 'prado', 2014, 'TXL', true, false, false, null],
            ['CNT-CCLX2-265-65-17', 'kia', 'sorento', 2015, 'EX', false, true, false, null],
            ['CNT-CCLX2-265-65-17', 'nissan', 'x-trail', 2014, 'SL', false, true, false, null],
            ['CNT-CCLX2-265-65-17', 'mitsubishi', 'pajero', 2007, 'GLS', false, true, false, null],

            // Toyo Open Country 265/65R17
            ['TOY-OPAT3-265-65-17', 'toyota', 'land-cruiser', 2016, 'GXR', false, true, false, null],
            ['TOY-OPAT3-265-65-17', 'toyota', 'prado', 2014, 'TXL', false, true, false, null],
            ['TOY-OPAT3-265-65-17', 'nissan', 'patrol', 2010, 'SE', false, true, false, null],
            ['TOY-OPAT3-265-65-17', 'mitsubishi', 'pajero', 2007, 'GLS', false, true, false, null],
            ['TOY-OPAT3-265-65-17', 'chevrolet', 'tahoe', 2015, 'LT', false, true, false, null],

            // ── 175/65R14 economy ────────────────────────────────────────
            // Yokohama BluEarth ES32 175/65R14
            ['YOK-BEES32-175-65-14', 'kia', 'rio', 2017, 'LX', true, false, false, null],
            ['YOK-BEES32-175-65-14', 'hyundai', 'accent', 2018, 'GL', true, false, false, null],
            ['YOK-BEES32-175-65-14', 'mitsubishi', 'lancer', 2008, 'GLS', false, true, false, null],

            // ── 285/60R18 large SUV ──────────────────────────────────────
            // Michelin Latitude Tour HP 285/60R18
            ['MCH-LAT-285-60-18', 'toyota', 'land-cruiser', 2008, 'VXR', true, false, false, null],
            ['MCH-LAT-285-60-18', 'nissan', 'patrol', 2010, 'LE', true, false, false, 'OEM for Patrol LE'],
            ['MCH-LAT-285-60-18', 'chevrolet', 'suburban', 2015, 'LT', false, true, false, null],
            ['MCH-LAT-285-60-18', 'dodge', 'durango', 2014, 'SXT', false, true, false, null],

            // ── 245/45R19 sport ──────────────────────────────────────────
            // Continental SportContact 7 245/45R19
            ['CNT-SSR-245-45-19', 'dodge', 'charger', 2015, 'RT', true, false, false, 'OEM R/T package'],
            ['CNT-SSR-245-45-19', 'chevrolet', 'tahoe', 2021, 'LTZ', false, true, false, null],

            // ── Batteries — fits many vehicles ───────────────────────────
            // Varta Blue Dynamic D24 60Ah — sedans
            ['VAR-BD-D24-60', 'toyota', 'corolla', 2014, 'EX', true, false, false, null],
            ['VAR-BD-D24-60', 'toyota', 'corolla', 2020, 'SE', true, false, false, null],
            ['VAR-BD-D24-60', 'kia', 'cerato', 2013, 'LX', true, false, false, null],
            ['VAR-BD-D24-60', 'kia', 'cerato', 2019, 'EX', true, false, false, null],
            ['VAR-BD-D24-60', 'hyundai', 'elantra', 2011, 'GL', true, false, false, null],
            ['VAR-BD-D24-60', 'hyundai', 'accent', 2018, 'GL', true, false, false, null],
            ['VAR-BD-D24-60', 'nissan', 'sunny', 2011, 'SV', true, false, false, null],
            ['VAR-BD-D24-60', 'mitsubishi', 'lancer', 2008, 'GLS', false, true, false, null],

            // Varta Silver AGM F21 80Ah — start-stop
            ['VAR-AGM-F21-80', 'toyota', 'camry', 2018, 'SE', true, false, false, 'Required for start-stop system'],
            ['VAR-AGM-F21-80', 'honda', 'accord', 2018, 'SPT', true, false, false, null],
            ['VAR-AGM-F21-80', 'honda', 'civic', 2016, 'EXT', true, false, false, null],
            ['VAR-AGM-F21-80', 'kia', 'sportage', 2022, 'GT', true, false, false, null],
            ['VAR-AGM-F21-80', 'hyundai', 'tucson', 2022, 'PRE', true, false, false, null],

            // Bosch S4 60Ah — standard sedans
            ['BSH-S4-024-60', 'toyota', 'corolla', 2014, 'EX', false, true, false, null],
            ['BSH-S4-024-60', 'kia', 'cerato', 2013, 'LX', false, true, false, null],
            ['BSH-S4-024-60', 'hyundai', 'elantra', 2011, 'GL', false, true, false, null],
            ['BSH-S4-024-60', 'nissan', 'sunny', 2011, 'SV', false, true, false, null],

            // Bosch S5 AGM 70Ah
            ['BSH-S5A-08-70', 'toyota', 'camry', 2018, 'SE', false, true, false, null],
            ['BSH-S5A-08-70', 'honda', 'accord', 2018, 'SPT', false, true, false, null],
            ['BSH-S5A-08-70', 'kia', 'sportage', 2017, 'EX', true, false, false, null],
            ['BSH-S5A-08-70', 'hyundai', 'tucson', 2016, 'GL', true, false, false, null],

            // Varta Blue Dynamic E11 74Ah — large sedans / SUVs
            ['VAR-BD-E11-74', 'toyota', 'camry', 2012, 'GL', true, false, false, null],
            ['VAR-BD-E11-74', 'hyundai', 'sonata', 2015, 'GLS', true, false, false, null],
            ['VAR-BD-E11-74', 'nissan', 'altima', 2013, 'S', true, false, false, null],
            ['VAR-BD-E11-74', 'kia', 'sorento', 2015, 'EX', false, true, false, null],
            ['VAR-BD-E11-74', 'honda', 'cr-v', 2017, 'EX', false, true, false, null],

            // Bosch T7 110Ah — trucks
            ['BSH-T7-110-TRK', 'toyota', 'hilux', 2016, 'SR5', true, false, false, 'Diesel engine'],
            ['BSH-T7-110-TRK', 'toyota', 'hilux', 2005, 'GL', true, false, false, null],
            ['BSH-T7-110-TRK', 'nissan', 'patrol', 2010, 'SE', false, true, false, null],
            ['BSH-T7-110-TRK', 'mitsubishi', 'pajero', 2007, 'GLS', false, true, false, null],
        ];

        foreach ($fitments as $row) {
            [$sku, $makeSlug, $modelSlug, $yearFrom, $trim, $isOem, $isAlt, $isExcl, $notesEn] = $row;

            $product = $p->get($sku);
            $v = $vehicle($makeSlug, $modelSlug, $yearFrom, $trim);

            if (!$product || !$v) {
                continue;
            }

            $fitment = Fitment::updateOrCreate(
                ['vehicle_id' => $v->id, 'product_id' => $product->id],
                ['is_oem' => $isOem, 'is_alternative' => $isAlt, 'is_excluded' => $isExcl]
            );

            if ($notesEn) {
                $fitment->translateOrNew('en')->notes = $notesEn;
                $fitment->translateOrNew('ar')->notes = $notesEn; // placeholder — can be refined
                $fitment->save();
            }
        }
    }
}
