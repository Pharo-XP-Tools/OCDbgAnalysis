Class {
	#name : #DurationExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #api }
DurationExtractor >> extract [

	^ task endTime - task startTime
]

{ #category : #'as yet unclassified' }
DurationExtractor >> targetField [

	^ #duration
]
