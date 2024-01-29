"
I provide a check with an aspect of a task, e.g., its validity.

The comment field describe why the decision was made.
"
Class {
	#name : #PhexTaskCheck,
	#superclass : #Object,
	#instVars : [
		'task',
		'comment'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #'instance creation' }
PhexTaskCheck class >> onTaskResult: aPhexTaskResult [

	^ self new
		  task: aPhexTaskResult;
		  yourself
]

{ #category : #accessing }
PhexTaskCheck >> comment [

	^ comment ifNil:[comment := String new]
]

{ #category : #accessing }
PhexTaskCheck >> comment: anObject [

	comment := anObject
]

{ #category : #accessing }
PhexTaskCheck >> task [

	^ task
]

{ #category : #accessing }
PhexTaskCheck >> task: anObject [

	task := anObject
]
