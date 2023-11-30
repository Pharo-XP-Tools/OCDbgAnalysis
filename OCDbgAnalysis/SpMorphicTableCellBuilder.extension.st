Extension { #name : #SpMorphicTableCellBuilder }

{ #category : #'*OCDbgAnalysis' }
SpMorphicTableCellBuilder >> visitOCDbgActionColumn: aTableColumn [

	| morph |
	morph := (SpPluggableButtonMorph on: aTableColumn)
		         actionBlock: [ aTableColumn action value: self item ];
		         icon: (aTableColumn readObject: self item);
		         label: ' ';
		         yourself.

	morph backgroundColor: Color transparent.
	morph color: Color transparent.
	
	self addCellMorph: morph column: aTableColumn
]

{ #category : #'*OCDbgAnalysis' }
SpMorphicTableCellBuilder >> visitOCDbgLinkColumn: aTableColumn [

	| presenter morph |
	presenter := SpLinkPresenter new
		             addStyle: 'table';
		             label: (aTableColumn readObject: self item);
		             yourself.

	aTableColumn url ifNotNil: [
		presenter url: (aTableColumn url value: self item) ].
	aTableColumn action ifNotNil: [
		presenter action: [ aTableColumn action value: self item ] ].
	
	morph := presenter build.
	presenter color: (aTableColumn displayColor value: self item).
	presenter adapter color: (aTableColumn displayColor value: self item).
	presenter adapter applyStyle: morph.
 
	self addCellMorph: morph column: aTableColumn
]
