Class {
	#name : #TaskFixingProposition,
	#superclass : #Object,
	#instVars : [
		'endingTask',
		'insertionPoint'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
TaskFixingProposition >> endingTask [

	^ endingTask
]

{ #category : #accessing }
TaskFixingProposition >> endingTask: anObject [

	endingTask := anObject
]

{ #category : #accessing }
TaskFixingProposition >> insertionPoint [

	^ insertionPoint
]

{ #category : #accessing }
TaskFixingProposition >> insertionPoint: anObject [

	insertionPoint := anObject
]
