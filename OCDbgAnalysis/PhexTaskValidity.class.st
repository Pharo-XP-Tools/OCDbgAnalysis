"
I tell if a phex task is valid (true) or not (false).
By default, I am valid (true).

"
Class {
	#name : #PhexTaskValidity,
	#superclass : #PhexTaskCheck,
	#instVars : [
		'isValid'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #accessing }
PhexTaskValidity >> computeValidity [

	| usedOCBP |
	usedOCBP := task eventsHistory breakpointEvents anySatisfy: [ :bp |
		            bp objectCentric ].

	"Initially, a task is valid if it is a control task, or if it is a treatment task with object-centric breakpoints.
	The validity of tasks should be defined in each experiment model instance instead."
	isValid := task type = #control or: [ usedOCBP ].
	isValid ifTrue: [ ^ isValid ].
	usedOCBP ifFalse: [
		comment := 'The treatment tool was not used (automatically detected)' ].
	^ isValid
]

{ #category : #accessing }
PhexTaskValidity >> isValid [

	^ isValid ifNil: [ self computeValidity ]
]

{ #category : #accessing }
PhexTaskValidity >> isValid: aBoolean [

	isValid := aBoolean
]
