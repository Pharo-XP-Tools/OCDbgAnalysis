Class {
	#name : #ParticipantResult,
	#superclass : #Object,
	#instVars : [
		'tasks',
		'participant'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
ParticipantResult class >> neoJsonMapping: mapper [
	mapper for: self do: [ :mapping |
		mapping mapInstVars: #(tasks participant)]
]

{ #category : #'instance creation' }
ParticipantResult class >> newFromData: aCollection [

	| result dstasks taskStats |
	result := self new.
	dstasks := aCollection ocdSelectTasksEnding collect: [ :e | e task ].
	taskStats := dstasks collect: [ :dst | 
		             TaskStats newForTask: dst fromData: aCollection ].
	result tasks: taskStats.
	result participant: ParticipantInfo new.
	^ result
]

{ #category : #'instance creation' }
ParticipantResult class >> newFromData: aCollection withUserID: userId [

	| result dstasks taskStats |
	result := self new.
	dstasks := aCollection ocdSelectTasksEnding collect: [ :e | e task ].
	taskStats := dstasks collect: [ :dst | 
		             TaskStats newForTask: dst fromData: aCollection ].
	result tasks: taskStats.
	result participant: (ParticipantInfo new
			 id: userId;
			 yourself).

	^ result
]

{ #category : #'as yet unclassified' }
ParticipantResult class >> resultsCollectionFromFiles: aCollection [

	| allParticipantsResult |
	allParticipantsResult := OrderedCollection new.
	aCollection do: [ :filePathString | 
		allParticipantsResult add:
			(self newFromData: (OCDbgEvents loadDataFromPath: filePathString)).
		self flag: 'add gc collect here if needed' ].
	^ allParticipantsResult
]

{ #category : #comparing }
ParticipantResult >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class == anObject class ifFalse: [ ^ false ].
	self participant = anObject participant ifFalse: [ ^ false ].
	^ self tasks = anObject tasks
]

{ #category : #accessing }
ParticipantResult >> ocBreakpointsAdded [
	^participant ocBreakpointsAdded 
]

{ #category : #accessing }
ParticipantResult >> participant [

	^ participant
]

{ #category : #accessing }
ParticipantResult >> participant: anObject [

	participant := anObject
]

{ #category : #accessing }
ParticipantResult >> tasks [

	^ tasks
]

{ #category : #accessing }
ParticipantResult >> tasks: anObject [

	tasks := anObject
]
