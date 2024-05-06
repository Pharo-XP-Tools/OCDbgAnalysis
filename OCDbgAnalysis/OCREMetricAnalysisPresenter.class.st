Class {
	#name : #OCREMetricAnalysisPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'data',
		'table',
		'timeBars',
		'nbBars',
		'actionsBars',
		'detailedAnalysisPane'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #analyze }
OCREMetricAnalysisPresenter >> analyzeResults: metrics [

	metrics ifNil: [ ^ self ].
	detailedAnalysisPane metricData: metrics.
	detailedAnalysisPane updateData
]

{ #category : #layout }
OCREMetricAnalysisPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: 20 percent;
				   add: #table;
				   add: detailedAnalysisPane;
				   yourself);
		  yourself
]

{ #category : #'accessing - model' }
OCREMetricAnalysisPresenter >> initializePresenters [

	table := self newTable.
	table addColumn:
		((SpStringTableColumn
			  title: 'Metric'
			  evaluated: [ :item | item toolName ])
			 sortFunction: nil;
			 yourself).			
	table items: data.
	table transmitDo: [:metric| self analyzeResults: metric].
	detailedAnalysisPane := OCREDetailedAnalysisPresenter new

]

{ #category : #'accessing - model' }
OCREMetricAnalysisPresenter >> printRatio: symbol for: taskName in: metric [

	|control cAvg treatment tAvg ratio|
	control := (metric control at: taskName) first.
	treatment := (metric treatment at: taskName) first.
	
	cAvg := control perform: symbol.
	cAvg isNumber ifFalse:[cAvg := cAvg asSeconds].
	tAvg := treatment perform: symbol.	
	tAvg isNumber ifFalse:[tAvg := tAvg asSeconds].
		
	tAvg = 0 ifTrue:[^'N/A'].
	ratio := ((cAvg / tAvg) asFloat - 1) * 100.
	^String streamContents: [ :s|s << ratio printString] limitedTo: 5
	
]

{ #category : #'accessing - model' }
OCREMetricAnalysisPresenter >> setModelBeforeInitialization: aCollectionOfData [
	data := aCollectionOfData 
	
]

{ #category : #updating }
OCREMetricAnalysisPresenter >> updateData: newData [
	data := newData.
	table items: data.

	
]
