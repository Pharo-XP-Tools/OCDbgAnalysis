Class {
	#name : #TaskDataExtractor,
	#superclass : #MetricExtractor,
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #'as yet unclassified' }
TaskDataExtractor >> extract [

	"Should return the metric after extracting and calculating it from all the data"

	^ OCDbgEvents selectTasksEvents: task uuid inCollection: data
]

{ #category : #'as yet unclassified' }
TaskDataExtractor >> targetField [

	"should return the name of the metric (and matching the stat instance variable name)"

	^ #events
]
