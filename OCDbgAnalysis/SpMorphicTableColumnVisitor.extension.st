Extension { #name : #SpMorphicTableColumnVisitor }

{ #category : #'*OCDbgAnalysis' }
SpMorphicTableColumnVisitor >> visitOCDbgActionColumn: aTableColumn [

	self halt
]

{ #category : #'*OCDbgAnalysis' }
SpMorphicTableColumnVisitor >> visitOCDbgLinkColumn: aTableColumn [

	self visitStringColumn: aTableColumn
]
