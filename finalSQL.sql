WITH firstVersionTable as (
SELECT
  deviceid,
  firstTime,
  Version1,
  Version2,
  COUNT(Version1) OVER (PARTITION BY deviceid ORDER BY firstTime) AS Version1Grouping,
  COUNT(Version2) OVER (PARTITION BY deviceid ORDER BY firstTime) AS Version2Grouping 
FROM (
  SELECT
    *
  FROM (
    SELECT
      deviceid,
      metricname,
      metricvalue,
      MIN(datetime) AS firstTime
    FROM
      data
    WHERE
     metricName IN ('Version1',
        'Version2')
    GROUP BY
      deviceid,
      metricName,
      metricValue ) table_1 PIVOT (MIN(metricvalue) FOR metricname IN ([Version1], [Version2]) ) as pivoted_table ) a
)
select 
  deviceid,
  firstTime,
  MAX(Version1) OVER (PARTITION BY deviceid, Version1Grouping
    ) as forward_filled_version1,
  MAX(Version2) OVER (PARTITION BY deviceid, Version2Grouping
    ) as forward_filled_version2
from 
firstVersionTable a
ORDER BY deviceid, firstTime







