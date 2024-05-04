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
