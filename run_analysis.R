# merge training and test data sets to create one data set.

## set working directory
setwd("~/Data Science/Coursera Assignments/3. Getting & Cleaning Data/Week 4/UCI HAR Dataset")
if(!file.exists("./data")){dir.create("./data")}
## import all that data
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip')
## read in the X and Y data for the test and training sets from their respective folders
X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/Y_test.txt")
X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/Y_train.txt")
## compile the training and test data for X and Y
x_total <- rbind(X_test, X_train)
y_total <- rbind(Y_test, Y_train)
## Combine X and Y data
total <- cbind(x_total, y_total)
# Appropriately labels the data set with descriptive variable names.
## name the column headings based on the features file
features <- read.table('features.txt')
features <- as.character(features$V2)
features <- append(features, 'Activity Number')
colnames(total) <- features
# Extracts only the measurements on the mean and standard deviation for each measurements
means <- as.numeric(grep('mean', names(total)))
stds <- as.numeric(grep('std', names(total)))
means_stds <- sort(c(means, stds))
extract <- append(means_stds, 562)
extracted <- total[extract]


# Uses descriptive activity names to name the activities in the data set
## read in activity>labels file
activity_labels <- read.table('activity_labels.txt')
## name the columns
names(activity_labels) <- c('Activity Number', 'Activity')
library(plyr)
library(dplyr)
## merge the activity lables witht the activity numbers containined in the main data set
merged <- merge(extracted, activity_labels, by.x = 'Activity Number', by.y = 'Activity Number', sort = FALSE)

# From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
## import the subject train and test data
subjects_train <- read.table('./train/subject_train.txt')
subjects_test <- read.table('./test/subject_test.txt')
#compile the subject train and test data
subjects_total <- rbind(subjects_train, subjects_test)
colnames(subjects_total) <- 'Subject'
## attach the subject data to the main set
final <- cbind(merged, subjects_total)
## first column was Activity Number, remove that column
final <- final[2:82]
## load the reshape2 package for reshaping data frames
library(reshape2)
## 'melt' the data to make Subject and Activity the id variables and everythign else a measure variable
melted <- melt(final, id.vars = c('Subject', 'Activity'), measure.vars = c(names(final[1:79])))
## Recast the data as a data frame with subject and activity in first and second columns and the average/mean value 
## for each measure in the following columns. 
wide_data <- dcast(melted, Subject + Activity ~ variable, mean)

