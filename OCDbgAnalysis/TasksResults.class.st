Class {
	#name : #TasksResults,
	#superclass : #Object,
	#instVars : [
		'name',
		'controlAvg',
		'treatmentAvg',
		'ratio',
		'controlData',
		'treatmentData',
		'averageDebuggingActionsCount'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
TasksResults >> averageDebuggingActionsCount [

	^ averageDebuggingActionsCount
]

{ #category : #accessing }
TasksResults >> averageDebuggingActionsCount: anObject [

	averageDebuggingActionsCount := anObject
]

{ #category : #accessing }
TasksResults >> collectControlValues [

	^ controlData collect: [ :d | d minutes + (d seconds / 60) asFloat ]
]

{ #category : #accessing }
TasksResults >> collectTreatmentValues [

	^ treatmentData collect: [ :d | d minutes + (d seconds / 60) asFloat ]
]

{ #category : #accessing }
TasksResults >> controlAvg [

	^ controlAvg
]

{ #category : #accessing }
TasksResults >> controlAvg: anObject [

	controlAvg := anObject
]

{ #category : #accessing }
TasksResults >> controlData [

	^ controlData
]

{ #category : #accessing }
TasksResults >> controlData: data [
	controlData := data.
	controlAvg := data average
]

{ #category : #accessing }
TasksResults >> name [

	^ name
]

{ #category : #accessing }
TasksResults >> name: anObject [

	name := anObject
]

{ #category : #accessing }
TasksResults >> ratio [

	^ ratio
]

{ #category : #accessing }
TasksResults >> ratio: aFloat [

	
	ratio := ((aFloat - 1) roundTo: 0.0001) * 100
]

{ #category : #accessing }
TasksResults >> treatmentAvg [

	^ treatmentAvg
]

{ #category : #accessing }
TasksResults >> treatmentAvg: anObject [

	treatmentAvg := anObject
]

{ #category : #accessing }
TasksResults >> treatmentData [

	^ treatmentData
]

{ #category : #accessing }
TasksResults >> treatmentData: data [
	treatmentData := data.
	treatmentAvg  := data average
]
