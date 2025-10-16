"
Description
--------------------

I am a cleaner to clean smalltalk method code for replication detection
"
Class {
	#name : 'FamixRepSmalltalkCleaner',
	#superclass : 'FamixRepPairedCommentsCleaner',
	#category : 'FamixReplication-Smalltalk',
	#package : 'FamixReplication-Smalltalk'
}

{ #category : 'displaying' }
FamixRepSmalltalkCleaner class >> displayStringOn: aStream [

	aStream << 'Smalltalk comments'
]

{ #category : 'actions' }
FamixRepSmalltalkCleaner >> cleanLine: aText [
	^ (super cleanLine: aText) copyWithRegex:  '\".*\"'  matchesReplacedWith: ''
]

{ #category : 'actions' }
FamixRepSmalltalkCleaner >> isComment: aLine [
	"we could have defined comment as 
		aLine matchesRegex:  '\"".*\""$' 
	but just returning false because a comment line will be empty because cleaner removes everything within double qoutes and hence not considered by the detector"

	^ false
]

{ #category : 'actions' }
FamixRepSmalltalkCleaner >> multilineCommentCloser [

	^ '"'
]

{ #category : 'actions' }
FamixRepSmalltalkCleaner >> multilineCommentOpener [

	^ '"'
]
