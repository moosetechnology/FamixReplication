Class {
	#name : #FamixRepEntitiesTest,
	#superclass : #TestCase,
	#category : #'FamixReplication-Tests-Entities'
}

{ #category : #tests }
FamixRepEntitiesTest >> testEntitiesCache [
	| entity |
	entity := FamixTest1Class new.
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
	| fragment entity replica model |
	entity := FamixTest1Class named: 'myProgram'.
	model := FamixTest1Model new.
	model add: entity.
	model replicationManager: FamixReplicationManager new.
	fragment := FamixReplicatedFragment new
		fragmentName: 'test';
		yourself.
	replica := FamixReplica new
		startLine: 1;
		endLine: 12;
		entity: entity.
	entity addReplica: replica.
	fragment addReplica: replica.
	self assert: replica replicatedFragment equals: fragment.
	self assert: fragment replicas size equals: 1.
	self assert: fragment entitiesContainingFragment size equals: 1.
	self assert: model allContainersWithDuplicatedCode size equals: 1.
	entity clearReplicationCache.
	self assertEmpty: model allContainersWithDuplicatedCode
]
