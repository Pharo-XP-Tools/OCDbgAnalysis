Class {
	#name : #ExperimentResultsExport,
	#superclass : #Object,
	#instVars : [
		'results'
	],
	#category : #'OCDbgAnalysis-Exports'
}

{ #category : #accessing }
ExperimentResultsExport >> results [

	^ results
]

{ #category : #accessing }
ExperimentResultsExport >> results: anObject [

	results := anObject
]

{ #category : #'as yet unclassified' }
ExperimentResultsExport >> toolUsagePerParticipation [

	^ ExperimentToolsUsageExport new 
		results: results; 
		yourself.
]
