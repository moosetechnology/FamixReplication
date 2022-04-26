"
I am a clearner for C-like languages, i.e. having comments `/* ... */` and `// ...`

"
Class {
	#name : #FamixRepCLikeCleaner,
	#superclass : #FamixRepSourcesCleaner,
	#category : #'FamixReplication-CPP'
}

{ #category : #actions }
FamixRepCLikeCleaner >> cleanLine: aText [
	"a++ //asd -> a++"

	^ (super cleanLine: aText) copyUpToSubString: '//'
]

{ #category : #testing }
FamixRepCLikeCleaner >> isComment: aLine [
	"return false because commented code is replaced with empty string"

	^ false
]

{ #category : #actions }
FamixRepCLikeCleaner >> multilineCommentEnd [
	^'*/'
]

{ #category : #actions }
FamixRepCLikeCleaner >> multilineCommentStart [
	^'/*'
]
