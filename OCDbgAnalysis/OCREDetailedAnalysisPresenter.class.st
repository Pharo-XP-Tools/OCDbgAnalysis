Class {
	#name : #OCREDetailedAnalysisPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'diagramsPresenter',
		'controlDataPresenter',
		'treatmentDataPresenter',
		'metricData',
		'metricsPresenters'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #layout }
OCREDetailedAnalysisPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
]

{ #category : #accessing }
OCREDetailedAnalysisPresenter >> metricData: anObject [

	metricData := anObject.
	metricsPresenters := metricData presenters
]

{ #category : #updating }
OCREDetailedAnalysisPresenter >> updateData [

	| newLayout subLayout |
	metricData ifNil: [ ^ self ].
	metricsPresenters values flattened do: #fillPresenters.
	newLayout := SpBoxLayout newLeftToRight.
	
	metricsPresenters keysAndValuesDo: [ :var :presenters |
		| subsubLayout |
		subsubLayout := SpBoxLayout newLeftToRight.
		subLayout := SpBoxLayout newTopToBottom.
		subLayout
			add: (SpLabelPresenter new
					 label: var varName;
					 addStyle: 'flat';
					 addStyle: 'title';
					 yourself) expand: false fill: false padding: 5.
		subLayout add: (self newText text: (var printSummary); yourself) height: 70.			
		subsubLayout add: presenters first expand: true fill: true.
		subsubLayout add: presenters second expand: true fill: true.
		subLayout add: subsubLayout.
		subLayout add: presenters last.
		newLayout add: subLayout expand: true fill: true padding: 4 ].

	self layout: newLayout
]
