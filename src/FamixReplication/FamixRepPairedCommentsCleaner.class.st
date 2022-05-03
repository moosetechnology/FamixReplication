"
I am an code cleaner for languages that have ""paired"" comments, i.e. multiline comments with a marker different for start and end (like ""/*"" and ""*/"")

Subclasses should define #multilineCommentOpener and #multilineCommentCloser to return the string marking beginning (resp. end) of a paired comment
"
Class {
	#name : #FamixRepPairedCommentsCleaner,
	#superclass : #FamixRepSourcesCleaner,
	#category : #'FamixReplication-Detection'
}

{ #category : #actions }
FamixRepPairedCommentsCleaner >> cleanMultilineComments: aText [
	"removes all comments possibly spanning several lines without changing the number of lines
	 (a multi line comment becomes a set of empty lines)"

	| current commentStart commentEnd |
	current := 1.
	^ String streamContents: [ :stream | 
	[ 
		commentStart := aText
			findString: self multilineCommentOpener
			startingAt: current.
		commentEnd := aText
			findString: self multilineCommentCloser
			startingAt: commentStart + 1.
		(commentStart >0) and: [ commentEnd > 0 ]
	] whileTrue: [ 
		self copy: aText from: current to: commentStart - 1 into: stream.
		current := commentStart + self multilineCommentOpener size.
		self copyAsEmptyLines: aText from: current to: commentEnd - 1 into: stream.
		current := commentEnd + self multilineCommentCloser size
	].
	self copy: aText from: current toEndInto: stream
]
]

{ #category : #actions }
FamixRepPairedCommentsCleaner >> multilineCommentCloser [
	"string of a paired comment closer (ex: '*/')"
	self subclassResponsibility 
]

{ #category : #actions }
FamixRepPairedCommentsCleaner >> multilineCommentOpener [
	"string of a paired comment opener (ex: '/*')"
	self subclassResponsibility 
]
