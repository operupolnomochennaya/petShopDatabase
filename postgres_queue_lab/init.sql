CREATE TABLE pet_orders (
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