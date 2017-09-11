#Basic string cleanup to remove special characters, whitespace, and convert
#to upper case.
#Useful for similar strings that you want to match for data coming from
#different sources; for example if you had a filename "count_from_combinations"
#and wanted to match that to something looking for "Count from Combinations"
#then this will give you something to use as a unique key across both sets.

standardize_text <- function(df) {
  df <- gsub("[[:punct:]]*", "", df)
  df <- gsub("[[:space:]]*", "", df)
  df <- toupper(df)
  return(df)
}

