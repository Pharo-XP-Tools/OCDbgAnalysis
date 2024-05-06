"
I hold the dependant variables model for the usage of a specific tool
"
Class {
	#name : #PhexToolUsageResults,
	#superclass : #Object,
	#instVars : [
		'toolName',
		'timeDV',
		'actionsDV',
		'occurencesDV'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #accessing }
PhexToolUsageResults >> actionsDV [

	^ actionsDV
]

{ #category : #accessing }
PhexToolUsageResults >> actionsDV: anObject [

	actionsDV := anObject
]

{ #category : #spec }
PhexToolUsageResults >> chartsFor: aVariable [

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
PhexToolUsageResults >> occurencesDV [

	^ occurencesDV
]

{ #category : #accessing }
PhexToolUsageResults >> occurencesDV: anObject [

	occurencesDV := anObject
]

{ #category : #spec }
PhexToolUsageResults >> presenters [

	| presenters |
	presenters := Dictionary new.
	presenters at: timeDV varName put: {
			(OCREDetailedDataColumnPresenter new
				 title: 'CONTROL';
				 data: timeDV controlData;
				 yourself).
			(OCREDetailedDataColumnPresenter new
				 title: 'TREATMENT';
				 data: timeDV treatmentData;
				 yourself).
			(self chartsFor: timeDV) }.

	presenters at: actionsDV varName put: {
			(OCREDetailedDataColumnPresenter new
				 title: 'CONTROL';
				 data: actionsDV controlData;
				 yourself).
			(OCREDetailedDataColumnPresenter new
				 title: 'TREATMENT';
				 data: actionsDV treatmentData;
				 yourself).
			(self chartsFor: actionsDV) }.

	presenters at: occurencesDV varName put: {
			(OCREDetailedDataColumnPresenter new
				 title: 'CONTROL';
				 data: occurencesDV controlData;
				 yourself).
			(OCREDetailedDataColumnPresenter new
				 title: 'TREATMENT';
				 data: occurencesDV treatmentData;
				 yourself).
			(self chartsFor: occurencesDV) }.
	^ presenters
]

{ #category : #printing }
PhexToolUsageResults >> printOn: aStream [
	aStream << toolName
]

{ #category : #accessing }
PhexToolUsageResults >> timeDV [

	^ timeDV
]

{ #category : #accessing }
PhexToolUsageResults >> timeDV: anObject [

	timeDV := anObject
]

{ #category : #accessing }
PhexToolUsageResults >> toolName [

	^ toolName
]

{ #category : #accessing }
PhexToolUsageResults >> toolName: anObject [

	toolName := anObject
]
