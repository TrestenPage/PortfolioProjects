Select TOP(10) *
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 3,4

/* Select TOP(10) *
From PortfolioProject..CovidVaccinations
Order by 3,4
*/

-- Select Data that we are going to be using 
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1, 2


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract Covid in your Country 
Select Location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1, 2 


-- Looking at Total Cases vs Population
-- Shows what percentage of population contracted Covid
Select Location, date, population, total_cases, (total_cases / population)*100 as InfectedPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1, 2 


-- Looking at Countries with highest Infection Rate compared to Population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases / population))*100 as ContractedPercentage
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
Where continent is not null 
Group By Location, population
order by ContractedPercentage DESC


-- Looking at Countries with Highest Death Count per Population
Select Location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
Where continent is not null 
Group By Location
order by TotalDeathCount DESC


-- LET'S BREAK THINGS DOWN BY CONTINENT 
Select [location], MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
Where continent is null 
Group By location
order by TotalDeathCount DESC


-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 --, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
Where continent is not null 
--Group By date
order by 1, 2 


-- Looking at Total Population vs Vaccinations
Select TOP(1000) dea.continent, dea.[location], dea.[date], vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinatd/population)*100
From PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.location
    and dea.[date] = vac.date
Where dea.continent is not null
Order by 2, 3


-- USE CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select TOP(1000) dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinatd/population)*100
From PortfolioProject..CovidDeaths dea 
 Join PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.location
    and dea.[date] = vac.date
Where dea.continent is not null
--Order by 2, 3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


-- TEMP TABLE
DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)

Insert Into #PercentPopulationVaccinated
Select  dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinatd/population)*100
From PortfolioProject..CovidDeaths dea 
 Join PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.location
    and dea.[date] = vac.date
Where dea.continent is not null
--Order by 2, 3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as 
Select  dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinatd/population)*100
From PortfolioProject..CovidDeaths dea 
 Join PortfolioProject..CovidVaccinations vac
    ON dea.[location] = vac.location
    and dea.[date] = vac.date
Where dea.continent is not null
--Order by 2, 3

Select *
From PercentPopulationVaccinated