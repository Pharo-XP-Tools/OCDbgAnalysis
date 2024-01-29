Class {
	#name : #CollectedTasks,
	#superclass : #Object,
	#instVars : [
		't1',
		't2',
		'tasks'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #adding }
CollectedTasks >> addTaskStats: aTaskStat [

	aTaskStat isValid ifFalse:[^self].
	aTaskStat taskInfo title = 'Lights Out' ifTrue: [ 
		self t1 add: aTaskStat ].
	aTaskStat taskInfo title = 'Ammolite' ifTrue: [ 
		self t2 add: aTaskStat ]
]

{ #category : #accessing }
CollectedTasks >> t1 [

	^ t1 ifNil:[t1 := OrderedCollection new]
]

{ #category : #accessing }
CollectedTasks >> t1: anObject [

	t1 := anObject
]

{ #category : #accessing }
CollectedTasks >> t2 [

	^ t2 ifNil:[t2 := OrderedCollection new]
]

{ #category : #accessing }
CollectedTasks >> t2: anObject [

	t2 := anObject
]

{ #category : #accessing }
CollectedTasks >> tasks [

	^ tasks
]

{ #category : #accessing }
CollectedTasks >> tasks: anObject [

	tasks := anObject
]
