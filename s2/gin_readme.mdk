
###  Get-Content -Raw lab/2_gin_queries.sql | docker exec -i petshop-postgres psql -U postgres -d petshop (с gin индексами )
Aggregate  (cost=11426.57..11426.58 rows=1 width=8) (actual time=105.776..105.778 rows=1 loops=1)
   Buffers: shared hit=78 read=10180
   ->  Bitmap Heap Scan on pet  (cost=404.23..11287.68 rows=55556 width=0) (actual time=8.466..102.121 rows=62370 loops=1)
         Recheck Cond: (attributes @> '{"color": "black"}'::jsonb)
         Heap Blocks: exact=10180
         Buffers: shared hit=78 read=10180
         ->  Bitmap Index Scan on gin_lab_pet_attr  (cost=0.00..390.34 rows=55556 width=0) (actual time=7.091..7.092 rows=62370 loops=1)
               Index Cond: (attributes @> '{"color": "black"}'::jsonb)
               Buffers: shared hit=78
 Planning:
   Buffers: shared hit=129 read=6
 Planning Time: 2.178 ms
 Execution Time: 106.256 ms
(13 rows)

                                                               QUERY PLAN                                               
-----------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=11709.69..11709.70 rows=1 width=8) (actual time=29.578..31.109 rows=1 loops=1)
   Buffers: shared read=9147
   ->  Gather  (cost=11709.48..11709.69 rows=2 width=8) (actual time=29.486..31.103 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared read=9147
         ->  Partial Aggregate  (cost=10709.48..10709.49 rows=1 width=8) (actual time=25.102..25.103 rows=1 loops=3)
               Buffers: shared read=9147
               ->  Parallel Seq Scan on client  (cost=0.00..10449.08 rows=104157 width=0) (actual time=0.011..21.416 rows=83333 loops=3)
                     Filter: (preferences ? 'newsletter'::text)
                     Buffers: shared read=9147
 Planning:
   Buffers: shared hit=47 read=2
 Planning Time: 1.222 ms
 Execution Time: 31.147 ms
(15 rows)

                                                                QUERY PLAN                                              
-------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=6493.00..6493.01 rows=1 width=8) (actual time=48.915..48.916 rows=1 loops=1)
   Buffers: shared hit=72 read=5319
   ->  Bitmap Heap Scan on audit_pet_accessorie  (cost=378.34..6360.39 rows=53044 width=0) (actual time=7.268..45.761 rows=62585 loops=1)
         Recheck Cond: (diff @> '{"reason": "sale"}'::jsonb)
         Heap Blocks: exact=5319
         Buffers: shared hit=72 read=5319
         ->  Bitmap Index Scan on gin_lab_audit_diff  (cost=0.00..365.08 rows=53044 width=0) (actual time=6.598..6.598 rows=62585 loops=1)
               Index Cond: (diff @> '{"reason": "sale"}'::jsonb)
               Buffers: shared hit=72
 Planning:
   Buffers: shared hit=31 read=1
 Planning Time: 0.656 ms
 Execution Time: 48.939 ms
(13 rows)

                                                                QUERY PLAN                                              
------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=12152.38..12152.39 rows=1 width=8) (actual time=19.383..19.385 rows=1 loops=1)
   Buffers: shared hit=23
   ->  Bitmap Heap Scan on pet  (cost=616.36..11927.88 rows=89801 width=0) (actual time=8.136..15.179 rows=100116 loops=1)
         Recheck Cond: (tags && '{cute,active}'::text[])
         Heap Blocks: exact=10189
         Buffers: shared hit=23
         ->  Bitmap Index Scan on gin_lab_pet_tags  (cost=0.00..593.91 rows=89801 width=0) (actual time=6.666..6.666 rows=100116 loops=1)
               Index Cond: (tags && '{cute,active}'::text[])
               Buffers: shared hit=21
 Planning:
   Buffers: shared hit=64 read=3
 Planning Time: 0.266 ms
 Execution Time: 19.486 ms
(13 rows)

                                                             QUERY PLAN                                                 
-------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=12700.71..12700.72 rows=1 width=8) (actual time=28.319..31.075 rows=1 loops=1)
   Buffers: shared hit=4184 read=6005
   ->  Gather  (cost=12700.49..12700.70 rows=2 width=8) (actual time=28.228..31.070 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=4184 read=6005
         ->  Partial Aggregate  (cost=11700.49..11700.50 rows=1 width=8) (actual time=25.713..25.713 rows=1 loops=3)
               Buffers: shared hit=4184 read=6005
               ->  Parallel Seq Scan on pet  (cost=0.00..11491.08 rows=83764 width=0) (actual time=0.020..22.463 rows=74923 loops=3)
                     Filter: (description_tsv @@ '''pet'' & ''description'''::tsquery)
                     Rows Removed by Filter: 8410
                     Buffers: shared hit=4184 read=6005
 Planning:
   Buffers: shared hit=13 read=13
 Planning Time: 3.558 ms
 Execution Time: 31.103 ms
(16 rows)

### Get-Content -Raw lab/2_gin_queries.sql | docker exec -i petshop-postgres psql -U postgres -d petshop (без индексов)
                                                           QUERY PLAN                                                 
-------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=12546.54..12546.55 rows=1 width=8) (actual time=27.725..29.421 rows=1 loops=1)
   Buffers: shared hit=4312 read=5877
   ->  Gather  (cost=12546.32..12546.53 rows=2 width=8) (actual time=27.627..29.416 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=4312 read=5877
         ->  Partial Aggregate  (cost=11546.32..11546.33 rows=1 width=8) (actual time=25.338..25.339 rows=1 loops=3)
               Buffers: shared hit=4312 read=5877
               ->  Parallel Seq Scan on pet  (cost=0.00..11491.08 rows=22096 width=0) (actual time=0.021..24.375 rows=20790 loops=3)
                     Filter: (attributes @> '{"color": "black"}'::jsonb)
                     Rows Removed by Filter: 62543
                     Buffers: shared hit=4312 read=5877
 Planning:
   Buffers: shared hit=72 read=6
 Planning Time: 0.535 ms
 Execution Time: 29.506 ms
(16 rows)

                                                               QUERY PLAN                                               
-----------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=11709.69..11709.70 rows=1 width=8) (actual time=30.267..31.850 rows=1 loops=1)
   Buffers: shared hit=128 read=9019
   ->  Gather  (cost=11709.48..11709.69 rows=2 width=8) (actual time=30.121..31.843 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=128 read=9019
         ->  Partial Aggregate  (cost=10709.48..10709.49 rows=1 width=8) (actual time=27.954..27.955 rows=1 loops=3)
               Buffers: shared hit=128 read=9019
               ->  Parallel Seq Scan on client  (cost=0.00..10449.08 rows=104157 width=0) (actual time=0.031..24.178 rows=83333 loops=3)
                     Filter: (preferences ? 'newsletter'::text)
                     Buffers: shared hit=128 read=9019
 Planning:
   Buffers: shared hit=33
 Planning Time: 0.195 ms
 Execution Time: 31.873 ms
(15 rows)

                                                                     QUERY PLAN                                         
-----------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=7689.63..7689.64 rows=1 width=8) (actual time=23.833..26.385 rows=1 loops=1)
   Buffers: shared hit=5319
   ->  Gather  (cost=7689.41..7689.62 rows=2 width=8) (actual time=23.726..26.379 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=5319
         ->  Partial Aggregate  (cost=6689.41..6689.42 rows=1 width=8) (actual time=21.197..21.198 rows=1 loops=3)
               Buffers: shared hit=5319
               ->  Parallel Seq Scan on audit_pet_accessorie  (cost=0.00..6621.09 rows=27329 width=0) (actual time=0.007..20.237 rows=20862 loops=3)
                     Filter: (diff @> '{"reason": "sale"}'::jsonb)
                     Rows Removed by Filter: 62472
                     Buffers: shared hit=5319
 Planning:
   Buffers: shared hit=19
 Planning Time: 0.180 ms
 Execution Time: 26.439 ms
(16 rows)

                                                             QUERY PLAN                                                 
-------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=12585.73..12585.74 rows=1 width=8) (actual time=27.529..29.241 rows=1 loops=1)
   Buffers: shared hit=4703 read=5781
   ->  Gather  (cost=12585.52..12585.73 rows=2 width=8) (actual time=27.427..29.235 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=4703 read=5781
         ->  Partial Aggregate  (cost=11585.52..11585.53 rows=1 width=8) (actual time=25.316..25.317 rows=1 loops=3)
               Buffers: shared hit=4703 read=5781
               ->  Parallel Seq Scan on pet  (cost=0.00..11491.08 rows=37773 width=0) (actual time=0.171..23.815 rows=33372 loops=3)
                     Filter: (tags && '{cute,active}'::text[])
                     Rows Removed by Filter: 49961
                     Buffers: shared hit=4703 read=5781
 Planning:
   Buffers: shared hit=60
 Planning Time: 0.217 ms
 Execution Time: 29.264 ms
(16 rows)

                                                             QUERY PLAN                                                 
-------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=12702.22..12702.23 rows=1 width=8) (actual time=28.793..30.596 rows=1 loops=1)
   Buffers: shared hit=4504 read=5685
   ->  Gather  (cost=12702.01..12702.22 rows=2 width=8) (actual time=28.698..30.590 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=4504 read=5685
         ->  Partial Aggregate  (cost=11702.01..11702.02 rows=1 width=8) (actual time=26.510..26.511 rows=1 loops=3)
               Buffers: shared hit=4504 read=5685
               ->  Parallel Seq Scan on pet  (cost=0.00..11491.08 rows=84369 width=0) (actual time=0.030..23.152 rows=74923 loops=3)
                     Filter: (description_tsv @@ '''pet'' & ''description'''::tsquery)
                     Rows Removed by Filter: 8410
                     Buffers: shared hit=4504 read=5685
 Planning:
   Buffers: shared hit=19
 Planning Time: 0.282 ms
 Execution Time: 30.618 ms
(16 rows)
## Сравнение
### 1) pet.attributes @> '{"color":"black"}'

-- Без индекса

- План: Parallel Seq Scan on pet

- Execution Time: 29.506 ms

- Buffers: hit=4312 read=5877

-- С GIN

- План: Bitmap Index Scan on gin_lab_pet_attr → Bitmap Heap Scan on pet

- Execution Time: 106.256 ms

- Buffers: hit=78 read=10180

GIN использовался, но запрос стал сильно медленнее. условие возвращает слишком много строк, 62 370 строк. Для такой низкой селективности обход через индекс + чтение большого числа heap-страниц оказался дороже, чем параллельный Seq Scan.

### 2) client.preferences ? 'newsletter'

-- Без индекса

- План: Parallel Seq Scan on client

- Execution Time: 31.873 ms

- Buffers: hit=128 read=9019

-- С GIN

- План: Parallel Seq Scan on client

- Execution Time: 31.147 ms

- Buffers: read=9147

План не изменился, planner не использовал GIN.
Разница во времени минимальна. оператор ? по этой колонке в данном распределении значений planner посчитал невыгодным для индекса из-за очень высокой доли совпадений.

### 3) audit_pet_accessorie.diff @> '{"reason":"sale"}'

-- Без индекса

- План: Parallel Seq Scan on audit_pet_accessorie

- Execution Time: 26.439 ms

- Buffers: hit=5319

-- С GIN

- План: Bitmap Index Scan on gin_lab_audit_diff → Bitmap Heap Scan on audit_pet_accessorie

- Execution Time: 48.939 ms

- Buffers: hit=72 read=5319

GIN использовался, но снова оказался хуже Seq Scan. совпадений много (62 585 строк). Для массового извлечения индекс невыгоден.

### 4) pet.tags && ARRAY['cute','active']

-- Без индекса

- План: Parallel Seq Scan on pet

- Execution Time: 29.264 ms

- Buffers: hit=4703 read=5781

-- С GIN

- План: Bitmap Index Scan on gin_lab_pet_tags → Bitmap Heap Scan on pet

- Execution Time: 19.486 ms

- Buffers: hit=23

Здесь GIN помог. Время снизилось примерно с 29.3 ms до 19.5 ms. План сменился с Parallel Seq Scan на индексный Bitmap Index Scan, индекс оказался выгоден для оператора overlap && по массиву.

### 5) pet.description_tsv @@ plainto_tsquery('simple', 'pet description')

-- Без индекса

- План: Parallel Seq Scan on pet

- Execution Time: 30.618 ms

- Buffers: hit=4504 read=5685

--С GIN

- План: Parallel Seq Scan on pet

- Execution Time: 31.103 ms

- Buffers: hit=4184 read=6005

План не изменился, GIN не использовался. Время почти то же, даже чуть хуже, т.к запрос слишком неселективный т.к совпадений очень много поэтому было выбрано последовательное сканирование.