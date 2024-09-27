Class {
	#name : 'FamixRepSourceCleanerTest',
	#superclass : 'TestCase',
	#instVars : [
		'cleaner'
	],
	#category : 'FamixReplication-Tests-Detection',
	#package : 'FamixReplication-Tests',
	#tag : 'Detection'
}

{ #category : 'testing' }
FamixRepSourceCleanerTest class >> isAbstract [
	^ self = FamixRepSourceCleanerTest
]

{ #category : 'helpers' }
FamixRepSourceCleanerTest >> actualClass [
	^ self class environment at: (self class name withoutSuffix: 'Test') asSymbol
]

{ #category : 'running' }
FamixRepSourceCleanerTest >> setUp [
	super setUp.
	cleaner := self actualClass new
]

{ #category : 'tests' }
FamixRepSourceCleanerTest >> testCleanCommentLines [
	self subclassResponsibility
]

{ #category : 'tests' }
FamixRepSourceCleanerTest >> testCleanLine [
	self subclassResponsibility
]

{ #category : 'tests' }
FamixRepSourceCleanerTest >> testCleanMultilineComments [
	self subclassResponsibility
]

{ #category : 'tests' }
FamixRepSourceCleanerTest >> testIsComment [
	self subclassResponsibility
]
