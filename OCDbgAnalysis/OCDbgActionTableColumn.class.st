Class {
	#name : 'OCDbgActionTableColumn',
	#superclass : 'SpLinkTableColumn',
	#category : 'OCDbgAnalysis-Presenters',
	#package : 'OCDbgAnalysis',
	#tag : 'Presenters'
}

{ #category : 'visiting' }
OCDbgActionTableColumn >> acceptColumnVisitor: aBuilder [

	^ aBuilder visitOCDbgActionColumn: self
]

{ #category : 'testing' }
OCDbgActionTableColumn >> getColor [
 ^Color red
]

{ #category : 'testing' }
OCDbgActionTableColumn >> isOn [
 ^true
]
