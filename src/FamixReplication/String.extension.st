Extension { #name : #String }

{ #category : #'*FamixReplication' }
String >> copyUpToSubString: aSubString [
	"I am a fast way to copy a string up to a substring. If you remove me, do some benchmark of the new solution because I'm use heavily in FamixReplication and this might cause trouble with the performances."

	^ self first: (self indexOfSubCollection: aSubString startingAt: 1 ifAbsent: [ ^ self ]) - 1
]
