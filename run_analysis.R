library(dplyr)


x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")



x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")


features <- read.table('./data/UCI HAR Dataset/features.txt')


activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')



colnames(x_train) <- features[,2]
colnames(y_train) <-"actid"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "actid"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('actid','activityType')



merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(merge_train, merge_test)



colNames <- colnames(setAllInOne)



mean_std <- (grepl("actid" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)



setMeanAndStd <- setAllInOne[ , mean_std == TRUE]



ActivityNames <- merge(setMeanAndStd, activityLabels,
                              by='actid',
                              all.x=TRUE)



secondTidySet <- aggregate(. ~subjectId + actid, ActivityNames, mean)
secondTidySet <- secondTidySet[order(secondTidySet$subjectId, secondTidySet$actid),]



write.table(secondTidySet, "secondTidySet.txt", row.name=FALSE)