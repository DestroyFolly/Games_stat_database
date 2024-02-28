-- запись в json file анных таблица и чтение файла

COPY (Select row_to_json(dota)
    from dota)
to 'C:\5sem\bd\testbd\dota.json';

COPY (Select row_to_json(cs)
    from cs)
to 'C:\5sem\bd\testbd\cs.json';

COPY (Select row_to_json(valorant)
    from valorant)
to 'C:\5sem\bd\testbd\valorant.json';

-- загрузить файл в таблицу
DROP TABLE IF EXISTS dota_json;
CREATE TABLE IF NOT EXISTS dota_json (
    dota_id int,
    rang text ,
    winrate int,
    rampages int,
    favrole text ,
    favhero text
);

DROP TABLE IF EXISTS json_table;
CREATE TABLE IF NOT EXISTS json_table
(
    data JSONB
);

COPY json_table from 'C:\5sem\bd\testbd\dota.json';

Select * from json_table;

INSERT INTO dota_json
Select
    (data->>'dota_id')::INT,
    data->>'rang',
    (data->>'winrate')::INT,
    (data->>'rampages')::INT,
    data->>'favrole',
    data->>'favhero'
from json_table;

Select * from dota_json;

-- Создать таблицу с данными json + заполнить ее
-- с помощью insert

drop table if exists player_json;

create temp table player_json
(
    info jsonb
);


insert into player_json(info) values
('{"id": 1, "name": "Vanya", "age": 20, "game": {"game_name": "minecraft", "hours": 500, "playing_from": 2010}}'),
('{"id": 2, "name": "Misha", "age": 20, "game": {"game_name": "warcraft", "hours": 1000, "playing_from": 2011}}'),
('{"id": 3, "name": "Kirill", "age": 19, "game": {"game_name": "fifa", "hours": 300, "playing_from": 2015}}'),
('{"id": 4, "name": "Marina", "age": 20, "game": {"game_name": "naruto", "hours": 1111, "playing_from": 2017}}'),
('{"id": 5, "name": "Regina", "age": 20, "game": {"game_name": "shararam", "hours": 9009, "playing_from": 2001}}'),
('{"id": 6, "name": "Gadzhi", "age": 20, "game": {"game_name": "dota2", "hours": 1000, "playing_from": 2019}}');


select *
from player_json


-- Действия над json

-- 1) Извлечь фрагмент json документа


drop table if exists player_json;

create temp table player_json
(
    info jsonb
);


insert into player_json(info) values
('{"id": 1, "name": "Vanya", "age": 20, "game": {"game_name": "minecraft", "hours": 500, "playing_from": 2010}}'),
('{"id": 2, "name": "Misha", "age": 20, "game": {"game_name": "warcraft", "hours": 1000, "playing_from": 2011}}'),
('{"id": 3, "name": "Kirill", "age": 19, "game": {"game_name": "fifa", "hours": 300, "playing_from": 2015}}'),
('{"id": 4, "name": "Marina", "age": 20, "game": {"game_name": "naruto", "hours": 1111, "playing_from": 2017}}'),
('{"id": 5, "name": "Regina", "age": 17, "game": {"game_name": "sims", "hours": 5000, "playing_from": 2001}}'),
('{"id": 6, "name": "Gadzhi", "age": 20, "game": {"game_name": "dota2", "hours": 1000, "playing_from": 2019}}');



select info->'name' as name, info->'game' as game
from player_json


-- 2) Извлечь значения конкретных узлов

select info->'name' as name, info->'game'->'game_name' as game_name, info->'game'->'hours' as hours
from player_json


-- 3) Проверить, существует ли узел или атрибут

create or replace function is_key_exists(info jsonb, key varchar) returns bool as
$$
begin
    return (info->key) is not null;
end;
$$ language plpgsql;


select is_key_exists(player_json.info, 'name')
from player_json;


-- 4) Изменить json документ

insert into player_json VALUES (NULL)
select *
from player_json

update player_json
set info = '{"id": 7, "name": "Steve", "age": 30, "game": {"game_name": "dota2", "hours": 1000, "playing_from": 2019}}'
where info is NULL;


-- 5) Разделить json документ на несколько строк по узлам

drop table if exists player_json;

create temp table player_json
(
    info jsonb
);


insert into player_json(info) values
('[
    {"id": 1, "name": "Vanya", "age": 20, "game": {"game_name": "minecraft", "hours": 500, "playing_from": 2010}},
    {"id": 2, "name": "Misha", "age": 20, "game": {"game_name": "warcraft", "hours": 1000, "playing_from": 2011}},
    {"id": 3, "name": "Kirill", "age": 19, "game": {"game_name": "fifa", "hours": 300, "playing_from": 2015}},
    {"id": 4, "name": "Marina", "age": 20, "game": {"game_name": "naruto", "hours": 1111, "playing_from": 2017}},
    {"id": 5, "name": "Regina", "age": 20, "game": {"game_name": "shararam", "hours": 99, "playing_from": 2001}},
    {"id": 6, "name": "Gadzhi", "age": 20, "game": {"game_name": "dota2", "hours": 1000, "playing_from": 2019}}
]');


select jsonb_array_elements(info::jsonb)
from player_json

