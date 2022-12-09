Class {
	#name : #TaskInfo,
	#superclass : #Object,
	#instVars : [
		'title',
		'index',
		'dstask'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
TaskInfo class >> neoJsonMapping: mapper [

	"#time . #correctness . #breakpointsInstalled . #breakpointsHit . #stepsInDebugger . #inspectingObjects . #debuggerOpenings"

	mapper
		for: self
		do: [ :mapping | mapping mapInstVars: #( title index ) ]
]

{ #category : #'instance creation' }
TaskInfo class >> newForTask: dstask fromData: aCollection [

	"task is DSTask"

	| tasks index |
	tasks := (aCollection ocdSelectTasksEnding sorted: [ :t1 :t2 | 
		          t1 dateTime < t2 dateTime ]) collect: [ :ds | ds task ].
	index := tasks find: dstask.
	^ self new
		  title: dstask title;
		  index: index;
		  yourself
]

{ #category : #comparing }
TaskInfo >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class == anObject class ifFalse: [ ^ false ].
	self title = anObject title ifFalse: [ ^ false ].
	self index = anObject index ifFalse: [ ^ false ].
	^ true
]

{ #category : #accessing }
TaskInfo >> dstask [

	^ dstask
]

{ #category : #accessing }
TaskInfo >> dstask: anObject [

	dstask := anObject
]

{ #category : #accessing }
TaskInfo >> index [

	^ index
]

{ #category : #accessing }
TaskInfo >> index: anObject [

	index := anObject
]

{ #category : #accessing }
TaskInfo >> title [

	^ title
]

{ #category : #accessing }
TaskInfo >> title: anObject [

	title := anObject
]
