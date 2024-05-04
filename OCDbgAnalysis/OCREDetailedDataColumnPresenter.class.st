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
		'data'
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

	data ifEmpty: [ ^ self ].
	average text: data average asFloat.
	stDev text: data stdev asFloat.
	dataSize text: data size.
	dataText text: (String streamContents: [ :str |
			 data do: [ :s |
				 str << s countDebugActions printString.
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
