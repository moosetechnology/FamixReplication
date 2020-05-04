Class {
	#name : #FamixReplicaTest,
	#superclass : #TestCase,
	#category : #'FamixReplication-Tests-Entities'
}

{ #category : #tests }
FamixReplicaTest >> testContiguousApreviousB [
	| a b entity |
	entity := FamixTest1Method new.
	a := FamixReplica from: 2 to: 4 for: entity.
	b := FamixReplica from: 5 to: 8 for: entity.
	self assert: (a isContiguousWith: b)
]

{ #category : #tests }
FamixReplicaTest >> testContiguousApreviousBdifferentsEntities [
	| a b entity1 entity2 |
	entity1 := FamixTest1Method new.
	entity2 := FamixTest1Method new.
	a := FamixReplica from: 2 to: 4 for: entity1.
	b := FamixReplica from: 5 to: 8 for: entity2.
	self deny: (a isContiguousWith: b)
]

{ #category : #tests }
FamixReplicaTest >> testContiguousApreviousBwithUnion [
	| a b entity |
	entity := FamixTest1Method new.
	a := FamixReplica from: 2 to: 4 for: entity.
	b := FamixReplica from: 4 to: 8 for: entity.
	self assert: (a isContiguousWith: b)
]

{ #category : #tests }
FamixReplicaTest >> testContiguousBpreviousA [
	| a b entity |
	entity := FamixTest1Method new.
	b := FamixReplica from: 2 to: 4 for: entity.
	a := FamixReplica from: 5 to: 8 for: entity.
	self assert: (a isContiguousWith: b)
]

{ #category : #tests }
FamixReplicaTest >> testContiguousBpreviousAwithUnion [
	| a b entity |
	entity := FamixTest1Method new.
	b := FamixReplica from: 2 to: 4 for: entity.
	a := FamixReplica from: 4 to: 8 for: entity.
	self assert: (a isContiguousWith: b)
]

{ #category : #tests }
FamixReplicaTest >> testContiguousDifferentLength [
	| a b entity |
	"For the moment, we do not consider the cases where the lengths of the merging fragments is different. Added this test to understand the behavior in case of different lengths"
	entity := FamixTest1Method new.
	a := FamixReplica from: 2 to: 4 for: entity.
	b := FamixReplica from: 1 to: 10 for: entity.
	self assert: (a isContiguousWith: b)
]

{ #category : #tests }
FamixReplicaTest >> testNotContiguousApreviousB [
	| a b entity |
	entity := FamixTest1Method new.
	a := FamixReplica from: 2 to: 4 for: entity.
	b := FamixReplica from: 6 to: 8 for: entity.
	self deny: (a isContiguousWith: b)
]

{ #category : #tests }
FamixReplicaTest >> testNotContiguousBpreviousA [
	| a b entity |
	entity := FamixTest1Method new.
	b := FamixReplica from: 2 to: 4 for: entity.
	a := FamixReplica from: 6 to: 8 for: entity.
	self deny: (a isContiguousWith: b)
]
