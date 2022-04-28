"
Description
--------------------

I am responsible for the detection of replication in the selected entities.

I'll act in multiple steps. 
- First I'll reject some entities that do not have enough info to be processed.
- I'll clean the source code of the entities no remove everything that can be considered as noise such as comments or line returns.
- I'll iterate over the sources anchors and for each of them I'll cut the source text in overlapping fragments and add them to a dictionary with their hash as their key. This will have for effect to group similar text fragment and is faster than string comparison.
- We can then keep only the fragments present in multiple part of the system.

At the end, adjacent replicated fragments are merged to report one fragment instead of several adjacent ones. The user can provide parameters for a code fragment: minimum lines of code and number of locations.
	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	bucket:				<aDictionary>			A Dictionary containing the has of each text fragments and the associated fragments.
	configuration:		<aConfiguration>		A configuration to parametrize the replication detection.

"
Class {
	#name : #FamixRepDetector,
	#superclass : #Object,
	#instVars : [
		'bucket',
		'configuration'
	],
	#category : #'FamixReplication-Detection'
}

{ #category : #execution }
FamixRepDetector class >> runOn: aMooseGroup with: aConfiguration [
	^ self new
		configuration: aConfiguration;
		runOn: aMooseGroup
]

{ #category : #accessing }
FamixRepDetector >> bucket [
	^ bucket
]

{ #category : #accessing }
FamixRepDetector >> configuration [
	^ configuration
]

{ #category : #accessing }
FamixRepDetector >> configuration: aRepConfiguration [
	configuration := aRepConfiguration
]

{ #category : #accessing }
FamixRepDetector >> detectReplicatedFragmentsOf: aSourcedEntity [
	configuration sourcesCleaner reset.
	aSourcedEntity allSourceAnchorsDo: [ :sourceAnchor | self detectReplicatedFragmentsOf: aSourcedEntity sourceAnchor: sourceAnchor ]
]

{ #category : #accessing }
FamixRepDetector >> detectReplicatedFragmentsOf: anEntity sourceAnchor: sourceAnchor [
	(self sourcesCleaner cleanedTextLines: sourceAnchor sourceText)
		ifNotEmpty: [ :lines | 
			configuration minimumNumberOfLines > lines size ifTrue: [ ^ self ].

			(lines allButLast: configuration minimumNumberOfLines - 1)
				withIndexDo: [ :line :index | 
					self
						registerToBucket: ((lines copyFrom: index to: index + configuration minimumNumberOfLines - 1) collect: #value)
						from: line key
						to: (lines at: index + configuration minimumNumberOfLines - 1) key
						in: sourceAnchor
						for: anEntity ] ]
]

{ #category : #private }
FamixRepDetector >> getHashFor: aCollectionOfLines concatenated: concatenateLines [
	^ concatenateLines hash * 10000000000000 + (String streamContents: [ :s | 1 to: aCollectionOfLines size do: [ :ind | s << (aCollectionOfLines at: ind) first ] ]) hash
]

{ #category : #private }
FamixRepDetector >> getReplicatedFragments [
	('Select cloned fragments from a bucket of ' , bucket values size asString , ' clones.') record.

	^ (bucket values select: [ :aFragment | aFragment replicas size >= configuration minimumNumberOfReplicas ])
			do: #registerReplicasInEntities;
			yourself
]

{ #category : #initialization }
FamixRepDetector >> initialize [
	super initialize.
	bucket := Dictionary new
]

{ #category : #private }
FamixRepDetector >> registerToBucket: aCollectionOfLines from: firstLineIndex to: lastLineIndex in: fileAnchor for: anEntity [
	aCollectionOfLines concatenatesStrings
		ifNotEmpty: [ :concatenatedLines | 
			| replica |
			concatenatedLines size > configuration minimumNumberOfCharacters ifFalse: [ ^ self ].

			replica := FamixReplica from: firstLineIndex to: lastLineIndex in: fileAnchor for: anEntity.

			bucket
				at: (self getHashFor: aCollectionOfLines concatenated: concatenatedLines)
				ifPresent: [ :clone | clone addReplica: replica ]
				ifAbsentPut: [ FamixReplicatedFragment with: replica ] ]
]

{ #category : #execution }
FamixRepDetector >> runOn: aCollection [

	| manager |
	self
		execute: [ 
			('Begin to register the fragments for ' , aCollection size asString
			 , ' entities.') record.

			(self selectEntitiesWithEnoughInformationFrom: aCollection) do: [ 
				:anEntity | self detectReplicatedFragmentsOf: anEntity ].

			manager := FamixReplicationManager new
				           replicatedFragments: self getReplicatedFragments;
				           configuration: self configuration;
				           mergeOverlappingFragments;
				           expandContiguousFragments;
				           resetFragmentNames;
				           "We reinit the names because some numbers might have been merge and there is an index in the fragment name."
					           yourself.

			('Duplication end with '
			 , manager replicatedFragments size asString , ' fragments.')
				record ]
		recordedAs: 'Duplication computation'.

	^ manager
]

{ #category : #execution }
FamixRepDetector >> selectEntitiesWithEnoughInformationFrom: aCollection [
	"I reject the entities that does not have a source anchor or whose source anchor does not know the start or the end position of the source in a file because in that case we will read everything and display wrong informations."

	| res size |
	size := aCollection size.
	res := aCollection select: #hasSourceAnchor.
	((size - (size := res size)) asString , ' entities without source anchors were rejected.') record.
	
	res := res select: [ :entity | entity sourceAnchor knowsStart ].
	((size - (size := res size)) asString , ' entities whose source anchor does not knows the start position in its source were rejected.') record.
	
	res := res select: [ :entity | entity sourceAnchor knowsEnd ].
	((size - (size := res size)) asString , ' entities whose source anchor does not knows the end position in its source were rejected.') record.

	"for duplication, we consider only those entities whose "
	res := res select: [ :entity | entity numberOfLinesOfCode >= self configuration minimumNumberOfLines ].
	((size - (size := res size)) asString , ' entities whose number of lines of code is greater or equal to the min number of lines of code for duplication detection. (' , self configuration minimumNumberOfLines asString ,' lines min)') record.
	
	(size asString , ' entities with enough informations to run duplication on.') record.
	^ res
]

{ #category : #accessing }
FamixRepDetector >> sourcesCleaner [
	^ configuration sourcesCleaner
]
