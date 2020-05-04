"
The cleaner cleans smalltalk method code for duplication detection.
"
Class {
	#name : #FamixRepSmalltalkCleaner,
	#superclass : #FamixRepSourcesCleaner,
	#category : #'FamixReplication-Smalltalk'
}

{ #category : #actions }
FamixRepSmalltalkCleaner >> clean: aText [
	^ (super clean: aText) copyWithRegex:  '\".*\"'  matchesReplacedWith: ''
]

{ #category : #actions }
FamixRepSmalltalkCleaner >> isComment: aLine [
	"we could have defined comment as 
		aLine matchesRegex:  '\"".*\""$' 
	but just returning false because a comment line will be empty because cleaner removes everything within double qoutes and hence not considered by the detector"

	^ false
]
