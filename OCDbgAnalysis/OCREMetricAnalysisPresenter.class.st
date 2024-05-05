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
OCREMetricAnalysisPresenter >> plotResults: metric [
	|plot ac at loc lot acData atData locData lotData|
	
	[	
	ac  := (metric control at: 'Ammolite') first avgTime asSeconds.
	at  := (metric treatment at: 'Ammolite') first avgTime asSeconds.
	loc := (metric control at: 'Lights Out') first avgTime asSeconds.
	lot := (metric treatment at: 'Lights Out') first avgTime asSeconds.
	
	acData  := (metric control at: 'Ammolite') first data collect: [:d|(d totalTime - d idleTime) asSeconds].
	atData  := (metric treatment at: 'Ammolite') first data collect: [:d|(d totalTime - d idleTime) asSeconds].
	locData := (metric control at: 'Lights Out') first data collect: [:d|(d totalTime - d idleTime) asSeconds].
	lotData := (metric treatment at: 'Lights Out') first data collect: [:d|(d totalTime - d idleTime) asSeconds].
		
	plot := (RSBarPlot barHeights: {ac. at. loc. lot }) 
					errors: (ExperimentResults confidenceIntervals: {acData. atData. locData. lotData}).

	plot horizontalTick fromNames: #( 'Ammo-C' 'Ammo-T' 'Light-C' 'Light-T' ).
	plot title: 'Mean time (in min), 95% CI.'
	]
		 on: Error do:[:err| self halt. timeBars := self newRoassal. ^self].

	timeBars := plot asPresenter.
	
	
	[	
	ac  := (metric control at: 'Ammolite') first avgNb.
	at  := (metric treatment at: 'Ammolite') first avgNb.
	loc := (metric control at: 'Lights Out') first avgNb.
	lot := (metric treatment at: 'Lights Out') first avgNb.	
		
	plot := (RSBarPlot barHeights: {ac. at. loc. lot })	.

	plot horizontalTick fromNames: #( 'Ammo-C' 'Ammo-T' 'Light-C' 'Light-T' ).
	plot title: 'Average occurence of tool usage'
	]
		 on: Error do:[:err| self halt. nbBars := self newRoassal. ^self].

	nbBars := plot asPresenter.
	
		[	
	ac  := (metric control at: 'Ammolite') first avgActions.
	at  := (metric treatment at: 'Ammolite') first avgActions.
	loc := (metric control at: 'Lights Out') first avgActions.
	lot := (metric treatment at: 'Lights Out') first avgActions.
	
	acData  := (metric control at: 'Ammolite') first actionsPerData.
	atData  := (metric treatment at: 'Ammolite') first actionsPerData.
	locData := (metric control at: 'Lights Out') first actionsPerData.
	lotData := (metric treatment at: 'Lights Out') first actionsPerData.
		
	plot := (RSBarPlot barHeights: {ac. at. loc. lot }) 
					errors: (ExperimentResults confidenceIntervals: {acData. atData. locData. lotData}).

	plot horizontalTick fromNames: #( 'Ammo-C' 'Ammo-T' 'Light-C' 'Light-T' ).
	plot title: 'Mean actions, 95% CI.'
	]
		 on: Error do:[:err| self halt. actionsBars := self newRoassal. ^self].

	actionsBars := plot asPresenter.
	
	self layout: self defaultLayout 
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

{ #category : #'as yet unclassified' }
OCREMetricAnalysisPresenter >> updateData: newData [
	data := newData.
	table items: data.

	
]
