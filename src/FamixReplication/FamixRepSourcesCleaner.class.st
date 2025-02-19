"
Description
--------------------

I am an cleaner providing methods to cleaning code before passing to the replication detector. Every language or a family of languages override these methods to implement the  logic of cleaning. 

"
Class {
	#name : 'FamixRepSourcesCleaner',
	#superclass : 'Object',
	#category : 'FamixReplication-Detection',
	#package : 'FamixReplication',
	#tag : 'Detection'
}

{ #category : 'accessing' }
FamixRepSourcesCleaner class >> allAvailableCleaners [
	^self withAllSubclasses select: [:cleaner | cleaner availableForUser]
]

{ #category : 'testing' }
FamixRepSourcesCleaner class >> availableForUser [ 

	^ self ~= FamixRepSourcesCleaner 
]

{ #category : 'displaying' }
FamixRepSourcesCleaner class >> displayString [
	self subclassResponsibility
]

{ #category : 'private' }
FamixRepSourcesCleaner >> addCleanedVersionOf: aLine at: index to: lines [
	"I clean a line and add it to the collection of lines if it's useful."

	aLine ifEmpty: [ ^ self ].

	(self cleanLine: aLine) ifNotEmpty: [ :cleanedLine | (self isComment: cleanedLine) ifFalse: [ lines add: index -> cleanedLine ] ]
]

{ #category : 'actions' }
FamixRepSourcesCleaner >> cleanCommentLines: aCollectionOfLines [
	"Clean end-of-line comments and empty lines
	This could be more elegant but be careful, I need to be fast and doing a collect with index then a reject is longer."
	| lines |
	lines := OrderedCollection new.
	aCollectionOfLines doWithIndex: [ :aLine :index | self addCleanedVersionOf: aLine at: index to: lines ].
	^ lines
]

{ #category : 'private' }
FamixRepSourcesCleaner >> cleanLine: text [
	^ {(String space).
	(String tab).
	(String cr).
	(String lf).
	(String crlf)} inject: text into: [ :crtLine :space | crtLine copyReplaceAll: space with: '' ]
]

{ #category : 'actions' }
FamixRepSourcesCleaner >> cleanMultilineComments: aText [
	"should remove all comments possibly spanning several lines without changing the number of lines
	 (a multi line comment becomes a set of empty lines)
	This is language depend so the default does nothing"
	^aText
]

{ #category : 'actions' }
FamixRepSourcesCleaner >> cleanedTextLines: aText [
	^self cleanCommentLines: (self cleanMultilineComments: aText) lines
]

{ #category : 'private' }
FamixRepSourcesCleaner >> copy: aString from: start to: end into: aStream [
	start to: end do: [ :i | aStream nextPut: (aString at: i) ].
	^aStream 
]

{ #category : 'private' }
FamixRepSourcesCleaner >> copy: aString from: start toEndInto: aStream [
	start to: aString size do: [ :i | aStream nextPut: (aString at: i) ].
	^aStream 
]

{ #category : 'private' }
FamixRepSourcesCleaner >> copyAsEmptyLines: aString from: start to: end into: aStream [
	start to: end do: [ :i || c | 
		c := aString at: i.
		( { Character cr . Character lf } includes: c)
		ifTrue: [ aStream nextPut: c]
	].
	^aStream 
]

{ #category : 'initialization' }
FamixRepSourcesCleaner >> initialize [
	super initialize.
	self reset
]

{ #category : 'private' }
FamixRepSourcesCleaner >> isComment: aLine [
	self subclassResponsibility 
]

{ #category : 'initialization' }
FamixRepSourcesCleaner >> reset [
	"By default I do nothing. For some cleaner maybe we need to reset it between each cleaning."

	
]
