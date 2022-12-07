# OCDbgAnalysis
Tools to help with logs analysis

To install everything from scratch, in an new Pharo9.0 64 bit image do this:

```Smalltalk
Metacello new
    baseline: 'OCDbgAnalysis';
    repository: 'github://Pharo-XP-Tools/OCDbgAnalysis:main';
    load.
```
    
If you only want to load the packages from OCDbgAnalysis without the dependencies (If you have them installed already) do this:

```Smalltalk
"Fetches the packages, without loading them and without triggering the pre and post baseline hooks"

Metacello new
    baseline: 'OCDbgAnalysis';
    repository: 'github://Pharo-XP-Tools/OCDbgAnalysis:main';
    fetch.
    
"Manually load the package"
((IceRepository repositories detect: [ :r| r name = 'OCDbgAnalysis' ]) 
    workingCopy packages detect: [:p| p package = 'OCDbgAnalysis' ])
    load.
```

Examples:
```Smalltalk
"Example 1: From log files to JSON"
(ParticipantResult resultsCollectionFromFiles: { 
   '/Users/maxw/Documents/ocrex1pilot/User-a1eff302-b2a0-0d00-b9ea-48310c48fda453911402438000' . 
   '/Users/maxw/Documents/ocrex1pilot/User-a1eff302-b2a0-0d00-b9ea-48310c48fda453911402438000' }) asJSON
```

```Smalltalk
"Example 2: Obtaining a task completion time"
|data tutorial tutorialTime|
"use the absolute path to your data file"
data := OCDbgExampleCode loadDataFromPath: '/Users/maxw/Documents/ocrex1pilot/User-a1eff302-b2a0-0d00-b9ea-48310c48fda453911402438000'.
tutorial:= (data ocdSelectTasksEnding  at:2) task.
tutorialTime := tutorial endTime - tutorial startTime.
 "0:00:13:47.212501"
```
