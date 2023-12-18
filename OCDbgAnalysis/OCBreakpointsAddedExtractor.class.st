Class {
	#name : #OCBreakpointsAddedExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
OCBreakpointsAddedExtractor >> extract [

	| taskEvents |
	taskEvents := OCDbgEvents
		              selectTasksEvents: task uuid
		              inCollection: data.
	^ taskEvents count: [ :evt |
		  (evt isKindOf: DSAbstractBreakpointEventRecord) and: [
			  evt objectCentric and: [ evt eventName = 'BreakpointAdded' ] ] ]
]

{ #category : #api }
OCBreakpointsAddedExtractor >> targetField [

	^ #ocBreakpointsAdded
]
