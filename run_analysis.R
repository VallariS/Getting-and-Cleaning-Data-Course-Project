library(dplyr)

filename <- "Coursera_DS3_Final.zip"

if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

activities<-read.table("UCI HAR Dataset\\activity_labels.txt",col.names=c("label","activity"))
features<-read.table("UCI HAR Dataset\\features.txt",col.names=c("n","functions"))
subject_test<-read.table("UCI HAR Dataset\\test\\subject_test.txt",col.names="subject")
x_test<-read.table("UCI HAR Dataset\\test\\X_test.txt",col.names=features$functions)
y_test<-read.table("UCI HAR Dataset\\test\\y_test.txt",col.names="labels")
subject_train<-read.table("UCI HAR Dataset\\train\\subject_train.txt",col.names="subject")
x_train<-read.table("UCI HAR Dataset\\train\\X_train.txt",col.names=features$functions)
y_train<-read.table("UCI HAR Dataset\\train\\y_train.txt",col.names="labels")

##Merging the training and the test sets to create one data set
X<-rbind(x_test,x_train)
Y<-rbind(y_test,y_train)
Subject<-rbind(subject_test,subject_train)
mergeddf<-cbind(Subject,Y,X)
mergedtbl<-tbl_df(mergeddf)

##Extracting the measurements on the mean and standard deviation for each measurement
wanted_data<-select(mergedtbl,subject,labels,contains("mean"),contains("std"))

##Using descriptive activity names to name the activities in the data set
wanted_data$labels<-activities[wanted_data$labels,2]

##Appropriately labelling the data set with descriptive variable names
names(wanted_data)[2]<-"activity"
names(wanted_data)<-gsub("Acc","Accelerometer",names(wanted_data))
names(wanted_data)<-gsub("Gyro","Gyroscope",names(wanted_data))
names(wanted_data)<-gsub("BodyBody","Body",names(wanted_data))
names(wanted_data)<-gsub("Mag","Magnitude",names(wanted_data))
names(wanted_data)<-gsub("^t","Time",names(wanted_data))
names(wanted_data)<-gsub("^f","Frequency",names(wanted_data))
names(wanted_data)<-gsub("tBody","TimeBody",names(wanted_data))
names(wanted_data)<-gsub("-mean()","Mean",names(wanted_data),ignore.case = TRUE)
names(wanted_data)<-gsub("-std()","STD",names(wanted_data),ignore.case = TRUE)
names(wanted_data)<-gsub("-freq()","Frequency",names(wanted_data),ignore.case = TRUE)
names(wanted_data)<-gsub("angle","Angle",names(wanted_data))
names(wanted_data)<-gsub("gravity","Gravity",names(wanted_data))

##From the data set in step 4, creating a second, independent tidy data set with the average of each variable for each activity and each subject.
summary_data<- wanted_data %>% group_by(subject,activity) %>% summarise_all(list(mean = mean))
write.table(summary_data,"UCI HAR Dataset\\FinalData.txt",row.names = FALSE)
