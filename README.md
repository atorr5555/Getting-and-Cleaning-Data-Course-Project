# Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

**Review criteria**

1. The submitted data set is tidy.
2. The Github repo contains the required scripts.
3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
4. The README that explains the analysis files is clear and understandable.
5. The work submitted for this project is the work of the student who submitted it.

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article ](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI HAR Dataset.zip)

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Script Explanation

First we download the data from the url:

```R
# Load the Data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./datafile.zip", method = "curl")
unzip(zipfile = "datafile.zip")
```

Then we read the data from features.txt which contains the column names and then the script get the required columns using grep and a regular expression that matches strings were the words 'mean' or 'std' appear. Finally the script removes the parenthesis from the column names to make it look nicer.

```R
## Reading the column names
column_names <- read.table("./UCI HAR Dataset/features.txt")
colnames(column_names) <- c("index", "name")
columns_req <- grep("(mean|std)", column_names[, "name"])
final_names <- column_names[columns_req, "name"]
final_names <- gsub('[()]', '', final_names)
```

Then the script read the activity names from the activity_labels.txt file.

```R
## Reading the activity names
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity_names) <- c("numActivity", "nameActivity")
```

The the script read the data from the test dataset:

1. Read the data from the files X_test.txt, y_test.txt and subject_test.txt
2. Rename the column names for the test_y (Activities) and the subject_test (subjects of the experiment)
3. Only select the required columns for the test_x dataset and rename the columns using the names read in previous parts of the script
4. Finally, combine the data of the 3 datasets read into 1 test data set

```R
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
```

The same strategy used to read the test data set is applied to read the train data set

```R
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
```

Then the script merge the data sets using `rbind` to combine the data from the test ant the train

```R
## Merging datasets
combined_data <- rbind(train_data, test_data)
```

Then the script set the activities and the subject as factors in order to make it look nicer and with a proper name (in the case of the activities) and to make it easy to group.

```R
## Setting activities as factors in order to make it easy the calc by activity
combined_data[["Activity"]] <- factor(combined_data[, "Activity"]
                                 , levels = activity_names[["numActivity"]]
                                 , labels = activity_names[["nameActivity"]])

## Setting subjects as factors in order to make it easy the calc by subject
combined_data[["Subject"]] <- as.factor(combined_data[, "Subject"])
```

Then the script uses `melt` to set subject and activity as id variables because we need measurements for each activity and each subject.

```R
## Loading library to reshape the data
library(reshape2)

## Melting the data set so subject and activity are id variables
final_data <- reshape2::melt(data = combined_data,
                                id = c("Subject", "Activity"))
```

Then the script uses `dcast` to get the mean of the measurements for each subject and activity.

```R
## For each subject and activity get the mean of the measurements
final_data <- reshape2::dcast(data = final_data,
                                 Subject + Activity ~ variable,
                                 fun.aggregate = mean)
```

Finally the script write the resulting tidy set into a text file

```R
## Writing the tidy set into a file
write.table(x = final_data, file = "./tidy_set.txt", row.name = FALSE)
```

