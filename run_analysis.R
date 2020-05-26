setwd("~/Coursera class/C3/data9/UCI HAR Dataset")

x_train <- read.table("./train/X_train.txt")               
# read the training set
y_train <- read.table("./train/y_train.txt")               
# read the training labels
subject_train <- read.table("./train/subject_train.txt")   
# read the subject who performed the activity [1-30]

head(x_train)
head(y_train)
head(subject_train)
tail(subject_train)

x_test <- read.table("./test/X_test.txt")              # read the test set
y_test <- read.table("./test/y_test.txt")              # read the test labels    
subject_test <- read.table("./test/subject_test.txt")  

head(x_train)
head(y_test)
head(subject_test)
tail(subject_test)

features <- read.table("./features.txt")   # reads the list of features

## 1. Merges the training and the test sets to create one data set.
merged <- rbind(x_train, x_test) 

## 4. Appropriately labels the data set with descriptive variable names.
colnames(merged) <- features$V2   # gives cols the names

str(merged)
head(merged)
names(merged)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
df <- merged[,grepl("mean|std", names(merged))]
names(df)
str(df)
df2 <- cbind(subjects = rbind(subject_train, subject_test), labels = rbind(y_train, y_test), df)
str(df2)
head(df2)
table(df2[1])
table(df2[2])

## 3. Uses descriptive activity names to name the activities in the data set
colnames(df2)[1]<-"subject"
colnames(df2)[2]<-"activity"
a_names <- read.table("./activity_labels.txt")

df3 <- rename(a_names, activity=V1, activity_name=V2)



df4 <- left_join(df2, df3, by="activity" )

str(df4)

### This writes the clean-up original data
write.table(df4,"./tidy-data.txt", row.name=FALSE)

## Now summarize 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

by_act_sub <-group_by(df4, activity, subject)
df5 <- summarise_all(by_act_sub, .funs = c(Mean="mean"), na.rm=TRUE)

write.table(df5,"./tidy-data-mean.txt", row.name=FALSE)

## end
