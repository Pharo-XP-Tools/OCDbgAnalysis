Class {
	#name : #TaskStats,
	#superclass : #Object,
	#instVars : [
		'breakpointsAdded',
		'breakpointsRemoved',
		'breakpointsHit',
		'ocBreakpointsAdded',
		'ocBreakpointsRemoved',
		'ocBreakpointsHit',
		'stepActions',
		'inspectingObjects',
		'debuggerOpenings',
		'duration',
		'taskInfo',
		'testSucess',
		'testSucessRaw',
		'manualRevisionSuccess',
		'order',
		'answer'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
TaskStats class >> neoJsonMapping: mapper [
"#time . #correctness . #breakpointsAdded . #breakpointsHit . #stepsInDebugger . #inspectingObjects . #debuggerOpenings"
	mapper for: self do: [ :mapping |
		mapping mapInstVars: #(taskInfo breakpointsAdded breakpointsHit breakpointsRemoved ocBreakpointsAdded ocBreakpointsHit ocBreakpointsRemoved stepActions order).
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
TaskStats >> breakpointsAdded [

	^ breakpointsAdded
]

{ #category : #accessing }
TaskStats >> breakpointsAdded: anObject [

	breakpointsAdded := anObject
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
TaskStats >> breakpointsRemoved [

	^ breakpointsRemoved
]

{ #category : #accessing }
TaskStats >> breakpointsRemoved: anObject [

	breakpointsRemoved := anObject
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
TaskStats >> manualRevisionSuccess [

	^ manualRevisionSuccess
]

{ #category : #accessing }
TaskStats >> manualRevisionSuccess: anObject [

	manualRevisionSuccess := anObject
]

{ #category : #accessing }
TaskStats >> ocBreakpointsAdded [

	^ ocBreakpointsAdded
]

{ #category : #accessing }
TaskStats >> ocBreakpointsAdded: anObject [

	ocBreakpointsAdded := anObject
]

{ #category : #accessing }
TaskStats >> ocBreakpointsHit [

	^ ocBreakpointsHit
]

{ #category : #accessing }
TaskStats >> ocBreakpointsHit: anObject [

	ocBreakpointsHit := anObject
]

{ #category : #accessing }
TaskStats >> ocBreakpointsRemoved [

	^ ocBreakpointsRemoved
]

{ #category : #accessing }
TaskStats >> ocBreakpointsRemoved: anObject [

	ocBreakpointsRemoved := anObject
]

{ #category : #accessing }
TaskStats >> order [

	^ order
]

{ #category : #accessing }
TaskStats >> order: anObject [

	order := anObject
]

{ #category : #printing }
TaskStats >> printOn: aStream [

	aStream << taskInfo title.
	aStream space.
	aStream << ' ('.
	duration printOn: aStream.
	aStream << ')'
]

{ #category : #accessing }
TaskStats >> stepActions [

	^ stepActions
]

{ #category : #accessing }
TaskStats >> stepActions: anObject [

	stepActions := anObject
]

{ #category : #accessing }
TaskStats >> taskInfo [

	^ taskInfo
]

{ #category : #accessing }
TaskStats >> taskInfo: anObject [

	taskInfo := anObject
]

{ #category : #accessing }
TaskStats >> testSucess [

	^ testSucess
]

{ #category : #accessing }
TaskStats >> testSucess: anObject [

	testSucess := anObject
]

{ #category : #accessing }
TaskStats >> testSucessRaw [

	^ testSucessRaw
]

{ #category : #accessing }
TaskStats >> testSucessRaw: anObject [

	testSucessRaw := anObject
]
