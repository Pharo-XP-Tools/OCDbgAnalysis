Class {
	#name : #ParticipantResult,
	#superclass : #Object,
	#instVars : [
		'tasks',
		'participant',
		'controlScore',
		'treatmentScore'
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
ParticipantResult >> controlScore [

	^ controlScore
]

{ #category : #accessing }
ParticipantResult >> controlScore: anObject [

	controlScore := anObject
]

{ #category : #'as yet unclassified' }
ParticipantResult >> controlTaskInfos [

	| task str |
	task := tasks first.
	({ 'Lights Out'. 'Ammolite' } includes: task taskInfo title) 
		ifFalse: [ ^ 'No data' ].
	str := WriteStream on: String new.
	str << '('.
	str << task taskInfo title.
	str << ')'.
	str space.
	str << task duration printString.
	^ str contents
]

{ #category : #testing }
ParticipantResult >> dataChecked [
	^controlScore notNil and:[treatmentScore notNil]
]

{ #category : #testing }
ParticipantResult >> isParticipationValid [

	^ (#( 'Lights Out' 'Ammolite' ) includes: tasks last taskInfo title)
		  and: [ tasks last isValid ]
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

{ #category : #printing }
ParticipantResult >> printCorrectness [

	^ String streamContents: [ :str |
		  str << controlScore printString.
		  str << ':'.
		  str << treatmentScore printString ]
]

{ #category : #accessing }
ParticipantResult >> tasks [

	^ tasks
]

{ #category : #accessing }
ParticipantResult >> tasks: anObject [

	tasks := anObject
]

{ #category : #accessing }
ParticipantResult >> treatmentScore [

	^ treatmentScore
]

{ #category : #accessing }
ParticipantResult >> treatmentScore: anObject [

	treatmentScore := anObject
]

{ #category : #'as yet unclassified' }
ParticipantResult >> treatmentTaskInfos [

	| task str |
	task := tasks last.
	({ 'Lights Out'. 'Ammolite' } includes: task taskInfo title) 
		ifFalse: [ ^ 'No data' ].
	str := WriteStream on: String new.
	str << '('.
	str << task taskInfo title.
	str << ')'.
	str space.
	str << task duration printString.
	^ str contents
]
