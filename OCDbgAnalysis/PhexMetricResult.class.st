"
First simple model of a tri-part metric (averages):
- actions in a window of type t
- number of windows of type t
- time spent in a window of type t
"
Class {
	#name : #PhexMetricResult,
	#superclass : #Object,
	#instVars : [
		'type',
		'data',
		'avgTime',
		'avgActions',
		'avgNb'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #accessing }
PhexMetricResult >> avgActions [

	^ avgActions
]

{ #category : #accessing }
PhexMetricResult >> avgActions: anObject [

	avgActions := anObject
]

{ #category : #accessing }
PhexMetricResult >> avgNb [

	^ avgNb
]

{ #category : #accessing }
PhexMetricResult >> avgNb: anObject [

	avgNb := anObject
]

{ #category : #accessing }
PhexMetricResult >> avgTime [

	^ avgTime
]

{ #category : #accessing }
PhexMetricResult >> avgTime: anObject [

	avgTime := anObject
]

{ #category : #accessing }
PhexMetricResult >> data [

	^ data
]

{ #category : #accessing }
PhexMetricResult >> data: anObject [

	data := anObject
]

{ #category : #accessing }
PhexMetricResult >> type [

	^ type
]

{ #category : #accessing }
PhexMetricResult >> type: anObject [

	type := anObject
]
