Class {
	#name : #OCRETaskValidationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'task',
		'success',
		'participantAnswer',
		'checkbox',
		'title'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #initialization }
OCRETaskValidationPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: title expand: false fill: false;
		  add: success expand: false fill: false;
		  add: participantAnswer;
		  add: checkbox expand: false fill: false;
		  yourself
]

{ #category : #initialization }
OCRETaskValidationPresenter >> initializePresenters [
	title := self newLabel label: task taskInfo title.
	success := self newLabel
		           label: ('Success: ', task testSuccess printString);
		           yourself.
	participantAnswer := self newText
		                     text: task answer contents;
		                     beNotEditable;
		                     yourself.

	checkbox := self newCheckBox.
	checkbox
		label: 'Correct';
		state: (task correctness ifNil: [ false ]);
		whenActivatedDo: [ task correctness: true ];
		whenDeactivatedDo: [ task correctness: false ]
]

{ #category : #initialization }
OCRETaskValidationPresenter >> setModelBeforeInitialization: aTask [

	task := aTask
]
