Class {
	#name : #OCRETaskSorcererPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'participantResult',
		'taskEnding',
		'taskNames',
		'rawData',
		'newTaskData',
		'buttonBar'
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

{ #category : #'accessing - model' }
OCRETaskSorcererPresenter >> filterEvents: filter [
	|history finishTaskHistory|
	filter ifEmpty: [
		rawData items: participantResult rawData.
		^ self ].
	history := 
	(DSRecordHistory on: participantResult rawData ).
	history buildWindowHistory.
	finishTaskHistory := history windowsHistory keys detect:[:name|
		('Finish task ', filter, '*' ) match: name windowName asString
		] ifNone:[self halt].
	rawData items: (history windowsHistory at: finishTaskHistory)
]

{ #category : #'accessing - model' }
OCRETaskSorcererPresenter >> initializePresenters [

	taskNames := self newDropList.
	taskNames items: #('' 'Lights Out' 'Ammolite').
	taskNames whenSelectedItemChangedDo: [ :e| self filterEvents: e].
	
	rawData := self newList.
	rawData items: participantResult rawData.
	rawData contextMenu: self rawDataMenu.

	newTaskData := self newList.
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
