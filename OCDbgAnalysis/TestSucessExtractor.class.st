Class {
	#name : #TestSucessExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
TestSucessExtractor >> extract [

	| dsTaskSucess |
	dsTaskSucess := data
		                detect: [ :evt | 
		                evt class = DSTaskSuccessRecord and: [ 
			                evt task = task ] ]
		                ifNone: [ ^ nil ].
	^ dsTaskSucess successBoolean
]

{ #category : #api }
TestSucessExtractor >> targetField [

	^ #testSuccess
]
