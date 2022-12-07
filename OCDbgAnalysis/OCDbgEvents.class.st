Class {
	#name : #OCDbgEvents,
	#superclass : #Object,
	#category : #'OCDbgAnalysis-Events'
}

{ #category : #'as yet unclassified' }
OCDbgEvents class >> findTaskEndIndexFor: aTaskUUID inCollection: aCollection startingAt: aNumber [

	aNumber to: aCollection size do: [ :i | 
		| ev |
		ev := aCollection at: i.
		(ev class = DSEndingTaskRecord and: [ ev task uuid = aTaskUUID ]) 
			ifTrue: [ ^ i ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> findTaskStartIndexFor: aTaskUUID inCollection: aCollection startingAt: aNumber [

	"This method assumes that aCollection is sorted by time"

	aNumber to: aCollection size do: [ :i | 
		| ev |
		ev := aCollection at: i.
		(ev class = DSStartTaskRecord and: [ ev task uuid = aTaskUUID ]) 
			ifTrue: [ ^ i ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> findWindowClosedtIndexFor: windowID inCollection: aCollection startingAt: aNumber [

	"This method assumes that aCollection is sorted by time"

	aNumber to: aCollection size do: [ :i | 
		| ev |
		ev := aCollection at: i.
		(ev class = DSWindowClosedRecord  and: [ ev windowId = windowID ]) 
			ifTrue: [ ^ i ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> findWindowOpenedtIndexFor: windowID inCollection: aCollection startingAt: aNumber [

	"This method assumes that aCollection is sorted by time"

	aNumber to: aCollection size do: [ :i | 
		| ev |
		ev := aCollection at: i.
		(ev class = DSWindowOpenedRecord  and: [ ev windowId = windowID ]) 
			ifTrue: [ ^ i ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> loadDataFromPath: aString [
"Note that this method removes duplicated uuid"
	^ (((EREventTool default unpackAll: aString asFileReference) key 
		    collect: [ :e | e safeUnpackedData ]) flattened
		   asOrderedCollection sort: [ :a :b | a dateTime < b dateTime ])
		  ocdSelectUnique
	"'/Users/maxw/Documents/ocrex1pilot/User-a1eff302-b2a0-0d00-b9ea-48310c48fda453911402438000'"
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> selectBrowseContext: aCollection [

	^ aCollection select: [ :each | each class = DSBrowseContextRecord ]
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> selectFullBrowse: aCollection [

	^ aCollection select: [ :each | each class = DSFullBrowseRecord ]
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> selectTasksEnding: aCollection [

	^ aCollection select: [ :each | each class = DSEndingTaskRecord ]
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> selectTasksEvents: aTaskUUID inCollection: aCollection [

	| taskStartIndex taskEndingIndex |
	"This method assumes that aCollection is sorted by time"
	taskStartIndex := self
		                  findTaskStartIndexFor: aTaskUUID
		                  inCollection: aCollection
		                  startingAt: 1.
	taskEndingIndex := self
		                   findTaskEndIndexFor: aTaskUUID
		                   inCollection: aCollection
		                   startingAt: taskStartIndex.

	^ aCollection copyFrom: taskStartIndex to: taskEndingIndex
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> selectTasksStarts: aCollection [

^ aCollection select: [ :each| each class=DSStartTaskRecord]
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> selectUnique: aCollection [

	| rememberedIDs newCollection |
	newCollection := OrderedCollection new.
	rememberedIDs := Set new.
	aCollection do: [ :each | 
		(rememberedIDs includes: each uuid) ifFalse: [ 
			rememberedIDs add: each uuid.
			newCollection add: each ] ].
	^ newCollection
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> selectWindowClosed: aCollection [

	^ aCollection select: [ :each | each class = DSWindowClosedRecord  ]
]

{ #category : #'as yet unclassified' }
OCDbgEvents class >> selectWindowOpened: aCollection [

	^ aCollection select: [ :each | each class = DSWindowOpenedRecord ]
]
