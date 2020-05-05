Extension { #name : #MooseModel }

{ #category : #'*FamixReplication' }
MooseModel >> allBehaviouralsWithDuplicatedCode [
	<navigation: 'All executables with duplicated code'>
	^ self
		lookUpPropertyNamed: #allBehaviouralsWithDuplicatedCode
		computedAs: [ 'Compute allBehaviouralsWithDuplicatedCode' record.

			"Ensure the replication detection was run."
			self replicationManager.

			self allModelBehaviourals select: #containsReplicas ]
]

{ #category : #'*FamixReplication' }
MooseModel >> allContainersWithDuplicatedCode [
	<navigation: 'All containers with duplicated code'>
	^ self allModelContainers select: #containsReplicas
]

{ #category : #'*FamixReplication' }
MooseModel >> allReplicatedFragments [
	<navigation: 'All replicated fragments'>
	^ self replicationManager replicatedFragments
]

{ #category : #'*FamixReplication' }
MooseModel >> clearReplicationManager [
	'Clear replication manager' record.
	self entitiesForReplicationDetection do: #clearReplicationCache.
	self privateState removeProperty: #allBehaviouralsWithDuplicatedCode
]

{ #category : #'*FamixReplication' }
MooseModel >> duplicationRate [
	"I return a metric that correspond to the percentage of duplication in the code."

	^ self
		lookUpPropertyNamed: #duplicationRate
		computedAs: [ [ | coll |
			coll := self entitiesForReplicationDetection.
			(coll sumNumbers: #duplicationRate) / coll size ]
				on: ZeroDivide
				do: [ MooseUnavailableMetric ] ]
]

{ #category : #'*FamixReplication' }
MooseModel >> entitiesForReplicationDetection [
	"Override this depending on your model."

	^ self allModelContainers
]

{ #category : #'*FamixReplication' }
MooseModel >> exportReplicationTo: file [
	self
		execute: [ self detectEncodingOfAllFileAnchors.
			SCExporter export: self replicationManager inFile: file ]
		recordedAs: 'Duplication export'
]

{ #category : #'*FamixReplication' }
MooseModel >> importReplicationFrom: file [
	self
		execute: [ file
				ifExists: [ [ self replicationManager: (SCImporter importFromFile: file state: self) ]
						on: Error
						do: [ 'Error during the loading of duplication.' record ] ]
				ifAbsent: [ 'Duplication file does not exists.' record ] ]
		recordedAs: 'Loading of duplication'
]

{ #category : #'*FamixReplication' }
MooseModel >> initializeReplicationManager [
	self clearReplicationManager.
	'Initialize replication detector' record.
	self replicationManager: (FamixRepDetector runOn: self entitiesForReplicationDetection with: self replicationDetectionConfiguration)
]

{ #category : #'*FamixReplication' }
MooseModel >> replicationDetectionConfiguration [
	"Example:
	
	replicationDetectionConfiguration
	^ FamixRepConfiguration
		sourcesCleaner: FamixRepCPPCleaner new
		minimumNumberOfReplicas: 2
		ofLines: 100
		ofCharacters: 80
		
		"

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
