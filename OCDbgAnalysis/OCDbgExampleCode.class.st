Class {
	#name : #OCDbgExampleCode,
	#superclass : #Object,
	#classInstVars : [
		'exampleDataPath'
	],
	#category : #OCDbgAnalysis
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
	^ OCDbgEventFilters selectTasksEvents: taskUuid inCollection: events
]

{ #category : #'as yet unclassified' }
OCDbgExampleCode class >> loadDataFromPath: aString [
"Note that this method removes duplicated uuid"
	^ (((EREventTool default unpackAll: aString asFileReference) key 
		    collect: [ :e | e safeUnpackedData ]) flattened
		   asOrderedCollection sort: [ :a :b | a dateTime < b dateTime ])
		  ocdSelectUnique
	"'/Users/maxw/Documents/ocrex1pilot/User-a1eff302-b2a0-0d00-b9ea-48310c48fda453911402438000'"
]
