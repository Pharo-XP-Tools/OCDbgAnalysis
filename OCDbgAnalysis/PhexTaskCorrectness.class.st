"
I tell if a phex task is correct (true) or not (false).
By default, I am neither correct or incorrect and isCorrect returns nil.

"
Class {
	#name : #PhexTaskCorrectness,
	#superclass : #PhexTaskCheck,
	#instVars : [
		'isCorrect',
		'correctnessTest'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #accessing }
PhexTaskCorrectness >> correctnessTest [

	^ correctnessTest ifNil: [
		  correctnessTest := (task events
			                      detect: [ :evt |
			                      evt class = DSTaskSuccessRecord ]
			                      ifNone: [ nil ])
			                     ifNil: [ false ]
			                     ifNotNil: [ :e | e successBoolean ] ]
]

{ #category : #accessing }
PhexTaskCorrectness >> correctnessTest: anObject [

	correctnessTest := anObject
]

{ #category : #accessing }
PhexTaskCorrectness >> isCorrect [

	^ isCorrect
]

{ #category : #accessing }
PhexTaskCorrectness >> isCorrect: anObject [

	isCorrect := anObject
]
