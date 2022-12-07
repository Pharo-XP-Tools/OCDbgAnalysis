Extension { #name : #OrderedCollection }

{ #category : #'*OCDbgAnalysis' }
OrderedCollection >> ocdSelectTasksEnding [

	^ OCDbgEvents selectTasksEnding: self
]

{ #category : #'*OCDbgAnalysis' }
OrderedCollection >> ocdSelectTasksStarting [

	^ OCDbgEvents selectTasksStarts: self
]

{ #category : #'*OCDbgAnalysis' }
OrderedCollection >> ocdSelectUnique [

	^ OCDbgEvents selectUnique: self
]
