Class {
	#name : #TasksResults,
	#superclass : #Object,
	#instVars : [
		'name',
		'controlAvg',
		'treatmentAvg',
		'ratio'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
TasksResults >> controlAvg [

	^ controlAvg
]

{ #category : #accessing }
TasksResults >> controlAvg: anObject [

	controlAvg := anObject
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
TasksResults >> ratio: anObject [

	ratio := anObject
]

{ #category : #accessing }
TasksResults >> treatmentAvg [

	^ treatmentAvg
]

{ #category : #accessing }
TasksResults >> treatmentAvg: anObject [

	treatmentAvg := anObject
]