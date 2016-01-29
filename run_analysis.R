setwd("C:/Users/i57598/Desktop/datascience/data_cleaning/UCI HAR Dataset")
        y_train <- read.table("train/y_train.txt", quote = "\"")
        y_test <- read.table("test/y_test.txt", quote = "\"")
        features <- read.table("features.txt", quote = "\"")
        activity_labels <- read.table("activity_labels.txt", quote = "\"")
        subject_train <- read.table("train/subject_train.txt", quote="\"")
        subject_test <- read.table("test/subject_test.txt", quote="\"")
        X_train <- read.table("train/X_train.txt", quote="\"")
        X_test <- read.table("test/X_test.txt", quote="\"")
        
colnames(activity_labels) <- c("V1", "Activity")

# Merge activity labels with the y_train file

subject <- rename(subject_train, subject = V1)
train <- cbind(y_train, subject)
train1 <- merge(train, activity_labels, by = ("V1"))

colnames(X_train) <- features[,2]
train2 <- cbind(train1, X_train)
#to fix "duplicate column name" error
train3 <- train2[,-1]

# now selecting only columns containing means and std
train4 <- select(train3, contains("subject"), contains("Activity"), contains("mean"), contains("std"))

colnames(activity_labels)<- c("V1","Activity")

subject1 <- rename(subject_test, subject = V1)
test <- cbind(y_test, subject1)
test1 <- merge(test, activity_labels, by = ("V1"))

colnames(X_test) <- features[,2]
test2 <- cbind(test1, X_test)
test3 <- test2[,-1]
test4 <- select(test3, contains("subject"), contains("Activity"), contains("mean"), contains("std"))
run_analysis1 <- rbind(train4, test4)

run_analysis <- (run_analysis1 %>%
                         group_by(subject, Activity) %>%
                         summarize_each(funs(mean)))

print(run_analysis)