"
Description
--------------------

I am a cleaner to clean smalltalk method code for replication detection
"
Class {
	#name : #FamixRepSmalltalkCleaner,
	#superclass : #FamixRepSourcesCleaner,
	#category : #'FamixReplication-Smalltalk'
}

{ #category : #actions }
FamixRepSmalltalkCleaner >> cleanLine: aText [
	^ (super cleanLine: aText) copyWithRegex:  '\".*\"'  matchesReplacedWith: ''
]

{ #category : #actions }
FamixRepSmalltalkCleaner >> isComment: aLine [
	"we could have defined comment as 
		aLine matchesRegex:  '\"".*\""$' 
	but just returning false because a comment line will be empty because cleaner removes everything within double qoutes and hence not considered by the detector"

	^ false
]

{ #category : #actions }
FamixRepSmalltalkCleaner >> multilineCommentEnd [
	"There are no special marker for multiline comments in Pharo"
	^ nil
]

{ #category : #actions }
FamixRepSmalltalkCleaner >> multilineCommentStart [

	"There are no special marker for multiline comments in Pharo"

	^ nil
]
