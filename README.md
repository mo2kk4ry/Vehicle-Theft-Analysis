# Motor Vehicle Thefts Analysis - New Zealand 🚗🚨

## Project Overview
This project analyzes six months of stolen vehicle data from the New Zealand Police Department’s *Vehicle of Interest* database. The goal was to identify theft patterns and provide actionable insights using **MySQL** for data analysis and **Tableau** for visualization.

## Key Questions Explored
- What are the most common months and days for vehicle thefts?  
- Which vehicle types, brands, and colors are most targeted, and how does this vary by region?  
- Which regions have the highest and lowest theft rates, and what factors influence these trends?  

## Tools Used
- **MySQL**: For data cleaning, querying, and identifying patterns.  
- **Tableau**: For creating visualizations to make insights more understandable.  

## Key Findings
- **Most Common Months for Thefts**: April, March, February, December.  
- **Most Common Days for Thefts**: Tuesday, Wednesday, Friday, Thursday.  
- **Most Stolen Vehicle Brands**: Toyota, Nissan, Mazda, Ford.  
- **Most Stolen Vehicle Types**: Station wagon, saloon, hatchback, trailer, utility.  
- **Most Stolen Vehicle Colors**: Silver, white, black.  
- **Most Stolen Vehicle Years**: 2005, 2006, 2007, 2004.  
- **Regions with High Theft Rates**: Auckland, Canterbury, Bay of Plenty, Waikato, Wellington, Northland.  
- **Regions with Low Theft Rates**: Schrader, Nelson, Southland, Tasman, Marlborough, West Coast.  

## Data Set Details
-**Source**: Maven Analytics.

-**Content**:
        -stolen vehicules(vehicle id, vehicle type, vehicle description.
        make id, model year, color, date stolen,location id).
        
        -Make details(make id,make name, make type).
        
        -Location(locaition id,region,country,population,density)
## Sample Query
```SQL
-- Categorizing vehicle thefts by age group
SELECT
    CASE
        WHEN model_year >= YEAR(CURDATE()) - 5 THEN 'New (0-5 years)'
        WHEN model_year >= YEAR(CURDATE()) - 20 THEN 'Moderate (6-20 years)'
        ELSE 'Old (20+ years)'
    END AS vehicle_age_group,
    COUNT(*) AS total_thefts
FROM stolen_vehicles
GROUP BY vehicle_age_group
ORDER BY total_thefts DESC;


## Contact
** Sanaba Kante **: kantesanaba78@gmail.com
