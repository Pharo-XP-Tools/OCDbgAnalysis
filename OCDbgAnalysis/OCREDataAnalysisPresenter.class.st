Class {
	#name : #OCREDataAnalysisPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tasksTable',
		'participantsTable',
		'experiment',
		'violins',
		'experience'
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

{ #category : #specs }
OCREDataAnalysisPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 50 percent;
		  add: (SpPanedLayout newTopToBottom
				   positionOfSlider: 25 percent;
				   add: (SpBoxLayout newTopToBottom add: 'Tasks' expand: false fill: false; add: tasksTable; yourself);
				   add: (SpBoxLayout newTopToBottom add: 'Participants' expand: false fill: false; add: participantsTable; yourself);
				   yourself);
		  add: (SpPanedLayout newTopToBottom
				   positionOfSlider: 50 percent;
				   add: violins;
				   add: experience;
				   yourself);
		  yourself
]

{ #category : #specs }
OCREDataAnalysisPresenter >> defaultSpec [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 50 percent;
		  add: (SpPanedLayout newTopToBottom
				   positionOfSlider: 25 percent;
				   add: tasksTable;
				   add: participantsTable;
				   yourself);
		  add: SpBoxLayout newTopToBottom;
		  yourself
]

{ #category : #initialization }
OCREDataAnalysisPresenter >> initializePresenters [

	tasksTable := self newTable.
	tasksTable addColumn: ((SpStringTableColumn
			  title: 'Task'
			  evaluated: [ :item | item name ])
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
				|stringValue|
				stringValue := 
				String streamContents: [ :str| 					
					item ratio > 0 ifTrue:[str << '+'].
					str << item ratio printString
					 ] limitedTo:  6.
				String streamContents: [ :str| 					
					str << stringValue.
					str << '%'
					 ]
				 ])
			 sortFunction: nil;
			 yourself).
			
	tasksTable items: experiment buildTaskResults.
	tasksTable transmitDo: [ :task| self plot: task ].
	
 
	participantsTable := self newTable.
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
				
		participantsTable addColumn: ((SpStringTableColumn
			  title: 'Valid'
			  evaluated: [ :item | item isParticipationValid ifTrue:['yes'] ifFalse:['no'] ])
			displayColor: [ :item| item isParticipationValid  ifTrue:[Color green muchDarker] ifFalse:[Color red] ];
			width: 40;
			 sortFunction: nil;
			 yourself).	
				
			participantsTable addColumn:(

	 OCDbgLinkTableColumn new 
		title: 'Correctness';
		evaluated: [ :item | 
			item dataChecked ifTrue:[item printCorrectness] ifFalse:['Needs check'] ];
		action: [ :item |  self checkData: item ];
	displayColor: [ :item| item dataChecked  ifTrue:[Color blue darker] ifFalse:[Color red] ];
		yourself).
				
			
	participantsTable items: experiment participantResults.
	
	violins := self newRoassal.
	self plotExperienceBarChart
]

{ #category : #initialization }
OCREDataAnalysisPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Experimental results'
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
	violins := dataViolins asPresenter.
	self layout: self defaultLayout
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

{ #category : #initialization }
OCREDataAnalysisPresenter >> setModelBeforeInitialization: anExperimentResult [

	experiment := anExperimentResult.
	experiment collectDeveloperExperience
]
