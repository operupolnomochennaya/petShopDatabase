```
SELECT
  p.id,
  p.name AS pet_name,
  c.name AS owner_name,
  c.surname AS owner_surname
FROM pet p
JOIN client c ON c.id = p.owner_id
LIMIT 20;
```
Результат: в результат попали пары питомец — владелец. Используется INNER JOIN между таблицами: в результат попадают только питомцы, у которых есть владелец, если бы у питомца не было соответствующей записи в client, такая строка не попала бы в выборку.

```
SELECT
  p.id,
  p.name,
  b.breed_name,
  at.name AS animal_type
FROM pet p
JOIN breed b ON b.id = p.breed_id
JOIN animal_type at ON at.id = b.animal_type_id
LIMIT 20;
```
Результат: Каждый питомец связан с породой и типом животного.

```
SELECT
  e.id,
  e.name,
  e.surname,
  e.profession,
  e.cage_id,
  ps.name AS petshop_name
FROM employee e
LEFT JOIN cage c ON c.id = e.cage_id
JOIN petshop ps ON ps.id = e.petshop_id
LIMIT 20;
```
Результат: В таблице присутствуют сотрудники как с клетками, так и без них. Здесь используются два типа соединений: LEFT JOIN **employee LEFT JOIN cage**
Это означает: сотрудники остаются в результате, даже если cage_id отсутствует, если клетки нет, значения из таблицы cage будут NULL.

INNER JOIN **employee JOIN petshop**
Это означает: каждый сотрудник должен быть привязан к магазину.

```
SELECT
  p.id,
  p.name,
  f.brand_name,
  f.food_type,
  ps.name AS petshop_name
FROM pet p
LEFT JOIN food f ON f.id = p.food_id
JOIN petshop ps ON ps.id = p.petshop_id
LIMIT 20;
```
Результат: Часть питомцев имеет корм, часть — нет. **LEFT JOIN food**: если у питомца нет записи food_id, он всё равно остаётся в результате; поля brand_name и food_type будут NULL.
**JOIN petshop**: гарантирует наличие магазина.

```
SELECT
  pa.pet_id,
  p.name AS pet_name,
  a.name AS accessory_name,
  pa.amount
FROM pet_accessorie pa
JOIN pet p ON p.id = pa.pet_id
JOIN accessorie a ON a.id = pa.accessorie_id
LIMIT 20;
```
Этот запрос показывает связь many-to-many: pet - pet_accessorie - accessorie
один питомец может иметь несколько аксессуаров, один аксессуар может принадлежать нескольким питомцам, промежуточная таблица pet_accessorie хранит количество аксессуаров.