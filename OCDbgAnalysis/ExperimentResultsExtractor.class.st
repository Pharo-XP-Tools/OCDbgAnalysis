Class {
	#name : #ExperimentResultsExtractor,
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
		'dataCache',
		'temp'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
ExperimentResultsExtractor class >> addDataDir: aDirectoryPath [

	self dataDirs add: aDirectoryPath
]

{ #category : #accessing }
ExperimentResultsExtractor class >> dataDirs [
	^dataDirs ifNil:[dataDirs := OrderedCollection new]
]

{ #category : #'as yet unclassified' }
ExperimentResultsExtractor class >> extractAndOpenResults: dataPath [
	
	^(self extractResults: dataPath) inspect
]

{ #category : #'as yet unclassified' }
ExperimentResultsExtractor class >> extractResults: dataPath [
	
	^self new extractResultsFromPath: dataPath asFileReference 
]

{ #category : #'as yet unclassified' }
ExperimentResultsExtractor class >> extractResultsWithProgress: dataPath [
	
	^self new extractResultsWithProgress: dataPath asFileReference 
]

{ #category : #'data analysis' }
ExperimentResultsExtractor >> buildTaskResults [
	
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
ExperimentResultsExtractor >> buildTaskResultsFor: participantsSubset [
	
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

{ #category : #surveys }
ExperimentResultsExtractor >> collectAlmostInvalidSurveys [

	| dict |
	dict := Dictionary new.
	participantResults do: [ :p |
		p participant surveys do: [ :s |
			s survey isAlmostValid ifFalse: [
				(dict at: p ifAbsentPut: [ OrderedCollection new ]) add: s ] ] ].
	^ dict
]

{ #category : #'data extraction' }
ExperimentResultsExtractor >> collectControlTasksFrom: participants [

	controlTasks := ControlTasks new.
	(participants "select:[:p| p participant participantDeclaredExperience > 2]") do: [ :p | 
			|task|
			task := p tasks first.
			task useConsolidatedTimes.
			controlTasks addTaskStats: task ]
]

{ #category : #'data analysis' }
ExperimentResultsExtractor >> collectDeveloperExperience [

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

{ #category : #surveys }
ExperimentResultsExtractor >> collectInvalidSurveys [

	| dict |
	dict := Dictionary new.
	participantResults do: [ :p |
		p participant surveys do: [ :s |
			s survey isValid not ifTrue: [
				(dict at: p ifAbsentPut: [ OrderedCollection new ]) add: s ] ] ].
	^ dict
]

{ #category : #'data extraction' }
ExperimentResultsExtractor >> collectTasksForAnalysis [

	self collectControlTasksFrom: participantResults.
	self collectTreatmentTasksFrom: participantResults
]

{ #category : #'data extraction' }
ExperimentResultsExtractor >> collectTasksForAnalysisFor: participantsSubset [

	self collectControlTasksFrom: participantsSubset.
	self collectTreatmentTasksFrom: participantsSubset
]

{ #category : #'data extraction' }
ExperimentResultsExtractor >> collectTreatmentTasksFrom: participants [

	treatmentTasks := TreatmentTasks new.
	(participants "select:[:p| p participant participantDeclaredExperience > 2]") do: [ :p |
		| task |
		task := p tasks last.
		task useConsolidatedTimes.
		treatmentTasks addTaskStats: task ]
]

{ #category : #'data extraction' }
ExperimentResultsExtractor >> dataEntriesFrom: dataPath [

	^ dataPath entries select: [ :e | e isDirectory ]
]

{ #category : #'data extraction' }
ExperimentResultsExtractor >> dataExtractionProgress [

	^ [ (participantResults size / dataSize) ]
		  on: Error
		  do: [ 0 ]
]

{ #category : #'data extraction' }
ExperimentResultsExtractor >> extractResultsFromPath: dataPath [

	participantResults := self class dataCache values asOrderedCollection.
	(self dataEntriesFrom: dataPath) collect: [ :dir |
		| data result |
		data := OCDbgExampleCode loadDataFromPath: dir.
		result := ParticipantResult newFromData: data.
		result participant surveys: (self extractSurveysFromData: data).
		result tasks notEmpty ifTrue: [
			participantResults add: result ] ].
	^ self
]

{ #category : #'data extraction' }
ExperimentResultsExtractor >> extractResultsWithProgress: dataPath [

	| dataEntries |
	dataEntries := self dataEntriesFrom: dataPath.
	participantResults := OrderedCollection new.
	dataSize := dataEntries size + participantResults size.
	dataEntries do: [ :dir |
		| data result |
		data := OCDbgExampleCode loadDataFromPath: dir.
		result := ParticipantResult newFromData: data.
		result id: dir reference path basename.
		result participant surveys: (self extractSurveysFromData: data).
		result tasks notEmpty ifTrue: [ participantResults add: result ] ].
	^ self
]

{ #category : #'data extraction' }
ExperimentResultsExtractor >> extractSurveysFromData: data [

	^ data select: [ :e | e class = DSSurveyRecord ]
]

{ #category : #accessing }
ExperimentResultsExtractor >> participantResults [

	^ participantResults
]

{ #category : #accessing }
ExperimentResultsExtractor >> participantResults: anObject [

	participantResults := anObject
]

{ #category : #accessing }
ExperimentResultsExtractor >> participantsExperience [

	^ participantsExperience
]
