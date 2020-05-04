Class {
	#name : #FamixRepSmalltalkCleanerTest,
	#superclass : #FamixRepSourceCleanerTest,
	#category : #'FamixReplication-Tests-Detection'
}

{ #category : #tests }
FamixRepSmalltalkCleanerTest >> testClean [
	self assert: (cleaner clean: 'cout + 1 "this is a comment"') equals: 'cout+1'
]

{ #category : #tests }
FamixRepSmalltalkCleanerTest >> testIsComment [
	self deny: (cleaner isComment: 'cout + 1 "this is a comment"') description: 'Comment in code does not make a line comment'
]
