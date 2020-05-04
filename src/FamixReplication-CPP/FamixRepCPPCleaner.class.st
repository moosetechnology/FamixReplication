"
clearner for CPP language.
To do: multiple line comments
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
