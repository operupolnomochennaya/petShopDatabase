using System.Text.Json;
using Npgsql;
using NpgsqlTypes;

var connectionString =
    "Host=localhost;Port=5438;Database=petShop;Username=postgres;Password=112233";

var products = new[]
{
    "Dog food premium",
    "Cat toy",
    "Aquarium filter",
    "Bird cage",
    "Hamster wheel"
};

var taskTypes = new[]
{
    "send_order_email",
    "update_stock",
    "recalculate_product_rating",
    "notify_delivery"
};

var random = new Random();

while (true)
{
    var isCritical = random.NextDouble() < 0.2;
    var priority = isCritical ? 10 : 1;

    var product = products[random.Next(products.Length)];
    var taskType = taskTypes[random.Next(taskTypes.Length)];
    var email = $"user{random.Next(1, 10000)}@mail.com";

    await using var conn = new NpgsqlConnection(connectionString);
    await conn.OpenAsync();

    await using var tx = await conn.BeginTransactionAsync();

    try
    {
        long orderId;

        await using (var orderCmd = new NpgsqlCommand("""
            INSERT INTO pet_orders(customer_email, product_name)
            VALUES (@email, @product)
            RETURNING id;
            """, conn, tx))
        {
            orderCmd.Parameters.AddWithValue("email", email);
            orderCmd.Parameters.AddWithValue("product", product);

            orderId = (long)(await orderCmd.ExecuteScalarAsync())!;
        }

        var payload = JsonSerializer.Serialize(new
        {
            order_id = orderId,
            customer_email = email,
            product = product,
            critical = isCritical
        });

        await using (var taskCmd = new NpgsqlCommand("""
            INSERT INTO tasks(task_type, payload, priority)
            VALUES (@taskType, @payload::jsonb, @priority);
            """, conn, tx))
        {
            taskCmd.Parameters.AddWithValue("taskType", taskType);
            taskCmd.Parameters.Add("payload", NpgsqlDbType.Jsonb).Value = payload;
            taskCmd.Parameters.AddWithValue("priority", priority);

            await taskCmd.ExecuteNonQueryAsync();
        }

        await tx.CommitAsync();

        Console.WriteLine($"Created task={taskType}, priority={priority}, order={orderId}");
    }
    catch (Exception ex)
    {
        await tx.RollbackAsync();
        Console.WriteLine($"Producer error: {ex.Message}");
    }

    await Task.Delay(1000);
}