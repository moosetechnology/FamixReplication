"
For tests only.
"
Class {
	#name : #FamixRepFakeCleaner,
	#superclass : #FamixRepSourcesCleaner,
	#category : #'FamixReplication-Tests-Detection'
}

{ #category : #actions }
FamixRepFakeCleaner >> isComment: aLine [
	^ false
]

{ #category : #actions }
FamixRepFakeCleaner >> multilineCommentEnd [

	^ '"'
]

{ #category : #actions }
FamixRepFakeCleaner >> multilineCommentStart [

	^ '"'
]
