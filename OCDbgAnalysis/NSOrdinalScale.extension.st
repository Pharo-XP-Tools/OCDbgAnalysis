Extension { #name : #NSOrdinalScale }

{ #category : #'*OCDbgAnalysis' }
NSOrdinalScale >> correctColors [

	| col |
	col := range asOrderedCollection.
	col addFirst: col third.
	col addFirst: col sixth.
	col removeLast.
	col removeLast.
	range := col asArray
]
