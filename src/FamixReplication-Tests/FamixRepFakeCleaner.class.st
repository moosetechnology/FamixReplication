"
For tests only.
"
Class {
	#name : #FamixRepFakeCleaner,
	#superclass : #FamixRepSourcesCleaner,
	#category : #'FamixReplication-Tests-Detection'
}

{ #category : #testing }
FamixRepFakeCleaner class >> availableForUser [
	
	^false
]

{ #category : #actions }
FamixRepFakeCleaner >> isComment: aLine [
	^ false
]
