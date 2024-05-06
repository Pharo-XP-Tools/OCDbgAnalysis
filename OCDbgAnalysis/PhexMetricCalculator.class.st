"
I am a calculator utility strategy, with a two class methods:
-  `#compute:` (abstract)
- `#transform:`
My subclasses should reimplement thess methods to compute adequate metric data points values and to transform the computed raw value to a Pharo object (if necessary), and then passed to the corresponding data point for which they should build the data.

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

{ #category : #'as yet unclassified' }
PhexMetricCalculator class >> phexPrint: anObject [
	^anObject asFloat printString
]

{ #category : #'as yet unclassified' }
PhexMetricCalculator class >> transform: aRawValue [
	^aRawValue
]
