Class {
	#name : #DebuggerOpeningsExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
DebuggerOpeningsExtractor >> extract [

	| taskEvents |
	taskEvents := OCDbgEvents
		              selectTasksEvents: task uuid
		              inCollection: data.
	^ taskEvents count: [ :evt | evt class = DSDebuggerOpeningRecord  ]
]

{ #category : #api }
DebuggerOpeningsExtractor >> targetField [

	^ #debuggerOpenings
]
