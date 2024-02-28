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