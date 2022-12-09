Class {
	#name : #OCBreakpointsHitExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
OCBreakpointsHitExtractor >> extract [

	| taskEvents |
	taskEvents := OCDbgEvents
		              selectTasksEvents: task uuid
		              inCollection: data.
	^ taskEvents count: [ :evt | evt class = DSBreakpointEventRecord and: [ evt objectCentric and: [ evt eventName = 'BreakpointHit' ] ]  ]
]

{ #category : #api }
OCBreakpointsHitExtractor >> targetField [

	^ #ocBreakpointsHit
]
