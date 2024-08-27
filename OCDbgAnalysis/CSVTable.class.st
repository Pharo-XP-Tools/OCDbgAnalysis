Class {
	#name : #CSVTable,
	#superclass : #Object,
	#instVars : [
		'table'
	],
	#category : #'OCDbgAnalysis-Exports'
}

{ #category : #translating }
CSVTable >> headers [

	^ (self rows flatCollect: [ :r | r asDictionary keys ]) asSet.
	
	
]

{ #category : #initialization }
CSVTable >> initialize [

	table := OrderedCollection new
]

{ #category : #'instance creation' }
CSVTable >> newRow [

	| row |
	
	row := OrderedCollection new.	
	
	table add: row.
	
	^ row
]

{ #category : #'instance creation' }
CSVTable >> newRow: aAssociations [

	^ self newRow 
		addAll: aAssociations;
		yourself.
]

{ #category : #'instance creation' }
CSVTable >> rows [

	^ table
]

{ #category : #translating }
CSVTable >> writeOn: aWriteStream [

	| headers items |
	
	headers := (self headers sorted collect: [ :h | h -> String empty ]) asOrderedDictionary.

	aWriteStream nextPutAll: (headers keys joinUsing: ';').
	aWriteStream cr.
	self rows do: [ :r |
		items := headers copy.
		items addAll: r asDictionary.
		aWriteStream nextPutAll: (items values joinUsing: ';').	
		aWriteStream cr.
	]
]
