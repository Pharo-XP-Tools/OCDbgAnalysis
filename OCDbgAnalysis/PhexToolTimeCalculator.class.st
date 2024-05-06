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

	^ data
		  inject: 0
		  into: [ :sum :next |
		  sum + (next totalTime - next idleTime) asSeconds ]
]

{ #category : #'as yet unclassified' }
PhexToolTimeCalculator class >> phexPrint: anObject [

	^anObject asDuration printString
]

{ #category : #'as yet unclassified' }
PhexToolTimeCalculator class >> transform: aRawValue [
	^aRawValue seconds
]
