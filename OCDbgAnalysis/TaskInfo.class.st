Class {
	#name : #TaskInfo,
	#superclass : #Object,
	#instVars : [
		'title'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
TaskInfo class >> neoJsonMapping: mapper [

	"#time . #correctness . #breakpointsInstalled . #breakpointsHit . #stepsInDebugger . #inspectingObjects . #debuggerOpenings"

	mapper
		for: self
		do: [ :mapping | mapping mapInstVars: #( title ) ]
]

{ #category : #'instance creation' }
TaskInfo class >> newForTask: dstask fromData: aCollection [

	^ self new
		  title: dstask title;
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
TaskInfo >> title [

	^ title
]

{ #category : #accessing }
TaskInfo >> title: anObject [

	title := anObject
]
