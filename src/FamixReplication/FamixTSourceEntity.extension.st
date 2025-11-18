Extension { #name : 'FamixTSourceEntity' }

{ #category : '*FamixReplication' }
FamixTSourceEntity >> addReplica: anObject [
	"If we do not have replicats but need to add one, we now save the collection in the cache in contrary of #replicas."

	(self cacheAt: #replicas ifAbsentPut: [ OrderedCollection new ]) add: anObject
]

{ #category : '*FamixReplication' }
FamixTSourceEntity >> clearReplicationCache [

	self removeCache: #replicas
]

{ #category : '*FamixReplication' }
FamixTSourceEntity >> codeReplicationIntervals [
	| text |
	text := self completeText.
	^ self replicas collect: [ :aCloneLocation | (text intervalOfLine: aCloneLocation startLine) first to: (text intervalOfLine: aCloneLocation endLine) last ]
]

{ #category : '*FamixReplication' }
FamixTSourceEntity >> containsReplicas [

	<FMProperty: #containsReplicas type: #Boolean>
	<derived>
	<FMComment: 'Flag true if the entity contains duplication.'>
	
	"If the cache is present, then there should be at least one replica"
	self  cacheAt: #replicas ifPresent: [ ^ true ].

	"Iterating over the children for speed reason instead of using an #anySatisfy:"
	self containedEntitiesDo: [ :child | child containsReplicas ifTrue: [  ^ true ] ].
	
	^ false
]

{ #category : '*FamixReplication' }
FamixTSourceEntity >> duplicationRate [
	<FMProperty: #duplicationRate type: #Number>
	<FMComment: 'Duplication Rate.'>
	<derived>
	^ self replicas
		ifEmpty: [ 0 ]
		ifNotEmpty: [ :cloneLocations | 
			| accumulator usefulCloneLocations |
			accumulator := 0.

			"We remove the localisations already included in other localisations because this add noise."
			usefulCloneLocations := cloneLocations
				inject: OrderedCollection new
				into: [ :res :cl | 
					res
						detect: [ :loc | loc isSupersetOfReplica: cl ]
						ifNone: [ res add: cl ].
					res ].

			"We sort the fragments by startline to get the contiguous next to each other."
			(usefulCloneLocations sort: #startLine ascending) allButLast
				do: [ :aLocation | 
					accumulator := accumulator
						+
							((aLocation isContiguousWith: (usefulCloneLocations after: aLocation))
								ifTrue: [ (usefulCloneLocations after: aLocation) startLine - aLocation startLine ]
								ifFalse: [ aLocation length ]) ].
			(accumulator + usefulCloneLocations anyOne length) / self numberOfLinesOfCode ]
]

{ #category : '*FamixReplication' }
FamixTSourceEntity >> mergePossibleDuplications [
	"I try to merge the duplication and if I fail I return false."

	| wasAbleToMergeAll |
	wasAbleToMergeAll := true.
	(self replicas collect: #replicatedFragment)
		removeDuplicates;
		combinations: 2 atATimeDo: [ :pair | (pair first mergeWith: pair second) ifFalse: [ wasAbleToMergeAll := false ] ].

	^ wasAbleToMergeAll
]

{ #category : '*FamixReplication' }
FamixTSourceEntity >> removeReplica: aReplica [

	self cacheAt: #replicas ifPresent: [ :collection | collection remove: aReplica ]
]

{ #category : '*FamixReplication' }
FamixTSourceEntity >> replicas [
	"If the entity does not have replicats, return en empty collection that we will not save to not add overhead to the memory"

	<FMProperty: #replicas type: #FamixReplica>
	<FMComment: 'A collection of fragments of cloned code found in this program'>
	<derived>
	^ self cacheAt: #replicas ifAbsent: [ OrderedCollection new ]
]
