SELECT *
FROM [Portfolio Project 1]..CovidDeaths
order by 3,4

SELECT *
FROM [Portfolio Project 1]..CovidVaccinations
order by 3,4

--Looking for Total cases, New Cases, Total Deaths
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project 1]..CovidDeaths
order by 1,2

--Looking for Total Deaths VS Total Cases in Percentage
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project 1]..CovidDeaths
Where location like '%India%'
order by 1,2

--Looking for Total Cases VS Population in Percentage
SELECT location, date, total_cases, population, (total_cases/population)*100 as EffectedPeoplePercentage
FROM [Portfolio Project 1]..CovidDeaths
Where location like '%India%'
order by 1,2

--Looking at countries with Highest Infection Rate as compared to Population
SELECT location, population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases)/population)*100 as PercentPopulationInfected
FROM [Portfolio Project 1]..CovidDeaths
Group by location, population
order by PercentPopulationInfected desc

--Showing countries with highest death count per population
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM [Portfolio Project 1]..CovidDeaths
Group by location
order by TotalDeathCount desc

--Showing countries with highest death count per population where the continent is null
SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [Portfolio Project 1]..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc

--Showing the continent with the highest death count
SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [Portfolio Project 1]..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers
SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, (SUM(CAST(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
FROM [Portfolio Project 1]..CovidDeaths
Where continent is not null
Group by date
order by 1,2

--Global Numbers Total
SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, (SUM(CAST(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
FROM [Portfolio Project 1]..CovidDeaths
Where continent is not null
--Group by date
order by 1,2

--Starting with Covid Vaccinations
SELECT*
FROM [Portfolio Project 1]..CovidVaccinations vac
JOIN [Portfolio Project 1]..CovidDeaths dea
 ON dea.location = vac.location
 and dea.date = vac.date

 --Looking at total population VS vaccination
SELECT dea.location, dea.date, dea.continent, dea.population, vac.new_vaccinations
FROM [Portfolio Project 1]..CovidDeaths dea
JOIN [Portfolio Project 1]..CovidVaccinations vac
  ON dea.location = vac.location
  and dea.date = vac.date
 Where dea.continent is not null
 order by 1,2,3


 --Looking at total population VS vaccination (by narrowing down)
SELECT dea.location, dea.date, dea.continent, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
FROM [Portfolio Project 1]..CovidDeaths dea
JOIN [Portfolio Project 1]..CovidVaccinations vac
  ON dea.location = vac.location
  and dea.date = vac.date
 Where dea.continent is not null
 order by 1,2,3

 -- USE CTE
 With Povsvac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
 AS
 (
SELECT dea.location, dea.date, dea.continent, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
FROM [Portfolio Project 1]..CovidDeaths dea
JOIN [Portfolio Project 1]..CovidVaccinations vac
  ON dea.location = vac.location
  and dea.date = vac.date
 Where dea.continent is not null
 --order by 1,2,3
 )
SELECT* ,(RollingPeopleVaccinated/population)*100
FROM Povsvac











