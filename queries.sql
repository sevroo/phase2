-- SET SEARCH_PATH

DROP VIEW IF EXISTS MilOwnersMultiGames CASCADE;
DROP VIEW IF EXISTS TotalPlaytime CASCADE;
DROP VIEW IF EXISTS Linux2018 CASCADE;

-- Q1: What is the average price of multiplayer games with a playerbase of at least 1,000,000
-- changed from original 200000 owners to make it a bit more interesting?

-- AppID of Multi-Player games with playerbase of at least 1,000,000 (owners)
CREATE VIEW MilOwnersMultiGames AS
    select distinct s.appID
    from stat as s
    inner join category as c
    on s.appID = c.appID
    where owners >= 1000000
    and c.category = 'Multi-player';

-- Get the avg price of those games
CREATE VIEW AvgPrice AS
    select avg(price)
    from MilOwnersMultiGames as m
    left join game as g
    on m.appID = g.appID;
-- Result: 10.6647079037800687

-- Q2: How many games have the developers with the most playtime developed but not
-- published by themselves?

----- discussion: some games have zero average playtime even if some people own the game
-- select count(*) from stat where owners>0 and averageplaytime=0;
-- Above query counts 20905 of 27075 with zero playtime.
-- Could be a lot of people don't play the game even if they own it or data not complete

-- Get total playtime for every developer
CREATE VIEW TotalPlaytime AS
    select developer, sum(averageplaytime) as total_playtime
    from developer as d
    left join stat as s
    on d.appID = s.appID
    group by developer;

-- Developer with the most playtime
CREATE VIEW PopularDev AS
    select * from TotalPlaytime
    where total_playtime = (select max(total_playtime) from TotalPlaytime);
-- Tie: Manuel Pazos and Daniel Celemin with total_playtime 190625 min (3177h)

-- AppID of the games they developed
CREATE VIEW DevGames AS
    select pd.developer, d.appID
    from PopularDev as pd
    left join developer as d
    on pd.developer = d.developer;
-- Result: The two developers developed a single game (appID: 474030) together
-- select * from game where appid = 474030;
-- Game:  The Abbey of Crime Extensum
---- discussion: never heard of this game lol. Prob exists other games with over 3177h
---- 			 playtime. data prob not reliable
-- select max(releasedate) from game; latest game is from 2019-05-01

-- Count number of games they did not publish
CREATE VIEW NumPublishedByOthers AS
    select count(*) from DevGames as dg
    left join publisher as p
    on dg.appID = p.appID
    where publisher not in (select developer from DevGames);
-- Result: zero. They published the game themselves.


-- original Q3: What games released in 2018 on Linux have a higher than average rating 
-- than the rest of the games released in 2018?
---- discussion: change to 2018 b/c latest game release in csv is 2019-05-01
---- not enough data for average rating. only number of positive & negative ratings
----									(not actual rating)

-- New Q3: Most popular community tag for games released in 2018 on Linux.
-- Get games released in 2018 on Linux
CREATE VIEW Linux2018 AS
    select g.appID
    from game as g
    inner join platform as p
    on g.appID = p.appID
    where platform = 'linux'
    and extract(year from releasedate) = 2018;

-- Get community tag and number of games tagged with this
CREATE VIEW TagPopularity AS
    select steamspytag, count(steamspytag) as num_tagged
    from Linux2018 as l
    left join communitytag as c
    on l.appID = c.appID
    group by steamspytag;

-- Get most popular tag of Linux games released in 2018
CREATE VIEW MostPopularTags AS
    select * from TagPopularity
    where num_tagged = (select max(num_tagged) from TagPopularity);
-- Result: Indie with 873 tagged