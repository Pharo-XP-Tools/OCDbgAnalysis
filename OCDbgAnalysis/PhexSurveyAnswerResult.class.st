"
I model an answer to a survey question
"
Class {
	#name : #PhexSurveyAnswerResult,
	#superclass : #Object,
	#instVars : [
		'question',
		'answer',
		'choices'
	],
	#category : #'OCDbgAnalysis-NewModel'
}

{ #category : #accessing }
PhexSurveyAnswerResult >> answer [

	^ answer
]

{ #category : #accessing }
PhexSurveyAnswerResult >> answer: anObject [

	answer := anObject
]

{ #category : #accessing }
PhexSurveyAnswerResult >> choices: aCollection [ 
	choices := aCollection
]

{ #category : #printing }
PhexSurveyAnswerResult >> printOn: aStream [

	aStream << question.
	aStream << ' -> '.
	aStream << answer
]

{ #category : #accessing }
PhexSurveyAnswerResult >> question [

	^ question
]

{ #category : #accessing }
PhexSurveyAnswerResult >> question: anObject [

	question := anObject
]
