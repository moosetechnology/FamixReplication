"
Description
--------------------

I am the result of the application of replication detection.

I know all the replicated fragments that are detected and their replicas. 
I can be configured for min number of lines of code or number of characters or number of replicas to report. 

I also know how to merge adjacent duplicate fragment to report one big contiguous duplicate fragment instead of several several small ones.

I can serialize myself on the disk in STON format.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	configuration:				<aConfiguration>		Configuration used to detect the replicated fragments.
	replicatedFragments:		<aCollection>			List of all replicated fragments detected.

"
Class {
	#name : 'FamixReplicationManager',
	#superclass : 'Object',
	#instVars : [
		'configuration',
		'replicatedFragments'
	],
	#category : 'FamixReplication-Entities',
	#package : 'FamixReplication',
	#tag : 'Entities'
}

{ #category : 'ston' }
FamixReplicationManager class >> stonName [
	^ #DuplicationSystem
]

{ #category : 'accessing' }
FamixReplicationManager >> configuration [
	^ configuration
]

{ #category : 'accessing' }
FamixReplicationManager >> configuration: aConfiguration [
	configuration := aConfiguration
]

{ #category : 'improving' }
FamixReplicationManager >> expandContiguousFragments [
	('Expand ' , self replicatedFragments size asString , ' fragments.') record.

	self replicatedFragments combinations: 2 atATimeDo: [ :fragments | fragments first tryToExpandWith: fragments second ].
	
	self removeDuplicatedFragments.

	('New number of fragments: ' , self replicatedFragments size asString) record
]

{ #category : 'postProcess' }
FamixReplicationManager >> mergeClosestOverlappingFragments: aCollectionOfFragments [
	"In this method I'll try to merge a maximum of fragments but it will not be possible all the time because some fragments can be part of the same duplication but not be contigious yet. I should return true if the merge is finished and false if I was not able to merge all the possible fragments."

	| unmergedFragments |
	('Merge ' , self replicatedFragments size asString , ' fragments of duplication.') record.

	"We try to merge the replicas and if we keep only those who failed to merge all of their replicas in this iteration."
	unmergedFragments := OrderedCollection new.

	aCollectionOfFragments
		combinations: 2
		atATimeDo: [ :pair | 
			(pair first mergeWith: pair second)
				ifFalse: [ unmergedFragments
						add: pair first;
						add: pair second ] ].

	"Remove replicated fragments without replica once they have been merged."
	self replicatedFragments removeAllSuchThat: [ :frag | frag hasReplicas not ].

	('New number of fragments: ' , self replicatedFragments size asString) record.
	^ unmergedFragments
]

{ #category : 'postProcess' }
FamixReplicationManager >> mergeClosestOverlappingFragmentsOf: aCollectionOfEntities [
	"In this method I'll try to merge a maximum of fragments but it will not be possible all the time because some fragments can be part of the same duplication but not be contigious yet. I should return true if the merge is finished and false if I was not able to merge all the possible fragments."

	| unmergedEntities |
	('Merge ' , self replicatedFragments size asString , ' fragments of duplication.') record.

	"We try to merge the replicas and if we keep only those who failed to merge all of their replicas in this iteration."
	unmergedEntities := aCollectionOfEntities reject: #mergePossibleDuplications.

	"Remove replicated fragments without replica once they have been merged."
	self replicatedFragments removeAllSuchThat: [ :frag | frag hasReplicas not ].

	('New number of fragments: ' , self replicatedFragments size asString) record.
	^ unmergedEntities
]

{ #category : 'postProcess' }
FamixReplicationManager >> mergeOverlappingFragments [
	"In this method I merge some duplication fragments because if I have a fragment in an entity from line 10 to 15 and one from line 13 to 17, at the end it can be a fragment from line 10 to 17. It is not sure that we can do it in one iteration so I'll repeat the operation until I am able to fully merge all the fragments."

	| unmergedFragments |
	unmergedFragments := self replicatedFragments.

	[ unmergedFragments := self mergeClosestOverlappingFragments: unmergedFragments.
	unmergedFragments isEmpty ] whileFalse
]

{ #category : 'cleaning' }
FamixReplicationManager >> removeDuplicatedFragments [
	"After expending fragments it is possible that some end up been contained in other ones. In that case, we remove them"

	| fragmentsToKeep |
	fragmentsToKeep := Set new.

	self replicatedFragments do: [ :fragment | (fragmentsToKeep anySatisfy: [ :anotherFragment | anotherFragment includesAllReplicasOf: fragment ]) ifFalse: [ fragmentsToKeep add: fragment ] ].

	"Do not use #reject:thenDo:. It would remove elements while iterating on the collection"
	(self replicatedFragments reject: [ :each | fragmentsToKeep includes: each]) do: [ :each | self removeReplicatedFragment: each ]
]

{ #category : 'removing' }
FamixReplicationManager >> removeReplicatedFragment: aFragment [
	self replicatedFragments remove: aFragment ifAbsent: [ ('Duplication - Fragment not found: ' , aFragment asString) record ].
	aFragment unregisterReplicasInEntities
]

{ #category : 'accessing' }
FamixReplicationManager >> replicatedFragments [
	^ replicatedFragments ifNil: [ replicatedFragments := OrderedCollection new ]
]

{ #category : 'accessing' }
FamixReplicationManager >> replicatedFragments: aCollection [
	replicatedFragments := OrderedCollection newFrom: aCollection.
	self resetFragmentNames.
]

{ #category : 'fragment-names' }
FamixReplicationManager >> resetFragmentNames [
	replicatedFragments doWithIndex: [ :each :index | each fragmentName: 'Code Fragment ' , index asString ]
]
