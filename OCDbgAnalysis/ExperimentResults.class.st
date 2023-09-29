Class {
	#name : #ExperimentResults,
	#superclass : #Object,
	#instVars : [
		'participantResults'
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

{ #category : #'data extraction' }
ExperimentResults >> extractResultsFromPath: dataPath [

	participantResults := dataPath entries collect: [ :dir | 
		                      | data result |
		                      data := OCDbgExampleCode loadDataFromPath: dir.
		                      result := ParticipantResult newFromData: data.
		                      result participant surveys:
			                      (self extractSurveysFromData: data).
		                      self halt.
		                      result ].
	^ self
]

{ #category : #'data extraction' }
ExperimentResults >> extractSurveysFromData: data [

	^ data select: [ :e | e class = DSSurveyRecord ]
]

{ #category : #accessing }
ExperimentResults >> participantResults [

	^ participantResults
]

{ #category : #accessing }
ExperimentResults >> participantResults: anObject [

	participantResults := anObject
]
