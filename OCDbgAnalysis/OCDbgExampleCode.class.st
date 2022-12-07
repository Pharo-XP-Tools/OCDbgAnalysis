Class {
	#name : #OCDbgExampleCode,
	#superclass : #Object,
	#classInstVars : [
		'exampleDataPath'
	],
	#category : #'OCDbgAnalysis-Events'
}

{ #category : #accessing }
OCDbgExampleCode class >> exampleDataPath [

	^ exampleDataPath
]

{ #category : #accessing }
OCDbgExampleCode class >> exampleDataPath: anObject [

	exampleDataPath := anObject
]

{ #category : #'as yet unclassified' }
OCDbgExampleCode class >> listEventsForATaskExample [

	| startedTasks events taskUuid |
	"list all events"
	events := self loadDataFromPath: exampleDataPath.
	"list all task started events, and collect only the tasks"
	startedTasks := events ocdSelectTasksStarting collect: [ :e | e task ].
	"Find the task uuid of the tutorial"
	taskUuid := (startedTasks detect: [ :t | t title = 'Tutorial' ]) uuid.
	^ OCDbgEvents selectTasksEvents: taskUuid inCollection: events
]

{ #category : #'as yet unclassified' }
OCDbgExampleCode class >> loadDataFromPath: aString [

	^ OCDbgEvents loadDataFromPath: aString
]
