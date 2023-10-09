Class {
	#name : #TestSucessRawExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
TestSucessRawExtractor >> extract [

	| dsTaskSucess |
	dsTaskSucess := data
		                detect: [ :evt | 
		                evt class = DSTaskSuccessRecord and: [ 
			                evt task = task ] ]
		                ifNone: [ ^ nil ].
	^ dsTaskSucess success
]

{ #category : #api }
TestSucessRawExtractor >> targetField [

	^ #testSuccessRaw
]
