#####Coursera Peer Assessment for "Getting and Cleaning Data"
library(stringr)
library(reshape2)
#Read in data
Train<-read.csv("/train/X_train.txt", header=F, quote="\"")
Test<-read.csv("/test/X_test.txt", header=F, quote="\"")
ytrain<-read.csv("/train/y_train.txt", header=F, quote="\"")
ytest<-read.csv("/test/y_test.txt", header=F, quote="\"")
subtrain<-read.csv("/train/subject_train.txt", header=F, quote="\"")
subtest<-read.csv("/test/subject_test.txt", header=F, quote="\"")
features<-read.csv("features.txt", header=F, quote"\"")

#1. Merge Data and rename variables
Total<-rbind(Test, Train)
#Name Variables
colnames(Total)<-features[,2]
ytotal<-rbind(ytrain, ytest)
colnames(ytotal)<-"Activity_Label"
Total<-cbind(Total, ytotal)
subtotal<-rbind(subtrain, subtest)
colnames(subtotal)<-"Subject_ID"
Total<-cbind(Total, subtotal)


#Extract the mean and standard deviation via the variable names
i<-1
#Create a placeholder matrix to store them
foo<-matrix(1:10299, ncol=1)
#Loop Through them
while (i<562) {
  if (str_detect(colnames(Total)[i], ".+mean\\(")==T | str_detect(colnames(Total)[i], ".+std\\(")==T) {
    foo<-cbind(foo, Total[i])
  }
  i<-i+1
}
#Delete the dummy first column
foo$foo<-NULL
#Combine with the Patient ID and Activity Codes
foo<-cbind(foo, Total[,562:563])

#Name the activites
foo$Activity_Label[foo$Activity_Label==1]<-"Walking"
foo$Activity_Label[foo$Activity_Label==2]<-"Walking_Upstairs"
foo$Activity_Label[foo$Activity_Label==3]<-"Walking_Downstairs"
foo$Activity_Label[foo$Activity_Label==4]<-"Sitting"
foo$Activity_Label[foo$Activity_Label==5]<-"Standing"
foo$Activity_Label[foo$Activity_Label==6]<-"Laying"

#Melt the dataframe
goo<-melt(foo, id.vars=c("Activity_Label", "Subject_ID"))
#Cast to show Activity and Subject
bar<-dcast(goo, Activity_Label + Subject_ID ~variable, fun.aggregate=mean)

#Write out the file
write.csv(bar, "Tidy_Dataset.csv", row.names=F)

