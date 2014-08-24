library(plyr)
library(data.table)

#Read in files.  This assumes the files are in a "UCI HAR Dataset" folder inside the working directory.  The instructions were slightly unclear
#whether the files needed to be directly inside the working directory or not, so I interpreted it to be okay for the files to be inside a subfolder.
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
activities <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, col.names = c("activity.id","activity.name"))
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names = features[,2])
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", header = FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names = features[,2])
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", header = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

#Create "group" column for Train vs Test
x_train$group = "Train"
x_test$group = "Test"

#Create "subject" column from subject files
x_train$subject = subject_train[,1]
x_test$subject = subject_test[,1]

#Create "activity.id" column from y files
x_train$activity.id = y_train[,1]
x_test$activity.id = y_test[,1]

#Create "set" which is a combination of train and test
set <- rbind(x_train, x_test)

#Creates a list of columns to keep.
#Starts by getting any column with "mean" or "std" in the name.  The instructions were unclear as to include only
#columns with "mean" or "std" anywhere in the name, or only at the end.  I chose to include anywhere in the name.
listCols <- features[features[,2] %like% "mean" | features[,2] %like% "std",1]

#Adds the last 3 columns (group, subject, activity.id)
listCols <- c(listCols, ncol(set) - 2, ncol(set) - 1, ncol(set))
set <- set[,listCols]

#Add activity name
set <- join(set,activities)

#Trim function to remove leading and trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

#Tidy up column names by replacing "." with " ", removing multiple spaces, and trimming
colnames(set) <- trim(gsub("  "," ",gsub("  "," ",gsub("[.]"," ",colnames(set)))))

#Aggregate all metrics using mean (FUN=mean), grouping by activity name and subject.  There was some debate on the
#forumns whether to aggregate all variables or only mean/std variables.  My interpretation was to aggregate the final
#set, so only mean/std variables.
agg <- aggregate(set[,1:(ncol(set) - 4)], by=list(set[,"activity name"], set[,"subject"]), FUN=mean, na.rm=TRUE)

#Set names of grouping variables
names(agg)[1] <- "activity name"
names(agg)[2] <- "subject"

#Write tidy data set (for part 5) to a file
write.table(agg, file = "tidyDataSet.txt",row.name=FALSE)
