Class {
	#name : #OCREExperienceScatterPlots,
	#superclass : #SpPresenter,
	#instVars : [
		'participants',
		'ammoliteC',
		'ammoliteT',
		'loC',
		'loT'
	],
	#category : #'OCDbgAnalysis-Presenters'
}

{ #category : #layout }
OCREExperienceScatterPlots >> defaultLayout [

	^ SpPanedLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: ammoliteC;
				   add: loT;
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   add: loC;
				   add: ammoliteT;
				   yourself);
		  yourself
]

{ #category : #initialization }
OCREExperienceScatterPlots >> initializePresenters [
	|ammoliteCData ammoliteTData loCData loTData labelConverter|
	
		labelConverter := [:val|
		|label|
		val = 1 ifTrue:[label := '< 1 year'].
		val = 2 ifTrue:[label := '1-2 years'].
		val = 3 ifTrue:[label := '3-5 years'].
		val = 4 ifTrue:[label := '6-10 years'].
		val = 5 ifTrue:[label := '> 10 years'].
		label
		 ].

	
	ammoliteCData  := 	(participants collect: [ :p| 
	p participant participantDeclaredExperience -> p tasks first
	 ]) select:[:a| a key >=0 and:[a value taskInfo title = 'Ammolite' ] ].

	ammoliteTData  := 	(participants collect: [ :p| 
	p participant participantDeclaredExperience -> p tasks last
	 ]) select:[:a| a key >=0 and:[a value taskInfo title = 'Ammolite' ] ].

	loCData  := 	(participants collect: [ :p| 
	p participant participantDeclaredExperience -> p tasks first
	 ]) select:[:a| a key >=0 and:[a value taskInfo title ~= 'Ammolite' ] ].

	loTData  := 	(participants collect: [ :p| 
	p participant participantDeclaredExperience -> p tasks last
	 ]) select:[:a| a key >=0 and:[a value taskInfo title ~= 'Ammolite' ] ].
	
	loC  := OCRERSScatterPlot new x: (loCData collect: #key) y: (loCData collect: [:t| t value duration asSeconds]).
	loC xlabel: 'Experience'.
	loC ylabel: 'Time to finish task in seconds'.
	loC title: 'Lights Out - Control'.
	loC horizontalTick labelConversion: labelConverter.
	loC := loC asPresenter.
	
	loT  := OCRERSScatterPlot new x: (loTData collect: #key) y: (loTData collect: [:t| t value duration asSeconds]).
	loT xlabel: 'Experience'.
	loT ylabel: 'Time to finish task in seconds'.
	loT title: 'Lights Out - Treatment'.	
	loT horizontalTick labelConversion: labelConverter.
	loT := loT asPresenter.
	
	ammoliteC  := OCRERSScatterPlot new x: (ammoliteCData collect: #key) y: (ammoliteCData collect: [:t| t value duration asSeconds]).
	ammoliteC xlabel: 'Experience'.
	ammoliteC ylabel: 'Time to finish task in seconds'.
	ammoliteC title: 'Ammolite - Control'.
	ammoliteC horizontalTick labelConversion: labelConverter.
	ammoliteC := ammoliteC asPresenter.
	
	ammoliteT  := OCRERSScatterPlot new x: (ammoliteTData collect: #key) y: (ammoliteTData collect: [:t| t value duration asSeconds]).
	ammoliteT xlabel: 'Experience'.
	ammoliteT ylabel: 'Time to finish task in seconds'.
	ammoliteT title: 'Ammolite - Treatment'.
	ammoliteT horizontalTick labelConversion: labelConverter.
	ammoliteT := ammoliteT asPresenter.
	
	

	
]

{ #category : #'accessing - model' }
OCREExperienceScatterPlots >> setModelBeforeInitialization: aCollection [
	participants := aCollection 
]
