Class {
	#name : #BaselineOfOCDbgAnalysis,
	#superclass : #BaselineOf,
	#category : #BaselineOfOCDbgAnalysis
}

{ #category : #baselines }
BaselineOfOCDbgAnalysis >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec preLoadDoIt: #'preload:package:'.
		spec postLoadDoIt: #'postload:package:'.
		spec 
			package: 'OCDbgAnalysis' ]
]

{ #category : #actions }
BaselineOfOCDbgAnalysis >> postload: loader package: packageSpec [

	(StPlayground new
		 contents:
			 '"inspect this, but use the path to your downloaded data file"
OCDbgExampleCode loadDataFromPath: ''/Users/maxw/Documents/ocrex1pilot/User-a1eff302-b2a0-0d00-b9ea-48310c48fda453911402438000''';
		 yourself) open
]

{ #category : #actions }
BaselineOfOCDbgAnalysis >> preload: loader package: packageSpec [

	"This preload hook will execute the required baselines. (We are not using the built-in dependencies system of baselines)"

	Metacello new
		baseline: 'Phex';
		repository: 'github://Pharo-XP-Tools/Phex:main';
		onWarning: [ :ex | 
			ex resume "prevents the load/merge question popup" ];
		load.

	"without the onWarning: line, you must choose the 'load' button in both appearing dialogs."

	"Note that the repository of the next baseline is not in the Pharo-XP-Tools github"
	Metacello new
		baseline: 'DebuggingSpy';
		repository: 'github://Pharo-XP-Tools/DebuggingSpy';
		load.

	Metacello new
		baseline: 'DSSpyEventRecorder';
		repository:
			'github://Pharo-XP-Tools/DebuggingSpy-EventRecorder:main';
		load.

	"fixes a bug. An unrelated (big) data file is downloaded in the unmodified method."
	EREventTool compile: 'ensureLocalDirectory
        "self default ensureLocalDirectory"
        self
                "ensureDownloadedData;
                ensureExtractedData"
'.
	"JSON tools from our fork"
	"Metacello new
		repository: 'github://Pharo-XP-Tools/NeoJSON/repository';
		baseline: 'NeoJSON';
		load"
		
	[Metacello new
    baseline: 'Roassal';
    repository: 'github://pharo-graphics/Roassal';
    load: 'Full'.] on: MCMergeOrLoadWarning do: [:warning | warning load ]
]
