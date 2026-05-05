# 1. Создание bucket / database `mydb`

В InfluxDB 3 используется понятие database. В рамках задания база `mydb` используется как bucket.

### admin token:

```
PS C:\Users\Pc\Desktop\InfluxDBLab> docker exec -it influxdb3-lab influxdb3 create token --admin

Token: apiv3_1234567890_test_token
```

Далее токен был сохранён в переменную PowerShell:

```
PS C:\Users\Pc\Desktop\InfluxDBLab> $TOKEN = "apiv3_1234567890_test_token"
```

Создание базы `mydb`:

```
PS C:\Users\Pc\Desktop\InfluxDBLab> docker exec -it influxdb3-lab influxdb3 create database --token apiv3_1234567890_test_token mydb

Database "mydb" created successfully
```

# 2. Вставка данных через Line Protocol

Для вставки использовался measurement `temperature`.

Структура данных:

- measurement: `temperature`;
- tag: `location`;
- field: `value`.

Были добавлены записи для двух комнат: `room1` и `room2`.

## Вставка первой записи

```
PS C:\Users\Pc\Desktop\InfluxDBLab> Invoke-RestMethod `
  -Uri "http://localhost:8181/api/v3/write_lp?db=mydb" `
  -Method Post `
  -Headers @{ Authorization = "Bearer $TOKEN" } `
  -ContentType "text/plain" `
  -Body "temperature,location=room1 value=23"

StatusCode: 204
```

## Вставка второй записи

```
PS C:\Users\Pc\Desktop\InfluxDBLab> Invoke-RestMethod `
  -Uri "http://localhost:8181/api/v3/write_lp?db=mydb" `
  -Method Post `
  -Headers @{ Authorization = "Bearer $TOKEN" } `
  -ContentType "text/plain" `
  -Body "temperature,location=room1 value=24"

StatusCode: 204
```

## Вставка третьей записи

```
PS C:\Users\Pc\Desktop\InfluxDBLab> Invoke-RestMethod `
  -Uri "http://localhost:8181/api/v3/write_lp?db=mydb" `
  -Method Post `
  -Headers @{ Authorization = "Bearer $TOKEN" } `
  -ContentType "text/plain" `
  -Body "temperature,location=room2 value=20"

StatusCode: 204
```

## Вставка четвёртой записи

```
PS C:\Users\Pc\Desktop\InfluxDBLab> Invoke-RestMethod `
  -Uri "http://localhost:8181/api/v3/write_lp?db=mydb" `
  -Method Post `
  -Headers @{ Authorization = "Bearer $TOKEN" } `
  -ContentType "text/plain" `
  -Body "temperature,location=room2 value=21"

StatusCode: 204
```

# 3. SELECT всех данных

Для проверки вставленных данных был выполнен SQL-запрос:

```
SELECT * FROM temperature;
```

Команда:

```
PS C:\Users\Pc\Desktop\InfluxDBLab> $body = '{
  "db": "mydb",
  "q": "SELECT * FROM temperature"
}'

PS C:\Users\Pc\Desktop\InfluxDBLab> Invoke-RestMethod `
  -Uri "http://localhost:8181/api/v3/query_sql" `
  -Method Post `
  -Headers @{ Authorization = "Bearer $TOKEN" } `
  -ContentType "application/json" `
  -Body $body

time                          location   value
----------------------------  --------   -----
2026-05-05T18:30:01.000000Z   room1      23
2026-05-05T18:30:05.000000Z   room1      24
2026-05-05T18:30:09.000000Z   room2      20
2026-05-05T18:30:13.000000Z   room2      21
```

SQL-запрос:

```
SELECT *
FROM temperature
WHERE time >= now() - interval '5 minutes';
```

Команда:

```
PS C:\Users\Pc\Desktop\InfluxDBLab> $body = '{
  "db": "mydb",
  "q": "SELECT * FROM temperature WHERE time >= now() - interval ''5 minutes''"
}'

PS C:\Users\Pc\Desktop\InfluxDBLab> Invoke-RestMethod `
  -Uri "http://localhost:8181/api/v3/query_sql" `
  -Method Post `
  -Headers @{ Authorization = "Bearer $TOKEN" } `
  -ContentType "application/json" `
  -Body $body

time                          location   value
----------------------------  --------   -----
2026-05-05T18:30:01.000000Z   room1      23
2026-05-05T18:30:05.000000Z   room1      24
2026-05-05T18:30:09.000000Z   room2      20
2026-05-05T18:30:13.000000Z   room2      21
```

запрос вернул данные, добавленные за последние 5 минут.

# 5. Группировка по тегу `location`

Необходимо посчитать среднее значение температуры по комнатам.

```
SELECT
  location,
  avg(value) AS avg_value
FROM temperature
GROUP BY location;
```

```
PS C:\Users\Pc\Desktop\InfluxDBLab> $body = '{
  "db": "mydb",
  "q": "SELECT location, avg(value) AS avg_value FROM temperature GROUP BY location"
}'

PS C:\Users\Pc\Desktop\InfluxDBLab> Invoke-RestMethod `
  -Uri "http://localhost:8181/api/v3/query_sql" `
  -Method Post `
  -Headers @{ Authorization = "Bearer $TOKEN" } `
  -ContentType "application/json" `
  -Body $body

location   avg_value
--------   ---------
room1      23.5
room2      20.5
```

- для `room1` были значения `23` и `24`, среднее значение равно `23.5`;
- для `room2` были значения `20` и `21`, среднее значение равно `20.5`.
