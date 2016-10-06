#Getting and Cleaning Data Week 4 Project



#Download and Unzip dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Read training files
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Read testing files
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Read features
features <- read.table('./data/UCI HAR Dataset/features.txt')

#Read activities
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#-------------------Step 1: Merge Train and Test-------------------------------#

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activity"
colnames(subject_train) <- "subject"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activity"
colnames(subject_test) <- "subject"

colnames(activityLabels) <- c('activity','activityType')

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
singledataset <- rbind(mrg_train, mrg_test)
singledataset <- unique(singledataset)

subset desired columns
reducedataset <- grep("-(mean|std)\\(\\)", features[, 2])
singledataset <- singledataset[, reducedataset]

#-----------------Step 2: Extract measurements on mean and SD for each measurement-----#

singledataset2 <- colnames(singledataset)

mean_and_stddev <- (grepl("activity" , singledataset2) | 
                         grepl("subject" , singledataset2) | 
                         grepl("mean.." , singledataset2) | 
                         grepl("std.." , singledataset2) 
)

singledataset3 <- singledataset[ , mean_and_stddev == TRUE]


#----------------Step 3 & 4: Name the activities in the data set with descriptive activity names-------#

ActivityNamesDataset <- merge(singledataset3, activityLabels,
                              by='activity',
                              all.x=TRUE)

#---------------Step 5: Independent tidy data set with average of each variable for each activity and subject---#

TidySet2 <- aggregate(. ~subject + activity, ActivityNamesDataset, mean)
TidySet2 <- TidySet2[order(TidySet2$subject, TidySet2$activity),]

write.table(TidySet2, "TidySet2.txt", row.name=FALSE)




