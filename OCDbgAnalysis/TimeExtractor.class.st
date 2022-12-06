Class {
	#name : #TimeExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
TimeExtractor >> extract [

	^ task endTime - task startTime
]

{ #category : #'as yet unclassified' }
TimeExtractor >> targetField [

	^ #time
]
