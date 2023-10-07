Class {
	#name : #OCDbgLinkTableColumn,
	#superclass : #SpLinkTableColumn,
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #visiting }
OCDbgLinkTableColumn >> acceptColumnVisitor: aBuilder [

	^ aBuilder visitOCDbgLinkColumn: self
]
