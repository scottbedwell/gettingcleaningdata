This readme document is intended to explain the analysis completed in the "run_analysis.R" code.

1) The appropriate libraries are loaded

2) The various data files are read in.  This includes
	- features.txt
	- activity_labels.txt
	- X_train.txt
	- Y_train.txt
	- subject_train.txt
	- X_test.txt
	- Y_test.txt
	- subject_test.txt
3) A "group" colum is created for Train vs Test

4) A "subject" colum is created from the subject files

5) An "activity.id" colum is created from the Y_train and Y_Test files

6) A "set" dataframe is created from combining the train and test dataframes

7) The "set" dataframe is filtered down to any column with "mean" or "std" in the name.  The instructions were unclear as to include only
columns with "mean" or "std" anywhere in the name, or only at the end.  I chose to include anywhere in the name.

8) Activity names are added from the activity_labels file using the join function based on the activity id

9) The column names are cleaned up by replacing "." with " ", removing multiple spaces, and trimming

10) All metrics are aggregated using mean (FUN=mean), grouping by activity name and subject.  There was some debate on the
forumns whether to aggregate all variables or only mean/std variables.  My interpretation was to aggregate the final
set, so only mean/std variables.

11) The names of the grouping variables are set

12) the tidy data set is written to tidyDataSet.txt
