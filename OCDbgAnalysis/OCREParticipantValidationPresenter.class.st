Class {
	#name : #OCREParticipantValidationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'participant',
		'experimentResultsBrowser'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #'accessing - model' }
OCREParticipantValidationPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (OCRETaskValidationPresenter on: participant tasks first);
		  add: (OCRETaskValidationPresenter on: participant tasks last);
		  yourself
]

{ #category : #accessing }
OCREParticipantValidationPresenter >> experimentResultsBrowser: anObject [

	experimentResultsBrowser := anObject
]

{ #category : #initialization }
OCREParticipantValidationPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Are the answers correct?';
		whenClosedDo: [ experimentResultsBrowser update ]
]

{ #category : #'accessing - model' }
OCREParticipantValidationPresenter >> setModelBeforeInitialization: aParticipantResult [

	participant := aParticipantResult
]
