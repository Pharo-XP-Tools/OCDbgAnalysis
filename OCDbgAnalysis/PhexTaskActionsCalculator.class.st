Class {
	#name : #PhexTaskActionsCalculator,
	#superclass : #PhexMetricCalculator,
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #initialize }
PhexTaskActionsCalculator class >> compute: data [

	^data countDebugActions
]
