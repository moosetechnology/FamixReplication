Extension { #name : #MooseModel }

{ #category : #'*FamixReplication' }
MooseModel >> allContainersWithDuplicatedCode [
	<navigation: 'All containers with duplicated code'>
	^ self allModelContainers select: #containsReplicas
]

{ #category : #'*FamixReplication' }
MooseModel >> clearReplicationManager [
	'Clear replication manager' record.
	self entitiesForReplicationDetection do: #clearReplicationCache.
	self privateState removeProperty: #allBehaviouralsWithDuplicatedCode
]

{ #category : #'*FamixReplication' }
MooseModel >> entitiesForReplicationDetection [
	"Override this depending on your model."

	^ self allModelContainers
]

{ #category : #'*FamixReplication' }
MooseModel >> initializeReplicationManager [
	self clearReplicationManager.
	'Initialize replication detector' record.
	self replicationManager: (FamixRepDetector runOn: self entitiesForReplicationDetection with: self replicationDetectionConfiguration)
]

{ #category : #'*FamixReplication' }
MooseModel >> replicationDetectionConfiguration [
	self subclassResponsibility
]

{ #category : #'*FamixReplication' }
MooseModel >> replicationManager [
	^ self privateState
		attributeAt: #replicationManager
		ifAbsent: [ self initializeReplicationManager.
			self replicationManager ]
]

{ #category : #'*FamixReplication' }
MooseModel >> replicationManager: anObject [
	self privateState attributeAt: #replicationManager put: anObject
]
