"
I model a scalar data point computed from DSWindow tool events.
"
Class {
	#name : #PhexToolDataPoint,
	#superclass : #PhexDataPoint,
	#instVars : [
		'toolName'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #'private - computation' }
PhexToolDataPoint >> compute [
	self halt 
]

{ #category : #accessing }
PhexToolDataPoint >> name [

	^ toolName ifNil: [ super name ]
]

{ #category : #accessing }
PhexToolDataPoint >> toolName: anObject [

	toolName := anObject
]
