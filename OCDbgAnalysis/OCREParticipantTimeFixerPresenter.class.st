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

{ #category : #actions }
OCREParticipantTimeFixerPresenter >> autoFixCase1: collectionOfIdleTimes [

	| comment |
	comment := 'Case 1: computed and declared interruption are consistent.
Decision taken automatically for all interruption of that task, based on case 1 rules.
Decision: interruption.'.
	collectionOfIdleTimes do: [ :idleTime |
		idleTime decision: true.
		idleTime comment: comment ]
]

{ #category : #actions }
OCREParticipantTimeFixerPresenter >> autoFixCase2: collectionOfIdleTimes [

	| comment |
	self halt: 'not implemented yet'.
	comment := 'Case 1: computed and declared interruption are consistent.
Decision taken automatically for all interruption of that task, based on case 1 rules.
Decision: interruption.'.
	collectionOfIdleTimes do: [ :idleTime |
		idleTime decision: true.
		idleTime comment: comment ]
]

{ #category : #actions }
OCREParticipantTimeFixerPresenter >> autoFixCase6: collectionOfIdleTimes [

	| forced comment |
	forced := IdleTimeControl new.	
	comment := 'Case 6: cannot decide interruption from computed interruption while declared interruption is not 0.
Decision taken automatically for all interruption of that task, based on case 6 rules.
Decision: interruption.'.
	forced comment: comment.
	forced computedIdleTime: ((self application newSelect items: {60. 300. 600. }; title: 'Force idle time (in seconds)'; openModal) ifNil:[^self]) asSeconds.
	forced events: OrderedCollection new.
	forced timeGapStartEvent: collectionOfIdleTimes first events first.
	forced timeGapStopEvent: collectionOfIdleTimes first events last.
	forced decision: true.
	collectionOfIdleTimes add: forced
]

{ #category : #'presenter - data' }
OCREParticipantTimeFixerPresenter >> calculateInterruptionTimesFor: anAssociation [

	^ (anAssociation value
		   inject: 0
		   into: [ :sum :next | sum + next computedIdleTime asSeconds ])
		  asSeconds
]

{ #category : #spec }
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

{ #category : #'presenter - data' }
OCREParticipantTimeFixerPresenter >> findDeclaredIdleTimeFor: association [

	^ association key
]

{ #category : #initialization }
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

{ #category : #spec }
OCREParticipantTimeFixerPresenter >> menu [

	^ self newMenu
		  addItem: [ :anItem |
			  anItem
				  name: 'Fix idle times...';
				  iconName: #testRed;
				  action: [
					  (OCREParticipantIdleTimesAnalyzer on: table selectedItem value)
						  open ] ];
		  addItem: [ :anItem |
			  anItem
				  name: 'Auto-Fix: case 1 (consistent, based on calculation)';
				  iconName: #testGreen;
				  action: [ self autoFixCase1: table selectedItem value ] ];
		  addItem: [ :anItem |
			  anItem
				  name: 'Auto-Fix: case 2 (based on declaration)';
				  iconName: #testYellow;
				  action: [ self autoFixCase2: table selectedItem value ] ];
		  addItem: [ :anItem |
			  anItem
				  name: 'Auto-Fix: case 6 (based on declaration)';
				  iconName: #confirm;
				  action: [ self autoFixCase6: table selectedItem value ] ];
		  yourself
]

{ #category : #'presenter - data' }
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
