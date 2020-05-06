Class {
	#name : #FamixRepEntitiesTest,
	#superclass : #TestCase,
	#category : #'FamixReplication-Tests-Entities'
}

{ #category : #tests }
FamixRepEntitiesTest >> testEntitiesCache [
	| entity |
	entity := FamixRepTestClass new.
	entity
		addReplica:
			(FamixReplica new
				startLine: 1;
				endLine: 10;
				entity: entity;
				yourself).
	self assert: entity containsReplicas.
	entity clearReplicationCache.
	self deny: entity containsReplicas
]

{ #category : #tests }
FamixRepEntitiesTest >> testReplicatedFragment [
	| fragment |
	fragment := FamixReplicatedFragment new
		fragmentName: 'test';
		yourself.
	fragment fragmentName: 'fragment'.
	self assert: fragment fragmentName equals: 'fragment'
]

{ #category : #tests }
FamixRepEntitiesTest >> testReplicationManager [
	| fragment class method replica model |
	model := FamixRepTestModel new.
	class := FamixRepTestClass named: 'class' model: model.
	method := FamixRepTestMethod named: 'method' model: model.
	FamixRepTestMethod named: 'method2' model: model.
	method parentType: class.
	model replicationManager: FamixReplicationManager new.
	fragment := FamixReplicatedFragment new
		fragmentName: 'test';
		yourself.
	replica := FamixReplica new
		startLine: 1;
		endLine: 12;
		entity: method.
	method addReplica: replica.
	fragment addReplica: replica.
	self assert: replica replicatedFragment equals: fragment.
	self assert: fragment replicas size equals: 1.
	self assert: fragment entitiesContainingFragment size equals: 1.
	self assert: model allContainersWithDuplicatedCode size equals: 2.
	self assert: model allBehaviouralsWithDuplicatedCode size equals: 1.
	method clearReplicationCache.
	model clearReplicationManager.
	self assertEmpty: model allContainersWithDuplicatedCode.
	self assertEmpty: model allBehaviouralsWithDuplicatedCode
]
