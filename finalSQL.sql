-- Solution from: 
-- [https://www.andrewvillazon.com/forward-fill-values-t-sql/#:~:text=To achieve the forward-filling,current row value is NULL .&text=Now we can SELECT the,rows come out as expected.&text=At this point%2C we've forward-filled](https://www.andrewvillazon.com/forward-fill-values-t-sql/#:~:text=To%20achieve%20the%20forward%2Dfilling,current%20row%20value%20is%20NULL%20.&text=Now%20we%20can%20SELECT%20the,rows%20come%20out%20as%20expected.&text=At%20this%20point%2C%20we've%20forward%2Dfilled)

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







