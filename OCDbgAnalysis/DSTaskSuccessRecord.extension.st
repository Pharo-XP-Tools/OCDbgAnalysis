Extension { #name : #DSTaskSuccessRecord }

{ #category : #'*OCDbgAnalysis' }
DSTaskSuccessRecord >> successBoolean [

	"#success sometimes contains an array. This method ensured that a boolean is returned"

	success ifNil: [ ^ false ].
	(success isKindOf: Boolean) ifTrue: [ ^ success ].
	(success isCollection and: [ 
		 success isSequenceable and: [ success size > 1 ] ]) ifTrue: [ 
		| sec |
		sec := success second.
		(sec isKindOf: Boolean) ifTrue: [ ^ sec ] ].
	^ false
]
