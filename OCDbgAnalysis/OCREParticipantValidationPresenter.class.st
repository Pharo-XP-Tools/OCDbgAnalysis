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

	layout := SpBoxLayout newTopToBottom.
	participant controlTask ifNotNil: [ :t |
		layout add: (OCRETaskValidationPresenter on: t) ].
	participant treatmentTask ifNotNil: [ :t |
		layout add: (OCRETaskValidationPresenter on: t) ].
	^ layout
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
