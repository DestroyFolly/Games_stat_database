create table  if not exists class(
    id int primary key,
    name varchar,
    base_year int,
    discription varchar,
    manager_id int
);

create table  if not exists manager(
    id int PRIMARY KEY,
    FIO varchar,
    birth_year int,
    expirience int,
    number int
);

create table  if not exists visitor(
    id int PRIMARY KEY,
    FIO varchar,
    birth_year int,
    adress varchar,
    email varchar
);

create table  if not exists comprasion(
    visitor_id int,
    class_id int
);

alter table comprasion
ADD FOREIGN KEY (visitor_id) REFERENCES visitor(id),
ADD FOREIGN KEY (class_id) REFERENCES class(id);

alter table class
ADD FOREIGN KEY (manager_id) REFERENCES  manager(id);

--я копировал данные из файлов, написаных мною во время рк, мне сказали не прикладывать сами файлы
-- но приложить текст из них, я это сделал в конце

copy manager from 'C:\5sem\bd\testbd\manager.txt' WITH          delimiter ';' QUOTE '"' csv;
copy class from 'C:\5sem\bd\testbd\class.txt' WITH          delimiter ';' QUOTE '"' csv;
copy visitor from 'C:\5sem\bd\testbd\visitors.txt' WITH          delimiter ';' QUOTE '"' csv;
copy comprasion from 'C:\5sem\bd\testbd\comprasion.txt' WITH          delimiter ';' QUOTE '"' csv;


--инструкция select использующая вложенные подзапросы с уровнем вложенности 3
--вывести им
select *
from manager
where id in(select manager_id
                 from class
                 where id in (select class_id
                                    from comprasion
                                    where comprasion.visitor_id  in (select id
                                                     from visitor
                                                     where birth_year = 2003)))

--инструкция селкт использующая предикат like
--вывести поситителей с адресом (название города) начинающихся на букву s
SELECT *
    FROM visitor
    WHERE adress LIKE 's%'
    ORDER BY id;

--инструкция селект использующая простое выражение case
--возращает id и fio руководителей а также добавляет столбец в котором указано разделение по возрасту
-- (если год рождения больше 1990 - молодой, иначе - старый)
SELECT id, fio,
CASE
  WHEN birth_year >= 1990 THEN 'Young'
  ELSE 'Old'
END AS STATUS
FROM manager;

--функция
CREATE OR REPLACE PROCEDURE search_exec_keyword() AS
$$
DECLARE
    proc_name text;
    proc_source text;
BEGIN
    FOR proc_name IN (SELECT proname FROM pg_proc WHERE pronamespace = current_schema()::regnamespace) LOOP
        EXECUTE format('SELECT pg_get_functiondef(%L::regproc)', proc_name) INTO proc_source;
        IF proc_source LIKE '%EXEC%' THEN
            RAISE NOTICE 'Найдена хранимая процедура, содержащая опасное ключевое слово "EXEC": %', proc_name;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

call search_exec_keyword()


--class.txt
-- 1;Dance;2003;good dance;2
-- 2;Footbal;2009;Spartak fc;5
-- 3;Basketball;2018;Spartak bsb;1
-- 4;Voleyball;2019;Spartak vc;2
-- 5;Tennis;2016;best tennis;9
-- 6;Reading;2006;best readers;3
-- 7;Swimming;2022;more records;4
-- 8;Singing;2020;omg;6
-- 9;Math;2019;5+5;7
-- 10;Informatics;2019;ez python;8
-- 11;CS;2022;global way;10
-- 12;Dota;2021; ez int;5

--manager.txt
-- 1;MPV;1997;8;887
-- 2;RTC;1985;12;858
-- 3;SVV;1978;10;315
-- 4;KSS;1991;9;899
-- 5;LOL;1969;19;849
-- 6;LIV;1994;8;843
-- 7;KAS;2000;3;858
-- 8;NOL;1984;9;220
-- 9;TAS;1977;8;845
-- 10;BKB;1985;10;849

--visitors.txt
-- 1;MPV;2003;moscow;asd@
-- 2;FGF;2006;ufa;kkk@
-- 3;ERR;2007;moscow;dfgdhf@
-- 4;KOL;2006;kazan;gdhdf@
-- 5;ASD;2005;ufa;kkk@
-- 6;NPC;2003;moscow;loknjdg@
-- 7;ERA;2004;samara;fdhfg@
-- 8;LLL;2009;saratov;dvsgd@
-- 9;PVV;2001;sochi;dsfev@
-- 10;MDM;2007;samara;127fgg@

--comprasion.txt
-- 1;3
-- 2;5
-- 2;9
-- 3;1
-- 3;2
-- 4;4
-- 5;3
-- 6;11
-- 6;10
-- 7;8
-- 8;9
-- 8;6
-- 8;7
-- 9;2
-- 10;12
