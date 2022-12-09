Class {
	#name : #StepActionsExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
StepActionsExtractor >> extract [

	| taskEvents |
	taskEvents := OCDbgEvents
		              selectTasksEvents: task uuid
		              inCollection: data.
	^ taskEvents count: [ :evt | evt class = DSStepActionRecord ]
]

{ #category : #api }
StepActionsExtractor >> targetField [

	^ #stepActions
]
