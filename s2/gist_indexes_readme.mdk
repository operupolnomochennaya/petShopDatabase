### Get-Content -Raw lab/04_gist_queries.sql | docker exec -i petshop-postgres psql -U postgres -d petshop (с gist)
                                      QUERY PLAN                                            
----------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=5183.65..5183.66 rows=1 width=8) (actual time=46.773..46.775 rows=1 loops=1)
   Buffers: shared hit=2453
   ->  Index Only Scan using gist_lab_pet_stay on pet  (cost=0.29..4964.73 rows=87568 width=0) (actual time=0.425..42.236 rows=88640 loops=1)
         Index Cond: (stay @> (now())::timestamp without time zone)
         Heap Fetches: 0
         Buffers: shared hit=2453
 Planning:
   Buffers: shared hit=106 dirtied=3
 Planning Time: 3.093 ms
 Execution Time: 47.821 ms
(10 rows)

                                                                                 QUERY PLAN                             
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=8439.66..8439.67 rows=1 width=8) (actual time=51.345..51.346 rows=1 loops=1)
   Buffers: shared hit=2450
   ->  Index Only Scan using gist_lab_pet_stay on pet  (cost=0.30..8083.24 rows=142568 width=0) (actual time=0.134..45.088 rows=144996 loops=1)
         Index Cond: (stay && tsrange(((now())::timestamp without time zone - '7 days'::interval), ((now())::timestamp without time zone + '7 days'::interval), '[]'::text))
         Heap Fetches: 0
         Buffers: shared hit=2450
 Planning:
   Buffers: shared hit=3
 Planning Time: 0.102 ms
 Execution Time: 51.365 ms
(10 rows)

                                                                      QUERY PLAN                                        
------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=7454.28..7454.29 rows=1 width=8) (actual time=48.106..48.107 rows=1 loops=1)
   Buffers: shared hit=1908
   ->  Index Only Scan using gist_lab_emp_years on employee  (cost=0.28..7085.53 rows=147500 width=0) (actual time=0.380..41.842 rows=150142 loops=1)
         Index Cond: (work_years @> 5)
         Heap Fetches: 0
         Buffers: shared hit=1908
 Planning:
   Buffers: shared hit=35 read=1 dirtied=1
 Planning Time: 1.029 ms
 Execution Time: 48.126 ms
(10 rows)

                                                                      QUERY PLAN                                        
-------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=11368.28..11368.29 rows=1 width=8) (actual time=63.996..63.999 rows=1 loops=1)
   Buffers: shared hit=1908
   ->  Index Only Scan using gist_lab_emp_years on employee  (cost=0.28..10805.78 rows=225000 width=0) (actual time=0.207..54.466 rows=225115 loops=1)
         Index Cond: (work_years && '[3,9)'::int4range)
         Heap Fetches: 0
         Buffers: shared hit=1908
 Planning Time: 0.059 ms
 Execution Time: 64.020 ms
(8 rows)

                                                                QUERY PLAN                                              
------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=1101.29..1101.30 rows=1 width=8) (actual time=90.439..90.441 rows=1 loops=1)
   Buffers: shared hit=96 read=14 dirtied=1
   ->  Index Scan using gist_lab_petshop_loc on petshop  (cost=0.26..1101.28 rows=1 width=0) (actual time=90.335..90.428 rows=70 loops=1)
         Index Cond: (location && _st_expand('0101000020E6100000CDCCCCCCCCCC42409A99999999D94B40'::geography, '50000'::double precision))
         Filter: st_dwithin(location, '0101000020E6100000CDCCCCCCCCCC42409A99999999D94B40'::geography, '50000'::double precision, true)
         Rows Removed by Filter: 18
         Buffers: shared hit=96 read=14 dirtied=1
 Planning:
   Buffers: shared hit=132 read=15 dirtied=1
 Planning Time: 13.942 ms
 Execution Time: 90.484 ms
(11 rows)
### без gist
                                                          QUERY PLAN                                            
----------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=5183.65..5183.66 rows=1 width=8) (actual time=46.773..46.775 rows=1 loops=1)
   Buffers: shared hit=2453
   ->  Index Only Scan using gist_lab_pet_stay on pet  (cost=0.29..4964.73 rows=87568 width=0) (actual time=0.425..42.236 rows=88640 loops=1)
         Index Cond: (stay @> (now())::timestamp without time zone)
         Heap Fetches: 0
         Buffers: shared hit=2453
 Planning:
   Buffers: shared hit=106 dirtied=3
 Planning Time: 3.093 ms
 Execution Time: 47.821 ms
(10 rows)

                                                                                 QUERY PLAN                             
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=8439.66..8439.67 rows=1 width=8) (actual time=51.345..51.346 rows=1 loops=1)
   Buffers: shared hit=2450
   ->  Index Only Scan using gist_lab_pet_stay on pet  (cost=0.30..8083.24 rows=142568 width=0) (actual time=0.134..45.088 rows=144996 loops=1)
         Index Cond: (stay && tsrange(((now())::timestamp without time zone - '7 days'::interval), ((now())::timestamp without time zone + '7 days'::interval), '[]'::text))
         Heap Fetches: 0
         Buffers: shared hit=2450
 Planning:
   Buffers: shared hit=3
 Planning Time: 0.102 ms
 Execution Time: 51.365 ms
(10 rows)

                                                                      QUERY PLAN                                        
------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=7454.28..7454.29 rows=1 width=8) (actual time=48.106..48.107 rows=1 loops=1)
   Buffers: shared hit=1908
   ->  Index Only Scan using gist_lab_emp_years on employee  (cost=0.28..7085.53 rows=147500 width=0) (actual time=0.380..41.842 rows=150142 loops=1)
         Index Cond: (work_years @> 5)
         Heap Fetches: 0
         Buffers: shared hit=1908
 Planning:
   Buffers: shared hit=35 read=1 dirtied=1
 Planning Time: 1.029 ms
 Execution Time: 48.126 ms
(10 rows)

                                                                      QUERY PLAN                                        
-------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=11368.28..11368.29 rows=1 width=8) (actual time=63.996..63.999 rows=1 loops=1)
   Buffers: shared hit=1908
   ->  Index Only Scan using gist_lab_emp_years on employee  (cost=0.28..10805.78 rows=225000 width=0) (actual time=0.207..54.466 rows=225115 loops=1)
         Index Cond: (work_years && '[3,9)'::int4range)
         Heap Fetches: 0
         Buffers: shared hit=1908
 Planning Time: 0.059 ms
 Execution Time: 64.020 ms
(8 rows)

                                                                QUERY PLAN                                              
------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=1101.29..1101.30 rows=1 width=8) (actual time=90.439..90.441 rows=1 loops=1)
   Buffers: shared hit=96 read=14 dirtied=1
   ->  Index Scan using gist_lab_petshop_loc on petshop  (cost=0.26..1101.28 rows=1 width=0) (actual time=90.335..90.428 rows=70 loops=1)
         Index Cond: (location && _st_expand('0101000020E6100000CDCCCCCCCCCC42409A99999999D94B40'::geography, '50000'::double precision))
         Filter: st_dwithin(location, '0101000020E6100000CDCCCCCCCCCC42409A99999999D94B40'::geography, '50000'::double precision, true)
         Rows Removed by Filter: 18
         Buffers: shared hit=96 read=14 dirtied=1
 Planning:
   Buffers: shared hit=132 read=15 dirtied=1
 Planning Time: 13.942 ms
 Execution Time: 90.484 ms
(11 rows)

PS C:\Users\Pc\Desktop\petShopDatabase\s2> Get-Content -Raw lab/4_gist_drop.sql | docker exec -i petshop-postgres psql -U postgres -d petshop -v ON_ERROR_STOP=1
DROP INDEX
DROP INDEX
DROP INDEX
ANALYZE
ANALYZE
ANALYZE
PS C:\Users\Pc\Desktop\petShopDatabase\s2> Get-Content -Raw lab/4_gist_queries.sql | docker exec -i petshop-postgres psql -U postgres -d petshop
                                                             QUERY PLAN                                                 
-------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=13103.30..13103.31 rows=1 width=8) (actual time=39.692..41.422 rows=1 loops=1)
   Buffers: shared hit=4754 read=5493
   ->  Gather  (cost=13103.09..13103.30 rows=2 width=8) (actual time=39.591..41.416 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=4754 read=5493
         ->  Partial Aggregate  (cost=12103.09..12103.10 rows=1 width=8) (actual time=34.702..34.703 rows=1 loops=3)
               Buffers: shared hit=4754 read=5493
               ->  Parallel Seq Scan on pet  (cost=0.00..12011.92 rows=36468 width=0) (actual time=0.084..32.945 rows=29547 loops=3)
                     Filter: (stay @> (now())::timestamp without time zone)
                     Rows Removed by Filter: 53787
                     Buffers: shared hit=4754 read=5493
 Planning:
   Buffers: shared hit=85
 Planning Time: 0.607 ms
 Execution Time: 41.503 ms
(16 rows)

                                                                                     QUERY PLAN                         
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=14462.68..14462.69 rows=1 width=8) (actual time=48.379..49.982 rows=1 loops=1)
   Buffers: shared hit=4850 read=5397
   ->  Gather  (cost=14462.46..14462.67 rows=2 width=8) (actual time=48.201..49.977 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=4850 read=5397
         ->  Partial Aggregate  (cost=13462.46..13462.47 rows=1 width=8) (actual time=45.873..45.874 rows=1 loops=3)
               Buffers: shared hit=4850 read=5397
               ->  Parallel Seq Scan on pet  (cost=0.00..13314.00 rows=59385 width=0) (actual time=0.076..43.615 rows=48332 loops=3)
                     Filter: (stay && tsrange(((now())::timestamp without time zone - '7 days'::interval), ((now())::timestamp without time zone + '7 days'::interval), '[]'::text))
                     Rows Removed by Filter: 35001
                     Buffers: shared hit=4850 read=5397
 Planning Time: 0.093 ms
 Execution Time: 50.002 ms
(14 rows)

                                                                QUERY PLAN                                              
------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=11929.55..11929.56 rows=1 width=8) (actual time=27.797..29.240 rows=1 loops=1)
   Buffers: shared hit=154 read=9375
   ->  Gather  (cost=11929.33..11929.54 rows=2 width=8) (actual time=27.639..29.235 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=154 read=9375
         ->  Partial Aggregate  (cost=10929.33..10929.34 rows=1 width=8) (actual time=24.832..24.834 rows=1 loops=3)
               Buffers: shared hit=154 read=9375
               ->  Parallel Seq Scan on employee  (cost=0.00..10773.08 rows=62500 width=0) (actual time=0.102..22.198 rows=50047 loops=3)
                     Filter: (work_years @> 5)
                     Rows Removed by Filter: 33286
                     Buffers: shared hit=154 read=9375
 Planning:
   Buffers: shared hit=26
 Planning Time: 0.124 ms
 Execution Time: 29.259 ms
(16 rows)

                                                                QUERY PLAN                                              
------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=12007.67..12007.68 rows=1 width=8) (actual time=26.569..28.097 rows=1 loops=1)
   Buffers: shared hit=250 read=9279
   ->  Gather  (cost=12007.46..12007.67 rows=2 width=8) (actual time=26.408..28.091 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=250 read=9279
         ->  Partial Aggregate  (cost=11007.46..11007.47 rows=1 width=8) (actual time=24.243..24.244 rows=1 loops=3)
               Buffers: shared hit=250 read=9279
               ->  Parallel Seq Scan on employee  (cost=0.00..10773.08 rows=93750 width=0) (actual time=0.060..20.816 rows=75038 loops=3)
                     Filter: (work_years && '[3,9)'::int4range)
                     Rows Removed by Filter: 8295
                     Buffers: shared hit=250 read=9279
 Planning Time: 0.067 ms
 Execution Time: 28.116 ms
(14 rows)

                                                               QUERY PLAN                                               
----------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=1253.00..1253.01 rows=1 width=8) (actual time=10.389..10.390 rows=1 loops=1)
   Buffers: shared hit=115
   ->  Seq Scan on petshop  (cost=0.00..1253.00 rows=1 width=0) (actual time=10.306..10.380 rows=70 loops=1)
         Filter: st_dwithin(location, '0101000020E6100000CDCCCCCCCCCC42409A99999999D94B40'::geography, '50000'::double precision, true)
         Rows Removed by Filter: 30
         Buffers: shared hit=115
 Planning:
   Buffers: shared hit=71
 Planning Time: 6.713 ms
 Execution Time: 10.417 ms
(10 rows)
# 1. `stay @> now()`

### Без индекса
- План: `Parallel Seq Scan on pet`
- Execution Time: **41.503 ms**
- Buffers: `hit=4754 read=5493`

### С GiST
- План: `Index Only Scan using gist_lab_pet_stay`
- Execution Time: **47.821 ms**
- Buffers: `hit=2453`

GiST индекс использовался Index Only Scan, но запрос стал медленнее.  
низкая селективность: условие возвращает ~88k строк, поэтому последовательное сканирование с параллелизмом оказалось дешевле.

---

# 2. `stay && tsrange(...)`

### Без индекса
- План: `Parallel Seq Scan on pet`
- Execution Time: **50.002 ms**
- Buffers: `hit=4850 read=5397`

### С GiST
- План: `Index Only Scan using gist_lab_pet_stay`
- Execution Time: **51.365 ms**
- Buffers: `hit=2450`

GiST индекс снова использован, но ускорения нет.  
Условие возвращает ~145k строк, что делает индекс невыгодным.

---

# 3. `work_years @> 5`

### Без индекса
- План: `Parallel Seq Scan on employee`
- Execution Time: **29.259 ms**
- Buffers: `hit=154 read=9375`

### С GiST
- План: `Index Only Scan using gist_lab_emp_years`
- Execution Time: **48.126 ms**
- Buffers: `hit=1908`

GiST индекс используется, но Seq Scan быстрее. совпадений слишком много

---

# 4. `work_years && int4range(3,9)`

### Без индекса
- План: `Parallel Seq Scan on employee`
- Execution Time: **28.116 ms**
- Buffers: `hit=250 read=9279`

### С GiST
- План: `Index Only Scan using gist_lab_emp_years`
- Execution Time: **64.020 ms**

Индекс используется, но результат хуже Seq Scan. очень низкая селективность

---

# 5. `ST_DWithin(location, point, radius)`

### Без индекса
- План: `Seq Scan on petshop`
- Execution Time: **10.417 ms**

### С GiST
- План: `Index Scan using gist_lab_petshop_loc`
- Execution Time: **90.484 ms**

GiST индекс используется Index Scan, но на небольшой таблице Seq Scan оказался быстрее.