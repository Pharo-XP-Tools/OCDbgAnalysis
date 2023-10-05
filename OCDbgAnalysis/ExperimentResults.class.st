Class {
	#name : #ExperimentResults,
	#superclass : #Object,
	#instVars : [
		'participantResults',
		'emails',
		'treatmentTasks',
		'controlTasks'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #'as yet unclassified' }
ExperimentResults class >> extractAndOpenResults: dataPath [
	
	^(self extractResults: dataPath) inspect
]

{ #category : #'as yet unclassified' }
ExperimentResults class >> extractResults: dataPath [
	
	^self new extractResultsFromPath: dataPath asFileReference 
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
	aDSSurveyRecord survey questions third answer: nil
]

{ #category : #'data analysis' }
ExperimentResults >> buildTaskResults [
	
	|t1 t2|
	self collectTasksForAnalysis.
	t1 := TasksResults new.
	t1 name: (controlTasks t1 first taskInfo title).
	t1 controlData: (controlTasks t1 collect:[:t| t duration]).
	t1 treatmentData: (treatmentTasks t1 collect:[:t| t duration]).
	t1 ratio: ((t1 controlAvg / t1 treatmentAvg) asFloat truncateTo: 0.000001).
	
	t2 := TasksResults new.
	t2 name: (controlTasks t2 first taskInfo title).
	t2 controlData: (controlTasks t2 collect:[:t| t duration]).
	t2 treatmentData: (treatmentTasks t2 collect:[:t| t duration]).
	t2 ratio: ((t2 controlAvg asNanoSeconds / t2 treatmentAvg asNanoSeconds) asFloat truncateTo: 0.000001).
	
	^ { t1. t2 }
]

{ #category : #'data extraction' }
ExperimentResults >> collectControlTasksFrom: participants [

	controlTasks := ControlTasks new.
	participants do: [ :p | controlTasks addTaskStats: p tasks first ]
]

{ #category : #'data extraction' }
ExperimentResults >> collectTasksForAnalysis [

	self collectControlTasksFrom: participantResults.
	self collectTreatmentTasksFrom: participantResults
]

{ #category : #'data extraction' }
ExperimentResults >> collectTreatmentTasksFrom: participants [

	treatmentTasks := TreatmentTasks new.
	participants do: [ :p | treatmentTasks addTaskStats: p tasks last ]
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
