Class {
	#name : 'TreatmentTasks',
	#superclass : 'CollectedTasks',
	#category : 'OCDbgAnalysis-ExportModel',
	#package : 'OCDbgAnalysis',
	#tag : 'ExportModel'
}

{ #category : 'adding' }
TreatmentTasks >> addTaskStats: aTaskStat [

	aTaskStat ocBreakpointsAdded > 0 ifFalse: [ aTaskStat notValid ].
	super addTaskStats: aTaskStat
]
