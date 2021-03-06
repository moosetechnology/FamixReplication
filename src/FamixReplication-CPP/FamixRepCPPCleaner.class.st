"
Description
--------------------

I am a clearner for CPP language.

I still need to clean multiple line comments
"
Class {
	#name : #FamixRepCPPCleaner,
	#superclass : #FamixRepSourcesCleaner,
	#category : #'FamixReplication-CPP'
}

{ #category : #actions }
FamixRepCPPCleaner >> clean: aText [
	"a++ //asd -> a++"

	^ (super clean: aText) copyUpToSubString: '//'
]

{ #category : #testing }
FamixRepCPPCleaner >> isComment: aLine [
	"return false because commented code is replaced with empty string"

	^ false
]
