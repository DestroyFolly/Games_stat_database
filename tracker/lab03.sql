-- скалярная функция
-- считает средний процент побед игроков, у которых больше 10 буйств

create or replace function get_avg_wr() returns float as
$$
begin
    return (select avg(winrate)
        from dota
        where rampages > 10);
end;
$$ language plpgsql;

select get_avg_wr() as avgwr

-- табличная функция
-- вернуть всю информацию о пользователях с именем Степан
create or replace function get_user_by_name(name varchar)
returns table (users_id int,  age int) as
$$
begin
    return query
    select U.users_id, U.age
    from Users as U
    where U.first_name like $1 || '%';
end;
$$ language plpgsql;

select *
from get_user_by_name('Stepan')

-- многооператорная табличная функция
-- вернуть id, ранг, количество часов и процент побед в игре валорант у пользователей 20 лет
create or replace function get_vs(sa int)
returns table (vid int, rang varchar, winrate int, hours int, age int) as
$$
begin
    drop table if exists player_stat;

    create temp table player_stat
    (
        vid int,
        rang varchar,
        winrate int,
        hours int,
        age int
    );

    insert into player_stat(vid, rang, winrate, hours, age)
        select fv.valorant_id, fv.rang, fv.winrate, fv.hours, fv.age
        from (valorant as v join users as u on v.valorant_id = u.users_id) as fv
        where fv.age = sa;

    return query

    select *
    from player_stat;
end;
$$ language plpgsql;

select *
from get_vs(20)

-- рекурсивные табличные функции
-- рекурсивно вывести символы таблицы

create or replace function get_recursive_print(id_start integer)
returns table(id integer, id_on integer, letter varchar) as
$$
begin
    drop table if exists Links;

    create table if not exists Links
    (
        id serial PRIMARY KEY,
        id_on int,
        letter varchar(5)
    );

    insert into Links(id_on, letter) values
    (3, 'a'),
    (6, 'e'),
    (5, 'b'),
    (2, 'd'),
    (4, 'c');

	return query

    with recursive RecursiveLetters(id, id_on, letter) as
    (
        select l.id, l.id_on, l.letter
        from Links as l
        where l.id = $1
        union all
        select l.id, l.id_on, l.letter
        from Links as l join RecursiveLetters as rec_l on l.id = rec_l.id_on
    )

    select *
    from RecursiveLetters;
end;
$$ language plpgsql;


select *
from get_recursive_print(1)

-- процедура с параметрами
--у всех пользователей с процентом побед больше 85 увеличить количество часов на 10000

create or replace procedure add_hours(wr integer, add_hours integer) as
$$
begin
    update valorant
    set hours = hours - $2
    where winrate > $1 ;
end;
$$ language plpgsql;

call add_hours(85, 10000);

select winrate, hours
from valorant
where winrate > 85

-- рекурсивные хранимые процедуры
-- рекурсивно вывести символы таблицы

drop table if exists Links;

create table if not exists Links
(
    id serial PRIMARY KEY,
    id_on int,
    letter varchar(5)
);

insert into Links(id_on, letter) values
(3, 'a'),
(NULL, 'e'),
(5, 'b'),
(2, 'd'),
(4, 'c');


create or replace procedure recursive_print(id_start integer) as
$$
declare
    next_id integer;
    cur_letter varchar;
begin
    select l.id_on, l.letter
    from Links as l
    where l.id = id_start
    into next_id, cur_letter;

	raise notice 'Now letter - %', cur_letter;

    if next_id is NULL then
        raise notice 'End of recursion';
    else
        call recursive_print(next_id);
    end if;
end;
$$ language plpgsql;


call recursive_print(1);

-- процедура с курсорами
-- информацию об игроках, которые сыграли определенное кол-во часов (100 - 140)

create or replace procedure info_about_players_by_hours(start_hours int, end_hours int) as
$$
declare
    cur_player record;
    player_cursor cursor for
        select *
        from valorant as v
        where v.hours between start_hours and end_hours
		order by v.hours;
begin
    open player_cursor;

    loop
        fetch player_cursor into cur_player;
		exit when not found;
        raise notice 'Info - rang:%, winrate: %, kd:%, hours: %', cur_player.rang, cur_player.winrate, cur_player.kd, cur_player.hours;
    end loop;

    close player_cursor;
end;
$$ language plpgsql;


call info_about_players_by_hours(100, 140);

-- Метаданные
-- Получить id базы данных по названию
DROP PROCEDURE IF EXISTS getDbMeta(dbname TEXT);

CREATE OR REPLACE PROCEDURE getDbMeta(dbname TEXT)
AS $$
DECLARE
    dbid INT;
BEGIN
    SELECT pg_database.oid
	FROM pg_database
	WHERE pg_database.datname = dbname
    INTO dbid;
    RAISE NOTICE 'DB: %, ID: %', dbname, dbid;
END;
$$ LANGUAGE PLPGSQL;

CALL getDbMeta('lab1');

-- триггер AFTER
-- выводит информацию об обновлении при Update таблицы users

create or replace function update_info()
returns trigger as
$$
begin
    raise notice 'Update: Information was successfully updated';
    return new;
end;
$$ language plpgsql;


create trigger update_trigger after update on users
for row execute procedure update_info();


update users
set gender = 'Male'
where users_id = 1;

-- триггер INSTEAD OF UPDATE
-- выводит информацию об обновлении при Update таблицы form

create or replace function check_update_form()
returns trigger as
$$
begin
    if new.country not in (' Russia', ' Belarus') then
        raise notice 'Update: mode % is unknown', new.country;

        return null;
    else
        raise notice 'Update: form was successfully updated';

        update form
        set country = new.country
		where form_id = new.form_id;

        return new;
	end if;
end;
$$ language plpgsql;

drop view form_view;

create view form_view as
select *
from form
order by form_id
limit 20;

create trigger form_update instead of update on form_view
for each row execute procedure check_update_form();


update form_view
set country = ' Belarus'
where form_id = 2;

select *
from form
where form_id < 10