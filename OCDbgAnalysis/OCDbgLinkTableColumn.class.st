Class {
	#name : #OCDbgLinkTableColumn,
	#superclass : #SpLinkTableColumn,
	#traits : 'SpTDecoratedText',
	#classTraits : 'SpTDecoratedText classTrait',
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #visiting }
OCDbgLinkTableColumn >> acceptColumnVisitor: aBuilder [

	^ aBuilder visitOCDbgLinkColumn: self
]
