Class {
	#name : #TaskStats,
	#superclass : #Object,
	#instVars : [
		'time',
		'correctness',
		'breakpointsInstalled',
		'breakpointsHit',
		'stepsInDebugger',
		'inspectingObjects',
		'debuggerOpenings'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #'instance creation' }
TaskStats class >> newForTask: task fromData: aCollection [

	"task is a DSTask"

	| taskStats |
	taskStats := self new.
	MetricExtractor allSubclassesDo: [ :s | 
		| extractor |
		extractor := s newForTask: task fromData: aCollection.
		taskStats
			writeSlotNamed: extractor targetField
			value: extractor extract ].
	^ taskStats
]

{ #category : #accessing }
TaskStats >> breakpointsHit [

	^ breakpointsHit
]

{ #category : #accessing }
TaskStats >> breakpointsHit: anObject [

	breakpointsHit := anObject
]

{ #category : #accessing }
TaskStats >> breakpointsInstalled [

	^ breakpointsInstalled
]

{ #category : #accessing }
TaskStats >> breakpointsInstalled: anObject [

	breakpointsInstalled := anObject
]

{ #category : #accessing }
TaskStats >> correctness [

	^ correctness
]

{ #category : #accessing }
TaskStats >> correctness: anObject [

	correctness := anObject
]

{ #category : #accessing }
TaskStats >> debuggerOpenings [

	^ debuggerOpenings
]

{ #category : #accessing }
TaskStats >> debuggerOpenings: anObject [

	debuggerOpenings := anObject
]

{ #category : #accessing }
TaskStats >> inspectingObjects [

	^ inspectingObjects
]

{ #category : #accessing }
TaskStats >> inspectingObjects: anObject [

	inspectingObjects := anObject
]

{ #category : #accessing }
TaskStats >> stepsInDebugger [

	^ stepsInDebugger
]

{ #category : #accessing }
TaskStats >> stepsInDebugger: anObject [

	stepsInDebugger := anObject
]

{ #category : #accessing }
TaskStats >> time [

	^ time
]

{ #category : #accessing }
TaskStats >> time: anObject [

	time := anObject
]
