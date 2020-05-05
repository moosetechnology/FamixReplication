Extension { #name : #FamixTSourceEntity }

{ #category : #'*FamixReplication' }
FamixTSourceEntity >> addReplica: anObject [ 
	self replicas add: anObject
]

{ #category : #'*FamixReplication' }
FamixTSourceEntity >> clearReplicationCache [
	self propertyNamed: #replicas put: OrderedCollection new
]

{ #category : #'*FamixReplication' }
FamixTSourceEntity >> containsReplicas [
	self replicas ifNotEmpty: [ ^ true ].

	^ self children anySatisfy: #containsReplicas
]

{ #category : #'*FamixReplication' }
FamixTSourceEntity >> removeReplica: aReplica [
	self containsReplicas ifTrue: [ self replicas remove: aReplica ]
]

{ #category : #'*FamixReplication' }
FamixTSourceEntity >> replicas [
	<MSEProperty: #replicas type: #FamixReplica>
	<MSEComment: 'A collection of fragments of cloned code found in this program'>
	<derived>
	^ self propertyNamed: #replicas ifAbsentPut: [ OrderedCollection new ]
]
