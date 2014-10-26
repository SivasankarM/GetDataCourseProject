## Unzip the data zip file present in the working directory
unzip("getdata-projectfiles-UCI HAR Dataset.zip")
## Load the test data for subject, activity and reading
test_subject <- read.table("UCI\ HAR\ Dataset/test/subject_test.txt")
test_reading <- read.table("UCI\ HAR\ Dataset/test/X_test.txt")
test_activity <- read.table("UCI\ HAR\ Dataset/test/y_test.txt")
## Combine them using column bind cbind function
test_data <- cbind(test_subject,test_activity,test_reading)
## Load the training data for subject, activity and reading
train_activity <- read.table("UCI\ HAR\ Dataset/train/y_train.txt")
train_reading <- read.table("UCI\ HAR\ Dataset/train/X_train.txt")
train_subject <- read.table("UCI\ HAR\ Dataset/train/subject_train.txt")
## Combine them using column bind cbind function
train_data <- cbind(train_subject,train_activity,train_reading)
## Create merged data of test and training data by using row bind rbind function
combined_data <- rbind(train_data,test_data)
## Load the list of reading features and use them to create column names
list_features <- read.table("UCI\ HAR\ Dataset/features.txt")
columnNames <- as.character(list_features$V2)
## First two columns are Subject ID and Activity ID followed by created column 
## names list
columnNames <- c("Subject_ID","Activity_ID",columnNames)
names(combined_data) <- columnNames
## Load the list of activities names mapping to IDs
activity_names <- read.table("UCI\ HAR\ Dataset/activity_labels.txt",
                             stringsAsFactors=FALSE)
## Filter only the mean and standard deviation related data
filtered_data <- combined_data[,
    (grepl("mean\\(\\)|std\\(\\)|Subject_ID|Activity_ID",columnNames)) == TRUE]
## Rename the variables to more meaningful names
names(filtered_data) <- gsub("\\)","",names(filtered_data))
names(filtered_data) <- gsub("\\(","",names(filtered_data))
names(filtered_data) <- gsub("-","_",names(filtered_data))
names(filtered_data) <- gsub("std","StandardDeviation",names(filtered_data))
names(filtered_data) <- gsub("Acc","Acceleration",names(filtered_data))
names(filtered_data) <- gsub("Mag","Magnitude",names(filtered_data))
## Melt the data based on Subject_ID and Activity_ID so that we can aggregate 
## over those columns (melt function in reshape package is used)
melted_data <- melt(filtered_data,id=c("Subject_ID","Activity_ID"),
                  measure.vars=c(names(filtered_data[3:68])))
## Calculate the mean of the value using ddply function in plyr package
aggregated_data <- ddply(melted_data,.(Subject_ID,Activity_ID,variable),summarize,
        mean=mean(value,na.rm=TRUE))
## Get the activity name from the activity_names loaded before and replace 
## Activity_ID with Activity_Name
aggregated_data$Activity_ID <- activity_names[aggregated_data$Activity_ID,2]
names(aggregated_data)[2] <- "Activity_Name"
## Write the resultant tidy data to the output file output.txt
write.table(aggregated_data,file="output.txt",row.names=FALSE)