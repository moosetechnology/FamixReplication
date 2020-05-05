Extension { #name : #FamixTIndexedFileNavigation }

{ #category : #'*FamixReplication' }
FamixTIndexedFileNavigation >> knowsEnd [
	^ self endPos isNotNil
]

{ #category : #'*FamixReplication' }
FamixTIndexedFileNavigation >> knowsStart [
	^ self startPos isNotNil
]
