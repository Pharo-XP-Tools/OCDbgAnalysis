Class {
	#name : #BreakpointsHitExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
BreakpointsHitExtractor >> extract [

	| taskEvents |
	taskEvents := OCDbgEvents
		              selectTasksEvents: task uuid
		              inCollection: data.
	^ taskEvents count: [ :evt | evt class = DSBreakpointEventRecord and: [ evt objectCentric not and: [ evt eventName = 'BreakpointHit' ] ]  ]
]

{ #category : #api }
BreakpointsHitExtractor >> targetField [

	^ #breakpointsHit
]
