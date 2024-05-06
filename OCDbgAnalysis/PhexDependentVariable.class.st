"
I model a dependant variable with its data.
I depend on a context, e.g., I can be a dependant variable measure in the context of the usage of a specific tool.
"
Class {
	#name : #PhexDependentVariable,
	#superclass : #Object,
	#instVars : [
		'varName',
		'data',
		'dvPrinter'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #accessing }
PhexDependentVariable class >> actions: data [

	^ self new
		  varName: 'Actions';
		  data: data;
		  yourself
]

{ #category : #accessing }
PhexDependentVariable class >> time: data [

	^ self new
		  varName: 'Time';
		  data: data;
		  dvPrinter: PhexTaskTimeCalculator;
		  yourself
]

{ #category : #accessing }
PhexDependentVariable class >> usage: data [

	^ self new
		  varName: 'Tool usage';
		  data: data;
		  yourself
]

{ #category : #accessing }
PhexDependentVariable >> controlData [
	^data first
]

{ #category : #accessing }
PhexDependentVariable >> data [

	^ data
]

{ #category : #accessing }
PhexDependentVariable >> data: anObject [

	data := anObject
]

{ #category : #accessing }
PhexDependentVariable >> dvPrinter [

	^ dvPrinter ifNil:[PhexMetricCalculator]
]

{ #category : #accessing }
PhexDependentVariable >> dvPrinter: anObject [

	dvPrinter := anObject
]

{ #category : #printing }
PhexDependentVariable >> printOn: aStream [
	aStream << 'Dependant variable:'.
	aStream space.
	aStream << varName
]

{ #category : #accessing }
PhexDependentVariable >> printSummary [

	|cResult tResult ratio|
	cResult := (self controlData collect: #rawValue) average. 
	tResult := (self treatmentData collect: #rawValue) average. 
	ratio := (tResult/cResult) - 1.
	^String streamContents: [ :str|
		
		str << 'control average = '.
		str << (self dvPrinter phexPrint: cResult).
		str cr.
		str << 'treatment average = '.
		str << (self dvPrinter phexPrint: tResult).
		str cr.
		str << 'ratio treatment/control = '.
		ratio > 0 ifTrue:[str << '+'].
		str << (ratio*100) rounded printString.
		str << '%'
		 ]
]

{ #category : #accessing }
PhexDependentVariable >> treatmentData [
	^data second
]

{ #category : #accessing }
PhexDependentVariable >> varName [

	^ varName
]

{ #category : #accessing }
PhexDependentVariable >> varName: anObject [

	varName := anObject
]
