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
		'correctnessTest',
		'eventsHistory',
		'detectedInterruptions',
		'type',
		'isValid'
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

{ #category : #time }
PhexTaskResult >> computeTime [
	self halt
]

{ #category : #accessing }
PhexTaskResult >> correctness [

	^ correctness
]

{ #category : #accessing }
PhexTaskResult >> correctness: anObject [

	correctness := anObject
]

{ #category : #accessing }
PhexTaskResult >> correctnessTest [
	^ correctnessTest
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
	^time
]

{ #category : #accessing }
PhexTaskResult >> events [

	^ events
]

{ #category : #accessing }
PhexTaskResult >> events: anObject [

	events := anObject
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

{ #category : #'instance creation' }
PhexTaskResult >> fromDSEvents: evts [

	title := evts first task title.
	events := evts.
	eventsHistory := DSRecordHistory on: events.
	correctness := nil.
	answer := evts last task answer contents.
	time := evts last task endTime - evts last task startTime.
	correctnessTest := (evts
		                    detect: [ :evt |
		                    evt class = DSTaskSuccessRecord ]
		                    ifNone: [ nil ])
		                   ifNil: [ false ]
		                   ifNotNil: [ :e | e successBoolean ].

	self detectTimeInterruptions
]

{ #category : #'instance creation' }
PhexTaskResult >> fromTaskStats: aTaskStats [ 
	
	title := aTaskStats taskInfo title.
	events := aTaskStats events.	
	eventsHistory := DSRecordHistory on: events.
	correctness := aTaskStats correctness.
	answer := aTaskStats answer contents.
	time := aTaskStats rawDuration.
	correctnessTest := aTaskStats testSuccess.
	
	self detectTimeInterruptions.
	
	
]

{ #category : #time }
PhexTaskResult >> hasUncheckedInterruptions [

	^ detectedInterruptions anySatisfy: [ :d | d decision isNil ]
]

{ #category : #testing }
PhexTaskResult >> isValid [

	^ isValid ifNil: [
		  isValid := type = #control or: [
			             eventsHistory breakpointEvents anySatisfy: [ :bp |
				             bp objectCentric ] ] ]
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

	^ time
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
