use Shark_Tank_Project;

-- 1.Total episodes were telecasted
select count(distinct Epno) from Shark_Tank;

--2.Total pitches 
select count(distinct brand) from Shark_Tank;

-- 3.How many pitches converted into funding?
select sum(a.converted_not_converted) as Funding,count(*) as total_funding ,cast(sum(a.converted_not_converted )as float)/cast(count(*) as float)*100 
as Total_Percent_Funding from(
select AmountInvestedlakhs,Case when AmountInvestedlakhs>0 then 1 else 0 end converted_not_converted from Shark_tank) a

--4.Total_Male
select sum(Male) as Total_Male from Shark_Tank;

--5.Total_Female
select sum(female) as Total_female from Shark_Tank;

--6.Gender Ratio
select sum(female)/sum(male)*100 as Feamle_Percent from Shark_Tank;

--7 total invested amount
select sum(AmountInvestedlakhs) as Total_Invested from Shark_Tank;

--8 .Average Equity Taken
select avg(a.EquityTaken) as avg_Equity_Taken from
(select * from Shark_Tank where EquityTaken>0) a

--9.Highest Amount Invested
select max(AmountInvestedlakhs) as max_amount from Shark_Tank;

--10.Highest Equity Invested
select max(EquityTaken) as max_equity from Shark_Tank;

--11 .Having atleast one women
select sum(a.female_count) as atleast_one_women from(
select female, case when female>0 then 1 else 0 end as female_count from Shark_Tank) a

--12 .Pitches converted having atleast one women
select sum(b.female_count) as Atleast_one_women from(
select  case when a.female>0 then 1 else 0 end as female_count from (
select * from Shark_Tank where Deal!='No Deal')a) b

--13.Average Team Members
Select avg(teammembers) as Avg_Team_Member from Shark_Tank;

--14.Amount invested per deal
select avg(a.AmountInvestedlakhs) as Avg_Amountinvested_perdeal from(
Select * from Shark_Tank where Deal!='No Deal') a

--15.Average Group of Contestant
select Avgage,count(Avgage) as Count_avgage 
from Shark_Tank group by Avgage order by Count_avgage desc;

--16.Location group by contestant
select Location,Count(Location) as Count_loc
from Shark_Tank group by Location order by Count_loc desc;

--17.sector group by contestant
select Sector,Count(Sector) as Count_sector
from Shark_Tank group by Sector order by Count_sector desc;

--18.Avg Equity Asked
Select avg(EquityAsked) as equity_asked from Shark_Tank;
select * from Shark_Tank;

--19.total investors group by contestant
select Totalinvestors,count(Totalinvestors) as count_totalinvestors 
from  Shark_Tank group by Totalinvestors order by count_totalinvestors desc;

--20.Partner deals
select Partners ,count(Partners) as Count_Partners
from Shark_Tank where Partners !='-'
group by Partners
order by Count_Partners desc;

-- 21.Making the matrix

(select a.keyy,a.totaldealsPresent,b.total_deals,c.totalinvested,c.avg_amountinvested from(
select 'Ashneer' as keyy ,count(AshneerAmountInvested) as totaldealsPresent
from Shark_Tank where AshneerAmountInvested is not null) a
Inner join(
select 'Ashneer' as keyy, count(AshneerAmountInvested) as total_deals
from Shark_Tank where AshneerAmountInvested is not null and AshneerAmountInvested!=0)b
on a.keyy=b.keyy
inner join (
select 'Ashneer' as keyy,sum(AshneerAmountInvested) as totalinvested,
avg(AshneerequityTaken ) as avg_amountinvested
from Shark_Tank 
where AshneerAmountInvested is not null and AshneerAmountInvested!=0)c
on b.keyy=c.keyy)
union 
(select a.keyy,a.totaldealsPresent,b.total_deals,c.totalinvested,c.avg_amountinvested from(
select 'Aman' as keyy ,count(AmanAmountInvested) as totaldealsPresent
from Shark_Tank where AmanAmountInvested is not null) a
Inner join(
select 'Aman' as keyy, count(AmanAmountInvested) as total_deals
from Shark_Tank where AmanAmountInvested is not null and AmanAmountInvested!=0)b
on a.keyy=b.keyy
inner join (
select 'Aman' as keyy,sum(AmanAmountInvested) as totalinvested,
avg(AmanequityTaken ) as avg_amountinvested
from Shark_Tank 
where AmanAmountInvested is not null and AmanAmountInvested!=0)c
on b.keyy=c.keyy)
union
(select a.keyy,a.totaldealsPresent,b.total_deals,c.totalinvested,c.avg_amountinvested from(
select 'Vineeta' as keyy ,count(VineetaAmountInvested) as totaldealsPresent
from Shark_Tank where VineetaAmountInvested is not null) a
Inner join(
select 'Vineeta' as keyy, count(VineetaAmountInvested) as total_deals
from Shark_Tank where VineetaAmountInvested is not null and VineetaAmountInvested!=0)b
on a.keyy=b.keyy
inner join (
select 'Vineeta' as keyy,sum(VineetaAmountInvested) as totalinvested,
avg(VineetaequityTaken ) as avg_amountinvested
from Shark_Tank 
where VineetaAmountInvested is not null and VineetaAmountInvested!=0)c
on b.keyy=c.keyy) 
union
(select a.keyy,a.totaldealsPresent,b.total_deals,c.totalinvested,c.avg_amountinvested from(
select 'Namita' as keyy ,count(NamitaAmountInvested) as totaldealsPresent
from Shark_Tank where NamitaAmountInvested is not null) a
Inner join(
select 'Namita' as keyy, count(NamitaAmountInvested) as total_deals
from Shark_Tank where NamitaAmountInvested is not null and NamitaAmountInvested!=0)b
on a.keyy=b.keyy
inner join (
select 'Namita' as keyy,sum(NamitaAmountInvested) as totalinvested,
avg(NamitaequityTaken ) as avg_amountinvested
from Shark_Tank 
where NamitaAmountInvested is not null and NamitaAmountInvested!=0)c
on b.keyy=c.keyy) 

-- 22.In which the startup in which has been invested in each domain/sector
select c.* from
(select brand,sector,AmountInvestedlakhs,rank() over(Partition by sector order by AmountInvestedlakhs desc)rnk
from Shark_Tank) c
where c.rnk=1;
