using Npgsql;

var workerName = args.Length > 0 ? args[0] : "worker";

var connectionString =
    "Host=localhost;Port=5438;Database=petShop;Username=postgres;Password=112233";

var random = new Random();

while (true)
{
    long? taskId = null;
    string? taskType = null;
    int priority = 0;
    string? payload = null;

    await using (var conn = new NpgsqlConnection(connectionString))
    {
        await conn.OpenAsync();

        await using var tx = await conn.BeginTransactionAsync();

        await using var cmd = new NpgsqlCommand("""
            WITH picked AS (
                SELECT id
                FROM tasks
                WHERE status = 'pending'
                ORDER BY priority DESC, created_at
                LIMIT 1
                FOR UPDATE SKIP LOCKED
            )
            UPDATE tasks t
            SET
                status = 'running',
                locked_by = @workerName,
                locked_at = now(),
                started_at = now(),
                attempts = attempts + 1
            FROM picked
            WHERE t.id = picked.id
            RETURNING t.id, t.task_type, t.priority, t.payload::text;
            """, conn, tx);

        cmd.Parameters.AddWithValue("workerName", workerName);

        await using (var reader = await cmd.ExecuteReaderAsync())
        {
            if (await reader.ReadAsync())
            {
                taskId = reader.GetInt64(0);
                taskType = reader.GetString(1);
                priority = reader.GetInt32(2);
                payload = reader.GetString(3);
            }
        }

        await tx.CommitAsync();
    }

    if (taskId is null)
    {
        Console.WriteLine($"{workerName}: no tasks");
        await Task.Delay(2000);
        continue;
    }

    Console.WriteLine($"{workerName}: processing task={taskId}, type={taskType}, priority={priority}");
    Console.WriteLine($"{workerName}: payload={payload}");

    await Task.Delay(random.Next(2000, 5000));

    var success = random.NextDouble() > 0.2;

    await using (var conn = new NpgsqlConnection(connectionString))
    {
        await conn.OpenAsync();

        if (success)
        {
            await using var cmd = new NpgsqlCommand("""
                UPDATE tasks
                SET status = 'completed',
                    finished_at = now()
                WHERE id = @taskId;
                """, conn);

            cmd.Parameters.AddWithValue("taskId", taskId.Value);
            await cmd.ExecuteNonQueryAsync();

            Console.WriteLine($"{workerName}: completed task={taskId}");
        }
        else
        {
            await using var cmd = new NpgsqlCommand("""
                UPDATE tasks
                SET status = 'failed',
                    finished_at = now(),
                    error_message = 'simulated error'
                WHERE id = @taskId;
                """, conn);

            cmd.Parameters.AddWithValue("taskId", taskId.Value);
            await cmd.ExecuteNonQueryAsync();

            Console.WriteLine($"{workerName}: failed task={taskId}");
        }
    }
}