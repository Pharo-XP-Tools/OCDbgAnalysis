"
I model a scalar data point computed from DSWindow tool events.
"
Class {
	#name : #PhexToolDataPoint,
	#superclass : #PhexDataPoint,
	#instVars : [
		'toolName',
		'rawValue'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #'private - computation' }
PhexToolDataPoint >> compute [

	rawValue := dataType compute: rawData.
	value := dataType transform: rawValue
]

{ #category : #accessing }
PhexToolDataPoint >> name [

	^ toolName ifNil: [ super name ]
]

{ #category : #'private - computation' }
PhexToolDataPoint >> printOn: aStream [

	super printOn: aStream.
	aStream space.	
	aStream <<'('.
	value printOn: aStream.
	aStream <<')'.
]

{ #category : #accessing }
PhexToolDataPoint >> toolName: anObject [

	toolName := anObject
]
