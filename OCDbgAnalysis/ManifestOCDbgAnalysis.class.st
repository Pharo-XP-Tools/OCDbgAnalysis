"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestOCDbgAnalysis,
	#superclass : #PackageManifest,
	#category : #'OCDbgAnalysis-Manifest'
}

{ #category : #'code-critics' }
ManifestOCDbgAnalysis class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#OCDbgAnalysis)) #'2023-10-09T13:00:59.78597+02:00') )
]
