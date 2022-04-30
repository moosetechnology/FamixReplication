"
Description
--------------------

I am a cleaner to clean smalltalk method code for replication detection
"
Class {
	#name : #FamixRepSmalltalkCleaner,
	#superclass : #FamixRepSourcesCleaner,
	#category : #'FamixReplication-Smalltalk'
}

{ #category : #displaying }
FamixRepSmalltalkCleaner class >> displayString [
	^'Smalltalk comments'
]

{ #category : #actions }
FamixRepSmalltalkCleaner >> cleanLine: aText [
	^ (super cleanLine: aText) copyWithRegex:  '\".*\"'  matchesReplacedWith: ''
]

{ #category : #actions }
FamixRepSmalltalkCleaner >> cleanMultilineComments: aText [
	"removes all comments possibly spanning several lines without changing the number of lines
	 (a multi line comment becomes a set of empty lines)"

	| current commentStart commentEnd |
	current := 1.
	^ String streamContents: [ :stream | 
	[ 
		commentStart := aText indexOf: $" startingAt: current.
		commentEnd := aText indexOf: $" startingAt: commentStart + 1.
		(commentStart > 0) and: [ commentEnd > 0 ]
	] whileTrue: [ 
		self copy: aText from: current to: commentStart - 1 into: stream.
		current := commentStart + 1.
		self copyAsEmptyLines: aText from: current to: commentEnd - 1 into: stream.
		current := commentEnd + 1
	].
	self copy: aText from: current toEndInto: stream
]
]

{ #category : #actions }
FamixRepSmalltalkCleaner >> isComment: aLine [
	"we could have defined comment as 
		aLine matchesRegex:  '\"".*\""$' 
	but just returning false because a comment line will be empty because cleaner removes everything within double qoutes and hence not considered by the detector"

	^ false
]
