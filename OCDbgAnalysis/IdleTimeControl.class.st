Class {
	#name : #IdleTimeControl,
	#superclass : #Object,
	#instVars : [
		'events',
		'timeGapStartEvent',
		'timeGapStopEvent',
		'decision',
		'computedIdleTime',
		'comment'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
IdleTimeControl >> comment [

	^ comment ifNil:[comment := 'No decision yet']
]

{ #category : #accessing }
IdleTimeControl >> comment: anObject [

	comment := anObject
]

{ #category : #accessing }
IdleTimeControl >> computedIdleTime [

	^ computedIdleTime
]

{ #category : #accessing }
IdleTimeControl >> computedIdleTime: anObject [

	computedIdleTime := anObject
]

{ #category : #accessing }
IdleTimeControl >> decision [

	^ decision
]

{ #category : #accessing }
IdleTimeControl >> decision: anObject [

	decision := anObject
]

{ #category : #accessing }
IdleTimeControl >> events [

	^ events
]

{ #category : #accessing }
IdleTimeControl >> events: anObject [

	events := anObject
]

{ #category : #printing }
IdleTimeControl >> printOn: stream [

	stream << '['.
	stream << computedIdleTime humanReadablePrintString.
	stream << ']'.
	stream space.
	stream << self comment
]

{ #category : #accessing }
IdleTimeControl >> timeGapStartEvent [

	^ timeGapStartEvent
]

{ #category : #accessing }
IdleTimeControl >> timeGapStartEvent: anObject [

	timeGapStartEvent := anObject
]

{ #category : #accessing }
IdleTimeControl >> timeGapStopEvent [

	^ timeGapStopEvent
]

{ #category : #accessing }
IdleTimeControl >> timeGapStopEvent: anObject [

	timeGapStopEvent := anObject
]
