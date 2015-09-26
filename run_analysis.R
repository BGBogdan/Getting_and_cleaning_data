library(reshape)
library(plyr)
# 1. Merge the training and test sets to create one data set
# Test data:
test_subject <- read.table("test/subject_test.txt")
test_x <- read.table("test/X_test.txt")
test_y <- read.table("test/y_test.txt")

# Training data:
train_subject <- read.table("train/subject_train.txt")
train_x <- read.table("train/X_train.txt")
train_y <- read.table("train/y_train.txt")

# Activity labels

activity <- read.table("activity_labels.txt")
features <- read.table("features.txt")

#Binding all the data sets:

final_x <- rbind(test_x, train_x)
final_y <- rbind(test_y, train_y)
final_subject <- rbind(test_subject, train_subject)

#Add Apropriate column names

heading <- features[,2]
colnames(final_x) = heading
colnames(final_subject) = c("subject_ID")
colnames(final_y) = c("Activity")

final_y$Activity = factor(
  final_y[,1], 
  labels = activity[,2]
)

#Final tidy data set

tidy_data <- cbind(final_subject, final_y, final_x)

# 2. Extract only the measurements on the mean and standard deviation for each measurement

means_std <- grep("-(mean|std)\\(\\)", names(tidy_data))
mean_std_data <- tidy_data[,means_std]
View(mean_std_data)

# Requirements 3. Uses descriptive activity names to name the activities in the data set
# and 4. Appropriately labels the data set with descriptive variable names, were already
# met when I compiled the tidy_data data frame. I initially assumend it was part of the
# first task before reading all of the requirements :)

# 5. From the data set in step 4, creates a second, independent tidy data set with the
# average of each variable for each activity and each subject.

dataset2 <- ddply(tidy_data, .(subject_ID, Activity), function(x) colMeans(x[,3:563]))
View(dataset2)

# Export the data set
write.table(dataset2, file = "./dataset2.txt", row.name=FALSE)