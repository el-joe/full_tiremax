<?php

namespace App\Models\Concerns;

use Illuminate\Database\Eloquent\Builder;

/**
 * Reusable, safely-grouped search across translated columns (Astrotomic
 * translations relation) and optional plain columns of the model itself.
 *
 *   Product::searchTranslated($term, ['name'], ['sku'])
 */
trait SearchesTranslations
{
    public function scopeSearchTranslated(Builder $query, ?string $term, array $translated = ['name'], array $plain = []): Builder
    {
        $term = trim((string) $term);
        if ($term === '') {
            return $query;
        }
        $like = '%'.$term.'%';

        return $query->where(function (Builder $w) use ($like, $translated, $plain) {
            foreach ($plain as $i => $col) {
                $i === 0 ? $w->where($col, 'like', $like) : $w->orWhere($col, 'like', $like);
            }
            $w->{$plain ? 'orWhereHas' : 'whereHas'}('translations', function ($t) use ($like, $translated) {
                $t->where(function ($g) use ($like, $translated) {
                    foreach ($translated as $j => $col) {
                        $j === 0 ? $g->where($col, 'like', $like) : $g->orWhere($col, 'like', $like);
                    }
                });
            });
        });
    }
}
