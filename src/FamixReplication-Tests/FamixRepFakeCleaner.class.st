"
For tests only.
"
Class {
	#name : 'FamixRepFakeCleaner',
	#superclass : 'FamixRepSourcesCleaner',
	#category : 'FamixReplication-Tests-Detection',
	#package : 'FamixReplication-Tests',
	#tag : 'Detection'
}

{ #category : 'testing' }
FamixRepFakeCleaner class >> availableForUser [
	
	^false
]

{ #category : 'actions' }
FamixRepFakeCleaner >> isComment: aLine [
	^ false
]
