Class {
	#name : #TaskStats,
	#superclass : #Object,
	#instVars : [
		'correctness',
		'breakpointsInstalled',
		'breakpointsHit',
		'stepsInDebugger',
		'inspectingObjects',
		'debuggerOpenings',
		'duration',
		'taskInfo'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
TaskStats class >> neoJsonMapping: mapper [
"#time . #correctness . #breakpointsInstalled . #breakpointsHit . #stepsInDebugger . #inspectingObjects . #debuggerOpenings"
	mapper for: self do: [ :mapping |
		mapping mapInstVars: #(correctness taskInfo).
		(mapping mapInstVar: #duration ) valueSchema: Duration	.
		"(mapping mapInstVar: #points) valueSchema: #ArrayOfPoints.
		(mapping mapInstVar: #bytes) valueSchema: ByteArray "].
	"mapper for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string | DateAndTime fromString: string ].
		mapping encoder: [ :dateAndTime | dateAndTime printString ] ]."
	mapper for: Duration  customDo: [ :mapping |
		self flag: 'the encoding format should match the expected ones from the client (the people reading the json, and therefore, the format expected by the library that consumes the json'.
		mapping decoder: [ :string | Duration fromString: string ].
		mapping encoder: [ :dur | dur printString ""] ].
	"mapper for: #ArrayOfPoints customDo: [ :mapping |
		mapping listOfElementSchema: Point ].  
	mapper mapAllInstVarsFor: Point.
	mapper for: ByteArray customDo: [ :mapping |
		mapping listOfType: ByteArray ]"
]

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
	taskStats taskInfo: (TaskInfo newForTask: task fromData: aCollection).
	^ taskStats
]

{ #category : #comparing }
TaskStats >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class == anObject class ifFalse: [ ^ false ].
	self class slotNames do: [ :each | 
		(self readSlotNamed: each) = (anObject readSlotNamed: each) 
			ifFalse: [ ^ false ] ].
	^ true
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
TaskStats >> duration [

	^ duration
]

{ #category : #accessing }
TaskStats >> duration: anObject [

	duration := anObject
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
TaskStats >> taskInfo [

	^ taskInfo
]

{ #category : #accessing }
TaskStats >> taskInfo: anObject [

	taskInfo := anObject
]
