--showing all covid deaths data
select *
from coviddeaths

--showing covid vaccination data
select *
from CovidVaccinations

--selected columns from covid deaths
select location,date,total_cases,new_cases, total_deaths,population
from coviddeaths
order by 1,2


-- looking at total_cases vs total_deaths
--looking at death percentage in afghanistan
select location,date,total_cases, total_deaths , (total_deaths/total_cases)*100 as deathpercentage
from coviddeaths
where location like '%Afghanistan%'
order by date

--looking at total_cases vs population 
--showing percentage of population got covid
select location,date, population,total_cases, total_deaths, (total_cases/population)*100 as percentagepopulationinfected
from coviddeaths
where location like '%Afghanistan%'
order by 1,2


--looking at the countries with highest infection rate compare to population
select location, population,max(total_cases) as HighestInfected,  max((total_cases/population))*100 as percentagepopulationinfected
from coviddeaths
--where location like '%Afghanistan%'
group by location,population
order by percentagepopulationinfected desc



--looking at countries highest death
select location,max(total_deaths) as Highestdeathcount
from coviddeaths
where continent is not null
group by location
order by Highestdeathcount desc


--Break the things by continent 
select continent,max(total_deaths) as Highestdeathcount
from coviddeaths
where continent is not null
group by continent
order by Highestdeathcount desc


select continent,max(total_deaths) as Highestdeathcount
from coviddeaths
where continent is null
group by continent
order by Highestdeathcount desc


--Global numbers
select location,date,  SUM(cast(total_deaths as int)) as Highestdeathcount
from coviddeaths
where continent is null
group by location,date
order by Highestdeathcount desc

--GLOBAL TOTAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths
, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Highestdeathcount
from coviddeaths
where continent is not null 
--Group By date
order by 1,2


-- join on two tables coviddeaths and CovidVaccinations 
Select *
From coviddeaths dea
join CovidVaccinations vac
on dea.location = vac.location 
and dea.date =vac.date


-- showing some selected columns from both tables 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From coviddeaths dea
join CovidVaccinations vac
on dea.location = vac.location 
and dea.date =vac.date
order by RollingPeopleVaccinated 

--USE CTE

with PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From coviddeaths dea
join CovidVaccinations vac
on dea.location = vac.location 
and dea.date =vac.date
--order by 1,2 

)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From coviddeaths dea
join CovidVaccinations vac
on dea.location = vac.location 
and dea.date =vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated











--looking at the countries with highest death count rate compare to population
select location, population,max(total_deaths) as Highestdeaths,  max((total_deaths/population))*100 as percentagepopulationdeaths
from coviddeaths
where continent is not null
--where location like '%Afghanistan%'
group by location,population
order by percentagepopulationdeaths desc





