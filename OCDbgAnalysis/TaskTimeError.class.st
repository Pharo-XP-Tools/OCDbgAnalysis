Class {
	#name : #TaskTimeError,
	#superclass : #Object,
	#instVars : [
		'taskStats',
		'start',
		'stop',
		'duration',
		'count',
		'comment'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
TaskTimeError >> comment [

	^ comment
]

{ #category : #accessing }
TaskTimeError >> comment: anObject [

	comment := anObject
]

{ #category : #accessing }
TaskTimeError >> count [

	^ count
]

{ #category : #accessing }
TaskTimeError >> count: anObject [

	count := anObject
]

{ #category : #accessing }
TaskTimeError >> duration [

	^ duration
]

{ #category : #accessing }
TaskTimeError >> duration: anObject [

	duration := anObject
]

{ #category : #initialization }
TaskTimeError >> initialize [ 	
	super initialize.
	count := true.
	comment := String new
]

{ #category : #accessing }
TaskTimeError >> start [

	^ start
]

{ #category : #accessing }
TaskTimeError >> start: anObject [

	start := anObject
]

{ #category : #accessing }
TaskTimeError >> stop [

	^ stop
]

{ #category : #accessing }
TaskTimeError >> stop: anObject [

	stop := anObject
]

{ #category : #accessing }
TaskTimeError >> taskStats [

	^ taskStats
]

{ #category : #accessing }
TaskTimeError >> taskStats: anObject [

	taskStats := anObject
]
