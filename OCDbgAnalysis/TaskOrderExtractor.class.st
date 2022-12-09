Class {
	#name : #TaskOrderExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
TaskOrderExtractor >> extract [

	| tasks |
	tasks := (data ocdSelectTasksEnding sorted: [ :t1 :t2 | 
		          t1 dateTime < t2 dateTime ]) collect: [ :ds | ds task ].
	^ tasks find: task
]

{ #category : #api }
TaskOrderExtractor >> targetField [

	^ #order
]
