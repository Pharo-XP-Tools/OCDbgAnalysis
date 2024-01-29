Class {
	#name : #ParticipantInfo,
	#superclass : #Object,
	#instVars : [
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
	^true
]

{ #category : #'as yet unclassified' }
ParticipantInfo >> participantDeclaredExperience [

	| demographicSurvey |
	demographicSurvey := surveys
		                     detect: [ :s |
		                     s survey title = 'Demographic information' ]
		                     ifNone: [ nil ].
	demographicSurvey ifNotNil: [ :s |
		| xp |
		xp := s survey answers
			      detect: [ :a |
				      a title
				      =
				      'How many years of programming experience do you have with Pharo?' ]
			      ifNone: [ nil ].
		xp ifNotNil: [
			^ [
			  | ans val |
			
			  ans := xp answer answer.
			  ans = '< 1' ifTrue: [ val := 1 ].
			  ans = '1-2 years' ifTrue: [ val := 2 ].
			  ans = '3-5 years' ifTrue: [ val := 3 ].
			  ans = '6-10 years' ifTrue: [ val := 4 ].
			  ans = 'More than 10' ifTrue: [ val := 5 ].
			  val ifNil: [ -1 ] ]
				  on: Error
				  do: [ -1 ] ] ].
	^ -1
]

{ #category : #'as yet unclassified' }
ParticipantInfo >> participantDeclaredExperienceLabels [

	| demographicSurvey |
	demographicSurvey := surveys
		                     detect: [ :s |
		                     s survey title = 'Demographic information' ]
		                     ifNone: [ nil ].
	demographicSurvey ifNotNil: [ :s |
		| xp |
		xp := s survey answers
			      detect: [ :a |
				      a title
				      =
				      'How many years of programming experience do you have with Pharo?' ]
			      ifNone: [ nil ].
		xp ifNotNil: [
			^ [ xp answer answer ]
				  on: Error
				  do: [ -1 ] ] ].
	^ 'None'
]

{ #category : #accessing }
ParticipantInfo >> surveys [

	^ surveys
]

{ #category : #accessing }
ParticipantInfo >> surveys: anObject [

	surveys := anObject
]
