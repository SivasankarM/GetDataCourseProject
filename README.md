GetDataCourseProject
====================

##run_analysis.R
This script processes the input data file in zip format which is downloaded from the location:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The given data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. The full description of the data is available at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Assumptions and requisites:
1. The given script assumes the downloaded zip file "getdata-projectfiles-UCI HAR Dataset.zip" is present in the current directory of R. 
2. The script requires the following packages in R to be loaded 
	a. plyr
	b. reshape

Steps in processing:
1. Unzips the given data file 
2. Loads the test data into 3 variables one each corresponding to the subject information, activity information and the various readings using read.table function on the files subject_test.txt, y_test.txt and X_test.txt files respectively
3. Combine the 3 test data into a single data frame using column bind (cbind) function
4. Loads the training data into 3 variables one each corresponding to the subject information, activity information and the various readings using read.table function on the files subject_train.txt, y_train.txt and X_train.txt files respectively
5. Combine the 3 training data into a single data frame using column bind (cbind) function
6. Merge the test data and training data into a single data frame using row bind (rbind) function
7. Load the features.txt file using read.table to get the list of column names and append Subject_ID and Activity_ID at the beginning.
8. Filter the Merged data to filter out the oolumns that have mean or standard deviation related measurement using grepl command searching for std() or mean() strings in column names
9. Rename the variables to more meaningful names by using gsub function
10. Melt the filtered data based on Subject_ID and Activity_ID so that reading for each observation is seen in separate row (melt function in reshape package is used)
11. Aggregate the melted data grouping based on the Subject_ID, Activity_ID and the variable which is our various feature variables. ddply function in plyr is used.
12. Load the activity id to name mapping from activity_labels.txt and use that to replace Activity_ID column with Activity_Name
13. Export the generated aggregated tidy data set to output.txt using write.table function with row.names as FALSE