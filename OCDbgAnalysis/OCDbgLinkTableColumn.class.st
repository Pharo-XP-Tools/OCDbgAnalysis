Class {
	#name : 'OCDbgLinkTableColumn',
	#superclass : 'SpLinkTableColumn',
	#traits : 'SpTDecoratedText',
	#classTraits : 'SpTDecoratedText classTrait',
	#category : 'OCDbgAnalysis-Presenters',
	#package : 'OCDbgAnalysis',
	#tag : 'Presenters'
}

{ #category : 'visiting' }
OCDbgLinkTableColumn >> acceptColumnVisitor: aBuilder [

	^ aBuilder visitOCDbgLinkColumn: self
]
