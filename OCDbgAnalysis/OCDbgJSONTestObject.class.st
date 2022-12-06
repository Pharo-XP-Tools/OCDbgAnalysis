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
OCDbgJSONTestObject >> = another [

	another == self ifTrue: [ ^ true ].
	another a = a ifFalse: [ ^ false ].
	another b = b ifFalse: [ ^ false ].
	^ another c = c
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
