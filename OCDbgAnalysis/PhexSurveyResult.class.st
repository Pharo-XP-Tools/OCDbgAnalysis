"
I hold the answers to a Phex survey
"
Class {
	#name : #PhexSurveyResult,
	#superclass : #Object,
	#instVars : [
		'title',
		'answers',
		'dateTime'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #'instance creation' }
PhexSurveyResult class >> from: aDSSurveyRecord [

	^self new from: aDSSurveyRecord
]

{ #category : #accessing }
PhexSurveyResult >> answers [
	^ answers
]

{ #category : #converting }
PhexSurveyResult >> asCSV [
	self shouldBeImplemented.
]

{ #category : #accessing }
PhexSurveyResult >> dateTime [
	^ dateTime
]

{ #category : #'instance creation' }
PhexSurveyResult >> from: aDSSurveyRecord [ 
	title := aDSSurveyRecord survey title.
	dateTime := aDSSurveyRecord dateTime.
	answers := aDSSurveyRecord collectAnswersFromQuestions
	
]

{ #category : #printing }
PhexSurveyResult >> printOn: aStream [

	aStream << title
]

{ #category : #accessing }
PhexSurveyResult >> title [
	^ title
]
