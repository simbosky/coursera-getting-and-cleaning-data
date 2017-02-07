# set up libraries
library(dplyr)

#set wd
setwd("~/Desktop/coursera/Assignments/GCD/UCI HAR Dataset")

# get column names from features.txt
feature_names <- read.table("features.txt", header = FALSE)

#make syntactically valid names
feature_names$V2 <- gsub("-","_", feature_names$V2)
feature_names$V2 <- gsub("\\(|\\)","", feature_names$V2)

# read X_train with feature names
X_train <- read.table("./train/X_train.txt", header = FALSE, col.names = feature_names$V2)

#read y_train  
y_train <- read.table("./train/y_train.txt", header = FALSE, col.names ="Activity")

#read subject_train
subject_train <- read.table("./train/subject_train.txt", header = FALSE, col.names ="subject_id")

# read X_test with feature names
X_test <- read.table("./test/X_test.txt", header = FALSE, col.names = feature_names$V2)

# read y_test
y_test <- read.table("./test/y_test.txt", header = FALSE, col.names = "Activity")

#read subject_test
subject_test <- read.table("./test/subject_test.txt", header = FALSE, col.names ="subject_id")


# bind X_train and y_train
train_total <- cbind(X_train, y_train, subject_train)

# bind X_test and y_test
test_total <- cbind(X_test, y_test, subject_test)

# merge datasets
merged <- rbind(test_total, train_total)

#select columns which contain mean and std

filtered <- merged %>% select(matches("(std|mean)_|(Activity)|(subject_id)"))

#read activities descriptiond
activity_labels <- read.table("activity_labels.txt", header = FALSE, col.names = c("activity_indicator","activity_label"))

#merge with filtered dataset

full <- merge(filtered, activity_labels, by.x="Activity", by.y="activity_indicator")
full <- full %>% select(-Activity)


#final clean on names
names(full) <- gsub("fBodyAcc", "FFT_Body_Accelerometer", names(full))
names(full) <- gsub("tBodyAcc", "Time_Body_Accelerometer", names(full))
names(full) <- gsub("fBodyGyro", "FFT_Body_Gyroscope", names(full))
names(full) <- gsub("tBodyGyro", "Time_Body_Gyroscope", names(full))
names(full) <- gsub("tGravityAcc", "Time_Gravity_Accelerometer", names(full))
names(full) <- gsub("fGravityAcc", "FFT_Gravity_Accelerometer", names(full))
names(full) <- gsub("tBodyAcc", "Time_Body_Gyroscope", names(full))
names(full) <- gsub("fBodyAcc", "FFT_Body_Gyroscope", names(full))
names(full) <- gsub("tBodyAccJerk", "Time_Body_Accelerometer_Jerk", names(full))
names(full) <- gsub("fBodyAccJerk", "FFT_Body_Accelerometer_Jerk", names(full))
names(full) <- gsub("tBodyGyroJerk", "Time_Body_Gyroscope_Jerk", names(full))
names(full) <- gsub("fBodyGyroJerk", "FFT_Body_Gyroscope_Jerk", names(full))

#create averages table
averages <- full %>% group_by(subject_id, activity_label) %>% summarize_at(.cols = vars(matches("mean|std")), .funs=c(Mean = "mean"))

#write out averages table
write.table(averages, "averages.txt", row.names = FALSE)

