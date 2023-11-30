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
		'manualRevisionSuccess',
		'order',
		'answer',
		'events',
		'valid',
		'testSuccess',
		'correctness',
		'testSuccessRaw',
		'alternateDuration',
		'rawDuration',
		'retainedIdleTime'
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
	taskStats recomputeDurationWithoutTaskAnswerTime.
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
TaskStats >> alternateDuration [

	^ alternateDuration ifNil:[self recomputeDurationWithoutTaskAnswerTime]
]

{ #category : #accessing }
TaskStats >> answer [
	^ answer
]

{ #category : #accessing }
TaskStats >> asSeconds [

	^ (DSRecordHistory on: events) collectTimeDiscrepancies
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
TaskStats >> calculateInterruptionTimes [

	^ (DSRecordHistory on: events) detectTimeDiscrepancies
]

{ #category : #accessing }
TaskStats >> collectTimeDiscrepancies [

	^ (DSRecordHistory on: events) collectTimeDiscrepancies
]

{ #category : #accessing }
TaskStats >> correctness [
	^correctness 
]

{ #category : #accessing }
TaskStats >> correctness: aBoolean [

	correctness := aBoolean
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
TaskStats >> events [

	^ events
]

{ #category : #api }
TaskStats >> forceValid [
	valid := true
]

{ #category : #accessing }
TaskStats >> inspectingObjects [

	^ inspectingObjects
]

{ #category : #accessing }
TaskStats >> inspectingObjects: anObject [

	inspectingObjects := anObject
]

{ #category : #testing }
TaskStats >> isValid [

	^ valid ifNil: [ valid := true ]
]

{ #category : #accessing }
TaskStats >> manualRevisionSuccess [

	^ manualRevisionSuccess
]

{ #category : #accessing }
TaskStats >> manualRevisionSuccess: anObject [

	manualRevisionSuccess := anObject
]

{ #category : #api }
TaskStats >> notValid [
	valid := false
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
TaskStats >> rawDuration [

	^ rawDuration ifNil:[rawDuration := duration]
]

{ #category : #'as yet unclassified' }
TaskStats >> recomputeDurationWithoutTaskAnswerTime [

	| finishTaskEvents |
	rawDuration := duration.
	finishTaskEvents := events select: [ :e |
		                    (e isKindOf: DSWindowOpenedRecord) and: [
			                    'Finish task ' , taskInfo title , '*' match:
				                    e windowName asString ] ].
	finishTaskEvents isEmpty ifTrue: [
		^ alternateDuration := rawDuration ].
	^ alternateDuration := finishTaskEvents last dateTime
	                       - events first dateTime
]

{ #category : #accessing }
TaskStats >> retainedIdleTime [

	^ retainedIdleTime ifNil:[retainedIdleTime := self calculateInterruptionTimes]
]

{ #category : #accessing }
TaskStats >> retainedIdleTime: anObject [

	retainedIdleTime := anObject
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
TaskStats >> taskName [
	^taskInfo title
]

{ #category : #accessing }
TaskStats >> testSuccess [

	^ testSuccess
]

{ #category : #accessing }
TaskStats >> testSuccess: anObject [

	testSuccess := anObject
]

{ #category : #accessing }
TaskStats >> testSuccessRaw [

	^ testSuccessRaw
]

{ #category : #accessing }
TaskStats >> testSuccessRaw: anObject [

	testSuccessRaw := anObject
]

{ #category : #accessing }
TaskStats >> useConsolidatedTimes [

	duration := self alternateDuration - self retainedIdleTime asSeconds
]

{ #category : #accessing }
TaskStats >> useRawTimes [
	duration := self rawDuration 
]
