xtr.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\train\\X_train.txt"
ytr.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\train\\y_train.txt"
subtrain.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\train\\subject_train.txt"

xtest.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\test\\X_test.txt"
ytest.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\test\\y_test.txt"
subtest.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\test\\subject_test.txt"


feat.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\features.txt"
act.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\activity_labels.txt"

features <- read.table(feat.url,col.names = c("idx","feature"))
activity <- read.table(act.url,col.names = c("activityID","activities"))

x_train <- read.table(xtr.url,col.names = features$feature)
y_train <- read.table(ytr.url,col.names = "activityID")
sub_train <- read.table(subtrain.url,col.names = "subject")


sub_tst <- read.table(subtest.url,col.names = "subject")
x_tst <- read.table(xtest.url,col.names = features$feature)
y_tst <- read.table(ytest.url,col.names = "activityID")

all_train <- cbind(x_train,sub_train,y_train)
all_test  <- cbind(x_tst,sub_tst,y_tst)
finaldata <- rbind(all_train,all_test)

finaldata <- finaldata %>% select(subject,activityID,contains("mean"),contains("std"))

finaldata$activityID <- activity[finaldata$activityID,2]

names(finaldata)<-gsub("Acc", "Accelerometer", names(finaldata))
names(finaldata)<-gsub("Gyro", "Gyroscope", names(finaldata))
names(finaldata)<-gsub("BodyBody", "Body", names(finaldata))
names(finaldata)<-gsub("Mag", "Magnitude", names(finaldata))
names(finaldata)<-gsub("^t", "Time", names(finaldata))
names(finaldata)<-gsub("^f", "Frequency", names(finaldata))
names(finaldata)<-gsub("tBody", "TimeBody", names(finaldata))
names(finaldata)<-gsub("-mean()", "Mean", names(finaldata))
names(finaldata)<-gsub("-std()", "STD", names(finaldata))
names(finaldata)<-gsub("-freq()", "Frequency", names(finaldata))
names(finaldata)<-gsub("angle", "Angle", names(finaldata))
names(finaldata)<-gsub("gravity", "Gravity", names(finaldata))

tidy_data <- finaldata %>% group_by(subject,activityID) %>% summarise_each(mean) 
write.table(tidy_data,"C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\tidydata.txt",
            row.names = FALSE)
