Class {
	#name : #PhexTaskTimeCalculator,
	#superclass : #PhexMetricCalculator,
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #initialize }
PhexTaskTimeCalculator class >> compute: data [

	^ data duration asSeconds
]

{ #category : #'as yet unclassified' }
PhexTaskTimeCalculator class >> phexPrint: anObject [

	^anObject asDuration printString
]

{ #category : #'as yet unclassified' }
PhexTaskTimeCalculator class >> transform: aRawValue [
	^aRawValue seconds
]
