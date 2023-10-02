Class {
	#name : #ExperimentResults,
	#superclass : #Object,
	#instVars : [
		'participantResults',
		'emails'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #'as yet unclassified' }
ExperimentResults class >> extractAndOpenResults: dataPath [
	
	^(self extractResults: dataPath) inspect
]

{ #category : #'as yet unclassified' }
ExperimentResults class >> extractResults: dataPath [
	
	^self new extractResultsFromPath: dataPath asFileReference 
]

{ #category : #adding }
ExperimentResults >> addEmail: aString [
	self emails add: aString.
	aString crTrace
]

{ #category : #adding }
ExperimentResults >> addPersonalDataSurvey: aDSSurveyRecord [

	aDSSurveyRecord ifNil: [ ^ self ].
	self addEmail: aDSSurveyRecord survey questions third answer.
	aDSSurveyRecord survey questions third answer: nil
]

{ #category : #accessing }
ExperimentResults >> emails [
	^ emails ifNil:[emails := OrderedCollection new]
]

{ #category : #'data extraction' }
ExperimentResults >> extractResultsFromPath: dataPath [

	participantResults := (dataPath entries select: [ :e | e isDirectory ]) 
		                      collect: [ :dir | 
			                      | data result |
			                      data := OCDbgExampleCode loadDataFromPath:
				                              dir.
			                      result := ParticipantResult newFromData: data.
			                      result participant surveys:
				                      (self extractSurveysFromData: data).
			                      result ].
	^ self
]

{ #category : #'data extraction' }
ExperimentResults >> extractSurveysFromData: data [

	| surveys |
	surveys := data select: [ :e | e class = DSSurveyRecord ].
	self addPersonalDataSurvey:
		(surveys
			 detect: [ :s | s survey questions size = 4 ]
			 ifNone: [ nil ]).

	^ surveys
]

{ #category : #accessing }
ExperimentResults >> participantResults [

	^ participantResults
]

{ #category : #accessing }
ExperimentResults >> participantResults: anObject [

	participantResults := anObject
]
