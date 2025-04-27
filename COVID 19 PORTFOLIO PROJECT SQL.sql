Select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

-- Select Data 

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Looking at Total cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, 
(CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0))*100 AS Deathpercentage
from PortfolioProject..CovidDeaths
Where location like '%kenya%'
order by 1,2

-- Looking at the Total Cases vs Total Deaths
--Shows what percentage of population got covid

Select location, date, population, total_cases,
(CONVERT(float,total_cases)/NULLIF(CONVERT(float,population),0))*100 AS PercentPopulationInfected
from PortfolioProject..CovidDeaths
--Where location like '%kenya%'
order by 1,2

-- Looking at countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) AS HighestInfectionCount,
(CONVERT(float,MAX(total_cases))/NULLIF(CONVERT(float,MAX(population)),0))*100 AS PercentPopulationInfected
from PortfolioProject..CovidDeaths
--Where location like '%kenya%'
GROUP BY location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--Where location like '%kenya%'
where continent is not null
Group by location
order by TotalDeathCount desc

-- Let's break things by continent

--Showing continents with the highest death count per population


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--Where location like '%kenya%'
where continent is not null
Group by continent
order by TotalDeathCount desc 

-- GLOBAL NUMBERS
Select SUM(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(cast
   (nullif(new_cases,0) as int)) * 100 as DeathPercentage
--total_deaths,
--(CONVERT(float,total_cases)/NULLIF(CONVERT(float,population),0))*100 AS PercentPopulationInfected
from PortfolioProject..CovidDeaths
--Where location like '%kenya%'
where continent is not null
Group by date
order by 1,2

-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as 
  RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE
with PopsVac (continent, location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as 
  RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *
From PopsVac

-- TEMP TABLE
DROP table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
Date datetime,
location nvarchar(255),
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as 
  RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *
From #PercentPopulationVaccinated


--Creating View to store data for later visualization

Create view PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as 
  RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select*
from PercentPopulationVaccinated


