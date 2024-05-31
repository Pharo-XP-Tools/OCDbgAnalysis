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
	"self halt.
	
	(aCollection add: (STON fromString: 'DSEndingTaskRecord{#dateTime:DateAndTime[''2024-04-05T16:48:01.180363+02:00''],#uuid:UUID[''fa026fdaecd30d00b3a77bcf0ce474f2''],#task:PhexTask{#order:4,#uuid:UUID[''8340c88e0cb50d008c3841dd0fe087f2''],#title:''Ammolite'',#description:''# Ammolite\r\r## The application\r\rAmmolite Magenta is a graphical application that can be launched via `AmmoliteMagenta class >> #run` (click on it).\r\r* Run the application by executing this method (clic on the play button near the method name).\r\rYou should see the following application:\r\r![Ammolite](https://raw.githubusercontent.com/Pharo-XP-Tools/xp-free-resources/main/ocd/ammolite.png)\r\rIts purpose is to create from a class/promotion, well balanced groups of students depending on their levels.\r\rTo represent the level, each student has a marker depending on how they perform during exams compared to average :\r- ""+"" when the level is above\r- ""-"" when the level is lower\r- nil otherwise.\r\rTo create groups, the user has to select a class/promotion and click onto the ""generate"" button.\rThe app the shows the result:\r\r![Ammolite groups](https://raw.githubusercontent.com/Pharo-XP-Tools/xp-free-resources/main/ocd/ammolite-groups.png)\r\r## The Problem\r\rThere is three student named Adèle with a ""+"" marker. However, for one of them, the marker is not printed in group lists.\r\r![Ammolite groups bug](https://raw.githubusercontent.com/Pharo-XP-Tools/xp-free-resources/main/ocd/ammolite-groups-bug.png)\r\rOnly the last Adèle in the list of students produces such behavior.\r\r## Your task\r\r1. Understand why the level marker of this student is not printed in group lists.\r2. Fix the bug. Identify the method reponsible for this behavior and fix the correct instruction.\r\rTo help you, you can inspect any student in the list by performing a right-click on it. This action will open an inspector on that student.\r'',#contents:''# Ammolite\r\r## The application\r\rAmmolite Magenta is a graphical application that can be launched via `AmmoliteMagenta class >> #run` (click on it).\r\r* Run the application by executing this method (clic on the play button near the method name).\r\rYou should see the following application:\r\r![Ammolite](https://raw.githubusercontent.com/Pharo-XP-Tools/xp-free-resources/main/ocd/ammolite.png)\r\rIts purpose is to create from a class/promotion, well balanced groups of students depending on their levels.\r\rTo represent the level, each student has a marker depending on how they perform during exams compared to average :\r- ""+"" when the level is above\r- ""-"" when the level is lower\r- nil otherwise.\r\rTo create groups, the user has to select a class/promotion and click onto the ""generate"" button.\rThe app the shows the result:\r\r![Ammolite groups](https://raw.githubusercontent.com/Pharo-XP-Tools/xp-free-resources/main/ocd/ammolite-groups.png)\r\r## The Problem\r\rThere is three student named Adèle with a ""+"" marker. However, for one of them, the marker is not printed in group lists.\r\r![Ammolite groups bug](https://raw.githubusercontent.com/Pharo-XP-Tools/xp-free-resources/main/ocd/ammolite-groups-bug.png)\r\rOnly the last Adèle in the list of students produces such behavior.\r\r## Your task\r\r1. Understand why the level marker of this student is not printed in group lists.\r2. Fix the bug. Identify the method reponsible for this behavior and fix the correct instruction.\r\rTo help you, you can inspect any student in the list by performing a right-click on it. This action will open an inspector on that student.\r'',#started:true,#finished:false,#answer:''Additional space in data string makes its way via bad parsing into the marker instvar.\rDisplay code compares with two strings \''+\'' and \''-\'' so it takes the same code path as if the marker was nil '',#requiresAnswer:true,#requiredAnswer:''Explain why the level marker of the last student named Adèle is not displayed in group lists, and how you fixed that.'',#endTime:@2,#startTime:DateAndTime[''2024-04-05T16:19:59.599021+02:00''],#passed:false,#survey:UUID[''bde9c78e0cb50d008c328a060fe087f2'']}}') beforeIndex: 8216)"
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
