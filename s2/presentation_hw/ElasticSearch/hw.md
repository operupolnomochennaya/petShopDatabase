### запрос создания индекса

```
Invoke-WebRequest -Uri "http://localhost:9200/products" -Method Put -ContentType "application/json"
```

```
StatusCode        : 200
StatusDescription : OK
Content           : {"acknowledged":true,"shards_acknowledged":true,"index":"products"}
RawContent        : HTTP/1.1 200 OK
                    X-elastic-product: Elasticsearch
                    Content-Length: 67
                    Content-Type: application/json

                    {"acknowledged":true,"shards_acknowledged":true,"index":"products"}
Forms             : {}
Headers           : {[X-elastic-product, Elasticsearch], [Content-Length, 67], [Content-Type, application/json]}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 67
```

### сщдание дока без id

```
$body = @{
    name     = "Ноутбук Lenovo IdeaPad"
    category = "electronics"
    price    = 65000
    in_stock = $true
    brand    = "Lenovo"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:9200/products/_doc" -Method Post -ContentType "application/json" -Body $body
```

```
_index        : products
_id           : jg_Su50B_pYFh4mtkdxp
_version      : 1
result        : created
_shards       : @{total=2; successful=1; failed=0}
_seq_no       : 0
_primary_term : 1
```

### добавить документ с указанным id = 2

```
$body = @{
    name     = "Смартфон Samsung Galaxy"
    category = "electronics"
    price    = 48000
    in_stock = $true
    brand    = "Samsung"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:9200/products/_doc/2" -Method Put -ContentType "application/json" -Body $body
```

```
_index        : products
_id           : 2
_version      : 1
result        : created
_shards       : @{total=2; successful=1; failed=0}
_seq_no       : 1
_primary_term : 1
```

### Добавить ещё несколько документов

```
$body = @{
    name     = "Мышь Logitech"
    category = "accessories"
    price    = 2500
    in_stock = $true
    brand    = "Logitech"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:9200/products/_doc/3" -Method Put -ContentType "application/json" -Body $body

$body = @{
    name     = "Наушники Sony"
    category = "electronics"
    price    = 7000
    in_stock = $false
    brand    = "Sony"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:9200/products/_doc/4" -Method Put -ContentType "application/json" -Body $body

$body = @{
    name     = "Планшет Apple iPad"
    category = "electronics"
    price    = 52000
    in_stock = $true
    brand    = "Apple"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:9200/products/_doc/5" -Method Put -ContentType "application/json" -Body $body
```

```
_index        : products
_id           : 3
_version      : 1
result        : created
_shards       : @{total=2; successful=1; failed=0}
_seq_no       : 2
_primary_term : 1

_index        : products
_id           : 4
_version      : 1
result        : created
_shards       : @{total=2; successful=1; failed=0}
_seq_no       : 3
_primary_term : 1

_index        : products
_id           : 5
_version      : 1
result        : created
_shards       : @{total=2; successful=1; failed=0}
_seq_no       : 4
_primary_term : 1
```

### обновлениу документа

```
$body = @{
    doc = @{
        price    = 7500
        in_stock = $true
    }
} | ConvertTo-Json -Depth 3

Invoke-RestMethod -Uri "http://localhost:9200/products/_update/4" -Method Post -ContentType "application/json" -Body $body

_index        : products
_id           : 4
_version      : 2
result        : updated
_shards       : @{total=2; successful=1; failed=0}
_seq_no       : 5
_primary_term : 1
```

### удаление документа

```
Invoke-RestMethod -Uri "http://localhost:9200/products/_doc/3?pretty" -Method Delete

_index        : products
_id           : 3
_version      : 2
result        : deleted
_shards       : @{total=2; successful=1; failed=0}
_seq_no       : 6
_primary_term : 1
```

## запросы

### match

```
$body = '{
  "query": {
    "match": {
      "name": "Lenovo"
    }
  }
}'

Invoke-RestMethod -Uri "http://localhost:9200/products/_search?pretty" -Method Post -ContentType "application/json" -Body $body

took timed_out _shards                                       hits
---- --------- -------                                       ----
 132     False @{total=1; successful=1; skipped=0; failed=0} @{total=; max_score=1,2576691; hits=System.Object[]}
```

### term

```
$body = '{
  "query": {
    "term": {
      "brand.keyword": "Samsung"
    }
  }
}'

Invoke-RestMethod -Uri "http://localhost:9200/products/_search?pretty" -Method Post -ContentType "application/json" -Body $body

took timed_out _shards                                       hits
---- --------- -------                                       ----
   5     False @{total=1; successful=1; skipped=0; failed=0} @{total=; max_score=1,3862942; hits=System.Object[]}
```

### range

```
$body = '{
  "query": {
    "range": {
      "price": {
        "gt": 10000
      }
    }
  }
}'

Invoke-RestMethod -Uri "http://localhost:9200/products/_search?pretty" -Method Post -ContentType "application/json" -Body $body

took timed_out _shards                                       hits
---- --------- -------                                       ----
  20     False @{total=1; successful=1; skipped=0; failed=0} @{total=; max_score=1,0; hits=System.Object[]}
```

### bool

```
$body = '{
  "query": {
    "bool": {
      "must": [
        { "match": { "category": "electronics" } },
        { "range": { "price": { "gt": 10000 } } },
        { "term": { "in_stock": true } }
      ]
    }
  }
}'

Invoke-RestMethod -Uri "http://localhost:9200/products/_search?pretty" -Method Post -ContentType "application/json" -Body $body

took timed_out _shards                                       hits
---- --------- -------                                       ----
  11     False @{total=1; successful=1; skipped=0; failed=0} @{total=; max_score=1,3746934; hits=System.Object[]}
```
