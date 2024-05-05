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

{ #category : #accessing }
PhexToolUsageResults >> occurencesDV [

	^ occurencesDV
]

{ #category : #accessing }
PhexToolUsageResults >> occurencesDV: anObject [

	occurencesDV := anObject
]

{ #category : #accessing }
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
				 yourself) }.

	presenters at: actionsDV varName put: {
			(OCREDetailedDataColumnPresenter new
				 title: 'CONTROL';
				 data: actionsDV controlData;
				 yourself).
			(OCREDetailedDataColumnPresenter new
				 title: 'TREATMENT';
				 data: actionsDV treatmentData;
				 yourself) }.

	presenters at: occurencesDV varName put: {
			(OCREDetailedDataColumnPresenter new
				 title: 'CONTROL';
				 data: occurencesDV controlData;
				 yourself).
			(OCREDetailedDataColumnPresenter new
				 title: 'TREATMENT';
				 data: occurencesDV treatmentData;
				 yourself) }.
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
