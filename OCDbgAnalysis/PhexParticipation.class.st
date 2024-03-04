"
I hold the data of a participation to a Phex Experiment
"
Class {
	#name : #PhexParticipation,
	#superclass : #Object,
	#instVars : [
		'id',
		'events',
		'controlTask',
		'treatmentTask',
		'agreement',
		'experimentFeedback',
		'demographicSurvey',
		'contactInfo',
		'shortId'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #'instance creation' }
PhexParticipation class >> fromParticipantResult: aParticipantResult [
	|participation|
	participation := self new.
	participation buildFrom: aParticipantResult.
	^participation
]

{ #category : #building }
PhexParticipation >> buildFrom: aParticipantResult [

	| surveys postTaskSurveys |
	id := aParticipantResult id.
	events := aParticipantResult rawData.
	surveys := aParticipantResult participant surveys collect: [ :s | PhexSurveyResult from: s ].
	
	aParticipantResult tasks ifNotEmpty:[
		controlTask := PhexTaskResult from: aParticipantResult tasks first.
		controlTask beControl.			
		treatmentTask := (aParticipantResult tasks size = 4) 
			ifTrue:[PhexTaskResult from: aParticipantResult tasks last] 
			ifFalse:[nil]].
	treatmentTask ifNotNil:[:t| t beTreatment].

	postTaskSurveys := 
		(surveys select: [ :s |  s title = 'Post-task survey' ]) 
			sort: [ :s1 :s2 | s1 dateTime < s2 dateTime ].
	postTaskSurveys size = 2 ifTrue: [
		controlTask survey: postTaskSurveys first.
		treatmentTask survey: postTaskSurveys second ].
	postTaskSurveys do: [ :s | surveys remove: s ].

	controlTask ifNotNil:[:c| c findDeclaredInterruptionTime].
	treatmentTask ifNotNil:[:t| t findDeclaredInterruptionTime].

	agreement := surveys detect:[:s|  s title = 'Experiment introduction and data policy.'] ifNone:[nil].
	experimentFeedback := surveys detect:[:s|  s title = 'Experiment Feedback (Perceived usefulness, Ease of Use, and self prediction of future use)'] ifNone:[nil].
	demographicSurvey := surveys detect:[:s|  s title = 'Demographic information'] ifNone:[nil].
	contactInfo := surveys detect:[:s|  s answers size = 4] ifNone:[nil]
]

{ #category : #building }
PhexParticipation >> buildFromTimeOrderedDSEventsArray: anArray [
	
	anArray size = 10 ifFalse:[self halt].	
	id := 'User-', (UUID new printString).
	
	events := anArray flattened.
	controlTask := PhexTaskResult new fromDSEvents: anArray second. 
	controlTask survey: (PhexSurveyResult from: anArray third first).
	controlTask beControl.				
		
	treatmentTask := PhexTaskResult new fromDSEvents: anArray sixth.
	treatmentTask survey: (PhexSurveyResult from: anArray seventh first).
	treatmentTask beTreatment.
	
	controlTask ifNotNil:[:c| c findDeclaredInterruptionTime].
	treatmentTask ifNotNil:[:t| t findDeclaredInterruptionTime].

	agreement := (PhexSurveyResult from: anArray first first).
	experimentFeedback :=  (PhexSurveyResult from: (anArray at: 9)  first).
	demographicSurvey :=  (PhexSurveyResult from: (anArray at: 8) first).
	contactInfo :=  (PhexSurveyResult from: anArray last first).
]

{ #category : #accessing }
PhexParticipation >> contactInfo [
	^ contactInfo
]

{ #category : #accessing }
PhexParticipation >> control [
	^controlTask 
]

{ #category : #accessing }
PhexParticipation >> controlTask [
	^ controlTask
]

{ #category : #'as yet unclassified' }
PhexParticipation >> controlTaskInfos [

	| str |
	controlTask ifNil: [ ^ 'No data' ].
	str := WriteStream on: String new.
	str << '('.
	str << controlTask title.
	str << ')'.
	str space.
	str << controlTask duration printString.
	^ str contents
]

{ #category : #'as yet unclassified' }
PhexParticipation >> dateStarted [
	^events first dateTime
]

{ #category : #accessing }
PhexParticipation >> demographicSurvey [
	^ demographicSurvey
]

{ #category : #accessing }
PhexParticipation >> events [
	^ events
]

{ #category : #'as yet unclassified' }
PhexParticipation >> eventsHistory [

	^ DSRecordHistory on: events
]

{ #category : #accessing }
PhexParticipation >> experimentFeedback [
	^ experimentFeedback
]

{ #category : #testing }
PhexParticipation >> hasValidDemographicSurvey [

	^ (self demographicSurvey isNil or: [
		   self demographicSurvey answers anySatisfy: [ :a |
			   a answer = 'No choice' ] ]) not
]

{ #category : #accessing }
PhexParticipation >> id [
	^ id
]

{ #category : #testing }
PhexParticipation >> isControlTaskValid [
	^controlTask notNil and:[controlTask isValid]
]

{ #category : #testing }
PhexParticipation >> isTreatmentTaskValid [

	^ treatmentTask notNil and: [ treatmentTask isValid ]
]

{ #category : #'as yet unclassified' }
PhexParticipation >> pharoExperience [

	| xp |
	demographicSurvey ifNil: [
		'nil demographic survey' crTrace.
		^ 0 ].
	xp := (demographicSurvey answers
		       detect: [ :a |
			       a question
			       =
			       'How many years of programming experience do you have with Pharo?' ]
		       ifNone: [ nil ]) ifNil: [ 0 ] ifNotNil: [ :a | a answer ].

	xp ifNotNil: [
		^ [
		  | val |
		  xp = '< 1' ifTrue: [ val := 1 ].
		  xp = '1-2 years' ifTrue: [ val := 2 ].
		  xp = '3-5 years' ifTrue: [ val := 3 ].
		  xp = '6-10 years' ifTrue: [ val := 4 ].
		  xp = 'More than 10' ifTrue: [ val := 5 ].
		  val ifNil: [ -1 ] ]
			  on: Error
			  do: [ -1 ] ].
	^ -1
]

{ #category : #accessing }
PhexParticipation >> shortId [
	^shortId ifNil:[shortId := 
		String streamContents: [ :str|
			str << (id readStream upTo: $-; upTo: $-; upTo: $-; upTo: $-; upTo: $-).
			str << '-'.
			str << self dateStarted asDate ddmmyyyy.
			str << '-'.			
			self dateStarted asTime print24: true on: str.
			 ]]
]

{ #category : #accessing }
PhexParticipation >> shortId: anUndefinedObject [ 
	shortId := anUndefinedObject
]

{ #category : #accessing }
PhexParticipation >> treatment [
	^treatmentTask 
]

{ #category : #accessing }
PhexParticipation >> treatmentTask [
	^ treatmentTask
]

{ #category : #accessing }
PhexParticipation >> treatmentTask: aPhexTaskResult [ 
	treatmentTask := aPhexTaskResult
]

{ #category : #'as yet unclassified' }
PhexParticipation >> treatmentTaskInfos [

	| str |
	treatmentTask ifNil: [ ^ 'No data' ].
	str := WriteStream on: String new.
	str << '('.
	str << treatmentTask title.
	str << ')'.
	str space.
	str << treatmentTask duration printString.
	^ str contents
]
