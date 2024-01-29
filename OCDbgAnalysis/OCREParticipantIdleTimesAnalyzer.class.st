Class {
	#name : #OCREParticipantIdleTimesAnalyzer,
	#superclass : #SpPresenter,
	#instVars : [
		'idleTimesList',
		'idleTimes',
		'eventList',
		'timeEventgaps',
		'comment',
		'decision',
		'selectedIdleTime',
		'eventInspector',
		'resetButton',
		'deduceButton',
		'keepButton'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #layout }
OCREParticipantIdleTimesAnalyzer >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 30 percent;
		  add: idleTimesList;
		  add: (SpBoxLayout newTopToBottom
				   add: (SpBoxLayout newLeftToRight
						    add: (SpBoxLayout newTopToBottom
								     add: 'Time gap between:' expand: false fill: false;
								     add: timeEventgaps;
								     yourself)
						    width: 100;
						    add: (SpBoxLayout newTopToBottom
								     add: 'All events:' expand: false fill: false;
								     add: eventList;
								     yourself)
						    width: 200;
						    add: eventInspector;
						    yourself);
				   add: 'Comment:' expand: false fill: false;
				   add: comment;
				   add: decision expand: false fill: false;
					add: (SpBoxLayout newLeftToRight add: resetButton; add: deduceButton; add: keepButton; yourself);
				   yourself);
		  yourself
]

{ #category : #initialization }
OCREParticipantIdleTimesAnalyzer >> initializePresenters [

	idleTimesList := self newList.
	idleTimesList displayColor: [ :item |
		item decision ifNil:
			[ Color red ]
			ifNotNil: [ Color blue ] ].
	idleTimesList whenSelectedDo: [ :s | self updateSelectedIdleTime: s ].
	idleTimesList items: idleTimes.

	eventInspector := self newPresenter.
	eventInspector layout: SpBoxLayout newTopToBottom.

	eventList := self newList.
	timeEventgaps := self newList.
	timeEventgaps whenSelectedDo: [ :s |
		eventList
			selectIndex: (eventList items indexOf: s)
			scrollToSelection: true ].

	eventList whenSelectedDo: [ :s |
		eventInspector layout: (SpBoxLayout newTopToBottom
				 add: s inspectionRaw;
				 yourself).
		self update ].

	comment := self newText.
	decision := self newLabel.
	decision label: 'Remove time: ', (selectedIdleTime ifNotNil:[:t|t  decision printString] ifNil:['']).
	resetButton := self newButton label: 'Reset decision'; action: [selectedIdleTime decision: nil. self updateSelectedIdleTime: selectedIdleTime]; yourself.
	deduceButton := self newButton label: 'Deduce time'; action: [selectedIdleTime decision: true. self updateSelectedIdleTime: selectedIdleTime]; yourself.
	keepButton := self newButton label: 'Keep time'; action: [selectedIdleTime decision: false. self updateSelectedIdleTime: selectedIdleTime]; yourself.
	
	decision whenChangedDo: [ :b |
		selectedIdleTime decision: b.
		self update ].
	idleTimesList selectIndex: 1
]

{ #category : #initialization }
OCREParticipantIdleTimesAnalyzer >> initializeWindow: w [
	super initializeWindow: w.
	w title: 'Idle time analyzer'
]

{ #category : #'accessing - model' }
OCREParticipantIdleTimesAnalyzer >> setModelBeforeInitialization: aIdleTimesCollection [

	idleTimes := aIdleTimesCollection
]

{ #category : #updating }
OCREParticipantIdleTimesAnalyzer >> updateSelectedIdleTime: s [

	selectedIdleTime := s.
	decision label: 'Remove time: ', (selectedIdleTime ifNotNil:[:t|t  decision printString] ifNil:['']).
	comment text: s comment.
	eventList items: s events.
	timeEventgaps items: {
			s timeGapStartEvent.
			s timeGapStopEvent }.
		self update
]
