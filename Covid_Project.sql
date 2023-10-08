Select *
From [Portfolio Project].dbo.CovidDeaths$
Where continent is not null
order by 3,4

--Select *
--From [Portfolio Project].dbo.CovidVaccinations$
--order by 3,4

--Selecting Data I going to use

Select location, date, total_cases, total_cases_per_million, new_cases,total_deaths,population
From [Portfolio Project].dbo.CovidDeaths$ 
Where continent is not null
order by 1,2
 

 -- Looking Total Case vs Total Deaths

Select location, date, total_cases, total_cases_per_million, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
From [Portfolio Project].dbo.CovidDeaths$ 
Where continent is not null
order by 1,2


--Looking at Total cases vs Population
--Cases Per_Million and Per Hundred
Select location, date, total_cases, population, total_cases_per_million, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS Total_case_Hundred
From [Portfolio Project].dbo.CovidDeaths$
Where continent is not null
order by 1,2

--Countries with highest infection rate comperd to population
Select location, population, Max(total_cases) As Highest_Infection_Count, Max((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) * 100 AS Percentage_of_population_infected
From [Portfolio Project].dbo.CovidDeaths$ 
Where continent is not null
Group by location, population
order by Percentage_of_population_infected desc

--Countries highest death count per populaton
Select location, Max(cast(total_deaths as int)) As Total_death_Count
From [Portfolio Project].dbo.CovidDeaths$ 
Where continent is not null
Group by location
order by Total_death_Count desc

--By Continent
Select location, Max(cast(total_deaths as int)) As Total_death_Count
From [Portfolio Project].dbo.CovidDeaths$ 
Where continent is null
And location <> 'High income'AND location <> 'upper middle income'And location <>'Lower middle income'AND location <> 'Low income'
Group by location
order by Total_death_Count desc

--By Income

Select location As Class_Income, Max(cast(total_deaths as int)) As Total_death_Count
From [Portfolio Project].dbo.CovidDeaths$ 
Where continent is null
And location <> 'World'AND location <> 'Europe'And location <>'Asia'AND location <> 'North America' AND location <> 'South America' AND location <> 'European Union' AND location <> 'Africa' AND location <> 'Oceania'
Group by location
order by Total_death_Count desc

--Global Number
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as Death_Percentage
From [Portfolio Project].dbo.CovidDeaths$
Where continent is not null
Order by 1,2

--Looking at  Total Population vs Vaccinations
Select cde.continent, cde.location,cde.date,cde.population, cva.new_vaccinations, SUM(Convert(bigint,cva.new_vaccinations)) over (partition by cde.location Order by cde.location,
cde.Date) AS Rolling_People_Vaccinated
From [Portfolio Project].dbo.CovidDeaths$ cde
Join [Portfolio Project].dbo.CovidVaccinations$ cva
On cde.location = cva.location
and cde.date = cva.date
Where cde.continent is not null
order by 2,3

--using CTE

With TPC (continent, location, date, population,new_vaccination, Rolling_People_Vaccinated)
AS
(
Select cde.continent, cde.location,cde.date,cde.population, cva.new_vaccinations, SUM(Convert(bigint,cva.new_vaccinations)) over (partition by cde.location Order by cde.location,
cde.Date) AS Rolling_People_Vaccinated
From [Portfolio Project].dbo.CovidDeaths$ cde
Join [Portfolio Project].dbo.CovidVaccinations$ cva
On cde.location = cva.location
and cde.date = cva.date
Where cde.continent is not null
)
Select *, (Rolling_People_Vaccinated/population)*100
From TPC


--Temp Table


Drop Table if exists #Population_Vaccinated_Percentage
Create Table #Population_Vaccinated_Percentage
(
Continent nvarchar(255),
location nvarchar(255),
DATE datetime,
Population numeric,
New_vaccination numeric,
Rolling_People_Vaccinated numeric,
)
Insert into #Population_Vaccinated_Percentage
Select cde.continent, cde.location,cde.date,cde.population, cva.new_vaccinations, SUM(Convert(bigint,cva.new_vaccinations)) over (partition by cde.location Order by cde.location,
cde.Date) AS Rolling_People_Vaccinated
From [Portfolio Project].dbo.CovidDeaths$ cde
Join [Portfolio Project].dbo.CovidVaccinations$ cva
On cde.location = cva.location
and cde.date = cva.date
Where cde.continent is not null

Select *, (Rolling_People_Vaccinated/population)*100 as RPVvsPopu
From #Population_Vaccinated_Percentage


