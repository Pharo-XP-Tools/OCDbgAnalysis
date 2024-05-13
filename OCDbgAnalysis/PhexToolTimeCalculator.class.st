"
I compute the time spent in a given tool.
"
Class {
	#name : #PhexToolTimeCalculator,
	#superclass : #PhexMetricCalculator,
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #initialize }
PhexToolTimeCalculator class >> compute: data [
|r|
	r :=  data
		  inject: 0
		  into: [ :sum :next |
		  sum + (next totalTime - next trueIdleTime) asSeconds ].
	r asSeconds > 10 hours ifTrue:[self halt].
	r < 0 ifTrue:[self halt].
	^r
]

{ #category : #'as yet unclassified' }
PhexToolTimeCalculator class >> phexPrint: anObject [

	^anObject asDuration printString
]

{ #category : #'as yet unclassified' }
PhexToolTimeCalculator class >> transform: aRawValue [
	^aRawValue asSeconds
]
