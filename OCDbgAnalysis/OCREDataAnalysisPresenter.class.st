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

	| boxPlot1 |
	boxPlot1 := RSViolinPlot data: {
			            { 6. 8. 7. 5. 7. 11. 9 }.
			            { 2. 2. 2. 3. 3. 12. 4. 2. 4. 2. 2. 2. 6. 2. 2. 8. 2. 5.
			            9. 2. 2. 2. 2. 2 } }.
	violins := boxPlot1 asPresenter.
	self layout: self defaultLayout
]

{ #category : #initialization }
OCREDataAnalysisPresenter >> setModelBeforeInitialization: anExperimentResult [

	experiment := anExperimentResult
]
