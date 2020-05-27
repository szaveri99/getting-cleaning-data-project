#get the url

xtr.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\train\\X_train.txt"
ytr.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\train\\y_train.txt"
subtrain.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\train\\subject_train.txt"

xtest.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\test\\X_test.txt"
ytest.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\test\\y_test.txt"
subtest.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\test\\subject_test.txt"

feat.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\features.txt"
act.url <- "C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\activity_labels.txt"

## reading all the files that are downloaded and naming the columns.

features <- read.table(feat.url,col.names = c("idx","feature"))
activity <- read.table(act.url,col.names = c("activityID","activities"))

x_train <- read.table(xtr.url,col.names = features$feature)
y_train <- read.table(ytr.url,col.names = "activityID")
sub_train <- read.table(subtrain.url,col.names = "subject")

sub_tst <- read.table(subtest.url,col.names = "subject")
x_tst <- read.table(xtest.url,col.names = features$feature)
y_tst <- read.table(ytest.url,col.names = "activityID")

## combining the data

all_train <- cbind(x_train,sub_train,y_train)
all_test  <- cbind(x_tst,sub_tst,y_tst)
finaldata <- rbind(all_train,all_test)

## extracting the data having the columns names that contains mean or std and saving
## the data into variable called finaldata
finaldata <- finaldata %>% select(subject,activityID,contains("mean"),contains("std"))

#row names is provided to activityID column 
finaldata$activityID <- activity[finaldata$activityID,2]

##descriptive names are given to the column
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

## taking out the average of each column group by subject,activityID
tidy_data <- finaldata %>% group_by(subject,activityID) %>% summarise_each(mean)

## finally writing the data into the text file that is cleaned and used 
##for futher purposes
write.table(tidy_data,"C:\\Users\\Sakina Zaveri\\Desktop\\UCI HAR Dataset\\tidydata.txt",
            row.names = FALSE)
