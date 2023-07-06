select count (*)
from dbo.CovidDeaths$

--Select data
select location, date, total_cases, new_cases, total_deaths, population
from [SQL Portfolio].dbo.CovidDeaths$
order by 1,2

-- Looking at total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [SQL Portfolio].dbo.CovidDeaths$
where location like '%states%'
order by 1,2

--Looking at total cases vs population
--Shows what percentage of population got covid
select location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
from [SQL Portfolio].dbo.CovidDeaths$
where location like '%honduras%'
order by 1,2

--Looking at countries with highest infection rate compared to population
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentagePopulationInfected
from [SQL Portfolio].dbo.CovidDeaths$
group by location, population
order by PercentagePopulationInfected desc

--Showing countries with highest death count per population
select location, max(cast(total_deaths as int)) as totaldeaths2
from [SQL Portfolio].dbo.CovidDeaths$
where continent is not null
group by location
order by totaldeaths2 desc

--bY CONTINENT
select location, max(cast(total_deaths as int)) as totaldeaths2
from [SQL Portfolio].dbo.CovidDeaths$
where continent is null
group by location
order by totaldeaths2 desc

--Global numbers
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathPercentage
from [SQL Portfolio].dbo.CovidDeaths$
where continent is not null
group by date
order by 1,2

-- COVID VACCINATIONS

-- total populations vs vaccinations
select *
from [SQL Portfolio].dbo.CovidDeaths$ dea
join [SQL Portfolio].dbo.CovidVaccinations$ vac
   on dea.location = vac.location
   and dea.date = vac.date

-- total populations vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from [SQL Portfolio].dbo.CovidDeaths$ dea
join [SQL Portfolio].dbo.CovidVaccinations$ vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

-- Temp table

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from [SQL Portfolio].dbo.CovidDeaths$ dea
join [SQL Portfolio].dbo.CovidVaccinations$ vac
	  on dea.location = vac.location
	  and dea.date = vac.date
--where dea.continent is not null

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated
