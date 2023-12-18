Class {
	#name : #OCBreakpointsRemovedExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
OCBreakpointsRemovedExtractor >> extract [

	| taskEvents |
	taskEvents := OCDbgEvents
		              selectTasksEvents: task uuid
		              inCollection: data.
	^ taskEvents count: [ :evt |
		  (evt isKindOf: DSAbstractBreakpointEventRecord) and: [
			  evt objectCentric and: [ evt eventName = 'BreakpointRemoved' ] ] ]
]

{ #category : #api }
OCBreakpointsRemovedExtractor >> targetField [

	^ #ocBreakpointsRemoved
]
