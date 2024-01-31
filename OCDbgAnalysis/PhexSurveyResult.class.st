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

{ #category : #'instance creation' }
PhexSurveyResult class >> title: aString answer: answers dateTime: aDateTime [

	^ self new title: aString answer: answers dateTime: aDateTime
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

{ #category : #'instance creation' }
PhexSurveyResult >> title: aString answer: aws dateTime: aDateTime [ 
	title := aString.
	answers := aws.
	dateTime := aDateTime 
]
