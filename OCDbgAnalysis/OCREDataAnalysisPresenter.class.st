Class {
	#name : #OCREDataAnalysisPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tasksTable',
		'participantsTable',
		'experiment',
		'violins',
		'experience',
		'debugActions',
		'buttonBar',
		'progress',
		'participantsToolbar',
		'alternateDurationButton',
		'rawDurationButton',
		'dataDirs',
		'controlsViolins',
		'meansDebugActionBars',
		'meanTimesBars',
		'controlsMeanTimesBars',
		'controlsMeanDebugActionsBars'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #specs }
OCREDataAnalysisPresenter class >> defaultSpec [

		^ SpPanedLayout newLeftToRight
		  positionOfSlider: 50 percent;
		  add: (SpPanedLayout newTopToBottom
				   positionOfSlider: 25 percent;
				   add: #tasksTable;
				   add: #participantsTable;
				   yourself);
		  add: SpBoxLayout newTopToBottom;
		  yourself
]

{ #category : #'as yet unclassified' }
OCREDataAnalysisPresenter class >> plotMeansBarChartFor: participants [
	|validParticipants controlData treatmentData plot|
	validParticipants := participants select:[:p| p tasks size = 4].
	controlData := participants collect:[:p| p tasks first duration asSeconds].
	treatmentData := participants collect:[:p| p tasks last duration asSeconds].
	

	
	plot := (RSBarPlot barHeights: ({controlData. treatmentData} collect: #average))
		errors: (self basicNew confidenceIntervals: {controlData. treatmentData}).
	plot horizontalTick
		fromNames: #(Control Treatment).
"	plot verticalTick
		labelConversion: [ :val | val asFloat printShowingDecimalPlaces: 5 ]."
	plot title: 'Mean time (in min), 95% CI.'.
	(String streamContents:[:ws|	 controlData do:[:e| ws << e printString. ws cr ]]) inspect. 
	(String streamContents:[:ws|	 treatmentData do:[:e| ws << e printString. ws cr ]]) inspect.
	^plot
]

{ #category : #initialization }
OCREDataAnalysisPresenter >> buildParticipantsToolbar [

	participantsToolbar := self newToolbar.
	participantsToolbar addItem: (SpToolbarButtonPresenter new
			 label: 'Fix times';
			 icon: (self iconNamed: #history);
			 action: [ self fixTimes ];
			 yourself).
	participantsToolbar beIcons
]

{ #category : #actions }
OCREDataAnalysisPresenter >> checkData: aParticipantResult [

	(OCREParticipantValidationPresenter on: aParticipantResult)
		experimentResultsBrowser: self;
		open
]

{ #category : #actions }
OCREDataAnalysisPresenter >> chooseAndLoad [

	| f |
	f := FileDialogWindow onFileSystem: FileSystem disk.
	f openModal.

	f answer ifNotNil: [ :a |
		ExperimentResultsExtractor addDataDir: a asFileReference.
		dataDirs items: ExperimentResultsExtractor dataDirs ]
]

{ #category : #analysis }
OCREDataAnalysisPresenter >> confidenceIntervals: datas [

	^ datas collect: [ :data | 1.96 * (data stdev / data size sqrt) ]
]

{ #category : #specs }
OCREDataAnalysisPresenter >> correctnessColorFor: participant [

	(participant treatmentTask notNil and: [participant treatmentTask isValid]) ifFalse: [ ^ Color black ].

	({
		 participant controlTask correctness.
		 participant treatmentTask correctness } includes: nil) ifFalse: [
		^ Color blue darker ].


	^ Color red
]

{ #category : #analysis }
OCREDataAnalysisPresenter >> countParticipant: aParticipantResult [ 
	aParticipantResult shouldCount: true
]

{ #category : #specs }
OCREDataAnalysisPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: 50 percent;
				   add: dataDirs;
				   add: buttonBar)
				height: self class toolbarHeight + 5
		  "expand: false fill: false padding: 10";
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: 50 percent;
				   add: (SpPanedLayout newTopToBottom
						    positionOfSlider: 25 percent;
						    add: (SpBoxLayout newTopToBottom
								     add: 'Tasks' expand: false fill: false;
								     add: tasksTable;
								     yourself);
						    add: (SpBoxLayout newTopToBottom
								     add: (SpBoxLayout newLeftToRight
										      add: 'Participants' expand: false fill: false;
										      add:
											      experiment participations size printString
											      , ' participations'
										      expand: false
										      fill: false;
											   add: participantsToolbar height: 16;
										      yourself)
								     expand: false
								     fill: false
								     padding: 5;
								     add: participantsTable;
								     yourself);
						    yourself);
				   add: (SpPanedLayout newTopToBottom
						    positionOfSlider: 50 percent;
						    add: (SpBoxLayout newLeftToRight
								     add: violins;
									  add: meanTimesBars;
								     add: debugActions;								     
									  add: meansDebugActionBars;
								     yourself);
						    add: (SpBoxLayout newLeftToRight
								     add: controlsViolins;
								     add: controlsMeanTimesBars;
								     add: experience;
								     yourself);
						    yourself);
				   yourself);
		  yourself
]

{ #category : #analysis }
OCREDataAnalysisPresenter >> doAnalysis [
	experiment collectTasksForAnalysis.
	experiment collectDeveloperExperience
]

{ #category : #actions }
OCREDataAnalysisPresenter >> doAnalysisAndUpdate [
	self doAnalysis.
	self updateAllViews 
]

{ #category : #analysis }
OCREDataAnalysisPresenter >> dontCountParticipant: aParticipantResult [ 
	aParticipantResult shouldCount: false
]

{ #category : #actions }
OCREDataAnalysisPresenter >> fixTimes [

	| interruptions |
	interruptions := ((experiment participations collect: [ :p |
		                   {
			                   p controlTask.
			                   p treatmentTask } flattened ]) flattened
		                  reject: [ :t | t isNil ]) collect: [ :t |
		                 t declaredInterruptionTime
		                 -> t detectedInterruptions ].
	(OCREParticipantTimeFixerPresenter on: interruptions)
		experimentResultsBrowser: self;
		open
]

{ #category : #initialization }
OCREDataAnalysisPresenter >> initializePresenters [

	tasksTable := self newTable.
	tasksTable addColumn:
		((SpStringTableColumn title: 'Task' evaluated: [ :item | item name ])
			 sortFunction: nil;
			 yourself).
	tasksTable addColumn: ((SpStringTableColumn
			  title: 'Control average time'
			  evaluated: [ :item | item controlAvg printString ])
			 sortFunction: nil;
			 yourself).
	tasksTable addColumn: ((SpStringTableColumn
			  title: 'Treatment average time'
			  evaluated: [ :item | item treatmentAvg printString ])
			 sortFunction: nil;
			 yourself).
	tasksTable addColumn: ((SpStringTableColumn
			  title: 'Treatment/Control speed change'
			  evaluated: [ :item |
				  | stringValue |
				  stringValue := String
					                 streamContents: [ :str |
						                 item ratio > 0 ifTrue: [ str << '+' ].
						                 str << item ratio printString ]
					                 limitedTo: 6.
				  String streamContents: [ :str |
						  str << stringValue.
						  str << '%' ] ])
			 sortFunction: nil;
			 yourself).

	tasksTable items: experiment buildTaskResults.
	tasksTable transmitDo: [ :task | self plotChartsForTask: task ].


	participantsTable := self newTable.
	participantsTable contextMenu: self menu.
	"	participantsTable addColumn: ((SpCheckBoxTableColumn new
			  title: ' ';
			  evaluated: [ :item | item shouldCount ])
			 onActivation: [ :item | self countParticipant: item ];
			 onDeactivation: [ :item | self dontCountParticipant: item ];
			 width: 30;
			 yourself)."
	participantsTable addColumn:
		((SpStringTableColumn
			  title: 'Id'
			  evaluated: [ :item | item shortId ])
			 displayBackgroundColor: [ :p |
				 p hasValidDemographicSurvey
					 ifTrue: [ Color white ]
					 ifFalse: [ Color red ] ];
			 width: 150;
			 yourself).
	"participantsTable addColumn: ((SpStringTableColumn
			  title: 'XP Date'
			  evaluated: [ :item | item dateStarted asLocalStringYMDHM ])
				displayBackgroundColor:[:p| p hasValidDemographicSurvey ifTrue:[Color white] ifFalse:[Color red]];
			 width: 100;
			 yourself)."

	participantsTable addColumn:
		((SpImageTableColumn title: ' ' evaluated: [ :item |
				  item isControlTaskValid
					  ifTrue: [ self iconNamed: #testGreen ]
					  ifFalse: [ self iconNamed: #testRed ] ])
			 width: 16;
			 sortFunction: nil;
			 yourself).
	participantsTable addColumn: ((SpStringTableColumn
			  title: 'Control'
			  evaluated: [ :item | item controlTaskInfos ])
			 displayColor: [ :item |
				 item controlTask hasUncheckedInterruptions
					 ifTrue: [ Color red ]
					 ifFalse: [ Color black ] ];
			 sortFunction: nil;
			 yourself).






	participantsTable addColumn:
		((SpImageTableColumn title: ' ' evaluated: [ :item |
				  item isTreatmentTaskValid
					  ifTrue: [ self iconNamed: #testGreen ]
					  ifFalse: [ self iconNamed: #testRed ] ])
			 width: 16;
			 sortFunction: nil;
			 yourself).
	participantsTable addColumn: ((SpStringTableColumn
			  title: 'Treatment'
			  evaluated: [ :item | item treatmentTaskInfos ])
			 displayColor: [ :item |
				 (item treatmentTask notNil and: [
						  item treatmentTask hasUncheckedInterruptions ])
					 ifTrue: [ Color red ]
					 ifFalse: [ Color black ] ];
			 sortFunction: nil;
			 yourself).

	participantsTable addColumn: (OCDbgLinkTableColumn new
			 title: 'Correctness';
			 evaluated: [ :item | self printCorrectnessFor: item ];
			 action: [ :item | self checkData: item ];
			 displayColor: [ :item | self correctnessColorFor: item ];
			 width: 100;
			 yourself).

	"	participantsTable addColumn: ((OCDbgActionTableColumn title: 'Time check' 
		evaluated: [ :item | self iconNamed: #history ])
			action:[:p| self fixTime: p];
			 width: 40;
			 sortFunction: nil;
			 yourself)."

	participantsTable items: (experiment participations sort: [ :a :b |
			 a dateStarted > b dateStarted ]).

	violins := self newRoassal.
	debugActions := self newRoassal.
	meanTimesBars := self newRoassal.
	meansDebugActionBars := self newRoassal.
	controlsMeanTimesBars := self newRoassal.
	controlsMeanDebugActionsBars := self newRoassal.
	self plotExperienceBarChart.
	self plotControls.

	buttonBar := self newButtonBar.
	buttonBar
		placeAtStart;
		add: (self newButton
				 icon: (self application iconNamed: #references);
				 action: [ self openDiagrams ];
				 label: 'Diagrams';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #glamorousInspect);
				 action: [ experiment inspect ];
				 label: 'Inspect';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #smallDoIt);
				 action: [ self doAnalysisAndUpdate ];
				 label: 'Analyze';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #glamorousTable);
				 action: [ self reload ];
				 label: 'Load';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #smallForward);
				 action: [ self stonExport ];
				 label: 'To STON';
				 yourself);
			add: (self newButton
				 icon: (self application iconNamed: #glamorousDown);
				 action: [ self stonImport ];
				 label: 'From STON';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #glamorousFolder);
				 action: [ self chooseAndLoad ];
				 label: 'Open';
				 yourself).
	dataDirs := self newDropList.
	dataDirs items: ExperimentResultsExtractor dataDirs.




	self buildParticipantsToolbar
]

{ #category : #initialization }
OCREDataAnalysisPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Experimental results'
]

{ #category : #specs }
OCREDataAnalysisPresenter >> menu [

	^ self newMenu
		  addItem: [ :anItem |
			  anItem
				  name: 'Fix data';
				  iconName: #configuration;
				  action: [
					  (OCRETaskSorcererPresenter on: participantsTable selectedItem) experimentResultsBrowser:  self;
						  open ] ];
		  addItem: [ :anItem |
			  anItem
				  name: 'inspect';
				  iconName: #glamorousInspect;
				  action: [ participantsTable selectedItem inspect ] ];
		  yourself
]

{ #category : #charts }
OCREDataAnalysisPresenter >> openDiagrams [

	| surveys dataLabels data plot |
	surveys := experiment participantResults collect: [ :result |
		           result participant surveys second survey answers first ].

	dataLabels := surveys first choices.


	data := OrderedCollection new.
	dataLabels do: [ :l |
		| count |
		count := (surveys select: [ :s | s answer answer = l ]) size.
		data add: count ].
	data inspect.
	plot := self newRoassal.
	plot := RSBarPlotNew new
		        data: data;
		        yTickLabels: dataLabels;
		        title: surveys first title;
		        horizontal;
		        asPresenter.

	plot open
]

{ #category : #charts }
OCREDataAnalysisPresenter >> plot: aTasksResults [

	| transformBlock dataViolins |
	transformBlock := [ :data |
	                  data collect: [ :duration |
		                  duration hours * 60 + duration minutes
		                  + (duration seconds / 60) asFloat ] ].
	dataViolins := RSViolinPlot data: {
			               (transformBlock value: aTasksResults controlData).
			               (transformBlock value: aTasksResults treatmentData) }.

	dataViolins xTickLabels: {
			('Control (' , aTasksResults controlData size printString
			 , ' points)').
			('Treatment (' , aTasksResults treatmentData size printString
			 , ' points)') }.
	dataViolins title: 'Time to finish the task (in min)'.
	dataViolins bandwidth: 10.
	violins := dataViolins asPresenter
]

{ #category : #charts }
OCREDataAnalysisPresenter >> plotChartsForTask: aTaskResult [

	aTaskResult ifNil: [ ^ self ].

	self plot: aTaskResult.
	self plotMeanTimesWith95IC: aTaskResult.
	self plotMeanDebugActionsWith95IC: aTaskResult.
	self plotDebugActionsCount: aTaskResult.
	self setDefaultLayout
]

{ #category : #charts }
OCREDataAnalysisPresenter >> plotControls [

	|control1 control2 transformBlock dataViolins plot controlBar1 controlBar2|
	tasksTable items ifEmpty:[^self].
	control1 := tasksTable items first.
	control2 := tasksTable items second.
	transformBlock := [ :data |
	                  data collect: [ :duration | (duration hours * 60) +
		                  duration minutes + (duration seconds / 60) asFloat ] ].
	dataViolins := RSViolinPlot data: {
			               (transformBlock value: control1 controlData).
			               (transformBlock value: control2 controlData) }.

	dataViolins xTickLabels: {
			(control1 name, '(' , control1 controlData size printString
			 , ' points)').
			(control2 name, '(' , control2 treatmentData size printString
			 , ' points)') }.
	dataViolins title:
			              'Controls times in min'.
	dataViolins bandwidth: 10.
	controlsViolins := dataViolins asPresenter.
	
	controlBar1 :=  (transformBlock value: control1 controlData).
	controlBar2 :=   (transformBlock value: control2 controlData) .
	
	plot := (RSBarPlot barHeights: ({controlBar1. controlBar2} collect: #average))
		errors: (self confidenceIntervals: {controlBar1. controlBar2}).
	plot horizontalTick
		fromNames: {control1 name. control2 name}.
	plot title: 'Mean time (in min), 95% CI.'.	

	controlsMeanTimesBars := plot asPresenter
]

{ #category : #charts }
OCREDataAnalysisPresenter >> plotDebugActionsCount: aTasksResults [

	debugActions := self newRoassal.
	debugActions := RSViolinPlot new
		                data: aTasksResults averageDebuggingActionsCount;
		                xTickLabels: { 'Control'. 'Treatment' };
		                title: 'Debug actions count';
		                bandwidth: 50;
		                asPresenter
]

{ #category : #charts }
OCREDataAnalysisPresenter >> plotExperienceBarChart [

	| dataLabels data |
	experience := self newRoassal.
	true ifTrue:[self flag: 'adapt if necessary or remove'. ^self].
	dataLabels := { '< 1'. '1-2 years'. '3-5 years'. '6-10 years'.
	              'More than 10' }.
	data := OrderedCollection new.
	dataLabels do: [ :l |
		data add: (experiment participantsExperience count: [ :e | e = l ]) ].
	dataLabels := { '<1'. '1-2'. '3-5'. '6-10'. '>10' }.
	experience := RSBarPlotNew new
		              data: data;
		              xTickLabels: dataLabels;
		              title:
			              'Participants development experience (in years)';
		              asPresenter
]

{ #category : #charts }
OCREDataAnalysisPresenter >> plotMeanDebugActionsWith95IC: aTasksResults [

	| control treatment plot|


	control := aTasksResults averageDebuggingActionsCount first.
	treatment := aTasksResults averageDebuggingActionsCount second.
	
	plot := (RSBarPlot barHeights: ({control. treatment} collect: #average))
		errors: (self confidenceIntervals: {control. treatment}).
	plot horizontalTick
		fromNames: #(Control Treatment).
"	plot verticalTick
		labelConversion: [ :val | val asFloat printShowingDecimalPlaces: 5 ]."
	plot title: 'Mean debug actions, 95% CI.'.
	

	meansDebugActionBars := plot asPresenter
]

{ #category : #charts }
OCREDataAnalysisPresenter >> plotMeanTimesWith95IC: aTasksResults [

	| transformBlock control treatment plot |
	transformBlock := [ :data |
	                  data collect: [ :duration |
		                  (duration hours * 60)+ duration minutes
		                  + (duration seconds / 60) asFloat ] ].

	control := transformBlock value: aTasksResults controlData.
	treatment := transformBlock value: aTasksResults treatmentData.

	plot := (RSBarPlot barHeights: ({
			          control.
			          treatment } collect: #average)) errors:
		        (self confidenceIntervals: {
				         control.
				         treatment }).
	plot horizontalTick fromNames: #( Control Treatment ).

	plot title: 'Mean time (in min), 95% CI.'.


	meanTimesBars := plot asPresenter
]

{ #category : #specs }
OCREDataAnalysisPresenter >> printCorrectnessFor: participant [

	| controlCorrectness treatmentCorrectness |
	controlCorrectness := participant controlTask correctness.
	treatmentCorrectness := [ participant treatmentTask correctness ]
		                        on: Error
		                        do: [ nil ].
	(({
		  controlCorrectness.
		  treatmentCorrectness } includes: nil) or: [
		 participant treatmentTask notNil ]) ifTrue: [ ^ 'Needs check' ].


	^ String streamContents: [ :str |
		  str << (controlCorrectness
			   ifTrue: [ '1' ]
			   ifFalse: [ '0' ]).
		  str << ' | '.
		  participant treatmentTask ifNil: [ str << 'x' ] ifNotNil: [
			  str << (treatmentCorrectness
				   ifTrue: [ '1' ]
				   ifFalse: [ '0' ]) ] ]
]

{ #category : #actions }
OCREDataAnalysisPresenter >> reload [

	| dir xpResults |
	dir := dataDirs selectedItem.
	(dir isNil or: [ dir exists not ]) ifTrue: [ ^ self ].
	xpResults := ExperimentResultsExtractor new.
	progress := self newProgressBar.


	self setProgressLayout.

	progress
		progress: [ xpResults dataExtractionProgress ]
		every: 0.1 seconds.
	[
	[
	experiment := ExperimentResults on:
		              (xpResults extractResultsWithProgress: dir).
	ExperimentResults current: experiment ] ensure: [
		self doAnalysisAndUpdate ] ] fork
]

{ #category : #specs }
OCREDataAnalysisPresenter >> setDefaultLayout [

	self layout: self defaultLayout
]

{ #category : #initialization }
OCREDataAnalysisPresenter >> setModelBeforeInitialization: anExperimentResult [

	experiment := anExperimentResult.
	self flag: 'adapt if necessary or remove'
	"experiment collectDeveloperExperience"
]

{ #category : #specs }
OCREDataAnalysisPresenter >> setProgressLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: buttonBar expand: false fill: false;
			 add: progress height: self class toolbarHeight;
			 add: (SpPanedLayout newLeftToRight
					  positionOfSlider: 50 percent;
					  add: (SpPanedLayout newTopToBottom
							   positionOfSlider: 25 percent;
							   add: (SpBoxLayout newTopToBottom
									    add: 'Tasks' expand: false fill: false;
									    add: tasksTable;
									    yourself);
							   add: (SpBoxLayout newTopToBottom
									    add: 'Participants' expand: false fill: false;
									    add: participantsTable;
									    yourself);
							   yourself);
					  add: (SpPanedLayout newTopToBottom
							   positionOfSlider: 50 percent;
							   add: (SpBoxLayout newLeftToRight
									    add: violins;
									    add: debugActions;
									    yourself);
							   add: experience;
							   yourself);
					  yourself);
			 yourself)
]

{ #category : #'as yet unclassified' }
OCREDataAnalysisPresenter >> stonExport [

	'data.ston' asFileReference writeStream
		nextPutAll: (STON toString: experiment);
		close
]

{ #category : #updating }
OCREDataAnalysisPresenter >> updateAllViews [

	|index|
	index := tasksTable selection selectedIndex.
	tasksTable items: experiment buildTaskResults.
	participantsTable items:
		(experiment participations sort: [ :a :b |
			 a dateStarted > b dateStarted ]).
	violins := self newRoassal.
	debugActions := self newRoassal.
	self plotExperienceBarChart.
	self plotControls.
	self layout: self defaultLayout.
	tasksTable selection selectIndexes: {index}
]

{ #category : #analysis }
OCREDataAnalysisPresenter >> useConsolidatedTimes [

"	TaskStats allInstances do: [ :t | t useConsolidatedTimes ].
	self doAnalysis.
	self updateAllViews"
]

{ #category : #analysis }
OCREDataAnalysisPresenter >> useRawTimes [
	"TaskStats allInstances do: [ :t | t useRawTimes ].
	self doAnalysis.
	self updateAllViews"
]
