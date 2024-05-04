"
I am a simple data point model, that computes a scalar value from a data set
"
Class {
	#name : #PhexDataPoint,
	#superclass : #Object,
	#instVars : [
		'dataType',
		'value',
		'rawData',
		'transformation'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #'accessing - defaults' }
PhexDataPoint class >> defaultName [
	^'A phex scalar data point'
]

{ #category : #'private - computation' }
PhexDataPoint >> compute [
	self subclassResponsibility 
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
PhexDataPoint >> defaultName [
	^self class defaultName
]

{ #category : #computation }
PhexDataPoint >> empty [

	rawData := OrderedCollection new.
	value := 0
]

{ #category : #accessing }
PhexDataPoint >> name [
	^self defaultName
]

{ #category : #'private - computation' }
PhexDataPoint >> printOn: aStream [
	aStream << self name

	
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
