"
I hold the dependant variables model for the usage of a specific tool
"
Class {
	#name : #PhexToolUsageResults,
	#superclass : #PhexAnalysisResult,
	#instVars : [
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
PhexToolUsageResults >> analyzedVariables [

	^ {
		  timeDV.
		  actionsDV.
		  occurencesDV }
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
PhexToolUsageResults >> timeDV [

	^ timeDV
]

{ #category : #accessing }
PhexToolUsageResults >> timeDV: anObject [

	timeDV := anObject
]
