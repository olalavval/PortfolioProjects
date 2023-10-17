select * 
from PortfolioProject..coviddeaths
order by 3,4

---select * 
---from PortfolioProject..covidvaccinations

--order by 3,4 

-- selecting Data i will be using for this project.

Select Location, date, total_cases, new_cases, total_deaths, population

from PortfolioProject..coviddeaths

order by 1,2


--- total cases vs total death
---likelywood of dying if contract covid
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as death_percentage

from PortfolioProject..coviddeaths

Where location = 'nigeria'
order by 1,2

---Looking at total cases vs population
Select Location, date, total_cases, population, (total_cases/Population) *100 as casespercentage

from PortfolioProject..coviddeaths

Where location = 'nigeria'
order by 1,2

---countries with highest infction rate compared to poppulation


Select Location, population, MAX(total_cases) as highestinfection, MAX((total_cases/population)) *100 as percentagepopulationinfected

from PortfolioProject..coviddeaths
group by location,population
order by percentagepopulationinfected DESC


--- countries with the highest death count per population

Select Location, MAX(total_deaths) as totaldeathcount

from PortfolioProject..coviddeaths

where continent is not null
group by location
order by totaldeathcount DESC

---breaking things down by continent
Select location, MAX(total_deaths) as totaldeathcount

from PortfolioProject..coviddeaths

where continent is  null
group by location
order by totaldeathcount DESC

--- Global numbers
 

SELECT
  
    SUM(total_cases) AS total_cases,
    SUM(new_cases) AS new_cases,
    SUM(new_deaths) AS new_deaths,
    SUM(new_deaths) / NULLIF(SUM(new_cases), 0) AS death_percentage,
    SUM(total_deaths) AS total_deaths,
    (SUM(total_deaths) / NULLIF(SUM(total_cases), 0)) * 100 AS death_percentage_total
FROM PortfolioProject..coviddeaths
WHERE continent IS NOT NULL
---GROUP BY date
ORDER BY 1,2;


--- looking at population vs vaccination and i will be using CTE for the new column (rolling_people_vaccinated) that i created

with popvsvac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as 
(

select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated--,
--(rolling_people_vaccinated/population) *100
from PortfolioProject..coviddeaths dea
join
 PortfolioProject..covidvaccinations vac

on dea.location = vac.location
and dea.date = vac.date

where dea.continent is not null
--order by 2,3
)

select * ,(rolling_people_vaccinated/population)*100

from popvsvac

---TEMP TABLE

create table #percentagepopulationvaccinated(

continent nvarchar (255),
location nvarchar (255), 
date datetime,
population Numeric,
new_vaccinations numeric, 
rolling_people_vaccinated numeric
)
insert into #percentagepopulationvaccinated
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated--,
--(rolling_people_vaccinated/population) *100
from PortfolioProject..coviddeaths dea
join
 PortfolioProject..covidvaccinations vac

on dea.location = vac.location
and dea.date = vac.date

where dea.continent is not null
--order by 2,3
select * ,(rolling_people_vaccinated/population)*100

from #percentagepopulationvaccinated


---creating view to store data for later visualization

create view percentagepopulationvaccinated as 
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated--,
--(rolling_people_vaccinated/population) *100
from PortfolioProject..coviddeaths dea
join
 PortfolioProject..covidvaccinations vac

on dea.location = vac.location
and dea.date = vac.date

where dea.continent is not null
--order by 2,3

Select *
from percentagepopulationvaccinated