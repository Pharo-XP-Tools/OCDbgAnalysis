"
I hold the dependant variables model for the main DV analysis of Phex xp
"
Class {
	#name : #PhexTaskDVResults,
	#superclass : #PhexAnalysisResult,
	#instVars : [
		'timeDV',
		'actionsDV',
		'correctnessDV'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #accessing }
PhexTaskDVResults >> actionsDV [

	^ actionsDV
]

{ #category : #accessing }
PhexTaskDVResults >> actionsDV: anObject [

	actionsDV := anObject
]

{ #category : #spec }
PhexTaskDVResults >> analyzedVariables [

	^ {
		  timeDV.
		  actionsDV.
		  "correctnessDV "}
]

{ #category : #accessing }
PhexTaskDVResults >> correctnessDV [

	^ correctnessDV
]

{ #category : #accessing }
PhexTaskDVResults >> correctnessDV: anObject [

	correctnessDV := anObject
]

{ #category : #accessing }
PhexTaskDVResults >> timeDV [

	^ timeDV
]

{ #category : #accessing }
PhexTaskDVResults >> timeDV: anObject [

	timeDV := anObject
]
