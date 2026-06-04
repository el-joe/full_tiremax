<?php

namespace Database\Seeders;

use App\Models\Vehicle;
use App\Models\VehicleMake;
use App\Models\VehicleModel;
use Illuminate\Database\Seeder;

class VehicleSeeder extends Seeder
{
    public function run(): void
    {
        $data = [
            [
                'slug' => 'toyota',
                'en' => 'Toyota',
                'ar' => 'تويوتا',
                'models' => [
                    [
                        'slug' => 'camry',
                        'en' => 'Camry',
                        'ar' => 'كامري',
                        'vehicles' => [
                            ['year_from' => 2018, 'year_to' => 2024, 'trim_code' => 'SE', 'engine' => '2.5L', 'trim_en' => 'SE', 'trim_ar' => 'SE'],
                            ['year_from' => 2012, 'year_to' => 2017, 'trim_code' => 'GL', 'engine' => '2.5L', 'trim_en' => 'GL', 'trim_ar' => 'GL'],
                        ]
                    ],
                    [
                        'slug' => 'corolla',
                        'en' => 'Corolla',
                        'ar' => 'كورولا',
                        'vehicles' => [
                            ['year_from' => 2014, 'year_to' => 2019, 'trim_code' => 'EX', 'engine' => '1.6L', 'trim_en' => 'EX', 'trim_ar' => 'EX'],
                            ['year_from' => 2020, 'year_to' => null, 'trim_code' => 'SE', 'engine' => '2.0L', 'trim_en' => 'SE', 'trim_ar' => 'SE'],
                        ]
                    ],
                    [
                        'slug' => 'land-cruiser',
                        'en' => 'Land Cruiser',
                        'ar' => 'لاند كروزر',
                        'vehicles' => [
                            ['year_from' => 2016, 'year_to' => 2021, 'trim_code' => 'GXR', 'engine' => '4.5L V8', 'trim_en' => 'GXR', 'trim_ar' => 'GXR'],
                            ['year_from' => 2008, 'year_to' => 2015, 'trim_code' => 'VXR', 'engine' => '4.5L V8', 'trim_en' => 'VXR', 'trim_ar' => 'VXR'],
                        ]
                    ],
                    [
                        'slug' => 'prado',
                        'en' => 'Prado',
                        'ar' => 'برادو',
                        'vehicles' => [
                            ['year_from' => 2014, 'year_to' => 2022, 'trim_code' => 'TXL', 'engine' => '4.0L V6', 'trim_en' => 'TXL', 'trim_ar' => 'TXL'],
                            ['year_from' => 2003, 'year_to' => 2013, 'trim_code' => 'GX', 'engine' => '4.0L V6', 'trim_en' => 'GX', 'trim_ar' => 'GX'],
                        ]
                    ],
                    [
                        'slug' => 'hilux',
                        'en' => 'Hilux',
                        'ar' => 'هايلكس',
                        'vehicles' => [
                            ['year_from' => 2016, 'year_to' => null, 'trim_code' => 'SR5', 'engine' => '2.8L Diesel', 'trim_en' => 'SR5', 'trim_ar' => 'SR5'],
                            ['year_from' => 2005, 'year_to' => 2015, 'trim_code' => 'GL', 'engine' => '2.5L Diesel', 'trim_en' => 'GL', 'trim_ar' => 'GL'],
                        ]
                    ],
                    [
                        'slug' => 'fortuner',
                        'en' => 'Fortuner',
                        'ar' => 'فورتونر',
                        'vehicles' => [
                            ['year_from' => 2016, 'year_to' => null, 'trim_code' => 'VXR', 'engine' => '2.8L Diesel', 'trim_en' => 'VXR', 'trim_ar' => 'VXR'],
                        ]
                    ],
                ]
            ],
            [
                'slug' => 'kia',
                'en' => 'Kia',
                'ar' => 'كيا',
                'models' => [
                    [
                        'slug' => 'cerato',
                        'en' => 'Cerato',
                        'ar' => 'سيراتو',
                        'vehicles' => [
                            ['year_from' => 2019, 'year_to' => null, 'trim_code' => 'EX', 'engine' => '1.6L', 'trim_en' => 'EX', 'trim_ar' => 'EX'],
                            ['year_from' => 2013, 'year_to' => 2018, 'trim_code' => 'LX', 'engine' => '1.6L', 'trim_en' => 'LX', 'trim_ar' => 'LX'],
                        ]
                    ],
                    [
                        'slug' => 'sportage',
                        'en' => 'Sportage',
                        'ar' => 'سبورتاج',
                        'vehicles' => [
                            ['year_from' => 2022, 'year_to' => null, 'trim_code' => 'GT', 'engine' => '1.6T', 'trim_en' => 'GT-Line', 'trim_ar' => 'GT Line'],
                            ['year_from' => 2017, 'year_to' => 2021, 'trim_code' => 'EX', 'engine' => '2.0L', 'trim_en' => 'EX', 'trim_ar' => 'EX'],
                        ]
                    ],
                    [
                        'slug' => 'sorento',
                        'en' => 'Sorento',
                        'ar' => 'سورينتو',
                        'vehicles' => [
                            ['year_from' => 2015, 'year_to' => 2020, 'trim_code' => 'EX', 'engine' => '2.4L', 'trim_en' => 'EX', 'trim_ar' => 'EX'],
                        ]
                    ],
                    [
                        'slug' => 'rio',
                        'en' => 'Rio',
                        'ar' => 'ريو',
                        'vehicles' => [
                            ['year_from' => 2017, 'year_to' => null, 'trim_code' => 'LX', 'engine' => '1.4L', 'trim_en' => 'LX', 'trim_ar' => 'LX'],
                        ]
                    ],
                ]
            ],
            [
                'slug' => 'hyundai',
                'en' => 'Hyundai',
                'ar' => 'هيونداي',
                'models' => [
                    [
                        'slug' => 'elantra',
                        'en' => 'Elantra',
                        'ar' => 'إيلانترا',
                        'vehicles' => [
                            ['year_from' => 2017, 'year_to' => 2022, 'trim_code' => 'GLS', 'engine' => '2.0L', 'trim_en' => 'GLS', 'trim_ar' => 'GLS'],
                            ['year_from' => 2011, 'year_to' => 2016, 'trim_code' => 'GL', 'engine' => '1.6L', 'trim_en' => 'GL', 'trim_ar' => 'GL'],
                        ]
                    ],
                    [
                        'slug' => 'tucson',
                        'en' => 'Tucson',
                        'ar' => 'توسان',
                        'vehicles' => [
                            ['year_from' => 2022, 'year_to' => null, 'trim_code' => 'PRE', 'engine' => '1.6T', 'trim_en' => 'Premium', 'trim_ar' => 'بريميوم'],
                            ['year_from' => 2016, 'year_to' => 2021, 'trim_code' => 'GL', 'engine' => '2.0L', 'trim_en' => 'GL', 'trim_ar' => 'GL'],
                        ]
                    ],
                    [
                        'slug' => 'sonata',
                        'en' => 'Sonata',
                        'ar' => 'سوناتا',
                        'vehicles' => [
                            ['year_from' => 2015, 'year_to' => 2019, 'trim_code' => 'GLS', 'engine' => '2.4L', 'trim_en' => 'GLS', 'trim_ar' => 'GLS'],
                            ['year_from' => 2020, 'year_to' => null, 'trim_code' => 'SEL', 'engine' => '2.5L', 'trim_en' => 'SEL', 'trim_ar' => 'SEL'],
                        ]
                    ],
                    [
                        'slug' => 'accent',
                        'en' => 'Accent',
                        'ar' => 'أكسينت',
                        'vehicles' => [
                            ['year_from' => 2018, 'year_to' => null, 'trim_code' => 'GL', 'engine' => '1.4L', 'trim_en' => 'GL', 'trim_ar' => 'GL'],
                        ]
                    ],
                ]
            ],
            [
                'slug' => 'honda',
                'en' => 'Honda',
                'ar' => 'هوندا',
                'models' => [
                    [
                        'slug' => 'accord',
                        'en' => 'Accord',
                        'ar' => 'أكورد',
                        'vehicles' => [
                            ['year_from' => 2018, 'year_to' => null, 'trim_code' => 'SPT', 'engine' => '1.5T', 'trim_en' => 'Sport', 'trim_ar' => 'سبورت'],
                            ['year_from' => 2013, 'year_to' => 2017, 'trim_code' => 'EX', 'engine' => '2.4L', 'trim_en' => 'EX', 'trim_ar' => 'EX'],
                        ]
                    ],
                    [
                        'slug' => 'civic',
                        'en' => 'Civic',
                        'ar' => 'سيفيك',
                        'vehicles' => [
                            ['year_from' => 2016, 'year_to' => 2021, 'trim_code' => 'EXT', 'engine' => '1.5T', 'trim_en' => 'EX-T', 'trim_ar' => 'EX-T'],
                            ['year_from' => 2022, 'year_to' => null, 'trim_code' => 'SPT', 'engine' => '1.5T', 'trim_en' => 'Sport', 'trim_ar' => 'سبورت'],
                        ]
                    ],
                    [
                        'slug' => 'cr-v',
                        'en' => 'CR-V',
                        'ar' => 'CR-V',
                        'vehicles' => [
                            ['year_from' => 2017, 'year_to' => null, 'trim_code' => 'EX', 'engine' => '1.5T', 'trim_en' => 'EX', 'trim_ar' => 'EX'],
                        ]
                    ],
                ]
            ],
            [
                'slug' => 'nissan',
                'en' => 'Nissan',
                'ar' => 'نيسان',
                'models' => [
                    [
                        'slug' => 'altima',
                        'en' => 'Altima',
                        'ar' => 'التيما',
                        'vehicles' => [
                            ['year_from' => 2019, 'year_to' => null, 'trim_code' => 'SV', 'engine' => '2.5L', 'trim_en' => 'SV', 'trim_ar' => 'SV'],
                            ['year_from' => 2013, 'year_to' => 2018, 'trim_code' => 'S', 'engine' => '2.5L', 'trim_en' => 'S', 'trim_ar' => 'S'],
                        ]
                    ],
                    [
                        'slug' => 'patrol',
                        'en' => 'Patrol',
                        'ar' => 'باترول',
                        'vehicles' => [
                            ['year_from' => 2010, 'year_to' => null, 'trim_code' => 'SE', 'engine' => '5.6L V8', 'trim_en' => 'SE', 'trim_ar' => 'SE'],
                            ['year_from' => 2010, 'year_to' => null, 'trim_code' => 'LE', 'engine' => '5.6L V8', 'trim_en' => 'LE', 'trim_ar' => 'LE'],
                        ]
                    ],
                    [
                        'slug' => 'sunny',
                        'en' => 'Sunny',
                        'ar' => 'صني',
                        'vehicles' => [
                            ['year_from' => 2011, 'year_to' => 2019, 'trim_code' => 'SV', 'engine' => '1.5L', 'trim_en' => 'SV', 'trim_ar' => 'SV'],
                        ]
                    ],
                    [
                        'slug' => 'x-trail',
                        'en' => 'X-Trail',
                        'ar' => 'إكس-تريل',
                        'vehicles' => [
                            ['year_from' => 2014, 'year_to' => 2021, 'trim_code' => 'SL', 'engine' => '2.5L', 'trim_en' => 'SL', 'trim_ar' => 'SL'],
                        ]
                    ],
                ]
            ],
            [
                'slug' => 'mitsubishi',
                'en' => 'Mitsubishi',
                'ar' => 'ميتسوبيشي',
                'models' => [
                    [
                        'slug' => 'lancer',
                        'en' => 'Lancer',
                        'ar' => 'لانسر',
                        'vehicles' => [
                            ['year_from' => 2008, 'year_to' => 2017, 'trim_code' => 'GLS', 'engine' => '1.6L', 'trim_en' => 'GLS', 'trim_ar' => 'GLS'],
                        ]
                    ],
                    [
                        'slug' => 'pajero',
                        'en' => 'Pajero',
                        'ar' => 'باجيرو',
                        'vehicles' => [
                            ['year_from' => 2007, 'year_to' => 2019, 'trim_code' => 'GLS', 'engine' => '3.8L V6', 'trim_en' => 'GLS', 'trim_ar' => 'GLS'],
                        ]
                    ],
                    [
                        'slug' => 'eclipse-cross',
                        'en' => 'Eclipse Cross',
                        'ar' => 'إكليبس كروس',
                        'vehicles' => [
                            ['year_from' => 2018, 'year_to' => null, 'trim_code' => 'SE', 'engine' => '1.5T', 'trim_en' => 'SE', 'trim_ar' => 'SE'],
                        ]
                    ],
                    [
                        'slug' => 'outlander',
                        'en' => 'Outlander',
                        'ar' => 'أوتلاندر',
                        'vehicles' => [
                            ['year_from' => 2013, 'year_to' => 2021, 'trim_code' => 'SE', 'engine' => '2.4L', 'trim_en' => 'SE', 'trim_ar' => 'SE'],
                        ]
                    ],
                ]
            ],
            [
                'slug' => 'chevrolet',
                'en' => 'Chevrolet',
                'ar' => 'شيفروليه',
                'models' => [
                    [
                        'slug' => 'malibu',
                        'en' => 'Malibu',
                        'ar' => 'ماليبو',
                        'vehicles' => [
                            ['year_from' => 2016, 'year_to' => null, 'trim_code' => 'LT', 'engine' => '1.5T', 'trim_en' => 'LT', 'trim_ar' => 'LT'],
                        ]
                    ],
                    [
                        'slug' => 'tahoe',
                        'en' => 'Tahoe',
                        'ar' => 'تاهو',
                        'vehicles' => [
                            ['year_from' => 2015, 'year_to' => 2020, 'trim_code' => 'LT', 'engine' => '5.3L V8', 'trim_en' => 'LT', 'trim_ar' => 'LT'],
                            ['year_from' => 2021, 'year_to' => null, 'trim_code' => 'LTZ', 'engine' => '5.3L V8', 'trim_en' => 'LTZ', 'trim_ar' => 'LTZ'],
                        ]
                    ],
                    [
                        'slug' => 'suburban',
                        'en' => 'Suburban',
                        'ar' => 'سبربان',
                        'vehicles' => [
                            ['year_from' => 2015, 'year_to' => null, 'trim_code' => 'LT', 'engine' => '5.3L V8', 'trim_en' => 'LT', 'trim_ar' => 'LT'],
                        ]
                    ],
                ]
            ],
            [
                'slug' => 'dodge',
                'en' => 'Dodge',
                'ar' => 'دودج',
                'models' => [
                    [
                        'slug' => 'charger',
                        'en' => 'Charger',
                        'ar' => 'تشارجر',
                        'vehicles' => [
                            ['year_from' => 2015, 'year_to' => null, 'trim_code' => 'SXT', 'engine' => '3.6L V6', 'trim_en' => 'SXT', 'trim_ar' => 'SXT'],
                            ['year_from' => 2015, 'year_to' => null, 'trim_code' => 'RT', 'engine' => '5.7L V8', 'trim_en' => 'R/T', 'trim_ar' => 'R/T'],
                        ]
                    ],
                    [
                        'slug' => 'durango',
                        'en' => 'Durango',
                        'ar' => 'دورانجو',
                        'vehicles' => [
                            ['year_from' => 2014, 'year_to' => null, 'trim_code' => 'SXT', 'engine' => '3.6L V6', 'trim_en' => 'SXT', 'trim_ar' => 'SXT'],
                        ]
                    ],
                ]
            ],
        ];

        foreach ($data as $mi => $makeData) {
            $make = VehicleMake::updateOrCreate(
                ['slug' => $makeData['slug']],
                ['is_active' => true, 'sort_order' => $mi]
            );
            $make->translateOrNew('en')->name = $makeData['en'];
            $make->translateOrNew('ar')->name = $makeData['ar'];
            $make->save();

            foreach ($makeData['models'] as $moi => $modelData) {
                $model = VehicleModel::updateOrCreate(
                    ['vehicle_make_id' => $make->id, 'slug' => $modelData['slug']],
                    ['is_active' => true, 'sort_order' => $moi]
                );
                $model->translateOrNew('en')->name = $modelData['en'];
                $model->translateOrNew('ar')->name = $modelData['ar'];
                $model->save();

                foreach ($modelData['vehicles'] as $vData) {
                    $vehicle = Vehicle::updateOrCreate(
                        [
                            'vehicle_model_id' => $model->id,
                            'year_from' => $vData['year_from'],
                            'trim_code' => $vData['trim_code'],
                        ],
                        [
                            'year_to' => $vData['year_to'],
                            'engine' => $vData['engine'],
                            'is_active' => true,
                        ]
                    );
                    $vehicle->translateOrNew('en')->trim_name = $vData['trim_en'];
                    $vehicle->translateOrNew('ar')->trim_name = $vData['trim_ar'];
                    $vehicle->save();
                }
            }
        }
    }
}
