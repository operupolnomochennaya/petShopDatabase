# LSN

### до вставки:

```
docker exec -it petshop-postgres psql -U postgres -d petshop -c "SELECT pg_current_wal_lsn() AS lsn_before;"
```

## lsn_before

1/7EF6AB88
(1 row)

### после вставки:

```
docker exec -it petshop-postgres psql -U postgres -d petshop -c "INSERT INTO wal_lab VALUES (1, 'first', 100);"
```

## lsn_after

1/7EF6AD08
(1 row)

## разница:

## pg_wal_lsn_diff

              60

(1 row)

# вывод: После INSERT значение LSN увеличилось, так как PostgreSQL записал изменение в WAL.

# WAL

### выполняем:

```
SELECT pg_current_wal_lsn() AS before_tx;

BEGIN;

INSERT INTO wal_lab VALUES (3, 'third', 300);

SELECT pg_current_wal_lsn() AS after_insert;
SELECT pg_current_wal_insert_lsn() AS insert_lsn;
SELECT pg_current_wal_flush_lsn() AS flush_lsn;

COMMIT;

SELECT pg_current_wal_lsn() AS after_commit;
SELECT pg_current_wal_insert_lsn() AS insert_lsn_after_commit;
SELECT pg_current_wal_flush_lsn() AS flush_lsn_after_commit;
```

## before_tx

1/7EF6B110
(1 row)

BEGIN
INSERT 0 1
after_insert

---

1/7EF6B110
(1 row)

## insert_lsn

1/7EF6B2B0
(1 row)

## flush_lsn

1/7EF6B110
(1 row)

COMMIT
after_commit

---

1/7EF6B2D8
(1 row)

## insert_lsn_after_commit

1/7EF6B2D8
(1 row)

## flush_lsn_after_commit

1/7EF6B2D8
(1 row)

## before_tx

1/7EF6B110
(1 row)

BEGIN
INSERT 0 1
after_insert

---

1/7EF6B110
(1 row)

## insert_lsn

1/7EF6B2B0
(1 row)

## flush_lsn

1/7EF6B110
(1 row)

COMMIT
after_commit

---

1/7EF6B2D8
(1 row)

## insert_lsn_after_commit

1/7EF6B2D8
(1 row)

## flush_lsn_after_commit

1/7EF6B2D8
(1 row)

- после INSERT LSN сдвинулся;

- после COMMIT WAL тоже изменился, потому что коммит тоже журналируется;

## WAL после массовой операции:

```
docker exec -it petshop-postgres psql -U postgres -d petshop -c "TRUNCATE wal_lab;"
```

очистили таблицу

### до массовой вставки:

## lsn_before_bulk

1/7EF75310
(1 row)

### после:

## lsn_after_bulk

1/7F08A000
(1 row)

### вывод: Массовая вставка 10 000 строк привела к значительному росту LSN. Разница между lsn_before_bulk и lsn_after_bulk показывает объём WAL, сгенерированный операцией.

### Создание новой бд: docker exec -it petshop-postgres psql -U postgres -c "CREATE DATABASE petshop_restore;"

### Дамп: Get-Content -Raw backups/petshop_full.sql | docker exec -i petshop-postgres psql -U postgres -d petshop_restore

### Идемпотентность:

```
PS C:\Users\Pc\Desktop\petShopDatabase\s2> Get-Content -Raw seed_extra/1_seed_test_accessories.sql | docker exec -i petshop-postgres psql -U postgres -d petshop
INSERT 0 3
PS C:\Users\Pc\Desktop\petShopDatabase\s2> Get-Content -Raw seed_extra/2_seed_test_clients.sql | docker exec -i petshop-postgres psql -U postgres -d petshop
INSERT 0 2
PS C:\Users\Pc\Desktop\petShopDatabase\s2> Get-Content -Raw seed_extra/3_seed_test_petshop.sql | docker exec -i petshop-postgres psql -U postgres -d petshop
INSERT 0 2
PS C:\Users\Pc\Desktop\petShopDatabase\s2> Get-Content -Raw seed_extra/1_seed_test_accessories.sql | docker exec -i petshop-postgres psql -U postgres -d petshop
INSERT 0 0
PS C:\Users\Pc\Desktop\petShopDatabase\s2>  Get-Content -Raw seed_extra/2_seed_test_clients.sql | docker exec -i petshop-postgres psql -U postgres -d petshop
INSERT 0 0
PS C:\Users\Pc\Desktop\petShopDatabase\s2>  Get-Content -Raw seed_extra/3_seed_test_petshop.sql | docker exec -i petshop-postgres psql -U postgres -d petshop
INSERT 0 0
```

## Для проверки идемпотентности seed-файлы были выполнены дважды. Благодаря конструкции ON CONFLICT DO NOTHING повторный запуск не привёл к дублированию данных.
