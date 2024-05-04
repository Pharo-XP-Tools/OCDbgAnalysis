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
		'participantsExperience',
		'analysisResults'
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
	

	self doTasksAnalysis.	
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
ExperimentResults >> collectDetailedDataMetricFor: data possibleTypes: possibleTypes dataType: dataType [
	"array first = control data, array second = treatment data"

	| typeDict |
	typeDict := Dictionary new.
	possibleTypes do: [ :t | typeDict at: t put: OrderedCollection new ].
	data do: [ :d |
		possibleTypes do: [ :type |
			(typeDict at: type) add: (d
					 at: type
					 ifPresent: [ :tdata |
						 PhexToolDataPoint new
							 rawData: tdata;
							 toolName: type;
							 dataType: dataType;
							 recompute ]
					 ifAbsent: [
						 PhexToolDataPoint new
							 toolName: type;
							 empty ]) ] ].
	^ typeDict
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

{ #category : #accessing }
ExperimentResults >> controls [

	^ controls ifNil: [ controls := OrderedCollection new ]
]

{ #category : #'data export' }
ExperimentResults >> convertSurveyAnswersToDictionary: aPhexSurveyResult [

	| dict |
	dict := Dictionary new.
	aPhexSurveyResult answers do: [ :a |
		dict at: a question put: a answer ].
	^ dict
]

{ #category : #'data export' }
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

{ #category : #'data export' }
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

{ #category : #'data export' }
ExperimentResults >> demographicSurveyCSVFormat [

	^ {
		  ('What is your highest achieved level of education?' -> 12).
		  ('What is you current job position?' -> 13).
		  ('How many years of programming experience do you have?' -> 14).
		  ('How many years of programming experience do you have with Pharo?'
		   -> 15).
		  ('How often do you write code?' -> 16).
		  ('How often do you write code in Pharo?' -> 17).
		  ('How much do you agree with the sentence: "I''m familiar with debugging"'
		   -> 18).
		  ('How much do you agree with the sentence: "I''m familiar with Object-Centric Debugging"'
		   -> 19) }
]

{ #category : #'data export' }
ExperimentResults >> demographicSurveySize [
	^8
]

{ #category : #'data analysis' }
ExperimentResults >> detailedToolAnalysisFor: aTaskDataArray named: title dataType: dataType [
	"array first = control data, array second = treatment data"

	| controlData treatmentData controlWindows treatmentWindows possibleTypes |
	controlData := aTaskDataArray first.
	treatmentData := aTaskDataArray second.

	controlWindows := controlData collect: [ :data |
		                  data eventsHistory filteredWindows groupedBy:
			                  #type ].
	treatmentWindows := treatmentData collect: [ :data |
		                    data eventsHistory filteredWindows groupedBy:
			                    #type ].

	possibleTypes := (controlWindows flattened collect: #type) asSet.
	possibleTypes addAll: (treatmentWindows flattened collect: #type).




	^ self
		  collectDetailedDataMetricFor: controlWindows
		  possibleTypes: possibleTypes
		  dataType: dataType
]

{ #category : #'data analysis' }
ExperimentResults >> doTasksAnalysis [
	
	"Ensure the history is correctly rebuilt"
	participations do: [ :p | 
		p == self class ifFalse:[
		self rebuildHistoryFor: p control.
		self rebuildHistoryFor: p treatment]].	
	
	"Collect tasks"	
	controls := ((participations collect: [ :p | p control ]) select: [
		             :t | t notNil and:[t isValid] ]) groupedBy: [ :t | t title ].
	treatments := ((participations collect: [ :p | p treatment ])
		               select: [ :t | t notNil and:[t isValid] ]) groupedBy: [ :t | t title ].
		
	
	"Analyze and cache results"
	analysisResults := Dictionary new.
	self doToolUsageAnalysis
]

{ #category : #'data analysis' }
ExperimentResults >> doToolUsageAnalysis [

	| taskList |
	taskList := controls keys.


	taskList do: [ :taskName |
		| time actions usage |
		time := self
			        detailedToolAnalysisFor: {
					        (controls at: taskName).
					        (treatments at: taskName) }
			        named: taskName
			        dataType: PhexToolTimeCalculator.

		actions := self
			           detailedToolAnalysisFor: {
					           (controls at: taskName).
					           (treatments at: taskName) }
			           named: taskName
			           dataType: PhexToolActionsCalculator.

		usage := self
			         detailedToolAnalysisFor: {
					         (controls at: taskName).
					         (treatments at: taskName) }
			         named: taskName
			         dataType: PhexToolUsageCalculator.
		time keysDo: [ :toolName |
			| toolUsageResults |
			toolUsageResults := PhexToolUsageResults new.
			toolUsageResults toolName: toolName.
			toolUsageResults timeDV: (PhexDependentVariable time: (time at: toolName)).
			toolUsageResults actionsDV:	(PhexDependentVariable actions: (actions at: toolName)).
			toolUsageResults occurencesDV:	(PhexDependentVariable usage: (usage at: toolName)).
			(analysisResults at: taskName ifAbsentPut: [ OrderedCollection new ]) 
																					add: toolUsageResults ] ]
]

{ #category : #'data export' }
ExperimentResults >> experimentFeedbackCSVFormat [

	^ {
		  ('"The Experiment was easy." How much do you agree?' -> 20).
		  ('"The Experiment was long." How much do you agree?' -> 21).
		  ('How much do you agree with: "OCDbg would enable me to accomplish debugging tasks more quickly"'
		   -> 22).
		  ('How much do you agree with: "OCDbg would improve my debugging performance"'
		   -> 23).
		  ('How much do you agree with: "OCDbg would increase my productivity"'
		   -> 24).
		  ('How much do you agree with: "OCDbg would increase my debugging effectiveness"'
		   -> 25).
		  ('How much do you agree with: "OCDbg would make it easier to debug the code"'
		   -> 26).
		  ('How much do you agree with: "I would find OCDbg useful"' -> 27).
		  ('How much do you agree with: "Learning to operate with OCDbg would be easy for me"'
		   -> 28).
		  ('How much do you agree with: "I would find it easy to get OCDbg to do what I want it to do, to track objects manipulations and locate the bug"'
		   -> 29).
		  ('How much do you agree with: "My interaction with OCDbg would be clear and understandable"'
		   -> 30).
		  ('How much do you agree with: "It would be easy for me to become skillful at using OCDbg"'
		   -> 31).
		  ('How much do you agree with: "It is easy to remember how to debug a code using OCDbg"'
		   -> 32).
		  ('How much do you agree with: "I would find OCDbg easy to use"'
		   -> 33).
		  ('How much do you agree with: "Assuming OCDbg would be available, I predict that I will use it in the future"'
		   -> 34).
		  ('How much do you agree with: " I would prefer OCDbg to the classic debugging system"'
		   -> 35) }
]

{ #category : #'data export' }
ExperimentResults >> experimentFeedbackSurveySize [
	^16
]

{ #category : #'data export' }
ExperimentResults >> exportParticipantDataToCSV [

	| format csvs out taskExport surveyExport fws |
	format := self hardCodedParticipantExportFormat.

	csvs := Dictionary new.
	out := WriteStream on: String new.
	taskExport := [ :col :task |
	              col add: task title.
	              col add: task correctness asString.
					  col add: task isValid. 				
					  col add: task time asSeconds.
	              col add: (task answer reject: [ :c | c = $; ]).
				 	  col add: task countDebugActions  ].

	surveyExport := [ :col :survey :csvFormat |
	                | dict |
	                dict := self convertSurveyAnswersToDictionary: survey.
	                (csvFormat collect: #key) do: [ :f |
		                col add: (dict at: f) ] ].

	self participations do: [ :p |
		| col |
		col := OrderedCollection new.
		col add: p id.
		p controlTask
			ifNil: [
				6 timesRepeat: [ col add: ' ' ].
				self postTaskSurveySize timesRepeat: [ col add: ' ' ] ]
			ifNotNil: [ :t |
				taskExport value: col value: t.
				p controlTask survey
					ifNil: [ self postTaskSurveySize timesRepeat: [ col add: ' ' ] ]
					ifNotNil: [ :s | surveyExport value: col value: s value: self postTaskCSVFormat] ].

		p treatmentTask
			ifNil: [
				6 timesRepeat: [ col add: ' ' ].
				self postTaskSurveySize timesRepeat: [ col add: ' ' ] ]
			ifNotNil: [ :t |
				taskExport value: col value: t.
				p treatmentTask survey
					ifNil: [ self postTaskSurveySize timesRepeat: [ col add: ' ' ] ]
					ifNotNil: [ :s | surveyExport value: col value: s value: self postTaskCSVFormat ] ].

		p experimentFeedback
			ifNil: [
			self experimentFeedbackSurveySize timesRepeat: [ col add: ' ' ] ]
			ifNotNil: [ :s | surveyExport value: col value: s value: self experimentFeedbackCSVFormat].

		p demographicSurvey
			ifNil: [ self demographicSurveySize timesRepeat: [ col add: ' ' ] ]
			ifNotNil: [ :s | surveyExport value: col value: s value: self demographicSurveyCSVFormat].

		csvs at: p id put: col ].
	
	fws := 'data.csv' asFileReference writeStream.
	(NeoCSVWriter on: fws)
		nextPut: format;
		nextPutAll: csvs values;
		close
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

{ #category : #'data export' }
ExperimentResults >> hardCodedParticipantExportFormat [
	^#('id' 'control task name' 'control task correctness' 'control task validity' 'control task time in seconds' 'control task answer' 'control task actions' 'ct-task-easiness' 'ct-task-length' 'ct-task-interruption' 'ct-bug-found' 'ct-bug-description' 'ct-debugger-help' 'ct-debugger-enjoy' 'ct-debugger-efficient' 'ct-debugger-intuitive' 'ct-debugger-easiness' 'ct-debugger-learn' 'treatment task name' 'treatment task correctness' 'treatment task validity' 'treatment task time in seconds' 'treatment task answer' 'treatment task actions' 'tt-task-easiness' 'tt-task-length' 'tt-task-interruption' 'tt-bug-found' 'tt-bug-description' 'tt-debugger-help' 'tt-debugger-enjoy' 'tt-debugger-efficient' 'tt-debugger-intuitive' 'tt-debugger-easiness' 'tt-debugger-learn' 'experiment-easiness' 'experiment-length' 'ocd-help' 'ocd-performance' 'ocd-productivity' 'ocd-effectiveness' 'ocd-easiness' 'ocd-usefulness' 'learn-ocd' 'ocd-tasks-help' 'ocd-interaction' 'ocd-skills' 'ocd-debugging' 'ocd-use' 'ocd-future' 'ocd-over-classical' 'education' 'job-position' 'program-exp' 'pharo-exp' 'code-frequency' 'pharo-frequency' 'debugger-familiarity' 'debugger-ocd-familarity' )
]

{ #category : #initialization }
ExperimentResults >> initialize [
	participations := OrderedCollection new
]

{ #category : #'data export' }
ExperimentResults >> participantExportFormat [
	|format|
	format := OrderedCollection new.
	format add: 'id'.
	format add: 'control task name'.
	format add: 'control task correctness'.
	format add: 'control task validity'.
	format add: 'control task time in seconds'.	
	format add: 'control task answer'.
	format add: 'control task actions'.	
	format addAll: (self postTaskCSVFormat collect: #value).
	
	format add: 'treatment task name'.
	format add: 'treatment task correctness'.
	format add: 'treatment task validity'.
	format add: 'treatment task time in seconds'.	
	format add: 'treatment task answer'.	
	format add: 'treatment task actions'.	
	format addAll: (self postTaskCSVFormat collect: #value).
	
	format addAll: (self experimentFeedbackCSVFormat collect: #value).
	format addAll: (self demographicSurveyCSVFormat collect: #value).
	^format
]

{ #category : #accessing }
ExperimentResults >> participations [

	^ participations ifNil:[participations := OrderedCollection new]
]

{ #category : #accessing }
ExperimentResults >> participations: anObject [

	participations := anObject
]

{ #category : #'data export' }
ExperimentResults >> postTaskCSVFormat [

	^ {
		  ('"The Task was easy." How much do you agree?' -> 1).
		  ('"The Task was long." How much do you agree?' -> 2).
		  ('How long have you been interrupted?' -> 3).
		  ('Did you find the bug?' -> 4).
		  ('If you found the bug, please describe it.' -> 5).
		  ('If you found the bug, how much the debugger helped discover the bug?'
		   -> 6).
		  ('If you found the bug, how much do you agree with: "The debugging method is enjoyable"'
		   -> 7).
		  ('If you found the bug, how much do you agree with: "The debugging method is efficient"'
		   -> 8).
		  ('If you found the bug, how much do you agree with: "The debugging method is intuitive"'
		   -> 9).
		  ('If you found the bug, how much do you agree with: "The debugging method is easy to use"'
		   -> 10).
		  ('If you found the bug, how much do you agree with: "The debugging method is asy to learn"'
		   -> 11) }
]

{ #category : #'data export' }
ExperimentResults >> postTaskSurveySize [
	^11
]

{ #category : #accessing }
ExperimentResults >> treatments [

	^ treatments ifNil: [ treatments := OrderedCollection new ]
]
