# Example of data recovery

The following works with Pharo 11.

### Install the tool
Download a fresh Pharo 11 image.

Execute the following baseline in a playground:
```Smalltalk
Metacello new
    baseline: 'OCDbgAnalysis';
    repository: 'github://Pharo-XP-Tools/OCDbgAnalysis:main';
    load.
```
    

### Read data and extract a single debugging task

In this example, we consider that the data is located in a folder whose path is stored in a variable named `dataFolder`. It can be a file reference or a simple string, is does not matter.

Execute the following code in a playground:
```Smalltalk
	| rawData taskStarted taskEnded taskData history |
	rawData := OCDbgExampleCode loadDataFromPath:
		           '/Users/steven/Documents/Research/projects/OCRE/experiment-results/run-2/data/raw/Pilot-E-User-097b27db-98b5-0d00-998c-ca2a0e3170cf53213692724000'.

	taskStarted := rawData detect: [ :e | e class = DSStartTaskRecord ].
	taskEnded := rawData detect: [ :e | e class = DSEndingTaskRecord ].
	taskData := rawData copyFrom: (rawData indexOf: taskStarted) to: (rawData indexOf: taskEnded).

	history := DSRecordHistory on: taskData.
	history buildWindowHistory.
	history inspect
```

This gives you a history of the user actions and interactions during this debugging session, as show below:

![[windowHistory.png]]

### Working with the history
The dictionary `windowHistory` is a history of opened windows and all user actions performed within these windows.

We can select all debugger windows:
```Smalltalk
debuggersHistory := windowHistory select: [ :association| 
	association value first class == DSDebuggerOpeningRecord ]
```

Events can be classified by name or by type. Names and types can be used to build visualizations. To obtain event names, we must use our history of instantiated events:
```Smalltalk
eventNames := debuggersHistory keys first collect:[:e| e eventName].
```

The list of possible event types can be obtained by getting the events class hierarchy:
```Smalltalk
eventTypes := DSAbstractEventRecord allSubclasses.
```

Events are ordered by time. The time of an event is accessible as follows:
```Smalltalk
randomEvent := debuggersHistory keys first atRandom.
randomEvent dateTime inspect
```

### Possible errors
You might encounter the following error when attempting to browse code:

![[possible-error.png]]


Just modify this method directly in the debugger like the following, then proceed and close all debuggers. It should then be fine.
```Smalltalk
BeautifulComments class>>renderComment: aString of: aClassOrPackage 
	
	^ aString
```
