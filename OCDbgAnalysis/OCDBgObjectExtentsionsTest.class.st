Class {
	#name : #OCDBgObjectExtentsionsTest,
	#superclass : #TestCase,
	#category : #'OCDbgAnalysis-Tests'
}

{ #category : #tests }
OCDBgObjectExtentsionsTest >> testAsJSONandNewFromJSON [

	| obj json |
	obj := OCDbgJSONTestObject new
		       a: 1;
		       b: 2;
		       yourself.
	json := obj asJSON.
	self assert: (OCDbgJSONTestObject newFromJSON: json) equals: obj.
	obj c: 2.
	self deny: (OCDbgJSONTestObject newFromJSON: json) equals: obj
]
