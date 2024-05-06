"
I hold the dependant variables model for a specific analysis
"
Class {
	#name : #PhexAnalysisResult,
	#superclass : #Object,
	#instVars : [
		'analysisName'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #accessing }
PhexAnalysisResult >> analysisName [

	^ analysisName
]

{ #category : #accessing }
PhexAnalysisResult >> analysisName: anObject [

	analysisName := anObject
]

{ #category : #spec }
PhexAnalysisResult >> chartsFor: aVariable [

	| layout c t barChart dataViolins |
	layout := SpBoxLayout newLeftToRight.

	c := aVariable controlData collect: #rawValue.
	t := aVariable treatmentData collect: #rawValue.

	barChart := (RSBarPlot barHeights: {c average asFloat. t average asFloat }) 
								 errors: (ExperimentResults confidenceIntervals: { c. t }).

	barChart horizontalTick fromNames: #( 'control' 'treatment' ).
	barChart title: aVariable varName , ' 95% CI'.

	layout add: barChart asPresenter.

	dataViolins := RSViolinPlot data: { c. t }.

	dataViolins xTickLabels: #( 'control' 'treatment' ).
	dataViolins title: aVariable varName.
	dataViolins bandwidth: 50.
	layout add: dataViolins asPresenter.

	^ layout
]

{ #category : #accessing }
PhexAnalysisResult >> presenters [

	| presenters |
	presenters := Dictionary new.
	self analyzedVariables do: [ :v |
		presenters at: v varName put: {
				(OCREDetailedDataColumnPresenter new
					 title: 'CONTROL';
					 data: v controlData;
					 yourself).
				(OCREDetailedDataColumnPresenter new
					 title: 'TREATMENT';
					 data: v treatmentData;
					 yourself).
				(self chartsFor: v) } ].
	^ presenters
]

{ #category : #printing }
PhexAnalysisResult >> printOn: aStream [
	aStream << analysisName
]
