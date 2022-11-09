Extension { #name : #OrderedCollection }

{ #category : #'*OCDbgAnalysis' }
OrderedCollection >> ocdSelectTasksEnding [

	^ OCDbgEventFilters selectTasksEnding: self
]

{ #category : #'*OCDbgAnalysis' }
OrderedCollection >> ocdSelectTasksStarting [

	^ OCDbgEventFilters selectTasksStarts: self
]

{ #category : #'*OCDbgAnalysis' }
OrderedCollection >> ocdSelectUnique [

	^ OCDbgEventFilters selectUnique: self
]
