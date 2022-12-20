Select location,date,total_cases,new_cases,total_deaths,population from portfolioProject.dbo.CovidDeaths
order by 1,2

--Total cases VS Total Deaths in location US

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from portfolioProject.dbo.CovidDeaths
where location like '%states%'
order by 1,2

-- Total cases vs Total Population for US
Select location,date,total_cases,population,(total_cases/population)*100 as CasePercentage
from portfolioProject.dbo.CovidDeaths
where location like '%states%'
order by 1,2

-- Countries with highest infection rate compared to population
Select location,MAX(total_cases) as HighestInfectCount,population,MAX((total_cases/population))*100 as PercentPopulationInfected
from portfolioProject.dbo.CovidDeaths
Group by Population,Location
order by PercentPopulationInfected desc

Select * from PortfolioProject..CovidDeaths where continent is not null

--Countries with Highest death count per Population
Select location,MAX(CAST(total_deaths as int)) as TotalDeathCount
from portfolioProject.dbo.CovidDeaths
where continent is not null
Group by Location
order by TotalDeathCount desc

--CONTINENT WISE
Select continent,MAX(CAST(total_deaths as int)) as TotalDeathCount
from portfolioProject.dbo.CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global Numbers
Select date,SUM(new_cases) as TotalNewCases
,SUM(cast(new_deaths as int))as TotalNewDeaths,
SUM(cast(new_deaths as int))/SUM(New_cases)*100 
as DeathPercentageGlobal
from portfolioProject.dbo.CovidDeaths
where continent is not null
group by date
order by 1,2

-- Total Population vs Vaccinations
Select d.continent,d.location,d.date,d.population
,v.new_vaccinations,
SUM(CAST(v.new_vaccinations as bigint)) OVER 
(PARTITION BY d.location order by d.location ,d.date)
as RollingPeopleVaccinated
--MAX(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths d
JOIN PortfolioProject..CovidVaccinations v
ON d.location = v.location and
d.date = v.date
where d.continent is not null
order by 2,3


--Use CTE
With PopVSVacc(Continent,Location,Population,
new_vaccinations,RollingPeopleVaccinated)
as (
Select d.continent,d.location,d.population
,v.new_vaccinations,
SUM(CAST(v.new_vaccinations as bigint)) OVER 
(PARTITION BY d.location order by d.location ,d.date)
as RollingPeopleVaccinated
--MAX(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths d
JOIN PortfolioProject..CovidVaccinations v
ON d.location = v.location and
d.date = v.date
where d.continent is not null
)

Select *,(RollingPeopleVaccinated/Population)*100 from PopVSVacc


-- TEMP TABLE

