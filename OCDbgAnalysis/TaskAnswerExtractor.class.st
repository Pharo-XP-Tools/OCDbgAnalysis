Class {
	#name : #TaskAnswerExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
TaskAnswerExtractor >> extract [

	| dsTask |
	dsTask := data
		          detect: [ :evt | 
		          evt class = DSEndingTaskRecord and: [ evt task = task ] ]
		          ifNone: [ ^ nil ].
	^ dsTask answer
]

{ #category : #api }
TaskAnswerExtractor >> targetField [

	^ #answer
]
