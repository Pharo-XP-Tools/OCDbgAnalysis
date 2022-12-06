Class {
	#name : #MetricExtractor,
	#superclass : #Object,
	#instVars : [
		'task',
		'data'
	],
	#category : #'OCDbgAnalysis-Metrics'
}

{ #category : #'instance creation' }
MetricExtractor class >> newForTask: task fromData: aCollection [

	"task is a DSTask"

	^ self new
		  task: task;
		  data: aCollection;
		  yourself
]

{ #category : #accessing }
MetricExtractor >> data [

	^ data
]

{ #category : #accessing }
MetricExtractor >> data: anObject [

	data := anObject
]

{ #category : #'as yet unclassified' }
MetricExtractor >> extract [

	"Should return the metric after extracting and calculating it from all the data"

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MetricExtractor >> targetField [

	"should return the name of the metric (and matching the stat instance variable name)"

	^ self subclassResponsibility
]

{ #category : #accessing }
MetricExtractor >> task [

	^ task
]

{ #category : #accessing }
MetricExtractor >> task: anObject [

	task := anObject
]
