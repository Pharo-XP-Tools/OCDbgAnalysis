"
I represent the collected and computed data about aPhex task
"
Class {
	#name : #PhexTaskResult,
	#superclass : #Object,
	#instVars : [
		'title',
		'events',
		'time',
		'survey',
		'correctness',
		'declaredInterruptionTime',
		'answer',
		'eventsHistory',
		'detectedInterruptions',
		'type',
		'validity'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #'instance creation' }
PhexTaskResult class >> from: aTaskStats [ 
	^self new fromTaskStats: aTaskStats 
]

{ #category : #accessing }
PhexTaskResult >> answer [
	^ answer
]

{ #category : #initialization }
PhexTaskResult >> beControl [
	type := #control
]

{ #category : #initialization }
PhexTaskResult >> beTreatment [
	type := #treatment
]

{ #category : #accessing }
PhexTaskResult >> calculateInterruptionTimes [

	^(detectedInterruptions inject: 0 into: [:sum :next| sum + next computedIdleTime asSeconds]) asSeconds

]

{ #category : #accessing }
PhexTaskResult >> correctness [

	^ correctness isCorrect
]

{ #category : #accessing }
PhexTaskResult >> correctness: anObject [

	correctness := correctness isCorrect: true
]

{ #category : #accessing }
PhexTaskResult >> correctnessComment [

	^correctness comment
]

{ #category : #accessing }
PhexTaskResult >> correctnessComment: aString [

	correctness comment: aString
]

{ #category : #accessing }
PhexTaskResult >> correctnessTest [
	^ correctness correctnessTest
]

{ #category : #time }
PhexTaskResult >> countDebugActions [
	^eventsHistory countDebugActions 
]

{ #category : #accessing }
PhexTaskResult >> declaredInterruptionTime [

	^ declaredInterruptionTime
]

{ #category : #accessing }
PhexTaskResult >> declaredInterruptionTime: anObject [

	declaredInterruptionTime := anObject
]

{ #category : #time }
PhexTaskResult >> detectTimeInterruptions [

	detectedInterruptions := eventsHistory collectTimeDiscrepancies
		                         collect: [ :association |
			                         | control |
			                         control := IdleTimeControl new.
			                         control events: association key last.
			                         control timeGapStartEvent:
				                         association key second.
			                         control timeGapStopEvent:
				                         association key first.
			                         control computedIdleTime:
				                         association value.
			                         control ]
]

{ #category : #time }
PhexTaskResult >> detectedInterruptions [
	^detectedInterruptions
]

{ #category : #accessing }
PhexTaskResult >> duration [
	^self time
]

{ #category : #accessing }
PhexTaskResult >> events [

	^ events
]

{ #category : #accessing }
PhexTaskResult >> events: anObject [

	events := anObject
]

{ #category : #accessing }
PhexTaskResult >> eventsHistory [
	^ eventsHistory
]

{ #category : #time }
PhexTaskResult >> findDeclaredInterruptionTime [

	| declaration |
	declaredInterruptionTime := 'undeclared'.
	survey ifNil: [ ^ self ].
	declaration := survey answers
		               detect: [ :a |
		               a question = 'How long have you been interrupted?' ]
		               ifNone: [ ^ self ].
	declaredInterruptionTime := declaration answer
]

{ #category : #testing }
PhexTaskResult >> forceValidity: aBoolean [

	validity isValid: aBoolean
]

{ #category : #'instance creation' }
PhexTaskResult >> fromDSEvents: evts [

	title := evts first task title.
	events := evts.
	eventsHistory := DSRecordHistory on: events.
	correctness := PhexTaskCorrectness onTaskResult: self.
	answer := evts last task answer contents.
	time := evts last task endTime - evts last task startTime.	
	self detectTimeInterruptions
]

{ #category : #'instance creation' }
PhexTaskResult >> fromTaskStats: aTaskStats [

	title := aTaskStats taskInfo title.
	events := aTaskStats events.
	eventsHistory := DSRecordHistory on: events.
	correctness := (PhexTaskCorrectness onTaskResult: self)
		               isCorrect: aTaskStats correctness;
		               correctnessTest: aTaskStats testSuccess;
		               yourself.
	answer := aTaskStats answer contents.
	time := aTaskStats rawDuration.

	self detectTimeInterruptions
]

{ #category : #time }
PhexTaskResult >> hasUncheckedInterruptions [

	^ detectedInterruptions anySatisfy: [ :d | d decision isNil ]
]

{ #category : #initialization }
PhexTaskResult >> initialize [
	super initialize.
	validity := PhexTaskValidity onTaskResult: self
]

{ #category : #testing }
PhexTaskResult >> isValid [

	^ validity isValid
]

{ #category : #accessing }
PhexTaskResult >> retainedIdleTime [

	^ ((detectedInterruptions select: [ :e |
		    e decision notNil and: [ e decision ] ])
		   inject: 0
		   into: [ :sum :next | sum + next computedIdleTime asSeconds ])
		  asSeconds
]

{ #category : #accessing }
PhexTaskResult >> survey [

	^ survey
]

{ #category : #accessing }
PhexTaskResult >> survey: anObject [

	survey := anObject
]

{ #category : #accessing }
PhexTaskResult >> time [
	^ time - self retainedIdleTime
]

{ #category : #accessing }
PhexTaskResult >> time: anObject [

	time := anObject
]

{ #category : #accessing }
PhexTaskResult >> title [

	^ title
]

{ #category : #accessing }
PhexTaskResult >> title: anObject [

	title := anObject
]

{ #category : #accessing }
PhexTaskResult >> type [
	^ type
]

{ #category : #testing }
PhexTaskResult >> validityComment [

	^ validity comment
]

{ #category : #testing }
PhexTaskResult >> validityComment: aString [

	 validity comment: aString
]
