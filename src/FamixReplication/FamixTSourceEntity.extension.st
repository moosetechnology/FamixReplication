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
FamixTSourceEntity >> codeReplicationIntervals [
	| text |
	text := self completeText.
	^ self replicas collect: [ :aCloneLocation | (text intervalOfLine: aCloneLocation startLine) first to: (text intervalOfLine: aCloneLocation endLine) last ]
]

{ #category : #'*FamixReplication' }
FamixTSourceEntity >> containsReplicas [
	self replicas ifNotEmpty: [ ^ true ].

	^ self children anySatisfy: #containsReplicas
]

{ #category : #'*FamixReplication' }
FamixTSourceEntity >> duplicationRate [
	<MSEProperty: #duplicationRate type: #Number>
	<MSEComment: 'Duplication Rate.'>
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

{ #category : #'*FamixReplication' }
FamixTSourceEntity >> mergePossibleDuplications [
	"I try to merge the duplication and if I fail I return false."

	| wasAbleToMergeAll |
	wasAbleToMergeAll := true.
	(self replicas collect: #replicatedFragment)
		removeDuplicates;
		combinations: 2 atATimeDo: [ :pair | (pair first mergeWith: pair second) ifFalse: [ wasAbleToMergeAll := false ] ].

	^ wasAbleToMergeAll
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
