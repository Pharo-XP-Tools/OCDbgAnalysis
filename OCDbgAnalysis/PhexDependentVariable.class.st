"
I model a dependant variable with its data.
I depend on a context, e.g., I can be a dependant variable measure in the context of the usage of a specific tool.
"
Class {
	#name : #PhexDependentVariable,
	#superclass : #Object,
	#instVars : [
		'varName',
		'data'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #accessing }
PhexDependentVariable class >> actions: data [

	^ self new
		  varName: 'Actions';
		  data: data;
		  yourself
]

{ #category : #accessing }
PhexDependentVariable class >> time: data [

	^ self new
		  varName: 'Time';
		  data: data;
		  yourself
]

{ #category : #accessing }
PhexDependentVariable class >> usage: data [

	^ self new
		  varName: 'Tool usage';
		  data: data;
		  yourself
]

{ #category : #accessing }
PhexDependentVariable >> data [

	^ data
]

{ #category : #accessing }
PhexDependentVariable >> data: anObject [

	data := anObject
]

{ #category : #printing }
PhexDependentVariable >> printOn: aStream [
	aStream << 'Dependant variable:'.
	aStream space.
	aStream << varName
]

{ #category : #accessing }
PhexDependentVariable >> varName [

	^ varName
]

{ #category : #accessing }
PhexDependentVariable >> varName: anObject [

	varName := anObject
]
