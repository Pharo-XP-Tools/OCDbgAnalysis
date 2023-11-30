Class {
	#name : #OCREParticipantTimeFixerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'participant',
		'experimentResultsBrowser',
		'table'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #'accessing - model' }
OCREParticipantTimeFixerPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: table
		  expand: true
		  fill: true
		  padding: 5;
		  yourself
]

{ #category : #accessing }
OCREParticipantTimeFixerPresenter >> experimentResultsBrowser: anObject [

	experimentResultsBrowser := anObject
]

{ #category : #'as yet unclassified' }
OCREParticipantTimeFixerPresenter >> findDeclaredIdleTimeFor: aTaskStats [

	| taskIndex surveys |
	taskIndex := participant tasks indexOf: aTaskStats.
	surveys := participant participant surveys select: [ :s |
		           s survey title = 'Post-task survey' ].

	(taskIndex = 1 and: [ surveys size > 0 ]) ifTrue: [
		^ surveys first survey answers third answer ].
	(taskIndex > 1 and: [ surveys size > 1 ]) ifTrue: [
		^ surveys second survey answers third answer ].

	^ 'undeclared'
]

{ #category : #'accessing - model' }
OCREParticipantTimeFixerPresenter >> initializePresenters [
	|tasks|
	table := self newTable.
	table contextMenu: self menu.
	table addColumn: ((SpStringTableColumn
			  title: 'Task name'
			  evaluated: [ :item | item taskName ])
			 sortFunction: nil;
			 yourself).

	table addColumn: ((SpStringTableColumn
			  title: 'Calculated time'
			  evaluated: [ :item | item alternateDuration printString ])
			 sortFunction: nil;
			 yourself).

	table addColumn: ((SpStringTableColumn
			  title: 'Estimated idle time'
			  evaluated: [ :item |
				  item calculateInterruptionTimes asSeconds printString ])
			 sortFunction: nil;
			 yourself).

	table addColumn: ((SpStringTableColumn
			  title: 'Declared idle time'
			  evaluated: [ :item | (self findDeclaredIdleTimeFor: item) printString ])
			 sortFunction: nil;
			 yourself).

	table addColumn: ((SpStringTableColumn
			  title: 'Retained idle time'
			  evaluated: [ :item | item retainedIdleTime printString ])
			 beEditable;
			 onAcceptEdition: [ :item :text |
				 item retainedIdleTime: text asNumber ];
			 sortFunction: nil;
			 yourself).

	table addColumn: 
		((SpStringTableColumn title: 'Fixed time' evaluated: [ :item |
				  (item alternateDuration - item retainedIdleTime asSeconds)
					  printString ])
			 sortFunction: nil;
			 yourself).
	tasks := OrderedCollection new.
	participant controlTask ifNotNil:[:t| tasks add: t].
	participant treatmentTask ifNotNil:[:t| tasks add: t].	
		table items: tasks
]

{ #category : #initialization }
OCREParticipantTimeFixerPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Time Fixer';
		whenClosedDo: [ experimentResultsBrowser update ]
]

{ #category : #'accessing - model' }
OCREParticipantTimeFixerPresenter >> menu [

	^ self newMenu
		  addItem: [ :anItem |
			  anItem
				  name: 'Show idle times...';
				  iconName: #glamorousInspect;
				  action: [ table selectedItem collectTimeDiscrepancies inspect ] ];
		  yourself
]

{ #category : #'accessing - model' }
OCREParticipantTimeFixerPresenter >> setModelBeforeInitialization: aParticipantResult [

	participant := aParticipantResult
]
