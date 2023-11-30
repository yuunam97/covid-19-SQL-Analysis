# :bar_chart::medical_symbol:microbe:COVID-19 ANALYSIS (SQL + POWER BI Visualization) :microbe::medical_symbol::bar_chart:

![Banner](https://github.com/yuunam97/covid-19-SQL-Analysis/blob/main/images/covid-banner.png?raw=true)

### Description:
This analysis aimed to provide a comprehensive understadning of the COVID-19 situation, offering insights into the spread of the virus, its impact on populations, and the progress of vaccination efforts across different regions and countries.
    - Overall COVID-19 statistics 
    - Detailed Data Selections
    - Top countries by infection, deaths and vaccination counts. 
    - Death and vaccination rates. 
    - Bivariate Analysis

The dataset utilized for this analysis was from [Coronavirus Pandemic (Our World in Data)](https://ourworldindata.org/coronavirus) dataset. This dataset was split into Deaths and Vaccination tables for data visualization using Power BI. 

### Tools used for this analysis:
- Microsoft SSMS 19.0
- SQL Server 2019
- Power BI

### The goals of this project was to analyze coutries:
- Death rate (total deaths/population)
- Infection rates (total cases/population)
- Fatality rates (total deaths/total cases)
- Number of vaccinations and New vaccinations.

### What I've learned + insights:
1. Fundamentals of SQL Querying like:
    - Data presentations
    - Conditonal Filtering
    - Common Table Expressions (CTE).
    - TEMP tables.
    - JOINs.
    - Dynamic SQL
2. Microsoft Power BI to visualize the Top countries with deaths and vaccinations. Also realized that compared to Tableau, it is more customizable in terms of the visuals and more user friendly. The ability to use DAX formulas to create new information was so awesome!
3. USA has the highest COVID infections and deaths rates. 
4. Small countries like Bhutan were countries with the highest vaccination rates. This can be explained by their higher vaccinations in their small population. 
5. Looking at this data, SOUTH AFRICA had 54k deaths with 2 million infected by COVID-19. The fatality rate was 2.43%. About 284K people were vaccinated. 

### Visualizations:
Using Power BI, the visualizations looks at the following:
_Please Note! Power BI online publishing link isn't available due to the subscription issues._

1. [COVID-19 Deaths](https://app.powerbi.com/reportEmbed?reportId=87b53381-bfe2-42e5-9da2-a640c0f4ac9c&autoAuth=true&ctid=92454335-564e-4ccf-b0b0-24445b8c03f7)

![PowerBI-Deaths](https://github.com/yuunam97/covid-19-SQL-Analysis/blob/main/images/powerbi-deaths.png?raw=true)

2. [COVID-19 Vaccinations](https://app.powerbi.com/reportEmbed?reportId=87b53381-bfe2-42e5-9da2-a640c0f4ac9c&autoAuth=true&ctid=92454335-564e-4ccf-b0b0-24445b8c03f7)

![PowerBI-Vaccinations](https://github.com/yuunam97/covid-19-SQL-Analysis/blob/main/images/powerbi-vaccinations.png?raw=true)

### Credits
1. [Coronavirus Pandemic (Our World in Data)](https://ourworldindata.org/coronavirus).
2. [COVID Data Exploration: SQL in MySQL Analysis and Insights](https://www.linkedin.com/pulse/data-exploration-covid-project-using-sql-sheik-sha-ha-m/) on basic guides on the analysis.
3. [Exploratory Data Analysis Using SQL: Unveiling Insights from COVID-19 Data](https://medium.com/@aimanmaznan/exploratory-data-analysis-using-sql-unveiling-insights-from-covid-19-data-c1ec3fe7f132)
4. Power BI inspirations from [COVID-19 Data Stories](https://community.fabric.microsoft.com/t5/COVID-19-Data-Stories-Gallery/bd-p/pbi_covid19_datastories)