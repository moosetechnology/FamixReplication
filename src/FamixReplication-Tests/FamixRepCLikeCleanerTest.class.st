Class {
	#name : 'FamixRepCLikeCleanerTest',
	#superclass : 'FamixRepSourceCleanerTest',
	#category : 'FamixReplication-Tests-Detection',
	#package : 'FamixReplication-Tests',
	#tag : 'Detection'
}

{ #category : 'tests' }
FamixRepCLikeCleanerTest >> testCleanCommentLines [
	self
		assertCollection: (cleaner cleanCommentLines: #('cout << 1 //this is a comment') )
		equals: { 1 -> 'cout<<1'} asOrderedCollection
]

{ #category : 'tests' }
FamixRepCLikeCleanerTest >> testCleanLine [
	self assert: (cleaner cleanLine: 'cout << 1 //this is a comment') equals: 'cout<<1'
]

{ #category : 'tests' }
FamixRepCLikeCleanerTest >> testCleanMultilineComments [
	self assert: (cleaner cleanMultilineComments: 'cout <<1;
/*this is a 
 * multi lines comment*/
doSomthingElse(2);
')
equals: 'cout <<1;


doSomthingElse(2);
'
]

{ #category : 'tests' }
FamixRepCLikeCleanerTest >> testCleanMultilineCommentsAtEnd [
	self
		assert: (cleaner cleanMultilineComments: 'cout << 1; /*this is comment*/')
		equals: 'cout << 1; '
]

{ #category : 'tests' }
FamixRepCLikeCleanerTest >> testCleanMultilineCommentsAtStart [
	self
		assert: (cleaner cleanMultilineComments: '/*this is comment*/cout << 1;')
		equals: 'cout << 1;'
]

{ #category : 'tests' }
FamixRepCLikeCleanerTest >> testCleanMultilineCommentsNone [
	self assert: (cleaner cleanMultilineComments: 'cout << 1') equals: 'cout << 1'

]

{ #category : 'tests' }
FamixRepCLikeCleanerTest >> testCleanMultilineCommentsOneLine [
	self assert: (cleaner cleanMultilineComments: 'cout /*this is a comment*/ << 1') equals: 'cout  << 1'.
	self assert: (cleaner cleanMultilineComments: 'cout /*this is a comment*/ << 1') equals: 'cout  << 1'.

]

{ #category : 'tests' }
FamixRepCLikeCleanerTest >> testCleanMultilineCommentsWithError [
	self assert: (cleaner cleanMultilineComments: 'cout << "this is not a comment /*";
doSomthingElse(2);
')
equals: 'cout << "this is not a comment /*";
doSomthingElse(2);
'
]

{ #category : 'tests' }
FamixRepCLikeCleanerTest >> testIsComment [
	self deny: (cleaner isComment: 'cout << 1 //this is a comment') description: 'Comment in code does not make a line comment'
]
