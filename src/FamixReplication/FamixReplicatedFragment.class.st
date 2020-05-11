"
Description
--------------------

I represent a replicated fragment of code. I contains multiple replica that are each one a location of this replicated fragment.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	fragmentName:		<aString>				Generated name to distinguish replicated fragments.
	replicas:				<aCollection>		A collection of replica locations.

"
Class {
	#name : #FamixReplicatedFragment,
	#superclass : #MooseEntity,
	#instVars : [
		'replicas',
		'fragmentName'
	],
	#category : #'FamixReplication-Entities'
}

{ #category : #meta }
FamixReplicatedFragment class >> annotation [
	<MSEClass: #ReplicatedFragment super: #MooseEntity >
	<package: #FamixReplication>
]

{ #category : #ston }
FamixReplicatedFragment class >> stonAllInstVarNames [
	^ super stonAllInstVarNames \ {#mooseID . #state . #mooseModel}
]

{ #category : #ston }
FamixReplicatedFragment class >> stonName [
	^ #Fragment
]

{ #category : #'instance creation' }
FamixReplicatedFragment class >> with: aReplica [
	^ self new
		addReplica: aReplica;
		yourself
]

{ #category : #accessing }
FamixReplicatedFragment >> addReplica: aFragmentLocation [
	self replicas add: aFragmentLocation.
	aFragmentLocation replicatedFragment: self
]

{ #category : #testing }
FamixReplicatedFragment >> allReplicasConcernSameFilesAs: anotherFragment [
	self replicas size <= anotherFragment replicas size ifFalse: [ ^ false ].

	^ self replicas allSatisfy: [ :aReplica | anotherFragment replicas anySatisfy: [ :anotherReplica | anotherReplica concernSameSubjectAs: aReplica ] ]
]

{ #category : #enumerating }
FamixReplicatedFragment >> averageNumberOfLines [
	self replicas ifEmpty: [ ^ MooseUnavailableMetric ].
	^ (self replicas sum: #length) / self replicas size
]

{ #category : #accessing }
FamixReplicatedFragment >> codeText [
	^ replicas anyOne codeText
]

{ #category : #enumerating }
FamixReplicatedFragment >> entitiesContainingFragment [
	^ self replicas collectAsSet: #entity
]

{ #category : #accessing }
FamixReplicatedFragment >> fragmentName [
	^ fragmentName
]

{ #category : #accessing }
FamixReplicatedFragment >> fragmentName: aString [
	fragmentName := aString.
]

{ #category : #ston }
FamixReplicatedFragment >> fromSton: stonReader [
	super fromSton: stonReader.
	self replicas do: [ :member | member replicatedFragment: self ]
]

{ #category : #merge }
FamixReplicatedFragment >> getReplicaCorrespondingTo: aReplica [
	| possibleFragments |
	"We need to check the file anchor because an entity can have multiple fileAnchor."
	possibleFragments := self replicas select: [ :replica | replica concernSameSubjectAs: aReplica ].

	"If there is only one result, it's the good one. If there is multiple result, there we can try to find the right result if a location contains a part of another location. Else we cannot find the right location and we return nil."

	^ possibleFragments size = 1
		ifTrue: [ possibleFragments anyOne ]
		ifFalse: [ possibleFragments
				detect: [ :each | (aReplica startLine between: each startLine and: each endLine) or: [ each startLine between: aReplica startLine and: aReplica endLine ] ]
				ifNone: [ nil ] ]
]

{ #category : #printing }
FamixReplicatedFragment >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0>
	^ composite fastList
		title: 'Replicas';
		display: [ self replicas ];
		beMultiple;
		format: [ :each | GTObjectPrinter asTruncatedTextFrom: each ];
		send: [ :result | 
			result
				ifNotNil: [ result size = 1
						ifTrue: [ result anyOne ]
						ifFalse: [ self species withAll: result ] ] ]
]

{ #category : #testing }
FamixReplicatedFragment >> hasContiguousReplicaWith: aReplica [
	^ self replicas anySatisfy: [ :anotherReplica | aReplica isContiguousWith: anotherReplica ]
]

{ #category : #testing }
FamixReplicatedFragment >> hasReplicas [
	^ self replicas isNotEmpty
]

{ #category : #testing }
FamixReplicatedFragment >> includesAllReplicasOf: anotherFragment [
	^ anotherFragment replicas allSatisfy: [ :replica | self replicas anySatisfy: [ :anotherReplica | anotherReplica isSupersetOfReplica: replica ] ]
]

{ #category : #testing }
FamixReplicatedFragment >> isReplicatedFragment [
	^ true
]

{ #category : #merge }
FamixReplicatedFragment >> mergeWith: anotherFragment [
	"I try to merge with another fragment. If I fail I return false to signal the merge was not finished."

	(self mergeableWith: anotherFragment) ifFalse: [ ^ true ].
	self replicas
		do: [ :replica | 
			(anotherFragment getReplicaCorrespondingTo: replica)
				ifNotNil: [ :anotherReplica | 
					replica startLine: (replica startLine min: anotherReplica startLine).
					replica endLine: (replica endLine max: anotherReplica endLine).
					anotherFragment remove: anotherReplica ] ].
	^ anotherFragment hasReplicas not
]

{ #category : #testing }
FamixReplicatedFragment >> mergeableWith: anotherFragment [
	anotherFragment = self ifTrue: [ ^ false ].
	
	^ (self replicas allSatisfy: [ :replica | anotherFragment hasContiguousReplicaWith: replica ])
		and: [ anotherFragment replicas allSatisfy: [ :replica | self hasContiguousReplicaWith: replica ] ]
]

{ #category : #printing }
FamixReplicatedFragment >> mooseNameOn: aStream [
	aStream << self fragmentName ifNil: [ #noname ]
]

{ #category : #printing }
FamixReplicatedFragment >> printOn: aStream [
	super printOn: aStream.
	aStream
		space;
		nextPut: $[;
		nextPutAll: self replicas size asString;
		nextPutAll: ' fragments]'
]

{ #category : #private }
FamixReplicatedFragment >> properties [
	^ {('Number of files' -> self replicas size asString).
	('Number of cloned lines' -> self averageNumberOfLines asInteger asString)}
]

{ #category : #merge }
FamixReplicatedFragment >> registerReplicasInEntities [
	"By default the replicas are not registered in entities since we create false result during the detection. Once it is done, we can register the non false positives."

	self replicas do: [ :replica | replica entity addReplica: replica ]
]

{ #category : #merge }
FamixReplicatedFragment >> remove: aReplica [
	aReplica entity removeReplica: aReplica.
	aReplica entity: nil.
	aReplica replicatedFragment: nil.
	self replicas remove: aReplica.
	
]

{ #category : #accessing }
FamixReplicatedFragment >> replicas [
	<navigation: 'Members of this clone fragment'>
	^ replicas ifNil: [ replicas := OrderedCollection new ]
]

{ #category : #accessing }
FamixReplicatedFragment >> replicas: anObject [
	replicas := anObject.
]

{ #category : #merge }
FamixReplicatedFragment >> tryToExpandWith: anotherFragment [
	"If it's the same fragment, we don't need to do anything."
	self = anotherFragment ifTrue: [ ^ self ].

	"We can expend a fragment only if all replicas of the other fragment are prensent in this fragment."
	(self allReplicasConcernSameFilesAs: anotherFragment) ifFalse: [ ^ self ].

	"here we have fragments that are a subgroup of another fragment in term of files so we can expand aFragment"
	self replicas
		do: [ :aReplica | 
			anotherFragment replicas
				do: [ :anotherReplica | 
					((anotherReplica isContiguousWith: aReplica) or: [ aReplica isContiguousWith: anotherReplica ])
						ifTrue: [ aReplica startLine: (aReplica startLine min: anotherReplica startLine).
							aReplica endLine: (aReplica endLine max: anotherReplica endLine) ] ] ]
]

{ #category : #merge }
FamixReplicatedFragment >> unregisterReplicasInEntities [
	self replicas do: [ :replica | replica entity removeReplica: replica ]
]
