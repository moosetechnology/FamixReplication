Extension { #name : 'FamixTMultipleFileAnchor' }

{ #category : '*FamixReplication' }
FamixTMultipleFileAnchor >> knowsEnd [
	^ self allSourceAnchors allSatisfy: #knowsEnd
]

{ #category : '*FamixReplication' }
FamixTMultipleFileAnchor >> knowsStart [
	^ self allSourceAnchors allSatisfy: #knowsStart
]
