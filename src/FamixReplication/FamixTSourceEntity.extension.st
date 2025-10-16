Extension { #name : 'FamixTSourceEntity' }

{ #category : '*FamixReplication' }
FamixTSourceEntity >> addReplica: anObject [ 
	self replicas add: anObject
]

{ #category : '*FamixReplication' }
FamixTSourceEntity >> clearReplicationCache [

	self cacheAt: #replicas put: OrderedCollection new
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
	self replicas ifNotEmpty: [ ^ true ].

	^ self containedEntities anySatisfy: #containsReplicas
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
	self containsReplicas ifTrue: [ self replicas remove: aReplica ]
]

{ #category : '*FamixReplication' }
FamixTSourceEntity >> replicas [

	<FMProperty: #replicas type: #FamixReplica>
	<FMComment: 'A collection of fragments of cloned code found in this program'>
	<derived>
	^ self cacheAt: #replicas ifAbsentPut: [ OrderedCollection new ]
]
