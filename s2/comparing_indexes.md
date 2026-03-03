### 1: > (SELECT)

SELECT count(\*) FROM pet WHERE age > 10;

### 2: < (SELECT)

SELECT count(\*) FROM pet WHERE age < 3;

### 3: = (SELECT) — удобно для Hash

SELECT count(\*) FROM pet WHERE status = 'healthy';

### 4: %like (SELECT) — ведущий wildcard

SELECT id FROM pet WHERE name LIKE '%12345' LIMIT 200;

### 5: like% (SELECT)

SELECT id FROM pet WHERE name LIKE 'Pet_12%' LIMIT 200;

### 6: IN (SELECT)

SELECT count(\*) FROM pet WHERE petshop_id IN (1,2,3,4,5,6,7,8,9,10);

# Без индекса

### "EXPLAIN (ANALYZE, BUFFERS) SELECT count(\*) FROM pet WHERE age > 10;":

- Parallel Seq Scan on pet (cost=0.00..11491.08 rows=43753 width=0) (actual time=0.026..8.207 rows=34977 loops=3)
- Execution Time: 12.172 ms
- Planning Time: 0.150 ms
- Buffers: shared hit=544 read=9645

### docker exec -it petshop-postgres psql -U postgres -d petshop -c "EXPLAIN (ANALYZE, BUFFERS) SELECT count(\*) FROM pet WHERE age < 3;":

- Parallel Seq Scan on pet (cost=0.00..11491.08 rows=15955 width=0) (actual time=0.019..9.275 rows=13165 loops=3)
- Planning Time: 0.157 ms
- Execution Time: 12.750 ms
- Buffers: shared hit=640 read=9549

### docker exec -it petshop-postgres psql -U postgres -d petshop -c "EXPLAIN (ANALYZE, BUFFERS) SELECT count(\*) FROM pet WHERE status = 'healthy';":

- Parallel Seq Scan on pet (cost=0.00..11491.08 rows=26247 width=0) (actual time=0.017..11.031 rows=20785 loops=3)
- Planning Time: 0.160 ms
- Execution Time: 14.493 ms
- Buffers: shared hit=736 read=9453

### docker exec -it petshop-postgres psql -U postgres -d petshop -c "EXPLAIN (ANALYZE, BUFFERS) SELECT id FROM pet WHERE name LIKE 'Pet_12%' LIMIT 200;":

- Seq Scan on pet (cost=0.00..13314.00 rows=12626 width=8) (actual time=0.037..0.115 rows=200 loops=1)
- Planning Time: 0.139 ms
- Execution Time: 0.142 ms
- Buffers: shared hit=13 read=5

### docker exec -it petshop-postgres psql -U postgres -d petshop -c "EXPLAIN (ANALYZE, BUFFERS) SELECT count(\*) FROM pet WHERE petshop_id IN (1,2,3,4,5,6,7,8,9,10);":

- Parallel Seq Scan on pet (cost=0.03..11751.52 rows=72799 width=0) (actual time=0.019..10.797 rows=58344 loops=3)
  -Planning Time: 0.230 ms
- Execution Time: 15.861 ms
- Buffers: shared hit=837 read=9352

# После создания B-tree итндексов

1. Aggregate (cost=2467.08..2467.09 rows=1 width=8) (actual time=7.803..7.804 rows=1 loops=1)
   Buffers: shared hit=1 read=92
   -> Index Only Scan using btree_pet_age on pet (cost=0.42..2204.25 rows=105133 width=0) (actual time=0.035..4.598 rows=104930 loops=1)
   Index Cond: (age > 10)
   Heap Fetches: 0
   Buffers: shared hit=1 read=92
   Planning:
   Buffers: shared hit=128 read=4
   Planning Time: 0.352 ms
   Execution Time: 7.837 ms
   (10 rows)

### другой способ сканирования, время выполнения значительно уменьшилось, но планируемого не достигло

2. Aggregate (cost=942.26..942.27 rows=1 width=8) (actual time=2.805..2.806 rows=1 loops=1)
   Buffers: shared hit=3 read=34
   -> Index Only Scan using btree_pet_age on pet (cost=0.42..842.03 rows=40092 width=0) (actual time=0.049..1.670 rows=39496 loops=1)
   Index Cond: (age < 3)
   Heap Fetches: 0
   Buffers: shared hit=3 read=34
   Planning:
   Buffers: shared hit=132
   Planning Time: 0.256 ms
   Execution Time: 2.835 ms
   (10 rows)

### другой способ сканирования. примерно такой же результат, скорость выполнения выросла

3. Aggregate (cost=1467.42..1467.43 rows=1 width=8) (actual time=4.450..4.451 rows=1 loops=1)
   Buffers: shared hit=1 read=56
   -> Index Only Scan using btree_pet_status on pet (cost=0.42..1311.05 rows=62550 width=0) (actual time=0.074..2.616 rows=62356 loops=1)
   Index Cond: (status = 'healthy'::text)
   Heap Fetches: 0
   Buffers: shared hit=1 read=56
   Planning:
   Buffers: shared hit=134
   Planning Time: 0.221 ms
   Execution Time: 4.481 ms
   (10 rows)

### другой способ сканирования. примерно такой же результат, скорость выполнения выросла

4.  Limit (cost=0.00..210.90 rows=200 width=8) (actual time=0.013..0.124 rows=200 loops=1)
    Buffers: shared hit=2 read=7
    -> Seq Scan on pet (cost=0.00..13314.00 rows=12626 width=8) (actual time=0.012..0.113 rows=200 loops=1)
    Filter: (name ~~ 'Pet_12%'::text)
    Rows Removed by Filter: 3
    Buffers: shared hit=2 read=7
    Planning:
    Buffers: shared hit=149 read=1 dirtied=2
    Planning Time: 0.380 ms
    Execution Time: 0.144 ms
    (10 rows)

### самый лучший результат. способ сканирования не изменился, самый максимально приближенный к планируемому времени

5.  Aggregate (cost=3998.84..3998.85 rows=1 width=8) (actual time=12.454..12.454 rows=1 loops=1)
    Buffers: shared hit=31 read=150
    -> Index Only Scan using btree_pet_petshop on pet (cost=0.42..3558.51 rows=176133 width=0) (actual time=0.094..7.244 rows=175033 loops=1)
    Index Cond: (petshop_id = ANY ('{1,2,3,4,5,6,7,8,9,10}'::bigint[]))
    Heap Fetches: 0
    Buffers: shared hit=31 read=150
    Planning:
    Buffers: shared hit=177 dirtied=1
    Planning Time: 0.718 ms
    Execution Time: 12.487 ms
    (10 rows)

### другой способ сканирования. примерно такой же результат, скорость выполнения выросла, но совсем незначительно

# После создания Hash итндексов

1. Finalize Aggregate (cost=12601.60..12601.61 rows=1 width=8) (actual time=11.704..13.071 rows=1 loops=1)
   Buffers: shared hit=1324 read=8865
   -> Gather (cost=12601.39..12601.60 rows=2 width=8) (actual time=11.647..13.063 rows=3 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   Buffers: shared hit=1324 read=8865
   -> Partial Aggregate (cost=11601.39..11601.40 rows=1 width=8) (actual time=9.789..9.790 rows=1 loops=3)
   Buffers: shared hit=1324 read=8865
   -> Parallel Seq Scan on pet (cost=0.00..11491.08 rows=44122 width=0) (actual time=0.019..8.673 rows=34977 loops=3)
   Filter: (age > 10)
   Rows Removed by Filter: 48357
   Buffers: shared hit=1324 read=8865
   Planning:
   Buffers: shared hit=94 dirtied=1
   Planning Time: 0.180 ms
   Execution Time: 13.121 ms
   (16 rows)

### ничего не изменилось, кроме действительного времени и буфферов

2. Finalize Aggregate (cost=12531.48..12531.49 rows=1 width=8) (actual time=13.529..14.770 rows=1 loops=1)
   Buffers: shared hit=1420 read=8769
   -> Gather (cost=12531.27..12531.48 rows=2 width=8) (actual time=13.469..14.766 rows=3 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   Buffers: shared hit=1420 read=8769
   -> Partial Aggregate (cost=11531.27..11531.28 rows=1 width=8) (actual time=11.905..11.906 rows=1 loops=3)
   Buffers: shared hit=1420 read=8769
   -> Parallel Seq Scan on pet (cost=0.00..11491.08 rows=16073 width=0) (actual time=0.031..11.410 rows=13165 loops=3)
   Filter: (age < 3)
   Rows Removed by Filter: 70168
   Buffers: shared hit=1420 read=8769
   Planning:
   Buffers: shared hit=94
   Planning Time: 0.512 ms
   Execution Time: 14.845 ms
   (16 rows)

### стало хуже

3.  Finalize Aggregate (cost=12556.13..12556.14 rows=1 width=8) (actual time=12.519..13.516 rows=1 loops=1)
    Buffers: shared hit=1516 read=8673
    -> Gather (cost=12555.92..12556.13 rows=2 width=8) (actual time=12.330..13.510 rows=3 loops=1)
    Workers Planned: 2
    Workers Launched: 2
    Buffers: shared hit=1516 read=8673
    -> Partial Aggregate (cost=11555.92..11555.93 rows=1 width=8) (actual time=10.738..10.738 rows=1 loops=3)
    Buffers: shared hit=1516 read=8673
    -> Parallel Seq Scan on pet (cost=0.00..11491.08 rows=25934 width=0) (actual time=0.018..10.066 rows=20785 loops=3)
    Filter: (status = 'healthy'::text)
    Rows Removed by Filter: 62548
    Buffers: shared hit=1516 read=8673
    Planning:
    Buffers: shared hit=100 dirtied=1
    Planning Time: 0.205 ms
    Execution Time: 13.571 ms
    (16 rows)

### изменений практически нет, врем стало чуть лучше

4.  Limit (cost=0.00..210.90 rows=200 width=8) (actual time=0.013..0.056 rows=200 loops=1)
    Buffers: shared hit=9
    -> Seq Scan on pet (cost=0.00..13314.00 rows=12626 width=8) (actual time=0.011..0.046 rows=200 loops=1)
    Filter: (name ~~ 'Pet_12%'::text)
    Rows Removed by Filter: 3
    Buffers: shared hit=9
    Planning:
    Buffers: shared hit=90 dirtied=4
    Planning Time: 0.228 ms
    Execution Time: 0.083 ms
    (10 rows)

### время стало даже меньше планируемого. способ сканирования не изменился

5. Finalize Aggregate (cost=12933.44..12933.45 rows=1 width=8) (actual time=14.835..15.933 rows=1 loops=1)
   Buffers: shared hit=1612 read=8577
   -> Gather (cost=12933.23..12933.44 rows=2 width=8) (actual time=14.660..15.929 rows=3 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   Buffers: shared hit=1612 read=8577
   -> Partial Aggregate (cost=11933.23..11933.24 rows=1 width=8) (actual time=13.034..13.035 rows=1 loops=3)
   Buffers: shared hit=1612 read=8577
   -> Parallel Seq Scan on pet (cost=0.03..11751.52 rows=72680 width=0) (actual time=0.018..11.208 rows=58344 loops=3)
   Filter: (petshop_id = ANY ('{1,2,3,4,5,6,7,8,9,10}'::bigint[]))
   Rows Removed by Filter: 24989
   Buffers: shared hit=1612 read=8577
   Planning:
   Buffers: shared hit=144 dirtied=1
   Planning Time: 0.379 ms
   Execution Time: 15.969 ms
   (16 rows)

### практически ничего не изменилось

# Составной индекс

5.  Aggregate (cost=1126.25..1126.26 rows=1 width=8) (actual time=4.485..4.486 rows=1 loops=1)
    Buffers: shared hit=22 read=49
    -> Index Only Scan using btree_pet_petshop_status on pet (cost=0.42..1018.02 rows=43292 width=0) (actual time=0.059..2.642 rows=43716 loops=1)
    Index Cond: ((petshop_id = ANY ('{1,2,3,4,5,6,7,8,9,10}'::bigint[])) AND (status = 'healthy'::text))
    Heap Fetches: 0
    Buffers: shared hit=22 read=49
    Planning:
    Buffers: shared hit=146 read=1
    Planning Time: 0.519 ms
    Execution Time: 4.533 ms
    (10 rows)

### с составным индексом ыремя выполнения уменьшилось. изменился тип сканирования
