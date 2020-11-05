drop schema if exists Steam cascade;
create schema Steam;
set search_path to Steam;

-- Define a primary key for every table
-- Wherever data in one table references another table, define a foreign key in SQL
-- Consider a NOT NULL contraint for every attribute in every table.
-- it doesn't always make sense, but it usually does - especially if your design is good
-- Express any other contraints that make sense for your domain

-- price >= 0
create domain Price as decimal(10, 2)
	default 0
	not null
	check (value >= 0);

-- owners >= 0
create domain NumOwners as integer
  default 0
  not null
  check (value >= 0);

-- positiveRatings and negativeRatings >= 0
create domain Rating as integer
	default 0
	not null
	check (value >= 0);

-- averagePlaytime and medianPlaytime >= 0
create domain Playtime as integer
	default 0
	not null
	check (value >= 0);

---- platform in ('windows', 'linux', 'mac')
create domain PlatformType as varchar(10)
	not null
	check (value in ('windows', 'linux', 'mac'));


create table Game(
	appID integer primary key,
	name varchar(300) not null,
	releaseDate date not null, -- to clean? YYYY-MM-DD select convert(varchar, getdate(), 23)
	price Price);

create table Developer(
	appID integer not null,
	developer varchar(300),
	primary key (appID, developer),
	foreign key (appID) references Game);

create table Publisher(
	appID integer not null,
	publisher varchar(80),
	primary key (appID, publisher),
	foreign key (appID) references Game);

create table Platform(
	appID integer not null,
	platform PlatformType,
	primary key (appID, platform),
	foreign key (appID) references Game);

create table Stat(
	appID integer primary key,
	positiveRatings Rating,
	negativeRatings Rating,
	averagePlaytime Playtime,
	medianPlaytime Playtime,
	owners NumOwners, -- to clean? maybe take midpoint of the string
	foreign key (appID) references Game);

create table Genre(
	appID integer not null,
	genre varchar(50) not null,
	primary key (appID, genre),
	foreign key (appID) references Game);

create table CommunityTag(
	appID integer not null,
	steamspyTag varchar(50) not null,
	primary key (appID, steamspyTag),
	foreign key (appID) references Game);

create table Category(
	appID integer not null,
	category varchar(50) not null,
	primary key (appID, category),
	foreign key (appID) references Game);
