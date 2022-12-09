Class {
	#name : #BreakpointsAddedExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
BreakpointsAddedExtractor >> extract [

	| taskEvents |
	taskEvents := OCDbgEvents
		              selectTasksEvents: task uuid
		              inCollection: data.
	^ taskEvents count: [ :evt | evt class = DSBreakpointEventRecord and: [ evt objectCentric not and: [ evt eventName = 'BreakpointAdded' ] ]  ]
]

{ #category : #api }
BreakpointsAddedExtractor >> targetField [

	^ #breakpointsAdded
]
