mergedata<-function(){
    X<-rbind(x_test,x_train)
    Y<-rbind(y_test,y_train)
    Subject<-rbind(subject_test,subject_train)
    mergeddf<-cbind(Subject,Y,X)
    mergedtbl<-tbl_df(mergeddf)
    wanted_data<-select(mergedtbl,subject,labels,contains("mean"),contains("std"))
    wanted_data$labels<-activities[wanted_data$labels,2]
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
    
    summary_data<- wanted_data %>% group_by(subject,activity) %>% summarise_all(list(mean = mean))
    write.table(summary_data,"UCI HAR Dataset\\FinalData.txt",row.names = FALSE)
}