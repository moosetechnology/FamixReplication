"
Description
--------------------

I am an cleaner providing methods to cleaning code before passing to the replication detector. Every language or a family of languages override these methods to implement the  logic of cleaning. 

"
Class {
	#name : #FamixRepSourcesCleaner,
	#superclass : #Object,
	#category : #'FamixReplication-Detection'
}

{ #category : #actions }
FamixRepSourcesCleaner >> addCleanedVersionOf: aLine at: index to: lines [
	"I clean a line and add it to the collection of lines if it's useful."

	aLine ifEmpty: [ ^ self ].

	(self clean: aLine) ifNotEmpty: [ :cleanedLine | (self isComment: cleanedLine) ifFalse: [ lines add: index -> cleanedLine ] ]
]

{ #category : #actions }
FamixRepSourcesCleaner >> clean: text [
	^ {(String space).
	(String tab).
	(String cr).
	(String lf).
	(String crlf)} inject: text into: [ :crtLine :space | crtLine copyReplaceAll: space with: '' ]
]

{ #category : #actions }
FamixRepSourcesCleaner >> getCleanLinesOf: aCollectionOfLines [
	| lines |
	"This could be more elegant but be careful, I need to be fast and doing a collect with index then a reject is longer."
	lines := OrderedCollection new.
	aCollectionOfLines doWithIndex: [ :aLine :index | self addCleanedVersionOf: aLine at: index to: lines ].
	^ lines
]

{ #category : #initialization }
FamixRepSourcesCleaner >> initialize [
	super initialize.
	self reset
]

{ #category : #actions }
FamixRepSourcesCleaner >> isComment: aLine [
	self subclassResponsibility 
]

{ #category : #initialization }
FamixRepSourcesCleaner >> reset [
	"By default I do nothing. For some cleaner maybe we need to reset it between each cleaning."

	
]
