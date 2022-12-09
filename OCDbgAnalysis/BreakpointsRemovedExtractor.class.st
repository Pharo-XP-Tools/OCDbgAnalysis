Class {
	#name : #BreakpointsRemovedExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
BreakpointsRemovedExtractor >> extract [

	| taskEvents |
	taskEvents := OCDbgEvents
		              selectTasksEvents: task uuid
		              inCollection: data.
	^ taskEvents count: [ :evt | evt class = DSBreakpointEventRecord and: [ evt objectCentric not and: [ evt eventName = 'BreakpointRemoved' ] ]  ]
]

{ #category : #api }
BreakpointsRemovedExtractor >> targetField [

	^ #breakpointsRemoved
]
