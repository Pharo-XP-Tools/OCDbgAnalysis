"
I hold a Phex experiment results and provide API to explore them. 
"
Class {
	#name : #ExperimentResults,
	#superclass : #Object,
	#instVars : [
		'participations',
		'controls',
		'treatments',
		'participantsExperience'
	],
	#classInstVars : [
		'dataCache',
		'current'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #spec }
ExperimentResults class >> browse [
	<script>

	(OCREDataAnalysisPresenter on: self current) open
]

{ #category : #cache }
ExperimentResults class >> cache: aPhexParticipation [

	self dataCache at: aPhexParticipation id put: aPhexParticipation.
	^aPhexParticipation
]

{ #category : #private }
ExperimentResults class >> cleanCache [

	<script>
	dataCache := nil.
	current := nil
]

{ #category : #'instance creation' }
ExperimentResults class >> current [

	^ current ifNil:[current := self new]
]

{ #category : #'instance creation' }
ExperimentResults class >> current: anObject [
	current := anObject
]

{ #category : #cache }
ExperimentResults class >> dataCache [

	^ dataCache ifNil: [ dataCache := Dictionary new ]
]

{ #category : #cache }
ExperimentResults class >> isCached: aString [ 
	^self dataCache keys includes: aString
]

{ #category : #'instance creation' }
ExperimentResults class >> materializeFromSTON [
	^self replaceWith: (STON fromString: 'data.ston' asFileReference contents)
]

{ #category : #'instance creation' }
ExperimentResults class >> on: anExperimentResultsExtractor [

	^self new
		  participations:
			  (anExperimentResultsExtractor participantResults collect: [ :p |
					   self cache: (PhexParticipation fromParticipantResult: p) ]);
		  yourself
]

{ #category : #'instance creation' }
ExperimentResults class >> replaceWith: anExperiment [

	self cleanCache.
	current := anExperiment.
	current participations do: [ :p | self cache: p ]
]

{ #category : #'data analysis' }
ExperimentResults >> buildTaskResults [
	

	self collectTasksForAnalysis.	
	^controls keys collect: [ :taskName|  
		|taskResult|		
		taskResult := TasksResults new.
		taskResult name: taskName.
		taskResult controlData: ((controls at: taskName) collect:[:t| t duration]).
		taskResult treatmentData: ((treatments at: taskName) collect:[:t| t duration]).
		taskResult ratio: ((taskResult controlAvg / taskResult treatmentAvg) asFloat truncateTo: 0.000001).	
		taskResult averageDebuggingActionsCount: 
			{(controls at: taskName) collect: [:next| next countDebugActions ].  
			(treatments at: taskName) collect: [:next| next countDebugActions ]}]
	

]

{ #category : #'data analysis' }
ExperimentResults >> collectDeveloperExperience [

	participantsExperience := OrderedCollection new.

	((participations select: [ :p | p demographicSurvey notNil ])
		 collect: [ :p | p demographicSurvey ]) do: [ :survey |
		| xp |
		xp := survey answers
			      detect: [ :a |
				      a question
				      =
				      'How many years of programming experience do you have with Pharo?' ]
			      ifNone: [ nil ].
		xp ifNotNil: [ participantsExperience add: xp answer ] ]
]

{ #category : #'data extraction' }
ExperimentResults >> collectTasksForAnalysis [

	controls := ((participations collect: [ :p | p control ]) select: [
		             :t | t notNil ]) groupedBy: [ :t | t title ].
	treatments := ((participations collect: [ :p | p treatment ])
		               select: [ :t | t notNil ]) groupedBy: [ :t | t title ]
]

{ #category : #'data extraction' }
ExperimentResults >> convertSurveyAnswersToDictionary: aPhexSurveyResult [

	| dict |
	dict := Dictionary new.
	aPhexSurveyResult answers do: [ :a |
		dict at: a question put: a answer ].
	^ dict
]

{ #category : #'data extraction' }
ExperimentResults >> convertSurveysToCSV [

	| csvs experimentFeedback demographicSurvey controlTasks treatmentTasks ammoliteControlSurveys ammoliteTreatmentSurveys lightsOutControlSurveys lightsOutTreatmentSurveys|
	csvs := Dictionary new.
	experimentFeedback := (self participations collect: [ :p |
		                       p experimentFeedback -> p id ]) reject: [
		                      :e | e key isNil ].

	demographicSurvey := (self participations collect: [ :p |
		                      p demographicSurvey -> p id ]) reject: [ :e |
		                     e key isNil ].
	
	controlTasks := (self participations collect: [ :p |
		                      p controlTask -> p id ]) reject: [ :e |
		                     e key isNil ].	
	ammoliteControlSurveys := ((controlTasks select:[:t| t key title = 'Ammolite' ]) collect:[:t| t key survey -> t value]) reject:[:assoc| assoc key isNil].
	lightsOutControlSurveys := ((controlTasks select:[:t| t key title = 'Lights Out' ]) collect:[:t| t key survey -> t value]) reject:[:assoc| assoc key isNil].
	
	
	treatmentTasks := (self participations collect: [ :p |
		                      p treatmentTask -> p id ]) reject: [ :e |
		                     e key isNil ].
	ammoliteTreatmentSurveys := ((treatmentTasks select:[:t| t key title = 'Ammolite' ]) collect:[:t| t key survey -> t value]) reject:[:assoc| assoc key isNil]..
	lightsOutTreatmentSurveys := ((treatmentTasks select:[:t| t key title = 'Lights Out' ]) collect:[:t| t key survey -> t value]) reject:[:assoc| assoc key isNil]..
	
	csvs at: 'ammolite-control.csv' put: (self convertSurveysToCSV: ammoliteControlSurveys).
	csvs at: 'lightsout-control.csv' put: (self convertSurveysToCSV: lightsOutControlSurveys).
	csvs at: 'ammolite-treatment.csv' put: (self convertSurveysToCSV: ammoliteTreatmentSurveys).
	csvs at: 'lightsout-treatment.csv' put: (self convertSurveysToCSV: lightsOutTreatmentSurveys).	
	csvs at: 'experiment-feedback.csv' put: (self convertSurveysToCSV: experimentFeedback).
	csvs at: 'demographic-information.csv' put: (self convertSurveysToCSV: experimentFeedback).
	
	csvs keysAndValuesDo: [ :filename :data|
		filename asFileReference writeStream nextPutAll: data; close ]
]

{ #category : #'data extraction' }
ExperimentResults >> convertSurveysToCSV: surveys [

	| dicts questions csv |
	dicts := surveys collect: [ :s |
		         (self convertSurveyAnswersToDictionary: s key) -> s value ].
	questions := dicts first key keys.
	csv := String streamContents: [ :str |
		       str << 'participant'.
		       str << ';'.
		       questions do: [ :q |
			       str << q.
			       q = questions last ifFalse: [ str << ';' ] ].
		       str cr.

		       dicts do: [ :d |
			       | uuid dict |
			       uuid := d value.
			       dict := d key.
			       str << uuid.
			       str << ';'.
			       questions do: [ :q |
				       str << (dict at: q).
				       q = questions last ifFalse: [ str << ';' ] ].
			       str cr ] ].
	^ csv
]

{ #category : #'data extraction' }
ExperimentResults >> extractContactInformation [

	| infos dict |
	infos := (self participations collect: [ :p | p contactInfo ])
		         reject: [ :e | e isNil ].

	dict := Dictionary new.
	infos do: [ :info |
		info answers do: [ :a |
			(#( 'If you would participate in a more detailed interview, please add your e-mail'
			    'If you would be informed about the results of this work, please add your e-mail' )
				 includes: a question) ifTrue: [
				(dict at: a question ifAbsentPut: [ OrderedCollection new ]) add:
					a answer.
				a answer: nil ] ] ].

	dict inspect
]

{ #category : #initialization }
ExperimentResults >> initialize [
	participations := OrderedCollection new
]

{ #category : #accessing }
ExperimentResults >> participations [

	^ participations ifNil:[participations := OrderedCollection new]
]

{ #category : #accessing }
ExperimentResults >> participations: anObject [

	participations := anObject
]
