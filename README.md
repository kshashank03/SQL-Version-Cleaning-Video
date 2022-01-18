
# SQL Version Table

In this exercise we'll try and use SQL to solve a problem I encountered recently. We need to take a table with dozens of metrics from IOT devices and convert it to a table that outlines when those devices were updated. 

I've posted by solution in `finalSQL.sql`. Feel free to post your solution. 

## Credit for solution
[https://www.andrewvillazon.com/forward-fill-values-t-sql/#:~:text=To achieve the forward-filling,current row value is NULL .&text=Now we can SELECT the,rows come out as expected.&text=At this point%2C we've forward-filled](https://www.andrewvillazon.com/forward-fill-values-t-sql/#:~:text=To%20achieve%20the%20forward%2Dfilling,current%20row%20value%20is%20NULL%20.&text=Now%20we%20can%20SELECT%20the,rows%20come%20out%20as%20expected.&text=At%20this%20point%2C%20we've%20forward%2Dfilled)

## Requirements/Information

**Convert a table of metrics into a Version history table**

- We need to convert the contents of the `data.csv` file into the contents of the `finalData.csv` file
- Version1 is a major software update
- Version2 is a minor software update

**Desired Final Format**
| deviceID | dateTime   | Version1 | Version2 |
|----------|------------|----------|----------|
| A        | 2021-01-01 | 1.0      | A1       |
| A        | 2021-01-02 | 1.0      | A2       |
| B        | 2022-01-01 | 3.0      | A4       |

**Must use SQL to keep as much processing in one system as possible**

- This would be easier in Python or R but then we’d have to extract the data from the database, transform it, then reimport it

**For each deviceID, there’s only a record when there’s an update to the system**

**If we just pivot our records then we get a lot of nulls**

## Resources

The initial data is in `data.csv`

You can insert the data into https://sqliteonline.com/ for a quick and easy SQL Database


## What You'll Learn / Use

My solution uses:
* The `PIVOT` operator
* `WITH` to create a Continuous Table Expression (CTE)
* `OVER` to use window functions