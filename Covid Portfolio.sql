Select *
FROM PortfolioCovid..CovidDeaths$
order by 3,4


--Select *
--FROM PortfolioCovid..
--order by 3,4




Select date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioCovid..CovidDeaths$
WHERE location like '%Poland%'
order by 1,2


-- Looking at Countries with highest infection rate compared to population



Select Location, population, MAX(total_cases) as HighestInfectionCount ,MAX(total_deaths/population )*100 as HighestDeathPercentage, MAX(total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioCovid..CovidDeaths$
--WHERE location like '%Poland%'
Group By Location, Population
order by PercentPopulationInfected desc


--Showing Countries with Highest Death Count per Population


Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioCovid..CovidDeaths$
--WHERE location like '%Poland%'
Where continent is not null
Group By location
order by TotalDeathCount desc

Select *
From CovidDeaths$
Where continent is not Null

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioCovid..CovidDeaths$
--WHERE location like '%Poland%'
Where continent is not null
Group By continent
order by TotalDeathCount desc

--Global Numbers

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as new_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
FROM PortfolioCovid..CovidDeaths$
where continent is not null
group by date
order by 1,2




--Showing Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioCovid..CovidDeaths$	
Where continent is not null
Group by location
order by TotalDeathCount desc


--Grouping by Continent


Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioCovid..CovidDeaths$	
Where continent is not null
Group by location
order by TotalDeathCount desc

-- Global Numbers

Select date, SUM(new_cases), SUM(Cast(new_deaths as int)), 
SUM(cast(New_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioCovid..CovidDeaths$
where continent is not null
Group by date
order by 1,2


--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (Partition by dea.Location Order by dea.location, dea.date)
From PortfolioCovid..CovidDeaths$ dea
Join PortfolioCovid..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (Partition by dea.Location Order by dea.location, dea.date)
From PortfolioCovid..CovidDeaths$ dea
Join PortfolioCovid..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated2 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (Partition by dea.Location Order by dea.location, dea.date) as 
RollingPeopleVaccinated2
From PortfolioCovid..CovidDeaths$ dea
Join PortfolioCovid..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated2 
