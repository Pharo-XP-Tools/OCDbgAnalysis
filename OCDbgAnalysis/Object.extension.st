Extension { #name : #Object }

{ #category : #'*OCDbgAnalysis' }
Object >> asJSON [

	"Should test later recursive serialization"
	
	^ String streamContents: [ :stream | 
		  (NeoJSONWriter on: stream)
			  prettyPrint: true;
			  mapInstVarsFor: self class;
			  nextPut: self ]

	
]

{ #category : #'*OCDbgAnalysis' }
Object class >> newFromJSON: aString [

	^ (NeoJSONReader on: aString readStream)
		  mapInstVarsFor: self;
		  nextAs: self
]
