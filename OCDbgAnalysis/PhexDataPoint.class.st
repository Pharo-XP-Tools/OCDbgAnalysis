"
I am a simple data point model, that computes a scalar value from a data set
"
Class {
	#name : #PhexDataPoint,
	#superclass : #Object,
	#instVars : [
		'dataType',
		'value',
		'rawData'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #'private - computation' }
PhexDataPoint >> compute [
	^self subclassResponsibility 
]

{ #category : #accessing }
PhexDataPoint >> dataType [

	^ dataType
]

{ #category : #accessing }
PhexDataPoint >> dataType: anObject [

	dataType := anObject
]

{ #category : #accessing }
PhexDataPoint >> dataValue [
	^value
]

{ #category : #accessing }
PhexDataPoint >> rawData [

	^ rawData
]

{ #category : #accessing }
PhexDataPoint >> rawData: anObject [

	rawData := anObject
]

{ #category : #computation }
PhexDataPoint >> recompute [
	self compute
]
