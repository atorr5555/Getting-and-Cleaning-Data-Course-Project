# Load the Data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./datafile.zip", method = "curl")
unzip(zipfile = "datafile.zip")

## Reading the column names
column_names <- read.table("./UCI HAR Dataset/features.txt")
colnames(column_names) <- c("index", "name")
columns_req <- grep("(mean|std)", column_names[, "name"])
final_names <- column_names[columns_req, "name"]
final_names <- gsub('[()]', '', final_names)

## Reading the activity names
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity_names) <- c("numActivity", "nameActivity")

## Getting the test data
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
## Renaming the column names
colnames(test_y) <- "Activity"
colnames(subject_test) <- "Subject"
## Only using the required columns
test_x <- test_x[, columns_req]
colnames(test_x) <- final_names
## Combining to create the test data set
test_data <- cbind(test_x, test_y, subject_test)

## Getting the train data
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
## Renaming the column names
colnames(train_y) <- "Activity"
colnames(subject_train) <- "Subject"
## Only using the required columns
train_x <- train_x[, columns_req]
colnames(train_x) <- final_names
## Combining to create the train data set
train_data <- cbind(train_x, train_y, subject_train)

## Merging datasets
combined_data <- rbind(train_data, test_data)

## Setting activities as factors in order to make it easy the calc by activity
combined_data[["Activity"]] <- factor(combined_data[, "Activity"]
                                 , levels = activity_names[["numActivity"]]
                                 , labels = activity_names[["nameActivity"]])

## Setting subjects as factors in order to make it easy the calc by subject
combined_data[["Subject"]] <- as.factor(combined_data[, "Subject"])

## Loading library to reshape the data
library(reshape2)

## Melting the data set so subject and activity are id variables
final_data <- reshape2::melt(data = combined_data,
                                id = c("Subject", "Activity"))

## For each subject and activity get the mean of the measurements
final_data <- reshape2::dcast(data = final_data,
                                 Subject + Activity ~ variable,
                                 fun.aggregate = mean)

## Writing the tidy set into a file
write.table(x = final_data, file = "./tidy_set.txt", row.name = FALSE)
