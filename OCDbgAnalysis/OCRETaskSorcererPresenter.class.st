Class {
	#name : #OCRETaskSorcererPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'participantResult',
		'taskEnding',
		'taskNames',
		'rawData',
		'newTaskData',
		'buttonBar',
		'experimentResultsBrowser'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #'accessing - model' }
OCRETaskSorcererPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: taskNames expand: false fill: false;
		  add: (SpBoxLayout newLeftToRight
				   add: rawData;
				   add: newTaskData;
				   yourself);
		  add: buttonBar expand: false fill: false;
		  yourself
]

{ #category : #accessing }
OCRETaskSorcererPresenter >> experimentResultsBrowser: anObject [

	experimentResultsBrowser := anObject
]

{ #category : #'accessing - model' }
OCRETaskSorcererPresenter >> filterEvents: filter [

	| history finishTaskHistory |
	filter ifEmpty: [
		rawData items: participantResult rawData.
		^ self ].
	history := participantResult eventsHistory.
	history buildWindowHistory.
	finishTaskHistory := history windowsHistory keys
		                     detect: [ :name |
			                     'Finish task ' , filter , '*' match:
				                     name windowName asString ]
		                     ifNone: [ self halt ].
	rawData items: (history windowsHistory at: finishTaskHistory)
]

{ #category : #'accessing - model' }
OCRETaskSorcererPresenter >> initializePresenters [

	taskNames := self newDropList.
	taskNames items: #('' 'Lights Out' 'Ammolite').
	taskNames whenSelectedItemChangedDo: [ :e| self filterEvents: e].
	
	rawData := self newList.
	rawData items: participantResult events.
	rawData contextMenu: self rawDataMenu.

	newTaskData := self newTable.
	newTaskData addColumn: ((SpStringTableColumn title: 'Element' evaluated: [ :item | item key ])
			 sortFunction: nil;
			 yourself).
			newTaskData addColumn: ((SpStringTableColumn title: 'Value' evaluated: [ :item | item value ])
			 sortFunction: nil;
			 yourself).
	newTaskData items: #().
	newTaskData contextMenu: self newTaskDataMenu.	
	
	buttonBar := self newButtonBar.
	buttonBar
		"We want to place them at the end (as is often used in dialogs)"
		placeAtEnd;
		add: (self newButton
			icon: (self application iconNamed: #configuration);
			action: [ self tryToFixTask ];
			label: 'Fix';
			yourself);
		add: (self newButton
			icon: (self application iconNamed: #glamorousAccept);
			action: [ self validateFix ];
			label: 'Validate fix';
			yourself)
]

{ #category : #'accessing - model' }
OCRETaskSorcererPresenter >> newTaskDataMenu [

	^ self newMenu addItem: [ :anItem |
		  anItem
			  name: 'inspect';
			  iconName: #glamorousInspect;
			  action: [ newTaskData selectedItem inspect ] ]
]

{ #category : #'as yet unclassified' }
OCRETaskSorcererPresenter >> proposeFixForTask: aPhexTask events: events finishHistory: finishHistory [ 
	|answer transaction|
	"Find where to insert the task"
	"Show the modifications in the new task list"
	taskEnding := DSEndingTaskRecord new.
	taskEnding dateTime: finishHistory first dateTime.
	taskEnding record: aPhexTask.
	aPhexTask endTime: taskEnding dateTime.
	answer := [(finishHistory select:[:e| { "DSClipboardPasteRecord. "DSClipboardCopyRecord } includes: e class] )last clipboardText] on: Error do: ['no answer found']. 
	aPhexTask answer: (PhexTaskAnswer new contents: answer; yourself). 
	transaction := TaskFixingProposition new.
	transaction endingTask: taskEnding.
	transaction insertionPoint: finishHistory last.
	taskEnding := transaction.
	newTaskData items: { 'Ending time'->aPhexTask endTime. 
	'Total time'->(events first dateTime - aPhexTask endTime) abs.
	'Answer'-> aPhexTask answer contents.
	'Inserted after'->transaction  insertionPoint.
	}
	
	
	"If fix is validated => insert task, recompute task stats for participant"
]

{ #category : #'accessing - model' }
OCRETaskSorcererPresenter >> rawDataMenu [

	^ self newMenu addItem: [ :anItem |
		  anItem
			  name: 'inspect';
			  iconName: #glamorousInspect;
			  action: [ rawData selectedItem inspect ] ]
]

{ #category : #'accessing - model' }
OCRETaskSorcererPresenter >> setModelBeforeInitialization: aParticipantResult [
	participantResult := aParticipantResult
]

{ #category : #'as yet unclassified' }
OCRETaskSorcererPresenter >> tryToFixTask [

	| taskName taskStart taskStartIndex taskEventsRange taskSwitchingEvent taskEvents |
	taskName := taskNames selectedItem ifEmpty: [ ^ self ].
	taskStart := participantResult events detect: [ :e |
		             e class == DSStartTaskRecord and: [
			             e task title = taskName ] ].
	taskStartIndex := participantResult events indexOf: taskStart.
	taskEventsRange := participantResult events
		                   copyFrom: taskStartIndex + 1
		                   to: participantResult events size.
	taskSwitchingEvent := taskEventsRange
		                      detect: [ :e |
			                      {
				                      DSStartTaskRecord.
				                      DSEndingTaskRecord } includes: e class ]
		                      ifNone: [ participantResult events last ].
	taskEvents := participantResult events
		              copyFrom: taskStartIndex
		              to:
		              (participantResult events indexOf: taskSwitchingEvent).

	self
		proposeFixForTask: taskStart task
		events: taskEvents
		finishHistory: rawData items
]

{ #category : #'as yet unclassified' }
OCRETaskSorcererPresenter >> validateFix [

	| dstasks dst taskStats |
	participantResult events
		add: taskEnding endingTask
		after: taskEnding insertionPoint.
	dstasks := participantResult events ocdSelectTasksEnding collect: [
		           :e | e task ].


	dst := dstasks
		       detect: [ :t | t title = taskNames selectedItem ]
		       ifNone: [
			       self inform: 'Impossible to fix: task was not found'.
			       ^ self ].

	taskStats := TaskStats
		             newForTask: dst
		             fromData: participantResult events.
	participantResult treatmentTask: (PhexTaskResult from: taskStats).
	participantResult treatmentTask beTreatment.
	experimentResultsBrowser doAnalysis.
	experimentResultsBrowser updateAllViews
]
