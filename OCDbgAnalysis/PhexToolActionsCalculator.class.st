"
I compute the number of debug actions performed in a given tool.
"
Class {
	#name : 'PhexToolActionsCalculator',
	#superclass : 'PhexMetricCalculator',
	#category : 'OCDbgAnalysis-NewModel',
	#package : 'OCDbgAnalysis',
	#tag : 'NewModel'
}

{ #category : 'initialize' }
PhexToolActionsCalculator class >> compute: data [

	^ (DSRecordHistory basicNew records:
		   (data collect: #events) flattened) countDebugActions
]
