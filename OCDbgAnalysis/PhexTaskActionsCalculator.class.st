Class {
	#name : 'PhexTaskActionsCalculator',
	#superclass : 'PhexMetricCalculator',
	#category : 'OCDbgAnalysis-NewModel',
	#package : 'OCDbgAnalysis',
	#tag : 'NewModel'
}

{ #category : 'initialize' }
PhexTaskActionsCalculator class >> compute: data [

	^data countDebugActions
]
