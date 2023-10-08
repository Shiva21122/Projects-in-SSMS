--Data used for tableau
Select *
From [Portfolio Project].dbo.CovidDeaths$
Where continent is not null
order by 3,4

--1

--Global Number
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as Death_Percentage
From [Portfolio Project].dbo.CovidDeaths$
Where continent is not null
Order by 1,2

--2

--Countries highest death count per populaton
Select continent, SUM(cast(new_deaths as int)) As Total_death_Count
From [Portfolio Project].dbo.CovidDeaths$ 
Where continent is not null
and location not in ('world', 'Europian Union', 'International')
--location <> 'World'AND location <> 'European Union'And location <>'International'
Group by continent
order by Total_death_Count desc

--3
--Countries with highest infection rate comperd to population
Select location, population, Max(total_cases) As Highest_Infection_Count, Max((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) * 100 AS Percentage_of_population_infected
From [Portfolio Project].dbo.CovidDeaths$ 
Where continent is not null
Group by location, population
order by Percentage_of_population_infected desc

--4

Select location, population, date , Max(total_cases) As Highest_Infection_Count, Max((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) * 100 AS Percentage_of_population_infected
From [Portfolio Project].dbo.CovidDeaths$ 
Where continent is not null
Group by location, population, date
order by Percentage_of_population_infected desc


Select location, SUM(cast(new_deaths as int)) As Total_death_Count
From [Portfolio Project].dbo.CovidDeaths$ 
Where continent is not null
and location not in ('world', 'Europian Union', 'International')
--location <> 'World'AND location <> 'European Union'And location <>'International'
Group by location
order by Total_death_Count desc
