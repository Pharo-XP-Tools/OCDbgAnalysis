Class {
	#name : #ExperimentToolsUsageExport,
	#superclass : #Object,
	#instVars : [
		'results',
		'filename'
	],
	#category : #'OCDbgAnalysis-Exports'
}

{ #category : #private }
ExperimentToolsUsageExport >> computeMetricsPerTask: aTask [

	| metrics |
	
	aTask ifNil: [ ^ OrderedCollection new ].
	
	metrics := OrderedCollection new.
	metrics addAll:((self computeTaskWindowsByType: aTask) flatCollect: [ :g |
		self computeMetricsPerWindowGroup: g forTask: aTask		
	]).
	metrics add: (self removeNonWhitespaces: aTask title , '_Condition') -> aTask type.

	^ metrics 
]

{ #category : #private }
ExperimentToolsUsageExport >> computeMetricsPerWindowGroup: aGroup forTask: aTask [

	| type | 
	aGroup value ifEmpty: [ self error: 'Cannot calculate metrics for an empty group' ].

	type := self removeNonWhitespaces: aTask title, ' ', aGroup key.

	^ {  
		type , '-time' ->	(PhexToolTimeCalculator compute: aGroup value). 
		type, '-actions' ->	(PhexToolActionsCalculator compute: aGroup value).
		type, '-usage' ->	(PhexToolUsageCalculator compute: aGroup value).
	}
]

{ #category : #private }
ExperimentToolsUsageExport >> computeTaskWindowsByType: aTask [

	| windows |

	windows := aTask 
		ifNotNil: [ :t | (t eventsHistory windows groupedBy: #type) associations ] 
		ifNil: [ OrderedCollection new ].
	
	^ 	windows sort: [ :a :b | a key < b key ]
]

{ #category : #accessing }
ExperimentToolsUsageExport >> filename [

	^ filename
]

{ #category : #accessing }
ExperimentToolsUsageExport >> filename: aFilename [

	filename := aFilename
]

{ #category : #removing }
ExperimentToolsUsageExport >> removeNonWhitespaces: aString [

	^ ('[\w|-]+' asRegex matchesIn: aString) joinUsing: '_'
]

{ #category : #accessing }
ExperimentToolsUsageExport >> results [

	^ results
]

{ #category : #accessing }
ExperimentToolsUsageExport >> results: anObject [

	results := anObject
]

{ #category : #services }
ExperimentToolsUsageExport >> save [

	| table  |

	table := CSVTable new.
	
	results participations do: [ :p |
		(self computeMetricsPerTask: p controlTask) ifNotEmpty: [ :r | 
			table newRow: r.
		].
		(self computeMetricsPerTask: p treatmentTask) ifNotEmpty: [ :r | 
			table newRow: r.
		]	
	].
	
	filename asFileReference writeStreamDo: [ :s | 
		table writeOn: s
	]
	

]
