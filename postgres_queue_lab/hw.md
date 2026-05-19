### таблица

```
CREATE TABLE orders_fake (
    id bigserial PRIMARY KEY,
    customer_email text NOT NULL,
    product_name text NOT NULL,
    created_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE tasks (
    id bigserial PRIMARY KEY,

    task_type text NOT NULL,

    payload jsonb NOT NULL,

    priority int NOT NULL,

    status text NOT NULL DEFAULT 'pending',

    attempts int NOT NULL DEFAULT 0,

    max_attempts int NOT NULL DEFAULT 3,

    locked_by text,

    locked_at timestamp,

    created_at timestamp NOT NULL DEFAULT now(),

    started_at timestamp,

    finished_at timestamp,

    error_message text
);

CREATE INDEX idx_tasks_pending_priority
ON tasks(priority DESC, created_at)
WHERE status = 'pending';
```

### проверка таблиц

```
petShop=# \dt
           List of relations
 Schema |    Name    | Type  |  Owner
--------+------------+-------+----------
 public | pet_orders | table | postgres
 public | tasks      | table | postgres
(2 rows)
```

- Producer создаёт задачи;
- worker-1 и worker-2 обрабатывают разные задачи;
- есть статусы completed / failed;
- priority = 10 — критические задачи;
- FOR UPDATE SKIP LOCKED не даёт двум воркерам взять одну и ту же задачу.

# Вывод

Очередь реализована на PostgreSQL. Producer создаёт заказ и задачу в одной транзакции. Два Worker-процесса конкурируют за задачи. Для безопасного выбора используется FOR UPDATE SKIP LOCKED, поэтому одна задача не обрабатывается двумя воркерами одновременно. Приоритеты позволяют критическим задачам обрабатываться раньше обычных.

### увеличение нагрузки

```
в Producer await Task.Delay(5);
```

### запуск воркеров

```
petShop=# SELECT
    count(*) AS pending_tasks,
    min(created_at) AS oldest_pending_task,
    now() - min(created_at) AS queue_lag
FROM tasks
WHERE status = 'pending';
 pending_tasks |    oldest_pending_task     |    queue_lag
---------------+----------------------------+-----------------
          2889 | 2026-05-19 21:37:25.738912 | 00:14:24.893968
(1 row)
```

### пропускная способность

```
SELECT
    count(*) AS completed_last_minute,
    round(count(*) / 60.0, 2) AS tasks_per_second
FROM tasks
WHERE status IN ('completed', 'failed')
  AND finished_at >= now() - interval '1 minute';


petShop=# SELECT
    count(*) AS completed_last_minute,
    round(count(*) / 60.0, 2) AS tasks_per_second
FROM tasks
WHERE status IN ('completed', 'failed')
  AND finished_at >= now() - interval '1 minute';
 completed_last_minute | tasks_per_second
-----------------------+------------------
                    37 |             0.62
```

- pending_tasks показывает размер очереди;
- oldest_pending_task показывает самую старую необработанную задачу;
- queue_lag показывает, сколько времени задача ждёт выполнения.

### оба воркера суумарно обработали 37 задач за минуту, в секунду они выполняют 0.62 задачи

# вывод

При высокой интенсивности Producer очередь начинает расти, потому что скорость создания задач становится выше скорости обработки двумя Worker-процессами. Это видно по увеличению количества задач в статусе pending и росту queue_lag.
