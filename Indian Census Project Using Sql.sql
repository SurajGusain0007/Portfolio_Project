
use Sql_PortfolioProject;
--1.  Query to check the table
select * from Dataset_1;

-- 1.1.  Query to check the table
select * from Dataset_2;

-- 2.  find the no. of rows into our dataset
select count(*) as total_rows from Dataset_1;

-- 2.1   find the no. of rows into our second dataset
select count(*) as  total_rows from Dataset_2;

 --3 .Dataset for Bihar and Andhra Pradesh State
 select * from Dataset_1
 where State='Bihar' or State='Andhra Pradesh';

 --4.  Total Population of India
 select sum(Population) as Total_Population

 from Dataset_2;

 --5.Average Growth percentage of India
 select avg(Growth)*100 as avg_growth
 from Dataset_1;

 --6. Average Growth Percentage of every State 
 select State ,avg(Growth)*100 as avg_growth
 from Dataset_1
 Group by State;

 --7 Average Sex Ratio of Every State
 Select State,round(avg(Sex_Ratio),0) as avg_sex_ratio
 from Dataset_1
 group by State
 Order by avg_sex_ratio desc;

 --8.Average Literacy percentage Rate of Every State
 Select State,avg(Literacy) as avg_literacy
 from Dataset_1
 group by State
 Order by avg_literacy desc;

 --9 .Average Literacy Percentage rate More than 90 percent
 Select State,avg(Literacy) as avg_literacy
 from Dataset_1
 group by State
 having avg(Literacy) >90
 Order by avg_literacy desc;

 --10.Top 3 States which show highest avg_growth state
 select Top 3 State ,avg(Growth)*100 as avg_growth
 from Dataset_1
 Group by State
 order by avg_growth desc;

 --11. Top 3 State which shows Highest avg_sex_ratio state
 Select Top 3 State,round(avg(Sex_Ratio),0) as avg_sex_ratio
 from Dataset_1
 group by State
 Order by avg_sex_ratio desc;

 --12 Top 3 state and bottom 3 states literacy rate in a matrix

 -- 12.1Temp table topstates
 Drop table if exists top_states
 Create table top_states
 (State nvarchar(255),topstate float)

 insert into top_states
 Select Top 3 State,avg(Literacy) as avg_literacy
 from Dataset_1
 group by State
 Order by avg_literacy desc;

 select * from top_states order by topstate desc;

 -- 12.2 temp table bottomstates
 Drop table if exists bottom_states
 Create table bottom_states
 (State nvarchar(255),bottomstate float)

 insert into bottom_states
 Select Top 3 State,avg(Literacy) as avg_literacy
 from Dataset_1
 group by State
 Order by avg_literacy ;

 select * from bottom_states order by bottomstate ;

-- union operator
select * from(
select top 3 *  from top_states order by topstate desc) a

 union

select * from(
select top 3 * from bottom_states order by bottomstate ) b;

-- 13. fetch those states starting with a
Select distinct State
from Dataset_1
where State like 'a%';

--14. Joining  the two Table and find the number of males and females
select a.district,a.State ,round(a.population/(a.Sex_ratio+1),0) as Males,round((a.population*a.Sex_ratio)/(a.Sex_ratio+1),0) as Females from(
select d1.district,d1.State,d1.Sex_Ratio/1000 as Sex_ratio,d2.population
from Dataset_1 as d1 inner join  Dataset_2 as d2
on d1.district= d2.district) as a

-- 15  Total Males and females in every state
select d.State,sum(d.Males) as Total_male ,sum(d.Females) as Total_females
from (select a.district,a.State ,round(a.population/(a.Sex_ratio+1),0) as Males,round((a.population*a.Sex_ratio)/(a.Sex_ratio+1),0) as Females from(
select d1.district,d1.State,d1.Sex_Ratio/1000 as Sex_ratio,d2.population
from Dataset_1 as d1 inner join  Dataset_2 as d2
on d1.district= d2.district) as a)d
Group by d.State

-- 16 Joining  the two Table and find the number of literate  and illiterate

select a.district,a.State ,round(a.population/(a.literacy_ratio),0) as literate_People,round((1-a.literacy_ratio)*(a.population),0) as Illiterate_People from(
select d1.district,d1.State,d1.literacy/100 as literacy_ratio,d2.population
from Dataset_1 as d1 inner join  Dataset_2 as d2
on d1.district= d2.district) as a



--17. Total literate and illiterate in every state
select d.State,sum(d.literate_people) as Total_literate_people ,sum(d.illiterate_people) as Total_illiiterate_people
from (select a.district,a.State ,round(a.population/(a.literacy_ratio),0) as literate_people,round((1-a.literacy_ratio)*(a.population),0) as illiterate_people from(
select d1.district,d1.State,d1.literacy/100 as literacy_ratio,d2.population
from Dataset_1 as d1 inner join  Dataset_2 as d2
on d1.district= d2.district) as a)d
Group by d.State


-- 18.Population previous census

select a.district,round(a.population/(1+a.Growth),0) as previous_census_population, a.population as current_population from(
select d1.district,d1.State,d1.Growth ,d2.population
from Dataset_1 as d1 inner join  Dataset_2 as d2
on d1.district= d2.district) as a

--19. Total Previous Census of every State

Select d.State,sum(d.previous_census_population) as previous_census_population,sum(d.current_population) as current_census_population from(
select a.State, a.district,round(a.population/(1+a.Growth),0) as previous_census_population, a.population as current_population from(
select d1.district,d1.State,d1.Growth ,d2.population
from Dataset_1 as d1 inner join  Dataset_2 as d2
on d1.district= d2.district) as a)d
group by d.State

--20. Total_census Previous Population vs Current_Census_Population
select  sum(e.previous_census_population) as Total_previous_census_population,
sum(e.current_census_population) as Total_current_census_population from(
Select d.State,sum(d.previous_census_population) as previous_census_population,sum(d.current_population) as current_census_population from(
select a.State, a.district,round(a.population/(1+a.Growth),0) as previous_census_population, a.population as current_population from(
select d1.district,d1.State,d1.Growth ,d2.population
from Dataset_1 as d1 inner join  Dataset_2 as d2
on d1.district= d2.district) as a)d
group by d.State)e


--21. Area vs Population
select (g.total_area/g.Total_previous_census_population) as area_previous_cencus,(g.total_area/Total_current_census_population )
as area_current_cencus from(
select s.*,r.total_area from(
select '1' as keys ,p.*from (
select  sum(e.previous_census_population) as Total_previous_census_population,
sum(e.current_census_population) as Total_current_census_population from(
Select d.State,sum(d.previous_census_population) as previous_census_population,sum(d.current_population) as current_census_population from(
select a.State, a.district,round(a.population/(1+a.Growth),0) as previous_census_population, a.population as current_population 
from(
select d1.district,d1.State,d1.Growth ,d2.population
from Dataset_1 as d1 inner join  Dataset_2 as d2
on d1.district= d2.district) as a)d
group by d.State)e) p )s inner join (

select '1' as keys ,q.* from(select sum(Area_km2) as total_area
from Dataset_2) q ) r on s.keys=r.keys) g


--22. Top 3 Districts  in every state with highest literacy rate
select a.* from(
select district,State,Literacy, Rank() over( Partition by State order by literacy desc) rnk 
from Dataset_1)a
where a.rnk in (1,2,3)


--23 Temp Table 
Create table Abc
 (State nvarchar(255),male int,female int)

 insert into Abc
 select d.State,sum(d.Males) as Total_male ,sum(d.Females) as Total_females
from (select a.district,a.State ,round(a.population/(a.Sex_ratio+1),0) as Males,round((a.population*a.Sex_ratio)/(a.Sex_ratio+1),0) as Females from(
select d1.district,d1.State,d1.Sex_Ratio/1000 as Sex_ratio,d2.population
from Dataset_1 as d1 inner join  Dataset_2 as d2
on d1.district= d2.district) as a)d
Group by d.State

-- 23.1 Which State has more Female Population
select State from Abc
where State in(
select 
case 
when female>male then State
END as Statename
from Abc)

-- 23.2 Which State has Male Population
Select State from Abc
where State in(
select 
case 
when female<male then State
END as Statename
from Abc)
