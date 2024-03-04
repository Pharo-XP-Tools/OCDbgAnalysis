"
First trivial model of metric analysis, based on control data and treatment data.
"
Class {
	#name : #PhexMetricAnalysis,
	#superclass : #Object,
	#instVars : [
		'name',
		'control',
		'treatment',
		'type'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #accessing }
PhexMetricAnalysis >> control [

	^ control
]

{ #category : #accessing }
PhexMetricAnalysis >> control: anObject [

	control := anObject
]

{ #category : #accessing }
PhexMetricAnalysis >> name [

	^ name
]

{ #category : #accessing }
PhexMetricAnalysis >> name: anObject [

	name := anObject
]

{ #category : #accessing }
PhexMetricAnalysis >> treatment [

	^ treatment
]

{ #category : #accessing }
PhexMetricAnalysis >> treatment: anObject [

	treatment := anObject
]

{ #category : #accessing }
PhexMetricAnalysis >> type [

	^ type
]

{ #category : #accessing }
PhexMetricAnalysis >> type: anObject [

	type := anObject
]
