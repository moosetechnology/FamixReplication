Class {
	#name : #FamixRepSmalltalkCleanerTest,
	#superclass : #FamixRepSourceCleanerTest,
	#category : #'FamixReplication-Tests-Detection'
}

{ #category : #tests }
FamixRepSmalltalkCleanerTest >> testCleanCommentLines [
	self
		assertCollection: (cleaner cleanCommentLines: #('cout + 1 "this is a comment"') )
		equals: { 1 -> 'cout+1'} asOrderedCollection
]

{ #category : #tests }
FamixRepSmalltalkCleanerTest >> testCleanLine [
	self assert: (cleaner cleanLine: 'cout + 1 "this is a comment"') equals: 'cout+1'
]

{ #category : #tests }
FamixRepSmalltalkCleanerTest >> testCleanMultilineComments [
	self assert: (cleaner cleanMultilineComments: 'cout + 1.
"this is a 
 multi lines comment"
cin + 2.
')
equals: 'cout + 1.


cin + 2.
'

]

{ #category : #tests }
FamixRepSmalltalkCleanerTest >> testCleanMultilineCommentsNone [
	self
		assert: (cleaner cleanMultilineComments: 'cout + 1')
		equals: 'cout + 1'

]

{ #category : #tests }
FamixRepSmalltalkCleanerTest >> testCleanMultilineCommentsOneLine [
	self
		assert: (cleaner cleanMultilineComments: 'cout + "a comment" 1')
		equals: 'cout +  1'

]

{ #category : #tests }
FamixRepSmalltalkCleanerTest >> testIsComment [
	self deny: (cleaner isComment: 'cout + 1 "this is a comment"') description: 'Comment in code does not make a line comment'
]
