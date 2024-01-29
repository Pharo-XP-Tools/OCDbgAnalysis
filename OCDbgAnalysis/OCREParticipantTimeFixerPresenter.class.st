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
OCREParticipantTimeFixerPresenter >> findDeclaredIdleTimeFor: aPhexTaskResult [

	^ aPhexTaskResult declaredInterruptionTime
]

{ #category : #'accessing - model' }
OCREParticipantTimeFixerPresenter >> initializePresenters [
	|tasks|
	table := self newTable.
	table contextMenu: self menu.
	"table addColumn: ((SpStringTableColumn
			  title: 'Task name'
			  evaluated: [ :item | item title ])
			 sortFunction: nil;
			 yourself).

	table addColumn: ((SpStringTableColumn
			  title: 'Calculated time'
			  evaluated: [ :item | item time ])
			 sortFunction: nil;
			 yourself)."

	table addColumn: ((SpStringTableColumn
			  title: 'Estimated idle time'
			  evaluated: [ :item |
				  item calculateInterruptionTimes printString ])
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
			 onAcceptEdition: [ :item :text |
				 item retainedIdleTime ];
			 sortFunction: nil;
			 yourself).

	"table addColumn: 
		((SpStringTableColumn title: 'Fixed time' evaluated: [ :item |
				  (item time - item retainedIdleTime)
					  printString ])
			 sortFunction: nil;
			 yourself)."
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
				  action: [ (OCREParticipantIdleTimesAnalyzer on: table selectedItem detectedInterruptions) open  ] ];
		  yourself
]

{ #category : #'accessing - model' }
OCREParticipantTimeFixerPresenter >> setModelBeforeInitialization: aParticipantResult [

	participant := aParticipantResult
]
