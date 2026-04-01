### задание 1:

- какой тип сканирования использован;
  - какие из уже созданных индексов не помогают этому запросу;
  - почему планировщик выбирает именно такой план.

## до:

```
"Seq Scan on store_checks  (cost=0.00..1880.07 rows=1 width=26) (actual time=3.756..3.758 rows=3 loops=1)"
"  Filter: ((sold_at >= '2025-02-14 00:00:00'::timestamp without time zone) AND (sold_at < '2025-02-15 00:00:00'::timestamp without time zone) AND (shop_id = 77))"
"  Rows Removed by Filter: 70001"
"Planning Time: 0.062 ms"
"Execution Time: 3.776 ms"
```

- сейчас ему особо ничего не помогает. Просто по очереди идёт чтение страниц. ЛУчше всего подойдёт индекс по равенству и по диапозону:

```
CREATE INDEX idx_store_checks_shop_id_sold_at
ON store_checks (shop_id, sold_at);
```

## после:

```
"Index Scan using idx_store_checks_shop_id_sold_at on store_checks  (cost=0.42..8.44 rows=1 width=26) (actual time=0.035..0.037 rows=3 loops=1)"
"  Index Cond: ((shop_id = 77) AND (sold_at >= '2025-02-14 00:00:00'::timestamp without time zone) AND (sold_at < '2025-02-15 00:00:00'::timestamp without time zone))"
"Planning Time: 0.976 ms"
"Execution Time: 0.094 ms"
```

- отлично изменилось время выполнения. Поменялся способ сканирования на Index Scan.
- Планировщик выбирает план на основе оценки селективности условий и стоимости доступа. Если подходящего составного индекса нет или ожидается, что запрос затронет заметную долю строк, может быть выбран Seq Scan. После появления индекса доступ становится более адресным, и стоимость индексного плана снижается.

### задание 2:

## до:

```
"Hash Join  (cost=690.74..1802.04 rows=727 width=27) (actual time=2.532..5.505 rows=819 loops=1)"
"  Hash Cond: (v.member_id = m.id)"
"  ->  Bitmap Heap Scan on club_visits v  (cost=233.41..1315.77 rows=11024 width=22) (actual time=0.770..2.659 rows=10998 loops=1)"
"        Recheck Cond: ((visit_at >= '2025-02-01 00:00:00'::timestamp without time zone) AND (visit_at < '2025-02-10 00:00:00'::timestamp without time zone))"
"        Heap Blocks: exact=917"
"        ->  Bitmap Index Scan on idx_club_visits_visit_at  (cost=0.00..230.66 rows=11024 width=0) (actual time=0.666..0.666 rows=10998 loops=1)"
"              Index Cond: ((visit_at >= '2025-02-01 00:00:00'::timestamp without time zone) AND (visit_at < '2025-02-10 00:00:00'::timestamp without time zone))"
"  ->  Hash  (cost=439.00..439.00 rows=1466 width=13) (actual time=1.749..1.750 rows=1466 loops=1)"
"        Buckets: 2048  Batches: 1  Memory Usage: 85kB"
"        ->  Seq Scan on club_members m  (cost=0.00..439.00 rows=1466 width=13) (actual time=0.011..1.506 rows=1466 loops=1)"
"              Filter: (member_level = 'premium'::text)"
"              Rows Removed by Filter: 20534"
"Planning Time: 0.421 ms"
"Execution Time: 5.610 ms"
```

- использован hash join. Это из-за того, что для этого конкретного плана Hash Join выглядит для планировщика дешевле, чем Nested Loop или Merge Join.

- Предложите и создайте одно улучшение, которое может ускорить запрос:

```
CREATE INDEX idx_club_visits_visit_at_member_id
ON club_visits (visit_at, member_id);
```

- Повторно постройте план выполнения:

```
"Hash Join  (cost=683.92..1790.37 rows=715 width=27) (actual time=2.190..4.290 rows=819 loops=1)"
"  Hash Cond: (v.member_id = m.id)"
"  ->  Bitmap Heap Scan on club_visits v  (cost=226.59..1304.83 rows=10749 width=22) (actual time=0.648..1.883 rows=10998 loops=1)"
"        Recheck Cond: ((visit_at >= '2025-02-01 00:00:00'::timestamp without time zone) AND (visit_at < '2025-02-10 00:00:00'::timestamp without time zone))"
"        Heap Blocks: exact=917"
"        ->  Bitmap Index Scan on idx_club_visits_visit_at  (cost=0.00..223.91 rows=10749 width=0) (actual time=0.557..0.557 rows=10998 loops=1)"
"              Index Cond: ((visit_at >= '2025-02-01 00:00:00'::timestamp without time zone) AND (visit_at < '2025-02-10 00:00:00'::timestamp without time zone))"
"  ->  Hash  (cost=439.00..439.00 rows=1466 width=13) (actual time=1.534..1.534 rows=1466 loops=1)"
"        Buckets: 2048  Batches: 1  Memory Usage: 85kB"
"        ->  Seq Scan on club_members m  (cost=0.00..439.00 rows=1466 width=13) (actual time=0.009..1.332 rows=1466 loops=1)"
"              Filter: (member_level = 'premium'::text)"
"              Rows Removed by Filter: 20534"
"Planning Time: 0.523 ms"
"Execution Time: 4.393 ms"
```

- Кратко поясните, улучшился ли план и за счет чего: стало немного лучше. Join не поменялся. Время выполнения немного ускорилось.
- Отдельно укажите, что означает преобладание shared hit или read в BUFFERS: shared hit означает, что страницы были найдены в буферном кеше PostgreSQL и не читались с диска. shared read означает, что страницы пришлось загружать с диска. Преобладание hit обычно говорит о более “тёплом” кеше и меньших издержках ввода-вывода.
- Планировщик выбрал Hash Join, потому что это эффективно для соединения по равенству, особенно когда нужно обработать заметное число строк. Одна из таблиц хешируется, после чего выполняется быстрое сопоставление по ключу member_id = id.

### плохие решения:

- Индекс, не покрывающий visit_at и member_id, слаб для club_visits;
- индекс, не покрывающий member_level, слаб для фильтра по club_members;
- индекс только по PK club_members(id) нужен для соединения, но не помогает фильтровать member_level.

## задание 3:

- до: фото 1
- после: фото 2
- после delete: фото 3

После UPDATE старая версия строки не перезаписывается, а создаётся новая версия строки. У новой версии меняются xmin и обычно ctid, а у старой версии появляется значение в xmax, показывающее, какой транзакцией она была заменена или сделана неактуальной.

2. Почему UPDATE не является простым перезаписыванием

В PostgreSQL используется MVCC, поэтому UPDATE реализуется как создание новой версии строки, а не как прямое изменение старой на месте. Это позволяет разным транзакциям видеть согласованные снимки данных без грубых блокировок чтения.

3. Что произошло после DELETE

После DELETE строка физически не исчезает мгновенно, а помечается как удалённая: для неё фиксируется xmax. В обычном SELECT она больше не видна, потому что текущий снимок считает эту версию строки удалённой.

### Сравнение VACUUM / autovacuum / VACUUM FULL

VACUUM очищает мёртвые версии строк и освобождает место для повторного использования внутри таблицы. autovacuum делает то же автоматически в фоне. VACUUM FULL переписывает таблицу целиком, реально уменьшает её физический размер на диске, но работает гораздо тяжелее.

5. Что полностью блокирует таблицу

Полную блокировку таблицы может давать VACUUM FULL, потому что он переписывает таблицу целиком и требует более жёсткой блокировки.

## задание 4:

1. Что происходит с DELETE и UPDATE в B

В первом эксперименте DELETE в сессии B блокируется и ждёт завершения транзакции A, потому что строка удерживается блокировкой FOR KEY SHARE, конфликтующей с удалением. Во втором эксперименте UPDATE в сессии B также ждёт, потому что FOR NO KEY UPDATE ставит более сильную блокировку на строку.

2. Отличие FOR KEY SHARE от FOR NO KEY UPDATE

FOR KEY SHARE — более слабая блокировка: она защищает строку от изменений ключа и удаления, но менее ограничивает другие операции. FOR NO KEY UPDATE — более сильная блокировка, обычно используемая перед изменением строки, когда нужно запретить конкурентные обновления.

3. Почему обычный SELECT ведёт себя иначе

Обычный SELECT в PostgreSQL читает данные по MVCC и не ставит такие блокировки строк. Поэтому он обычно не мешает UPDATE и DELETE, если явно не указаны режимы FOR...

4. Где используется FOR NO KEY UPDATE

FOR NO KEY UPDATE полезен в прикладных сценариях, где строку собираются изменить и нужно защититься от гонок. Например, при бронировании, списании остатка, изменении счётчика или обработке заказа.
