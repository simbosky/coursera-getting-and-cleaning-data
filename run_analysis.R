# set up libraries
library(dplyr)
library(tidyr)

#set wd
setwd("~/Desktop/coursera/Assignments/UCI HAR Dataset")

# get column names from features.txt
feature_names <- read.table("features.txt", header = FALSE)

#make  valid names to be able to split later
clean_names <- gsub("-","_", feature_names$V2)
clean_names <- gsub("\\(|\\)","", clean_names)
clean_names <- gsub("^t","time_", clean_names)
clean_names <- gsub("^f","fft_", clean_names)
clean_names <- gsub("([a-z])([A-Z])","\\1_\\2", clean_names)
clean_names <- gsub("(_Jerk)","Jerk", clean_names)
clean_names <- gsub("(Body_Body)","BodyBody", clean_names)
clean_names <- gsub("(mean_Freq)","meanFreq", clean_names)
clean_names <- gsub("(.+)(Mag_)(.+)","\\1\\3_Mag", clean_names)

#read activities descriptiond
activity_labels <- read.table("activity_labels.txt", header = FALSE, col.names = c("activity_indicator","activity_label"))

# read X_train with feature names
X_train <- read.table("./train/X_train.txt", header = FALSE, col.names = clean_names)

#read y_train  
y_train <- read.table("./train/y_train.txt", header = FALSE, col.names ="Activity")

#read subject_train
subject_train <- read.table("./train/subject_train.txt", header = FALSE, col.names ="subject_id")

# read X_test with feature names
X_test <- read.table("./test/X_test.txt", header = FALSE, col.names = clean_names)

# read y_test
y_test <- read.table("./test/y_test.txt", header = FALSE, col.names = "Activity")

#read subject_test
subject_test <- read.table("./test/subject_test.txt", header = FALSE, col.names ="subject_id")


# bind X_train and y_train
train_total <- cbind(X_train, y_train, subject_train)

#select columns which contain mean and std
train_total <- train_total %>% select(matches("(std|mean)_|(Activity)|(subject_id)"))

#merge with activity labels
train_total <- merge(train_total, activity_labels, by.x="Activity", by.y="activity_indicator")
train_total <- train_total %>% select(-Activity)

# bind X_test and y_test
test_total <- cbind(X_test, y_test, subject_test)

#select columns which contain mean and std
test_total <- test_total %>% select(matches("(std|mean)_|(Activity)|(subject_id)"))

#merge with activity labels
test_total <- merge(test_total, activity_labels, by.x="Activity", by.y="activity_indicator")
test_total <- test_total %>% select(-Activity)

#gather then separate dataset
train_total <- train_total %>% gather(transform_area_measuretype_calc_direction, value, -subject_id, -activity_label) %>%
  separate(col=transform_area_measuretype_calc_direction, into=c("transform","area","measuretype","calc","direction"))

test_total <- test_total %>% gather(transform_area_measuretype_calc_direction, value, -subject_id, -activity_label) %>%
  separate(col=transform_area_measuretype_calc_direction, into=c("transform","area","measuretype","calc","direction"))

#remove any duplicated
train_total <- unique(train_total)
test_total<- unique(test_total)

# merge datasets
merged <- rbind(test_total, train_total)


#train_total <- spread(train_total, calc, value)
#test_total <- spread(test_total, calc, value)


#create averages table
 averages <- merged %>% group_by(subject_id, activity_label, transform, area, measuretype, direction, calc) %>% summarize_at(.cols = vars(matches("value|mean|std")), .funs=c(Mean = "mean"))
 averages <- spread(averages, calc, Mean)
 
 
#write out averages table
 write.table(averages, "averages.txt", row.names = FALSE)
# 
