-- 1 Инструкция SELECT, использующая предикат сравнения.
SELECT users_id, first_name, last_name, age, gender, phone
    FROM public.users
    WHERE age < 16
    ORDER BY users_id;
-- 2 Инструкция SELECT, использующая предикат BETWEEN.
SELECT *
    FROM public.dota
    WHERE rampages BETWEEN 3 and 7
    ORDER BY favrole;
-- 3 Инструкция SELECT, использующая предикат LIKE.
SELECT *
    FROM public.dota
    WHERE favhero LIKE '%W%'
    ORDER BY dota_id;
-- 4 Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
SELECT *
    FROM public.dota
    WHERE dota_id IN (SELECT dota_id
					 FROM public.dota
					 WHERE winrate > 80)
		AND favrole = ' Mid'
ORDER BY rang;
-- 5 Инструкция SELECT, использующая предикат EXISTS с вложенным
-- подзапросом.
SELECT *
	FROM public.form
	WHERE EXISTS (SELECT * from public.form
			 	where city = ' Ekaterinburg'
	)
	ORDER BY city;
-- 6 Инструкция SELECT, использующая предикат сравнения с квантором.
SELECT *
	FROM public.dota
	WHERE winrate > all (SELECT winrate
					   from public.dota
			 		   where favhero = 'Techies'
	)
	ORDER BY favrole;
-- 7 Инструкция SELECT, использующая агрегатные функции в выражениях
-- столбцов.
SELECT *
  FROM public.cs
  WHERE winrate > (SELECT AVG(winrate)
          FROM cs)
  ORDER BY hours;
-- 8 Инструкция SELECT, использующая скалярные подзапросы в выражениях
-- столбцов.
SELECT *
  FROM public.users
  WHERE age > (SELECT age
          FROM users
            WHERE first_name = 'Pavel')
  ORDER BY users_id;
-- 9 Инструкция SELECT, использующая простое выражение CASE.
SELECT valorant_id, rang,
CASE
  WHEN winrate >= 50 THEN 'Good'
  ELSE 'Bad'
END AS STATUS
FROM public.valorant;
-- 10 Инструкция SELECT, использующая поисковое выражение CASE.
SELECT users_id, first_name,last_name,age,
CASE
  WHEN age < 18 THEN 'Minor'
    when age < 22 THEN 'Youth'
  ELSE 'Adult'
END AS STATUS
FROM public.users;
-- 11 Создание новой временной локальной таблицы из результирующего набора
-- данных инструкции SELECT.
SELECT dota_id, (select max(rampages)
    from public.dota) AS R_MAX,
    ((select max(rampages)
    from public.dota) - rampages) AS diff
INTO YOURPERCENT
FROM public.dota
GROUP BY dota_id
--12 Инструкция SELECT, использующая вложенные коррелированные
-- подзапросы в качестве производных таблиц в предложении FROM.
select nickname, country, winrate
from (form as f join (select dota_id, winrate
                      from dota
                      where favrole like '%upport%'
                      )as d on f.form_id = d.dota_id) as fd
--13 Инструкция SELECT, использующая вложенные подзапросы с уровнем
-- вложенности 3.
select *
from form
where form_id in(select form_id
                 from id_table
                 where users_id in (select users_id
                                    from users
                                    where age < ALL(select age
                                                     from users
                                                     where last_name like '%Maslukov%')))
--14  Инструкция SELECT, консолидирующая данные с помощью предложения
-- GROUP BY, но без предложения HAVING.
select age, gender
from users
group by age, gender
--15 Инструкция SELECT, консолидирующая данные с помощью предложения
-- GROUP BY и предложения HAVING.
select winrate, count(winrate)
from cs
group by winrate
having winrate > 60
order by winrate
--16 Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений
insert into form values (1001,'KPYTOU 4eJL', 'Russia', 'Omsk', 'Female', 'Всем йоу!!!')
--17 Многострочная инструкция INSERT, выполняющая вставку в таблицу
-- результирующего набора данных вложенного подзапроса.
insert into form
    select form_id+1, nickname, country, city, preference,message
    from form
    where form_id = 1001
--18 Простая инструкция UPDATE.
update form
set message = ' Йоу. Крутой чел из Омска на связи'
where city = ' Omsk'
--19 Инструкция UPDATE со скалярным подзапросом в предложении SET.
update users
set age = (select min(age)
           from users)
where first_name = 'Stepan'
--20 Простая инструкция DELETE.
delete from form
where form_id = 1002
--21 Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE
delete from form
where form_id in (select form_id
                  from form
                  where form_id > 1000 and city ='Omsk')
--22 Инструкция SELECT, использующая простое обобщенное табличное выражение
with cte
as (select *
    from dota)

select AVG(winrate) as "Средний процент побед"
from cte
--23 Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение.
with recursive cs(cs_id,rang,winrate,kd,hs,hours) as(
    values (1002, 'Global', 99, '1,99', '90%', 5000)
    union all
    select cs.cs_id + 1, 'Global', cs.winrate - 5, '1,99', '90%', cs.hours - 500 from cs where cs.cs_id < 1005
)

select * from cs
where cs_id > 1001
--24 Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
select rang, favrole, AVG(winrate) over (partition by favrole) as avg_win
from dota
--25 Оконные фнкции для устранения дублей
with cte as
(
    select *
    from cs
    union all
    select *
    from cs
),

delete_db as
(
    select *, row_number() over (partition by cs_id) as row_id
    from cte
)

select *
from delete_db
where row_id = 1


select first_name, last_name, nickname, city, rang, winrate
from (users as u join (select nickname, city
                      from form
                      where city = 'Kazan'
                      ) as f join (select rang, winrate
                                   from cs) as c
    on (u.user_id = f.form__id and u.user_id = c.cs_id) as ufc

