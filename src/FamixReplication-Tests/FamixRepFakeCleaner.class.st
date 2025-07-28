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

	^ false
]

{ #category : 'displaying' }
FamixRepFakeCleaner class >> displayStringOn: aStream [

	aStream << 'For tests only'
]

{ #category : 'actions' }
FamixRepFakeCleaner >> isComment: aLine [
	^ false
]
