"
I present data from the OCRE experiment in a formatted column.
"
Class {
	#name : #OCREDetailedDataColumnPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'dataText',
		'dataSize',
		'average',
		'stDev',
		'data',
		'title'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #accessing }
OCREDetailedDataColumnPresenter >> data: aCollection [
	data := aCollection.
	
]

{ #category : #layout }
OCREDetailedDataColumnPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
				   add: title;
				   add: '';
				   yourself)
		  expand: false fill: false;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Data size';
				   add: dataSize;
				   yourself)
		  expand: false fill: false;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Average';
				   add: average;
				   yourself)
		  expand: false fill: false;
		  add: (SpBoxLayout newLeftToRight
				   add: 'StDev';
				   add: stDev;
				   yourself)
		  expand: false fill: false;
		  add: dataText expand: true fill: true;
		  yourself
]

{ #category : #initialize }
OCREDetailedDataColumnPresenter >> fillPresenters [

	data ifNil: [ ^ self ].
	data isEmpty ifTrue: [  ^self] .
	average text: ((data collect: #rawValue) average asFloat truncateTo: 0.01 )printString.
	stDev text: ((data collect: #rawValue) stdev asFloat truncateTo: 0.01) printString.
	dataSize text: data size printString.
	dataText text: (String streamContents: [ :str |
			(data collect: #value)  do: [ :s |
				 str << (s rawValue truncateTo: 0.01) printString.
				 str cr ] ])
]

{ #category : #initialize }
OCREDetailedDataColumnPresenter >> initializePresenters [

	data := OrderedCollection new.
	average := self newTextInput
		           editable: false;
		           yourself.
	dataSize := self newTextInput
		            editable: false;
		            yourself.
	stDev := self newTextInput
		         editable: false;
		         yourself.

	dataText := self newText
		            editable: false;
		            yourself.
	self fillPresenters
]

{ #category : #accessing }
OCREDetailedDataColumnPresenter >> title: aString [

	title := aString
]
