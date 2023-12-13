Class {
	#name : #TaskTimeControl,
	#superclass : #Object,
	#instVars : [
		'taskStats',
		'estimatedIdleTime',
		'declaredIdleTime',
		'retainedIdleTime',
		'threshold',
		'timeErrors',
		'taskDuration'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #control }
TaskTimeControl >> buildTimeErrorFrom: start to: stop delta: delta [

	| timeError |
	timeError := TaskTimeError new.
	timeError start: start.
	timeError stop: stop.
	timeError duration: delta.
	timeError taskStats: taskStats.
	timeErrors add: timeError
]

{ #category : #control }
TaskTimeControl >> collectTimeErrors [

	| controlBlock |
	timeErrors := OrderedCollection new.
	controlBlock := [ :delta :start :stop |
	                self buildTimeErrorFrom: start to: stop delta: delta ].
	self controlTimeErrors: controlBlock
]

{ #category : #control }
TaskTimeControl >> computeTime [

	| finishTaskEvents |
	finishTaskEvents := self events select: [ :e |
		                    self isFinishTaskWindowOpening: e ].

	finishTaskEvents isEmpty ifTrue: [
		taskDuration := self events last dateTime
		                - self events first dateTime.
		^ self ].
	^ taskDuration := finishTaskEvents last dateTime
	                  - self events first dateTime
]

{ #category : #control }
TaskTimeControl >> computeTotalTimeErrors [

	| controlBlock |
	estimatedIdleTime := 0.
	controlBlock := [ :delta |
	                estimatedIdleTime := estimatedIdleTime + delta ].
	self controlTimeErrors: controlBlock
]

{ #category : #control }
TaskTimeControl >> controlTime [
	
	self computeTime.
	self computeTotalTimeErrors.
	self collectTimeErrors 
]

{ #category : #control }
TaskTimeControl >> controlTimeErrors: controlBlock [

	| time start |
	time := 0.
	timeErrors := OrderedCollection new.
	start := self events first.
	self events do: [ :stop |
		| delta |
		(self isFinishTaskWindowOpening: stop) ifTrue: [ ^ self ].
		delta := stop dateTime asSeconds - start dateTime asSeconds.
		time := time + (stop dateTime asSeconds - start dateTime asSeconds).
		delta >= threshold ifTrue: [
			controlBlock cull: delta cull: start cull: stop ].
		start := stop ]
]

{ #category : #accessing }
TaskTimeControl >> declaredIdleTime [

	^ declaredIdleTime
]

{ #category : #accessing }
TaskTimeControl >> declaredIdleTime: anObject [

	declaredIdleTime := anObject
]

{ #category : #accessing }
TaskTimeControl >> estimatedIdleTime [

	^ estimatedIdleTime
]

{ #category : #accessing }
TaskTimeControl >> estimatedIdleTime: anObject [

	estimatedIdleTime := anObject
]

{ #category : #control }
TaskTimeControl >> events [
	^taskStats events
]

{ #category : #initialization }
TaskTimeControl >> initialize [

	threshold := 60.
	retainedIdleTime := 0
]

{ #category : #control }
TaskTimeControl >> isFinishTaskWindowOpening: event [

	^ ((event isKindOf: DSWindowOpenedRecord) and: [
		   'Finish task *' match: event windowName asString ])
]

{ #category : #accessing }
TaskTimeControl >> retainedIdleTime [

	^ retainedIdleTime
]

{ #category : #accessing }
TaskTimeControl >> retainedIdleTime: anObject [

	retainedIdleTime := anObject
]

{ #category : #accessing }
TaskTimeControl >> taskDuration [

	^ taskDuration
]

{ #category : #accessing }
TaskTimeControl >> taskDuration: anObject [

	taskDuration := anObject
]

{ #category : #accessing }
TaskTimeControl >> taskStats [

	^ taskStats
]

{ #category : #accessing }
TaskTimeControl >> taskStats: anObject [

	taskStats := anObject
]

{ #category : #accessing }
TaskTimeControl >> threshold [

	^ threshold
]

{ #category : #accessing }
TaskTimeControl >> threshold: anObject [

	threshold := anObject
]

{ #category : #accessing }
TaskTimeControl >> timeErrors [

	^ timeErrors
]

{ #category : #accessing }
TaskTimeControl >> timeErrors: anObject [

	timeErrors := anObject
]
