# OpenMRS ETL & Predictive Modeling Across Multiple Platforms
The amount of data generated is getting increased day by day and so as the appetite for finding the information from data as well. Growing appetite for data analysis can't be achieved by transactional databases. With organization thriving towards separating their data warehouse compliance from transactional databases so, that they can track the historical data better, the need for ETL tool is getting increased everyday. The intention of this project is to have a ETL module to interact with multiple DW compliance over which predictive modeling code could run. So, that healthcare provider can check upon the predictive modeling result based on historical data they are having/loading. 

# GSoC Midterm Presentation
[GSoC 2014: OpenMRS Module for ETL & Predictive Modeling across Multiple Platform (DW) Midterm Presentation](https://talk.openmrs.org/t/gsoc-2014-openmrs-module-for-etl-predictive-modeling-across-multiple-platform-dw-midterm-presentation/301) 

# Brief Approach
###ETL
1. Login to the database contains records.
2. Select the data one wants to load in datawarehouse as historical data.
3. Login to DW and load it with timestamps.

###Predictive Analysis**
1. Login to datawarehouse and load the selected data with timestamps.
2. Run the analytics query on the datawarehouse.
3. Fetch Back the Results and show it.


# OpenMRS Wiki
[ETL & Predictive Modeling Across Multiple Platforms](https://wiki.openmrs.org/pages/viewpage.action?pageId=60068088)

# Visit Blog
[Get Latest Updates](http://vineetgsocer2014.wordpress.com/)

