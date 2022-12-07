Class {
	#name : #OCDbgJSONTestObject,
	#superclass : #Object,
	#instVars : [
		'a',
		'b',
		'c'
	],
	#category : #'OCDbgAnalysis-Tests'
}

{ #category : #comparing }
OCDbgJSONTestObject >> = anObject [

	anObject == self ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	anObject a = a ifFalse: [ ^ false ].
	anObject b = b ifFalse: [ ^ false ].
	^ anObject c = c
]

{ #category : #accessing }
OCDbgJSONTestObject >> a [

	^ a
]

{ #category : #accessing }
OCDbgJSONTestObject >> a: anObject [

	a := anObject
]

{ #category : #accessing }
OCDbgJSONTestObject >> b [

	^ b
]

{ #category : #accessing }
OCDbgJSONTestObject >> b: anObject [

	b := anObject
]

{ #category : #accessing }
OCDbgJSONTestObject >> c [

	^ c
]

{ #category : #accessing }
OCDbgJSONTestObject >> c: anObject [

	c := anObject
]
