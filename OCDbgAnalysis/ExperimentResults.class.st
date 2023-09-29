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
		                      ParticipantResult newFromData:
			                      (OCDbgExampleCode loadDataFromPath: dir) ].
	^ self
]

{ #category : #accessing }
ExperimentResults >> participantResults [

	^ participantResults
]

{ #category : #accessing }
ExperimentResults >> participantResults: anObject [

	participantResults := anObject
]
