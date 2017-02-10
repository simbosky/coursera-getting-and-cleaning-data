# Code Book
## Source of Data
Experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.



## Transformations applied to the UCI HAR dataset

**Data Transformations**  
The data was cleaned by:  
1. Adding column names from the features table which were cleaned to enable extraction of variables from column names at a later stage  
2. Merging the subject id and activity label  
3. selecting only variables with "std" or "mean" in the title  
4. Melting the dataframe and separating to create the new variables (see below)
3. Concatenating the train and test data  
6. producing a table of averages by grouping and summarizing all numeric variables by subject and activity  
7. spreading the table to separate out the mean and standard deviation rows to columns

This produces a table of 5950 observations of 8 variables.

** Variables **
The variable names created for the averages table, and the values they can take, are:
- subject_id -> a range of 1:30 identifying the subject
- activity_label -> a string labeling the activity as WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
- transform -> a string labeling the measure as Time or Fast Fourier Transform
- area -> a string labelling the measue as Body or Gravity
- measuretype -> a string labelling the measue as Acc, AccJerk, Gyro or GyroJerk
- direction -> a string labelling the measure as X, Y, Z or MAG
- mean -> a value being the mean of the means
- std -> a value being the mean of the standard deviations