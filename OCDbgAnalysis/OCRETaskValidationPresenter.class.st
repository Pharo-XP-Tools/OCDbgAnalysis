Class {
	#name : #OCRETaskValidationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'task',
		'success',
		'participantAnswer',
		'checkbox',
		'title',
		'valid',
		'correctnessComment',
		'validityComment',
		'correctnessLabel'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #initialization }
OCRETaskValidationPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: title expand: false fill: false;
		  add: (SpBoxLayout newLeftToRight
				   add: success expand: false fill: false;
				   add: checkbox height: 20;
			 		add: correctnessLabel expand: false fill: false;
				   yourself) expand: false fill: false;
		  add: (SpBoxLayout newLeftToRight
				   add: participantAnswer expand: true fill: true padding: 5;
				   add: correctnessComment expand: true fill: true padding: 5;
				   yourself);
		  add: valid expand: false fill: false;
		  add: validityComment;
		  yourself
]

{ #category : #initialization }
OCRETaskValidationPresenter >> initializePresenters [
	title := self newLabel label: task title.
	success := self newLabel
		           label: ('Auto. test: ', (task correctnessTest ifTrue:['SUCCESS'] ifFalse:['FAILURE']) );
		           yourself.
	participantAnswer := self newText
		                     text: task answer;
		                     beNotEditable;
		                     yourself.

	checkbox := self newCheckBox.
	checkbox
		label: 'Correct';
		state: (task correctness ifNil: [ false ]);
		whenActivatedDo: [ task correctness: true ];
		whenDeactivatedDo: [ task correctness: false ].
	correctnessLabel := self newLabel label: (task correctness ifNil: [ 'CORRECTNESS UNDECIDED PLEASE CHECK' ] ifNotNil:['']).
		
	valid := self newCheckBox.
	valid
		label: 'Valid';
		state: (task isValid ifNil: [ true ]);
		whenActivatedDo: [ task forceValidity: true ];
		whenDeactivatedDo: [ task forceValidity: false ].
		
	correctnessComment := self newText.
	correctnessComment whenTextChangedDo: [ :newValue| task correctnessComment: newValue ].
	correctnessComment text: task correctnessComment.
	
	validityComment := self newText.
	validityComment text: task validityComment.
	validityComment whenTextChangedDo: [ :newValue| task validityComment: newValue ].
]

{ #category : #initialization }
OCRETaskValidationPresenter >> setModelBeforeInitialization: aTask [

	task := aTask
]
