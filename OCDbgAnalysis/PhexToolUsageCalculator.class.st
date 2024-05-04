"
I compute how much time a given tool was used.
"
Class {
	#name : #PhexToolUsageCalculator,
	#superclass : #PhexMetricCalculator,
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #initialize }
PhexToolUsageCalculator class >> compute: data [

	^data size
]
