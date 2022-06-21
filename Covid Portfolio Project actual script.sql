use Portfolio_Project;

-- 1.look total_cases Vs total_deaths
-- Shows likelihoood of dying contract covid in your country 

Select location,date,total_cases,total_deaths,total_deaths/total_cases*100 as Death_percentage_rate
From Portfolio_Project..Covid_Deaths
Where location ='India'
order by 1,2;

-- 2.look total_cases Vs total_population
-- Show what percentage of Population got covid
select location,date,population,total_cases,total_cases/population*100 as Covid_infected_rate
from covid_deaths
where location='India'
order by location,date;

-- 3. Looking at countries with Highest Population Infected Rate as compared to population
select location,max(total_cases) as Highest_Infected_Count,population, max(total_cases)/population*100 as PercentPopulationInfected
from covid_deaths
group by location,population
order by PercentPopulationInfected desc;

-- 4.Showing Counties with Highest Death  as Per Population
select location,max(cast(total_deaths as int))as Total_Death_Count
from covid_deaths
where continent is not null
group by location
order by Total_Death_Count desc;


-- 5.Showing Continent with highest Death as per population
select continent,max(cast(total_deaths as int))as Total_Death_Count
from covid_deaths
where continent is not null
group by continent
order by Total_Death_Count desc;

-- 6.Showing Countries with Highest New Infected Count as Per total_cases
select location,max(total_cases) as Highest_infected_count,max(new_cases) as Highest_Infected_NewCount,max(new_cases)/max(total_cases)*100 as Percent_NewCases_Infected
from covid_deaths
group by location
order by Percent_NewCases_Infected desc;


-- 7.Global Total_new_cases,Total_New_Death and Death percentage rate every day
select date,sum(new_cases) as Total_new_cases,sum(cast(new_deaths as int)) as Total_new_death,sum(cast(new_deaths as int)) /sum(new_cases)*100 as Death_PercentageRate
from covid_deaths
where continent is not null
group by date;

--8 Vaccinated Percentage as per population
select cd.continent, cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over
(Partition by cd.location order by cd.location,cd.date) as RollingVaccinatedPeople,sum(cast(cv.new_vaccinations as int)) over
(Partition by cd.location order by cd.location,cd.date) /Population*100 as Vaccinated_Percentage
from Covid_Deaths as cd Join CovidVaccinations as cv
ON cd.location=cv.location and cd.date=cv.date
where cd.continent is not null
order by 2,3;

-- Temp Table
drop table if exists PercentVaccinatedPeople
Create table PercentVaccinatedPeople(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinatedPeople numeric,
Vaccinated_Percentage numeric)

Insert into PercentVaccinatedPeople
select cd.continent, cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over
(Partition by cd.location order by cd.location,cd.date) as RollingVaccinatedPeople,sum(cast(cv.new_vaccinations as int)) over
(Partition by cd.location order by cd.location,cd.date) /Population*100 as Vaccinated_Percentage
from Covid_Deaths as cd Join CovidVaccinations as cv
ON cd.location=cv.location and cd.date=cv.date;

-- Create View to store data for later visulization
Create view PerVaccinatedPeople as
select cd.continent, cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over
(Partition by cd.location order by cd.location,cd.date) as RollingVaccinatedPeople,sum(cast(cv.new_vaccinations as int)) over
(Partition by cd.location order by cd.location,cd.date) /Population*100 as Vaccinated_Percentage
from Covid_Deaths as cd Join CovidVaccinations as cv
ON cd.location=cv.location and cd.date=cv.date;

select * from PerVaccinatedPeople;



