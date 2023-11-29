Class {
	#name : #ParticipantResult,
	#superclass : #Object,
	#instVars : [
		'tasks',
		'participant',
		'controlScore',
		'treatmentScore',
		'rawData',
		'shouldCount'
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
	result rawData: aCollection.
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

	controlScore := tasks first correctness.
	treatmentScore := tasks last correctness.

	^ controlScore notNil and: [ treatmentScore notNil ]
]

{ #category : #'as yet unclassified' }
ParticipantResult >> dateStarted [
	^tasks first events first dateTime 
]

{ #category : #accessing }
ParticipantResult >> experience [
	^participant participantDeclaredExperience
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
		  str << (controlScore ifTrue:['1'] ifFalse:['0']).
		  str << ' | '.
		  str << (treatmentScore ifTrue:['1'] ifFalse:['0']) ]
]

{ #category : #accessing }
ParticipantResult >> rawData [

	^ rawData
]

{ #category : #accessing }
ParticipantResult >> rawData: anObject [

	rawData := anObject
]

{ #category : #accessing }
ParticipantResult >> shouldCount [

	^ shouldCount ifNil: [ shouldCount := true ]
]

{ #category : #accessing }
ParticipantResult >> shouldCount: anObject [

	shouldCount := anObject
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
