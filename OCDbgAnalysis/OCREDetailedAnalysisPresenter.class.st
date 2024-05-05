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
		  add: controlDataPresenter expand: true fill: true;
		  add: treatmentDataPresenter expand: true fill: true;
		  yourself
]

{ #category : #initialization }
OCREDetailedAnalysisPresenter >> initializePresenters [

	controlDataPresenter := OCREDetailedDataColumnPresenter new.
	controlDataPresenter title: 'CONTROL'.
	treatmentDataPresenter := OCREDetailedDataColumnPresenter new.
	treatmentDataPresenter title: 'TREATMENT'
	
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

	metricsPresenters keysAndValuesDo: [ :title :presenters |
		| subsubLayout |
		subsubLayout := SpBoxLayout newLeftToRight.
		subLayout := SpBoxLayout newTopToBottom.
		subLayout add: title asText allBold expand: false fill: false.
		presenters do: [ :p | subsubLayout add: p expand: true fill: true ].
		subLayout add: subsubLayout.
		newLayout add: subLayout ].

	self layout: newLayout
]
