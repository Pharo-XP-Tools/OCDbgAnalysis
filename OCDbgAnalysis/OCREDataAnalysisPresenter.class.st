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
		'controlsViolins'
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

{ #category : #initialization }
OCREDataAnalysisPresenter >> buildParticipantsToolbar [

	participantsToolbar := self newToolbar.
	alternateDurationButton := self newToolbarToggleButton.
	rawDurationButton := self newToolbarToggleButton.
	rawDurationButton state: true.
	
	participantsToolbar addItemRight: rawDurationButton.
	participantsToolbar addItemRight:  alternateDurationButton.
	
	rawDurationButton associatedToggleButtons: { alternateDurationButton }.
	
	rawDurationButton label: 'Raw time'; icon: (self application iconNamed: #recentMessages).
	alternateDurationButton label: 'Consolidated time'; icon: (self application iconNamed: #history).
	
	rawDurationButton whenActivatedDo: [ self useRawTimes ].
	alternateDurationButton whenActivatedDo: [ self useConsolidatedTimes ].
]

{ #category : #actions }
OCREDataAnalysisPresenter >> checkData: aParticipantResult [

	aParticipantResult isParticipationValid ifFalse: [ ^ self ].
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
		ExperimentResults addDataDir: a asFileReference.
		dataDirs items: ExperimentResults dataDirs ]
]

{ #category : #specs }
OCREDataAnalysisPresenter >> correctnessColorFor: participant [

	participant isParticipationValid ifFalse: [ ^ Color black ].

	participant dataChecked ifTrue: [ ^ Color blue darker ].


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
											      experiment participantResults size printString
											      , ' participations'
										      expand: false
										      fill: false;
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
								     add: debugActions;
								     yourself);
						    add: (SpBoxLayout newLeftToRight
								     add: controlsViolins;
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
	participantsTable addColumn: ((SpCheckBoxTableColumn new
			  title: ' ';
				evaluated: [ :item | item shouldCount ])
			  onActivation: [ :item | self countParticipant: item ];
			onDeactivation: [ :item | self dontCountParticipant: item ];
			width: 30;
			yourself
			).
	participantsTable addColumn: ((SpStringTableColumn
			  title: 'XP Date'
			  evaluated: [ :item | item dateStarted asLocalStringYMDHM ])
			 width: 100;
			 yourself).
	participantsTable addColumn: ((SpStringTableColumn
			  title: 'Control'
			  evaluated: [ :item | item controlTaskInfos ])
			 sortFunction: nil;
			 yourself).
	participantsTable addColumn: ((SpStringTableColumn
			  title: 'Treatment'
			  evaluated: [ :item | item treatmentTaskInfos ])
			 sortFunction: nil;
			 yourself).
	participantsTable contextMenu: self menu.

	participantsTable addColumn:
		((SpImageTableColumn title: 'Valid' evaluated: [ :item |
				  item isParticipationValid
					  ifTrue: [ self iconNamed: #testGreen ]
					  ifFalse: [ self iconNamed: #testRed ] ])
			 displayColor: [ :item |
				 item isParticipationValid
					 ifTrue: [ Color green muchDarker ]
					 ifFalse: [ Color red ] ];
			 width: 40;
			 sortFunction: nil;
			 yourself).

	participantsTable addColumn: (OCDbgLinkTableColumn new
			 title: 'Correctness';
			 evaluated: [ :item | self printCorrectnessFor: item ];
			 action: [ :item | self checkData: item ];
			 displayColor: [ :item | self correctnessColorFor: item ];
			 yourself).


	participantsTable items:
		(experiment participantResults sort: [ :a :b |
			 a dateStarted > b dateStarted ]).

	violins := self newRoassal.
	debugActions := self newRoassal.
	self plotExperienceBarChart.
	self plotControls.

	buttonBar := self newButtonBar.
	buttonBar
		placeAtStart;
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
				 icon: (self application iconNamed: #glamorousFolder);
				 action: [ self chooseAndLoad ];
				 label: 'Open';
				 yourself).
		dataDirs := self newDropList.
		dataDirs items: ExperimentResults dataDirs




	"	self buildParticipantsToolbar."
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
OCREDataAnalysisPresenter >> plot: aTasksResults [

	| transformBlock dataViolins |
	transformBlock := [ :data |
	                  data collect: [ :duration |
		                  duration minutes + (duration seconds / 60) asFloat ] ].
	dataViolins := RSViolinPlot data: {
			               (transformBlock value: aTasksResults controlData).
			               (transformBlock value: aTasksResults treatmentData) }.

	dataViolins xTickLabels: {
			('Control (' , aTasksResults controlData size printString
			 , ' points)').
			('Treatment (' , aTasksResults treatmentData size printString
			 , ' points)') }.
	dataViolins title:
			              'Time to finish the task (in min)'.
	dataViolins bandwidth: 10.
	violins := dataViolins asPresenter
]

{ #category : #charts }
OCREDataAnalysisPresenter >> plotChartsForTask: aTaskResult [

	aTaskResult ifNil: [ ^ self ].

	self plot: aTaskResult.
	self plotDebugActionsCount: aTaskResult.
	self setDefaultLayout
]

{ #category : #charts }
OCREDataAnalysisPresenter >> plotControls [

	|control1 control2 transformBlock dataViolins |

	control1 := tasksTable items first.
	control2 := tasksTable items second.
	transformBlock := [ :data |
	                  data collect: [ :duration |
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
	controlsViolins := dataViolins asPresenter
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

{ #category : #specs }
OCREDataAnalysisPresenter >> printCorrectnessFor: participant [

	participant isParticipationValid ifFalse: [ ^ 'N/A' ].
	participant dataChecked ifTrue: [^participant printCorrectness ].
	^ 'Needs check'
]

{ #category : #actions }
OCREDataAnalysisPresenter >> reload [
	|dir|
	dir := dataDirs selectedItem.
	(dir isNil or: [dir isEmpty or: [dir exists not]]) ifTrue:[^self].
	experiment := ExperimentResults new.
	progress := self newProgressBar.


	self setProgressLayout.

	progress
		progress: [ experiment dataExtractionProgress ]
		every: 0.1 seconds.
	[
	[ experiment extractResultsWithProgress: dir] ensure: [
		self doAnalysisAndUpdate ] ] fork
]

{ #category : #specs }
OCREDataAnalysisPresenter >> setDefaultLayout [

	self layout: self defaultLayout
]

{ #category : #initialization }
OCREDataAnalysisPresenter >> setModelBeforeInitialization: anExperimentResult [

	experiment := anExperimentResult.
	experiment collectDeveloperExperience
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

{ #category : #updating }
OCREDataAnalysisPresenter >> updateAllViews [

	tasksTable items: experiment buildTaskResults.
	participantsTable items:
		(experiment participantResults sort: [ :a :b |
			 a dateStarted > b dateStarted ]).
	violins := self newRoassal.
	debugActions := self newRoassal.
	self plotExperienceBarChart.
	self plotControls.


	self layout: self defaultLayout
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
