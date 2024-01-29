Class {
	#name : #OCREParticipantTimeFixerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'experimentResultsBrowser',
		'table',
		'data'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #'as yet unclassified' }
OCREParticipantTimeFixerPresenter >> calculateInterruptionTimesFor: anAssociation [

	^ (anAssociation value
		   inject: 0
		   into: [ :sum :next | sum + next computedIdleTime asSeconds ])
		  asSeconds
]

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
OCREParticipantTimeFixerPresenter >> findDeclaredIdleTimeFor: association [

	^ association key
]

{ #category : #'accessing - model' }
OCREParticipantTimeFixerPresenter >> initializePresenters [

	| colorBlock|
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
			
	colorBlock := [ :item| (item value anySatisfy: [ :i| i decision isNil ]) ifTrue:[Color red] ifFalse:[Color black]].		

	table addColumn: ((SpStringTableColumn
			  title: 'Estimated idle time'
			  evaluated: [ :item |
				  (self calculateInterruptionTimesFor: item) printString ])
			 sortFunction: nil;
			 displayColor: colorBlock;
			 yourself).

	table addColumn: ((SpStringTableColumn
			  title: 'Declared idle time'
			  evaluated: [ :item |
				  (self findDeclaredIdleTimeFor: item) asString ])
			 sortFunction: nil;
			displayColor: colorBlock;
			 yourself).

	table addColumn: ((SpStringTableColumn
			  title: 'Retained idle time'
			  evaluated: [ :item |
				  (self retainedIdleTimeFor: item) printString ])
			 sortFunction: nil;
			displayColor: colorBlock;
			 yourself).

	"table addColumn: 
		((SpStringTableColumn title: 'Fixed time' evaluated: [ :item |
				  (item time - item retainedIdleTime)
					  printString ])
			 sortFunction: nil;
			 yourself)."

	table items: data
]

{ #category : #initialization }
OCREParticipantTimeFixerPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Time Fixer';
		whenClosedDo: [ experimentResultsBrowser updateAllViews ]
]

{ #category : #'accessing - model' }
OCREParticipantTimeFixerPresenter >> menu [

	^ self newMenu
		  addItem: [ :anItem |
			  anItem
				  name: 'Fix idle times...';
				  iconName: #glamorousInspect;
				  action: [
					  (OCREParticipantIdleTimesAnalyzer on: table selectedItem value)
						  open ] ];
		  yourself
]

{ #category : #'as yet unclassified' }
OCREParticipantTimeFixerPresenter >> retainedIdleTimeFor: anAssociation [

	^ ((anAssociation value select: [ :item |
		    item decision notNil and: [ item decision ] ])
		   inject: 0
		   into: [ :sum :next | sum + next computedIdleTime asSeconds ])
		  asSeconds
]

{ #category : #'accessing - model' }
OCREParticipantTimeFixerPresenter >> setModelBeforeInitialization: associations [

	data := associations
]
