--------------------------------
-- Looking at Data (CovidDeath):
--------------------------------
SELECT * 
FROM CovidDeaths$
ORDER BY 3,4

--------------------------------------
-- Looking at Data (CovidVaccination):
--------------------------------------
SELECT *
FROM CovidVaccinations$
ORDER BY 3,4


--------------------------------
-- Data Selections (CovidDeath): 
--------------------------------
SELECT
	location,
	date,
	population
	total_cases,
	new_cases,
	total_deaths
FROM CovidDeaths$
ORDER BY 1,2

--------------------------------------
-- Data Selections (CovidVaccination): 
--------------------------------------
SELECT
	location,
	date,
	new_tests,
	total_tests,
	new_vaccinations,
	total_vaccinations
FROM CovidVaccinations$
ORDER BY 1,2

---------------------------
-- Global details on COVID:
---------------------------
SELECT
	SUM(new_cases) AS total_cases,
	SUM(CAST(new_deaths as INT)) AS total_deaths,
	ROUND(SUM(CAST(new_deaths as INT))/SUM(new_cases) * 100, 2) AS death_rate
FROM CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 1,2;

------------------------------------------------------
-- (Univariate) Countries with highest infection count 
------------------------------------------------------
SELECT TOP 10
	location,
	population,
	MAX(total_cases) AS highest_infection
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY  
	location,
	population
ORDER BY 
	highest_infection DESC


--------------------------------------------------
-- (Univariate) Countries with highest death count
--------------------------------------------------
SELECT
	location,
	population,
	MAX(CONVERT(INT, total_deaths)) AS highest_death_count
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY  
	location,
	population
ORDER BY 
	highest_death_count DESC


--SELECT
--	location,
--	population,
--	MAX(CONVERT(INT, total_deaths)) AS highest_death_count
--FROM CovidDeaths$
--WHERE continent IS NULL AND location NOT IN('World', 'International', 'European Union')
--GROUP BY  
--	location,
--	population
--ORDER BY 
--	highest_death_count DESC


--------------------------------------------------------
-- (Univariate) Countries with highest vaccinated count
--------------------------------------------------------
SELECT
	location,
	MAX(CONVERT(INT, total_vaccinations)) AS highest_vaccinated_count,
	MAX(CONVERT(INT, people_fully_vaccinated)) AS highest_fully_vaccinated
FROM CovidVaccinations$
WHERE continent IS NOT NULL
GROUP BY  
	location
ORDER BY 
	highest_vaccinated_count DESC, highest_fully_vaccinated

-------------------------------------------------------
-- (Univariate) Countries with highest COVID test count
-------------------------------------------------------
SELECT
	location,
	MAX(CONVERT(INT, total_tests)) AS highest_vaccine_test_count
FROM CovidVaccinations$
WHERE continent IS NOT NULL
GROUP BY  
	location
ORDER BY 
	highest_vaccine_test_count DESC


----------------------------------------------
-- Countries with Highest Death per Population
----------------------------------------------
SELECT
	location,
	MAX(total_deaths/population) AS death_per_population
FROM CovidDeaths$
-- WHERE location LIKE '%South Africa%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_per_population DESC;


----------------------------------------------------
-- Countries with Highest vaccination per Population
----------------------------------------------------
SELECT
	cd.location,
	MAX(cv.people_vaccinated/cd.population) AS vaccination_per_population
FROM CovidVaccinations$ cv
JOIN CovidDeaths$ cd ON cd.location = cv.location
-- WHERE location LIKE '%South Africa%'
WHERE cd.continent IS NOT NULL
GROUP BY cd.location
ORDER BY vaccination_per_population DESC;


--------------------------------------------
-- (Bivariate) Total Deaths vs Total Cases
-- (Calculates the fatality rate from COVID)
--------------------------------------------
SELECT 
	location,
	date,
	total_cases,
	CAST(total_deaths AS INT) AS total_deaths,
	ROUND((CONVERT(INT, total_deaths)/total_cases) * 100, 2) AS fatality_rate
FROM CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 
	location, 
	date


---------------------------------------------
-- (Bivariate) Total Cases vs Population
-- (Calculates the % of population from COVID)
---------------------------------------------
SELECT 
	location,
	date,
	population,
	total_cases,
	ROUND((total_cases/population) * 100, 2) AS covid_percentage_population
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY 
	location, 
	date,
	population,
	total_cases
ORDER BY 
	location,
	date,
	covid_percentage_population DESC


-------------------------------------------
-- Total Population vs Vaccinations
-- (% of population received COVID Vaccine)
-------------------------------------------

SELECT
	CD.continent,
	CD.location,
	CD.date,
	CD.population,
	CV.new_vaccinations,
	SUM(CONVERT(int, CV.new_vaccinations)) OVER (
		PARTITION BY CD.location 
		ORDER BY CD.location, CD.date) AS people_vaccinated
FROM CovidDeaths$ CD
JOIN CovidVaccinations$ CV ON CV.location = CD.location 
AND CV.date = CD.date
WHERE CD.continent IS NOT NULL
ORDER BY 2, 3;

-------------------------------------------------------------------------------
-- Vaccinated Rate by using Common Table Expression (CTE) on Partitioned Table:
-------------------------------------------------------------------------------

WITH VaccineCTE(continent, location, date, population, new_vaccinations, people_vaccinated)
AS (SELECT
		CD.continent,
		CD.location,
		CD.date,
		CD.population,
		CV.new_vaccinations,
		SUM(CONVERT(INT, CV.new_vaccinations)) OVER (PARTITION BY CD.location
													 ORDER BY CD.location, CD.date) AS people_vaccinated
	FROM CovidDeaths$ CD
	JOIN CovidVaccinations$ CV ON CV.location = CD.location AND CV.date = CD.date
	WHERE CD.continent IS NOT NULL
)

SELECT *,
	(people_vaccinated/population) * 100 AS vaccinated_percentage
FROM VaccineCTE
ORDER BY location, date

--------------------------------------------
-- TEMP Table on Partition Table from above:
--------------------------------------------

DROP TABLE IF EXISTS PopulationVaccinatedPercentage
CREATE TABLE PopulationVaccinatedPercentage(
	continent varchar(255),
	location varchar(255),
	date datetime,
	year int,
	month int,
	monthname varchar(3),
	population numeric,
	new_vaccinations numeric,
	people_vaccinated numeric,
	vaccination_rate float
);

INSERT INTO PopulationVaccinatedPercentage
SELECT 
	CD.continent,
	CD.location,
	CD.date,
	YEAR(CD.date) AS year,
	MONTH(CD.date) AS month,
	FORMAT(CD.date, 'MMM', 'en-US') AS monthname,
	CD.population,
	CV.new_vaccinations,
	SUM(CONVERT(int, CV.new_vaccinations)) OVER (
	PARTITION BY CD.location 
	ORDER BY CD.location, CD.date) AS people_vaccinated,
	(CV.new_vaccinations/CD.population) * 100 AS vaccination_rate
FROM CovidDeaths$ CD
JOIN CovidVaccinations$ CV ON CV.location = CD.location 
AND CV.date = CD.date


-------------------------------------------------
-- TEMP Table on Partition Table for CovidDeaths:
-------------------------------------------------

-- CovidDeaths:
DROP TABLE IF EXISTS CovidPopulationDeaths
CREATE TABLE CovidPopulationDeaths(
	continent varchar(255),
	location varchar(255),
	population numeric,
	infected_count numeric,
	death_count numeric,
	population_infection_rate float,
	fatality_rate float,
	population_death_rate float
);

INSERT INTO CovidPopulationDeaths 
SELECT
	continent,
	location,
	population,
--  measurements:
	MAX(total_cases) AS infected_counts,
	MAX(CONVERT(INT, total_deaths)) AS death_counts,
	MAX(total_cases/population) * 100 AS population_infection_rate,
	(MAX(CONVERT(INT, total_deaths))/MAX(total_cases)) * 100 AS fatality_rate,
	(MAX(CONVERT(INT, total_deaths))/population) * 100 AS population_death_rate
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent, location, population
ORDER BY location;

-------------------------------
-- CovidDeaths (Date included):
-------------------------------

SELECT
	continent,
	location,
	population,
	date,
	YEAR(date) AS year,
	MONTH(date) AS month,
	FORMAT(date, 'MMM', 'en-US') AS monthname,
	total_cases AS infected_counts,
--  measurements:
	(CONVERT(INT, total_deaths)) AS death_counts,
	(total_cases/population) * 100 AS population_infection_rate,
	CONVERT(INT, total_deaths)/total_cases * 100 AS fatality_rate,
	CONVERT(INT, total_deaths)/population * 100 AS population_death_rate
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent, location, population, date, total_cases, total_deaths
ORDER BY population_death_rate desc;