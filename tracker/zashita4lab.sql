BEGIN TRANSACTION;

create table users
(
    users_id   integer UNIQUE not null
        primary key,
    first_name varchar not null,
    last_name  varchar not null,
    age        integer not null,
    gender     varchar not null,
    phone      varchar not null
);

create table form
(
    form_id    integer UNIQUE not null
        primary key,
    nickname   varchar UNIQUE not null,
    country    varchar not null,
    city       varchar not null,
    preference varchar not null,
    message    varchar not null
);

create table cs
(
    cs_id   integer UNIQUE not null
        primary key,
    rang    varchar not null,
    winrate integer not null,
    kd      varchar not null,
    hs      varchar not null,
    hours   integer not null
);

create table dota
(
    dota_id  integer UNIQUE not null
        primary key,
    rang     varchar,
    winrate  integer,
    rampages integer,
    favrole  varchar,
    favhero  varchar
);

create table valorant
(
    valorant_id integer UNIQUE not null
        primary key,
    rang        varchar not null,
    winrate     integer not null,
    kd          varchar not null,
    hs          varchar not null,
    hours       integer not null
);


CREATE TABLE id_table (
    id INT PRIMARY KEY,
    users_id INT,
    form_id INT,
	cs_id INT,
	dota_id INT,
	valorant_id INT
);

COMMIT TRANSACTION;

copy users from 'C:\5sem\bd\1lab\users.txt' WITH          delimiter ';' QUOTE '"' csv;
copy form from 'C:\5sem\bd\1lab\forms.txt'               delimiter ';' QUOTE '"' csv;
copy cs from 'C:\5sem\bd\1lab\cs.txt'               delimiter ';' QUOTE '"' csv;
copy dota from 'C:\5sem\bd\1lab\dota.txt'             delimiter ';' QUOTE '"' csv;
copy valorant from 'C:\5sem\bd\1lab\valorant.txt' delimiter ';' QUOTE '"' csv;
copy id_table from 'C:\5sem\bd\1lab\id_table.txt' delimiter ';' QUOTE '"' csv;

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