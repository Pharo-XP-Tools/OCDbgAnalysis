"
I am a calculator utility strategy, with a single `#compute:` abstract class method.
My subclasses should reimplement this method to compute adequate metric data points values, and then passed to the correspoding data point for which they should build the data.
"
Class {
	#name : #PhexMetricCalculator,
	#superclass : #Object,
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #initialize }
PhexMetricCalculator class >> compute: data [

	^self subclassResponsibility 
]
