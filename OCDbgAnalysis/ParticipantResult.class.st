Class {
	#name : #ParticipantResult,
	#superclass : #Object,
	#instVars : [
		'tasks'
	],
	#category : #'OCDbgAnalysis-ExportModel'
}

{ #category : #accessing }
ParticipantResult class >> neoJsonMapping: mapper [
	mapper for: self do: [ :mapping |
		mapping mapInstVars: #(tasks)]
]

{ #category : #'instance creation' }
ParticipantResult class >> newFromData: aCollection [

	| result dstasks taskStats |
	result := self new.
	dstasks := aCollection ocdSelectTasksEnding collect: [ :e | e task ].
	taskStats := dstasks collect: [ :dst | 
		             TaskStats newForTask: dst fromData: aCollection ].
	result tasks: taskStats.
	^ result
]

{ #category : #accessing }
ParticipantResult >> tasks [

	^ tasks
]

{ #category : #accessing }
ParticipantResult >> tasks: anObject [

	tasks := anObject
]
