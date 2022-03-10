/* PART 1: Energy Stability and Market Outages */

/* #1: What are the most common outage types? */

--1.1 The number of valid (i.e. Status = Approved) outage events for 2016
SELECT COUNT(*) AS Total_Number_Outage_Events,
    Status,
    Reason
FROM AEMR
WHERE year(Start_Time) = 2016
    AND Status = 'Approved'
GROUP BY 3, 2
ORDER BY 3;


--1.3 The number of valid (i.e. Status = Approved) outage events for 2017
SELECT COUNT(*) AS Total_Number_Outage_Events,
    Status,
    Reason
FROM AEMR
WHERE year(Start_Time) = 2017
    AND Status = 'Approved'
GROUP BY 3, 2
ORDER BY 3;


--1.5: The avg duration in days for each approved outage type across 2016-2017
SELECT Status,
      Reason,
      COUNT(*) AS Total_Number_Outage_Events,
      ROUND(AVG((TIMESTAMPDIFF(MINUTE,Start_Time,End_Time)/60)/24),2) AS Average_Outage_Duration_Time_Days,
      Year(Start_Time) AS Year
FROM AEMR
WHERE Status='Approved'
GROUP BY 2, 5
ORDER BY 2, 5;



/* #2: How frequently do outages occur? */

--2.1 Monthly count of all approved outage types 2016
SELECT Status,
      Reason,
      COUNT(*) AS Total_Number_Outage_Events,
      MONTH(Start_Time) AS Month
FROM AEMR
WHERE Status = 'Approved'
  AND year(Start_Time) = 2016
GROUP BY 1, 2, 4
ORDER BY 1, 4;


--2.2 Monthly count of all approved outage types 2017
SELECT Status,
      Reason,
      COUNT(*) AS Total_Number_Outage_Events,
      MONTH(Start_Time) AS Month
FROM AEMR
WHERE Status = 'Approved'
  AND year(Start_Time) = 2017
GROUP BY 1, 2, 4
ORDER BY 1, 4;


--2.3 Monthly count of all approved outage types 2016-2017
SELECT Status,
      COUNT(*) AS Total_Number_Outage_Events,
      MONTH(Start_Time) AS Month,
      YEAR(Start_Time) AS Year
FROM AEMR
WHERE Status = 'Approved'
GROUP BY 1, 3, 4
ORDER BY 3, 4;



/* #3: Are there any energy providers that have more outages than their peers
that may be indicative of being unreliable? */

--3.1 Count of all approved outage types by participant codes 2016-2017
SELECT COUNT(*) AS Total_Number_Outage_Events,
      Participant_Code,
      Status,
      YEAR(Start_Time) AS Year
FROM AEMR
WHERE Status = 'Approved'
GROUP BY 2, 3, 4
ORDER BY 2, 4 DESC;


--3.2 Avg duration approved outage types by participant codes 2016-2017
SELECT Participant_Code,
      Status,
      YEAR(Start_Time) AS Year,
      ROUND(AVG((TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)/60)/24),2) AS Average_Outage_Duration_Time_Days
FROM AEMR
WHERE Status = 'Approved'
GROUP BY 1,2,3
ORDER BY 4 DESC;




/* PART 2: Energy Losses and Market Reliability */

/* #4: Of the outage types in 2016 and 2017, what are the respective percentages composed of Forced Outage(s)? */

--4.1 Count the total number of approved forced outage events for 2016 and 2017
SELECT COUNT(*) AS Total_Number_Outage_Events,
      Reason,
      YEAR(Start_Time) AS Year
FROM AEMR
WHERE Status = 'Approved'
   AND Reason = 'Forced'
GROUP BY 2,3
ORDER BY 2, 3


--4.2 Calculate the proportion of outages that were forced for both 2016 and 2017
SELECT Total_Number_Forced_Outage_Events,
        Total_Number_Outage_Events,
        ROUND(((Total_Number_Forced_Outage_Events / Total_Number_Outage_Events) * 100) , 2) AS Forced_Outage_Percentage,
        Year
FROM (SELECT
          SUM(CASE
                WHEN Reason = 'Forced' THEN 1
                ELSE 0
              END) AS Total_Number_Forced_Outage_Events,
          COUNT(*) AS Total_Number_Outage_Events,
          YEAR(Start_Time) AS Year
FROM AEMR
WHERE Status = 'Approved'
GROUP BY 3) As totals;



/* #5: What was the avg duration for a forced outage during both 2016 and 2017? Have we seen an increase in the average duration of forced outages? */

--5.1 Calculate avg duration and energy lost (MW) for forced outages 2016-2017
SELECT Status,
  YEAR(Start_Time) AS Year,
  ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
  ROUND(AVG(TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)),2) AS Average_Outage_Duration_Time_Minutes
FROM AEMR
WHERE Reason = 'Forced'
  AND Status = 'Approved'
GROUP BY 1,2
ORDER BY 1, 2;

--5.2 Compare the avg duration of each outage type event for 2016-2017
SELECT Status,
  Reason,
  YEAR(Start_Time) AS Year,
  ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
  ROUND(AVG(TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)),2) AS Average_Outage_Duration_Time_Minutes
FROM AEMR
WHERE Status = 'Approved'
GROUP BY 1, 2, 3
ORDER BY 3;



/* #6: Which energy providers tend to be the most unreliable? */

--6.1 Calculate avg duration and energy lost (MW) for forced outages by participant code
SELECT Participant_Code,
  Status,
  YEAR(Start_Time) AS Year,
  ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
  ROUND(AVG((TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)/60)/24),2) AS Average_Outage_Duration_Time_Days
FROM AEMR
WHERE Status = 'Approved'
  AND Reason = 'Forced'
GROUP BY 1, 2, 3
ORDER BY 4, 3 DESC;


-- 6.2 Calculate avg outage and summed outage (MW) loss by participant code for forced oytages 2016-2017
-- Your answer here
SELECT Participant_Code,
  Facility_Code,
  Status,
  YEAR(Start_Time) AS Year,
  ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
  ROUND(SUM(Outage_MW),2)AS Summed_Energy_Lost
FROM AEMR
WHERE Status = 'Approved'
  AND Reason = 'Forced'
GROUP BY 1, 2, 3, 4
ORDER BY 4, 6 DESC;
