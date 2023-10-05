Class {
	#name : #OCREDataAnalysisPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tasksTable',
		'participantsTable',
		'experiment',
		'violins'
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
				   add: tasksTable;
				   add: participantsTable;
				   yourself);
		  add: violins;
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
			  title: 'Ratio'
			  evaluated: [ :item | item ratio printString ])
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
			
	participantsTable items: experiment participantResults.
	
	violins := self newRoassal.
]

{ #category : #'as yet unclassified' }
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
	violins := dataViolins asPresenter.
	self layout: self defaultLayout
]

{ #category : #initialization }
OCREDataAnalysisPresenter >> setModelBeforeInitialization: anExperimentResult [

	experiment := anExperimentResult
]
