Class {
	#name : 'DurationExtractor',
	#superclass : 'MetricExtractor',
	#category : 'OCDbgAnalysis-Metrics',
	#package : 'OCDbgAnalysis',
	#tag : 'Metrics'
}

{ #category : 'api' }
DurationExtractor >> extract [

	^ task endTime - task startTime
]

{ #category : 'as yet unclassified' }
DurationExtractor >> targetField [

	^ #duration
]
