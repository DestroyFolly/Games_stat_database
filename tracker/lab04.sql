-- Определяет игрок про или нет
create extension plpython3u;

create or replace function is_pro(wr int, hour int)
returns varchar as
$$
    if (wr > 70 and hour > 2500):
        return "Yes"
    else:
        return "No"
$$ language plpython3u;

select cs_id, rang, winrate, is_pro(winrate, hours)
from cs
where hours > 2500

-- Количество игроков в доту с количеством буйств равным 10
create or replace function rang_count(rang varchar)
returns int as
$$
    query = '''
        select *
        from (( users as U join dota as D on U.user_id = D.dota_id) as DU
            join form as F on DU.user_id = F.form_id) DUF
        where DUF.rang = '%s'
        ''' % (rampages)
    res = plpy.execute(query)
    players = 0
    if res is not None:
        for user in res:
            users +=1
$$ language plpython3u;

select rang, rang_count(rang)
from dota
group by rang

-- Информация об игроках с определённым рангом
create or replace function players_by_rang(rang varchar)
returns table(nickname varchar, age int, email varchar, version varchar) as
$$
    query = '''
        select DUF.first_name, DUF.last_name, DUF.nickname, DUF.rang
        from ((dota as D join users as U on D.dota_id = U.users_id) as DU
                join form as F on DU.user_id = F.form_id) as DUF
        where DUF.rang like '%s'
            ''' % (rang)

    res = plpy.execute(query)

    res_table = list()

    if res is not None:
        for user in res:
            res_table.append(user)

    return res_table

$$ language plpython3u;

select *
from players_by_rang('Legend')


-- Хранимая процедура
-- Обновить информацию о стране по id

create or replace procedure update_country_type_by_id(form_id int, country varchar) as
$$
    prepare = plpy.prepare("update form set type = $1 where id = $2", ["varchar", "int"])

    plpy.execute(plan, [country, form_id])
$$ language plpython3u;

call update_country_type_by_id(23, 'England');

select *
from form
where form_id = 23


-- Новое сообщение при обновлении таблицы form

create or replace function update_form_type()
returns trigger as
$$
    plpy.notice("Updated mode for table form")

$$ language plpython3u;


create trigger update_trigger_mode after update on form
for row execute procedure update_form_type();


update form
set city = 'Grozniy'
where form_id = 20;

select form_id, city
from form
where form_id = 20

-- Определяемый пользователем тип данных
-- В определенном городе получить всех игроков и узнать о них
-- их никнейм, предпочтение, и город

create type player_info_city as
(
    nickname varchar,
    preference varchar,
    city varchar
);


create or replace function players_info_all_by_city(city varchar)
returns setof player_info_city as
$$
    query = '''
        select form.nickname, form.preference, form.city
        from form
        where form.city like '%s'
            ''' % (city)

    res = plpy.execute(query)

    if res is not None:
        return res

$$ language plpython3u;


select *
from players_info_all_by_city('Moscow')




