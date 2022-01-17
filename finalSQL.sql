WITH firstVersionTable as (
SELECT
  deviceID,
  firstTime,
  Version1,
  Version2,
  COUNT(deviceID+version1) OVER (ORDER BY deviceID, firstTime) AS version1Grouping,
  COUNT(deviceID+version2) OVER (ORDER BY deviceID, firstTime) AS version2Grouping 
FROM (
SELECT
    *
  FROM (
SELECT
      deviceID,
      metricName,
      metricValue,
      MIN(dateTime) AS firstTime
    FROM
      DATA
    WHERE
      metricName IN ('Version1',
        'Version2')
    GROUP BY
      deviceID,
      metricName,
      metricValue
 ) as firstTable
 PIVOT(MIN(metricValue) FOR metricName IN ([Version1],[Version2])) as secondTable
) as finalTable)
--select * from firstVersionTable

, v1JoinTable as (
select 
  deviceID, Version1, version1Grouping
  from firstVersionTable
  WHERE Version1 IS NOT NULL
  GROUP BY deviceID, Version1, version1Grouping)
, v2JoinTable as (
select 
  deviceID, Version2, version2Grouping
  from firstVersionTable
  WHERE Version2 IS NOT NULL
  GROUP BY deviceid, Version2, version2Grouping
)
  
 select 
  a.deviceID,
  a.firstTime,
  COALESCE(a.Version1, b.Version1) as Version1,
  COALESCE(a.Version2, c.Version2) as Version2
from 
firstVersionTable a 
LEFT JOIN v1JoinTable b
ON a.version1Grouping = b.version1Grouping
LEFT JOIN v2JoinTable c
ON a.version2Grouping = c.version2Grouping

