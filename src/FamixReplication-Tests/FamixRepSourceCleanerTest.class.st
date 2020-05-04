Class {
	#name : #FamixRepSourceCleanerTest,
	#superclass : #TestCase,
	#instVars : [
		'cleaner'
	],
	#category : #'FamixReplication-Tests-Detection'
}

{ #category : #testing }
FamixRepSourceCleanerTest class >> isAbstract [
	^ self = FamixRepSourceCleanerTest
]

{ #category : #helpers }
FamixRepSourceCleanerTest >> actualClass [
	^ self class environment at: (self class name withoutSuffix: 'Test') asSymbol
]

{ #category : #running }
FamixRepSourceCleanerTest >> setUp [
	super setUp.
	cleaner := self actualClass new
]

{ #category : #tests }
FamixRepSourceCleanerTest >> testClean [
	self subclassResponsibility
]

{ #category : #tests }
FamixRepSourceCleanerTest >> testIsComment [
	self subclassResponsibility
]
