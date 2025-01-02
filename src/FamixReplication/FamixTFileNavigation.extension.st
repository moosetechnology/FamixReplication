Extension { #name : 'FamixTFileNavigation' }

{ #category : '*FamixReplication' }
FamixTFileNavigation >> knowsEnd [
	^ self endLine isNotNil
]

{ #category : '*FamixReplication' }
FamixTFileNavigation >> knowsStart [
	^ self startLine isNotNil
]
