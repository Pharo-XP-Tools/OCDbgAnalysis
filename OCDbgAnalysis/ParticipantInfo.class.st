Class {
	#name : #ParticipantInfo,
	#superclass : #Object,
	#instVars : [
		'id',
		'startDateTime',
		'surveys'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
ParticipantInfo class >> neoJsonMapping: mapper [

	mapper for: self do: [ :mapping | 
		(mapping mapInstVar: #id) valueSchema: UUID.
		(mapping mapInstVar: #startDateTime) valueSchema: DateAndTime ].
	mapper for: UUID customDo: [ :mapping | 
		mapping decoder: [ :string | UUID fromString: string ].
		mapping encoder: [ :uuid | uuid printString ] ].
	mapper for: DateAndTime customDo: [ :mapping | 
		mapping decoder: [ :string | DateAndTime fromString: string ].
		mapping encoder: [ :dateAndTime | dateAndTime printString ] ]
]

{ #category : #comparing }
ParticipantInfo >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class == anObject class ifFalse: [ ^ false ].
	self startDateTime = anObject startDateTime ifFalse: [ ^ false ].
	^ self uuid = anObject uuid
]

{ #category : #accessing }
ParticipantInfo >> id [

	^ id
]

{ #category : #accessing }
ParticipantInfo >> id: anObject [

	id := anObject
]

{ #category : #accessing }
ParticipantInfo >> startDateTime [

	^ startDateTime
]

{ #category : #accessing }
ParticipantInfo >> startDateTime: anObject [

	startDateTime := anObject
]

{ #category : #accessing }
ParticipantInfo >> surveys [

	^ surveys
]

{ #category : #accessing }
ParticipantInfo >> surveys: anObject [

	surveys := anObject
]
