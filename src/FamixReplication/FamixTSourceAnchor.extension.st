Extension { #name : 'FamixTSourceAnchor' }

{ #category : '*FamixReplication' }
FamixTSourceAnchor >> knowsEnd [
	^ self explicitRequirement
]

{ #category : '*FamixReplication' }
FamixTSourceAnchor >> knowsStart [
	^ self explicitRequirement
]
