Class {
	#name : #FamixReplicatedFragmentTest,
	#superclass : #TestCase,
	#category : #'FamixReplication-Tests-Entities'
}

{ #category : #tests }
FamixReplicatedFragmentTest >> testFragmentNotMergeableWithItself [
	| frag1 entity1 |
	entity1 := FamixTest1Method new.

	frag1 := FamixReplicatedFragment new replicas: {(FamixReplica from: 5 to: 8 for: entity1) . (FamixReplica from: 21 to: 24 for: entity1)}.

	self deny: (frag1 mergeableWith: frag1)
]

{ #category : #tests }
FamixReplicatedFragmentTest >> testMerge [
	| anchor frag1 frag2 entity1 entity2 |
	entity1 := FamixTest1Method new.
	entity2 := FamixTest1Method new.
	anchor := FamixTest1FileAnchor new.

	frag1 := FamixReplicatedFragment new
		addReplica: (FamixReplica from: 5 to: 8 for: entity1);
		addReplica: (FamixReplica from: 21 to: 24 for: entity2).
	frag2 := FamixReplicatedFragment new
		addReplica: (FamixReplica from: 9 to: 15 for: entity1);
		addReplica: (FamixReplica from: 25 to: 31 for: entity2).

	frag1 replicas , frag2 replicas do: [ :location | location fileAnchor: anchor ].

	self assert: entity1 replicas size equals: 2.
	self assert: entity2 replicas size equals: 2.

	frag1 mergeWith: frag2.

	self assert: entity1 replicas size equals: 1.
	self assert: entity2 replicas size equals: 1.

	self assert: entity1 replicas first startLine equals: 5.
	self assert: entity1 replicas first endLine equals: 15.

	self assert: entity2 replicas first startLine equals: 21.
	self assert: entity2 replicas first endLine equals: 31.

	self assert: entity1 replicas size equals: 1.
	self assert: entity2 replicas size equals: 1
]

{ #category : #tests }
FamixReplicatedFragmentTest >> testMergeable [
	| frag1 frag2 entity1 entity2 |
	entity1 := FamixTest1Method new.
	entity2 := FamixTest1Method new.

	frag1 := FamixReplicatedFragment new replicas: {(FamixReplica from: 5 to: 8 for: entity1) . (FamixReplica from: 21 to: 24 for: entity2)}.
	frag2 := FamixReplicatedFragment new replicas: {(FamixReplica from: 9 to: 15 for: entity1) . (FamixReplica from: 25 to: 31 for: entity2)}.

	self assert: (frag1 mergeableWith: frag2)
]

{ #category : #tests }
FamixReplicatedFragmentTest >> testMergeableOverlap [
	| frag1 frag2 entity1 entity2 |
	entity1 := FamixTest1Method new.
	entity2 := FamixTest1Method new.

	frag1 := FamixReplicatedFragment new replicas: {(FamixReplica from: 5 to: 8 for: entity1) . (FamixReplica from: 21 to: 24 for: entity2)}.
	frag2 := FamixReplicatedFragment new replicas: {(FamixReplica from: 6 to: 9 for: entity1) . (FamixReplica from: 22 to: 25 for: entity2)}.

	self assert: (frag1 mergeableWith: frag2)
]

{ #category : #tests }
FamixReplicatedFragmentTest >> testNotMergeable [
	| frag1 frag2 entity1 entity2 |
	entity1 := FamixTest1Method new.
	entity2 := FamixTest1Method new.

	frag1 := FamixReplicatedFragment new replicas: {(FamixReplica from: 5 to: 8 for: entity2) . (FamixReplica from: 21 to: 24 for: entity1)}.
	frag2 := FamixReplicatedFragment new replicas: {(FamixReplica from: 9 to: 15 for: entity1) . (FamixReplica from: 25 to: 31 for: entity2)}.

	self deny: (frag1 mergeableWith: frag2)
]
