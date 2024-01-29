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
