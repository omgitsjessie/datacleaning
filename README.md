# datacleaning
Different short recipes to clean different oddball data formats.

## count_from_combinations()
This function was designed to clean some oddly structured data as it was exported from BigQuery.  The original export was designed to look at object features; every object had one or more feature levels on it.  When exported, it showed a count of every instance of *each unique combination* of feature levels. The data were of the format:


| Count | Combinations of feature levels |
| -----: | :------ | 
| 111 | "string1, string2" |
| 4 | "string1" |
| 31 | "string2, string3, string4, string5" |
| 14 | "string4, string5" |
| 10 | "string5" |


The end result is something we can use to actually look at the frequency of each level of our object feature variable:

Total Count | Single Feature Level
| ---: | :--- | 
string1 | 115
string2 | 142
string3 | 31
string4 | 45
string5 | 55

count_from_combinations(df, valuesCol, stringsCol)
`df` is the dataframe containing count and comma-separated feature combination data;
`valuesCol` is the name of the column in `df` that has the counts of the feature combination data;
`stringsCol` is the name of the column in `df` that has the comma-separated string.