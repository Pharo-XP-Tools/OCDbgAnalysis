Class {
	#name : #ExperimentResults,
	#superclass : #Object,
	#instVars : [
		'participantResults',
		'emails',
		'treatmentTasks',
		'controlTasks',
		'participantsExperience',
		'dataSize'
	],
	#classInstVars : [
		'current',
		'dataDirs',
		'dataCache'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
ExperimentResults class >> addDataDir: aDirectoryPath [

	self dataDirs add: aDirectoryPath
]

{ #category : #accessing }
ExperimentResults class >> current [
	^current ifNil:[current := self new]
]

{ #category : #accessing }
ExperimentResults class >> current: anExperiment [

	current := anExperiment
]

{ #category : #accessing }
ExperimentResults class >> dataDirs [
	^dataDirs ifNil:[dataDirs := OrderedCollection new]
]

{ #category : #'as yet unclassified' }
ExperimentResults class >> extractAndOpenResults: dataPath [
	
	^(self extractResults: dataPath) inspect
]

{ #category : #'as yet unclassified' }
ExperimentResults class >> extractResults: dataPath [
	
	^self new extractResultsFromPath: dataPath asFileReference 
]

{ #category : #'as yet unclassified' }
ExperimentResults class >> extractResultsWithProgress: dataPath [
	
	^self new extractResultsWithProgress: dataPath asFileReference 
]

{ #category : #adding }
ExperimentResults >> addEmail: aString [
	self emails add: aString.
	aString crTrace
]

{ #category : #adding }
ExperimentResults >> addPersonalDataSurvey: aDSSurveyRecord [

	aDSSurveyRecord ifNil: [ ^ self ].
	self addEmail: aDSSurveyRecord survey questions third answer.
"	aDSSurveyRecord survey questions third answer: nil"
]

{ #category : #'data analysis' }
ExperimentResults >> buildTaskResults [
	
	|t1 t2 debuggingActionCount|
	debuggingActionCount := [ :results|  (results collect: [:next|	
	(DSRecordHistory on: next events) countDebugActions ]) "average asFloat rounded"].

	self collectTasksForAnalysis.
	t1 := TasksResults new.
	t1 name: (controlTasks t1 first taskInfo title).
	t1 controlData: (controlTasks t1 collect:[:t| t duration]).
	t1 treatmentData: (treatmentTasks t1 collect:[:t| t duration]).
	t1 ratio: ((t1 controlAvg / t1 treatmentAvg) asFloat truncateTo: 0.000001).
	
	t1 averageDebuggingActionsCount: {(debuggingActionCount value: controlTasks t1).  (debuggingActionCount value: treatmentTasks t1).  }.
	
	t2 := TasksResults new.
	t2 name: (controlTasks t2 first taskInfo title).
	t2 controlData: (controlTasks t2 collect:[:t| t duration]).
	t2 treatmentData: (treatmentTasks t2 collect:[:t| t duration]).
	t2 ratio: ((t2 controlAvg asNanoSeconds / t2 treatmentAvg asNanoSeconds) asFloat truncateTo: 0.000001).
		t2 averageDebuggingActionsCount: {(debuggingActionCount value: controlTasks t2).  (debuggingActionCount value: treatmentTasks t2).  }.
	
	^ { t1. t2 }
]

{ #category : #'data analysis' }
ExperimentResults >> buildTaskResultsFor: participantsSubset [
	
	|t1 t2 debuggingActionCount|
	debuggingActionCount := [ :results|  (results collect: [:next|	
	(DSRecordHistory on: next events) countDebugActions ]) "average asFloat rounded"].

	self collectTasksForAnalysisFor: participantsSubset.
	t1 := TasksResults new.
	t1 name: (controlTasks t1 first taskInfo title).
	t1 controlData: (controlTasks t1 collect:[:t| t duration]).
	t1 treatmentData: (treatmentTasks t1 collect:[:t| t duration]).
	t1 ratio: ((t1 controlAvg / t1 treatmentAvg) asFloat truncateTo: 0.000001).
	
	t1 averageDebuggingActionsCount: {(debuggingActionCount value: controlTasks t1).  (debuggingActionCount value: treatmentTasks t1).  }.
	
	t2 := TasksResults new.
	t2 name: (controlTasks t2 first taskInfo title).
	t2 controlData: (controlTasks t2 collect:[:t| t duration]).
	t2 treatmentData: (treatmentTasks t2 collect:[:t| t duration]).
	t2 ratio: ((t2 controlAvg asNanoSeconds / t2 treatmentAvg asNanoSeconds) asFloat truncateTo: 0.000001).
		t2 averageDebuggingActionsCount: {(debuggingActionCount value: controlTasks t2).  (debuggingActionCount value: treatmentTasks t2).  }.
	
	^ { t1. t2 }
]

{ #category : #'data extraction' }
ExperimentResults >> collectControlTasksFrom: participants [

	controlTasks := ControlTasks new.
	participants do: [ :p | 
			|task|
			task := p tasks first.
			task useConsolidatedTimes.
			controlTasks addTaskStats: task ]
]

{ #category : #'data analysis' }
ExperimentResults >> collectDeveloperExperience [

	participantsExperience := OrderedCollection new.
	((participantResults select: [ :p | p shouldCount ]) collect: [ :r |
		 r participant surveys ]) do: [ :surveys |
		| demographicSurvey |
		demographicSurvey := surveys
			                     detect: [ :s |
			                     s survey title = 'Demographic information' ]
			                     ifNone: [ nil ].
		demographicSurvey ifNotNil: [ :s |
			| xp |
			xp := s survey answers
				      detect: [ :a |
					      a title
					      =
					      'How many years of programming experience do you have with Pharo?' ]
				      ifNone: [ nil ].
			xp ifNotNil: [ participantsExperience add: xp answer answer ] ] ]
]

{ #category : #'data extraction' }
ExperimentResults >> collectTasksForAnalysis [

	self collectControlTasksFrom: participantResults.
	self collectTreatmentTasksFrom: participantResults
]

{ #category : #'data extraction' }
ExperimentResults >> collectTasksForAnalysisFor: participantsSubset [

	self collectControlTasksFrom: participantsSubset.
	self collectTreatmentTasksFrom: participantsSubset
]

{ #category : #'data extraction' }
ExperimentResults >> collectTreatmentTasksFrom: participants [

	treatmentTasks := TreatmentTasks new.
	participants do: [ :p |
		| task |
		task := p tasks last.
		task useConsolidatedTimes.
		treatmentTasks addTaskStats: task ]
]

{ #category : #'data extraction' }
ExperimentResults >> dataExtractionProgress [

	^ [ (participantResults size / dataSize) ]
		  on: Error
		  do: [ 0 ]
]

{ #category : #accessing }
ExperimentResults >> emails [
	^ emails ifNil:[emails := OrderedCollection new]
]

{ #category : #'data extraction' }
ExperimentResults >> extractResultsFromPath: dataPath [

	participantResults := (dataPath entries select: [ :e | e isDirectory ]) 
		                      collect: [ :dir | 
			                      | data result |
			                      data := OCDbgExampleCode loadDataFromPath:
				                              dir.
			                      result := ParticipantResult newFromData: data.
			                      result participant surveys:
				                      (self extractSurveysFromData: data).
			                      result ].
	^ self
]

{ #category : #'data extraction' }
ExperimentResults >> extractResultsWithProgress: dataPath [

	| dataEntries |
	dataEntries := dataPath entries select: [ :e | e isDirectory ].
	dataSize := dataEntries size.

	participantResults := OrderedCollection new.
	dataEntries do: [ :dir |
		| data result |
		data := OCDbgExampleCode loadDataFromPath: dir.
		result := ParticipantResult newFromData: data.
		result id: dir reference path basename.
		result participant surveys: (self extractSurveysFromData: data).
		participantResults add: result ].
	self class current: self.
	^ self
]

{ #category : #'data extraction' }
ExperimentResults >> extractSurveysFromData: data [

	| surveys |
	surveys := data select: [ :e | e class = DSSurveyRecord ].
	self addPersonalDataSurvey:
		(surveys
			 detect: [ :s | s survey questions size = 4 ]
			 ifNone: [ nil ]).

	^ surveys
]

{ #category : #accessing }
ExperimentResults >> participantResults [

	^ participantResults
]

{ #category : #accessing }
ExperimentResults >> participantResults: anObject [

	participantResults := anObject
]

{ #category : #accessing }
ExperimentResults >> participantsExperience [

	^ participantsExperience
]

{ #category : #'as yet unclassified' }
ExperimentResults >> scatterPlots [
	self shouldBeImplemented.
]
