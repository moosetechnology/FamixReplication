Class {
	#name : #FamixRepCPPCleanerTest,
	#superclass : #FamixRepSourceCleanerTest,
	#category : #'FamixReplication-Tests-Detection'
}

{ #category : #tests }
FamixRepCPPCleanerTest >> testClean [
	self assert: (cleaner clean: 'cout << 1 //this is a comment') equals: 'cout<<1'
]

{ #category : #tests }
FamixRepCPPCleanerTest >> testIsComment [
	self deny: (cleaner isComment: 'cout << 1 //this is a comment') description: 'Comment in code does not make a line comment'
]
