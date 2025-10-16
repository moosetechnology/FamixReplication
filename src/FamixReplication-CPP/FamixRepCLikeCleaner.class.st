"
I am a clearner for C-like languages, i.e. having comments `/* ... */` and `// ...`

"
Class {
	#name : 'FamixRepCLikeCleaner',
	#superclass : 'FamixRepPairedCommentsCleaner',
	#category : 'FamixReplication-CPP',
	#package : 'FamixReplication-CPP'
}

{ #category : 'displaying' }
FamixRepCLikeCleaner class >> displayStringOn: aStream [

	aStream << 'C like comments'
]

{ #category : 'actions' }
FamixRepCLikeCleaner >> cleanLine: aText [
	"a++ //asd -> a++"

	^ (super cleanLine: aText) copyUpToSubString: '//'
]

{ #category : 'testing' }
FamixRepCLikeCleaner >> isComment: aLine [
	"return false because commented code is replaced with empty string"

	^ false
]

{ #category : 'actions' }
FamixRepCLikeCleaner >> multilineCommentCloser [
	^'*/'
]

{ #category : 'actions' }
FamixRepCLikeCleaner >> multilineCommentOpener [
	^'/*'
]
