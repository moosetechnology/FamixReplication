"
Description
--------------------

I represent one replica of a replica fragment. I know the file anchor of a replica and the localisation of the replicated text in the file anchor.	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	endLine:						<anInteger> 			Last line of the replica in the file anchor.
	entity:						<anEntity>			Entity concerned by this replica. This entity should be a behavioural entity in Famix such as a method or a function.
	fileAnchor:					<aFileAnchor>		File anchor containing the replica. We save it here because an entity can have multiple file anchors.
	replicatedFragment:		<aFragment>			The replicated fragment for which I am on of the replica.
	startLine:					<anInteger>			First line of the replica in the file anchor.

"
Class {
	#name : #FamixReplica,
	#superclass : #MooseEntity,
	#instVars : [
		'startLine',
		'endLine',
		'entity',
		'fileAnchor',
		'replicatedFragment'
	],
	#category : #'FamixReplication-Entities'
}

{ #category : #meta }
FamixReplica class >> annotation [
	<FMClass: #Replica super: #MooseEntity >
	<package: #FamixReplication>
]

{ #category : #ston }
FamixReplica class >> entityCustomizer [
	<stonCustomizationFor: #entity>
	^ STONCustomizer
		readBlock: [ :fragment :value :reader | 
			fragment
				entity:
					((reader state entityNamed: value ifAbsent: [ nil ])
						ifNotNil: [ :entity | 
							entity addReplica: fragment.
							entity ]) ]
		writeBlock: [ :fragment | fragment entity mooseName ]
]

{ #category : #ston }
FamixReplica class >> fileAnchorCustomizer [
	<stonCustomizationFor: #fileAnchor>
	^ STONCustomizer
		readBlock: [ :fragment :value | 
			fragment
				fileAnchor:
					(fragment entity allSourceAnchors
						detect: [ :each | each fileName = value ]
						ifNone: [ self error: 'No file named ' , value , ' in ' , fragment entity asString ]) ]
		writeBlock: [ :fragment | fragment fileAnchor fileName ]
]

{ #category : #'instance creation' }
FamixReplica class >> from: start to: end for: anEntity [
	"Adds clone location in entity setted in this location"
	| result |

	result := self new
		startLine: start;
		endLine: end;
		entity: anEntity;
		yourself.
	anEntity addReplica: result.
	^ result.
]

{ #category : #'instance creation' }
FamixReplica class >> from: start to: end in: fileAnchor for: anEntity [
	^ self new
		startLine: start;
		endLine: end;
		fileAnchor: fileAnchor;
		entity: anEntity;
		yourself
]

{ #category : #ston }
FamixReplica class >> stonAllInstVarNames [
	"Here we need to keep the order of the variables because entity needs to be before fileAnchor, else it might be a problem during the import since the FileAnchor need to be imported AFTER the entity."

	| toReject |
	toReject := #(#mooseID #state #mooseModel #replicatedFragment).
	^ super stonAllInstVarNames reject: [ :each | toReject includes: each ]
]

{ #category : #ston }
FamixReplica class >> stonName [
	^ #Location
]

{ #category : #accessing }
FamixReplica >> codeText [
	| text |
	text := self entitySourceCode.
	^ text copyFrom: (text intervalOfLine: self startLine) first to: (text intervalOfLine: self endLine) last
]

{ #category : #testing }
FamixReplica >> concernSameSubjectAs: anotherReplica [
	"Return true if my entity and file containing the sources are the same as the onthe replica."

	self entity = anotherReplica entity ifFalse: [ ^ false ].

	^ self fileAnchor = anotherReplica fileAnchor
]

{ #category : #accessing }
FamixReplica >> endLine [
	<navigation: 'Ending line of the replica'>
	^ endLine
]

{ #category : #accessing }
FamixReplica >> endLine: anObject [
	endLine := anObject
]

{ #category : #accessing }
FamixReplica >> entity [
	<navigation: 'The entity of this replica'>
	^ entity
]

{ #category : #accessing }
FamixReplica >> entity: anEntity [
	entity := anEntity.
]

{ #category : #accessing }
FamixReplica >> entitySourceCode [
	^ self fileAnchor sourceText
]

{ #category : #accessing }
FamixReplica >> fileAnchor [
	<navigation: 'The file of the entity that contains the duplicated code fragment'>
	^ fileAnchor
]

{ #category : #accessing }
FamixReplica >> fileAnchor: aFileAnchor [
	fileAnchor := aFileAnchor
]

{ #category : #testing }
FamixReplica >> hasReplicatedFragment [
	"If a replica does not have a replicated fragment it might mean that it was removed form the replication system and should not be considered for analysis anymore."

	^ self replicatedFragment isNotNil
]

{ #category : #testing }
FamixReplica >> isContiguousWith: anotherLocation [
	"Return true if the duplication fragment is in the same file and overlapping with the fragment passed as parameter."

	(self concernSameSubjectAs: anotherLocation) ifFalse: [ ^ false ].

	^ self startLine <= (anotherLocation endLine + 1) and: [ self endLine + 1 >= anotherLocation startLine ]
]

{ #category : #testing }
FamixReplica >> isSupersetOfReplica: aReplica [
	(self concernSameSubjectAs: aReplica) ifFalse: [ ^ false ].

	^ (aReplica startLine between: self startLine and: self endLine) and: [ aReplica endLine between: self startLine and: self endLine ]
]

{ #category : #accessing }
FamixReplica >> length [
	^ self endLine - self startLine + 1
]

{ #category : #printing }
FamixReplica >> mooseNameOn: stream [
	stream
		nextPutAll: 'Replica in ';
		nextPutAll: self name;
		nextPutAll: '(file: ';
		nextPutAll: self replicaFileName;
		nextPutAll: ' from: ';
		print: self startLine;
		nextPutAll: ' to: ';
		print: self endLine;
		nextPut: $)
]

{ #category : #accessing }
FamixReplica >> name [
	^ self entity ifNil: [ #undefined ] ifNotNil: #name
]

{ #category : #accessing }
FamixReplica >> replicaFileName [
	self fileAnchor ifNotNil: [ :anchor | anchor isFileAnchor ifTrue: [ ^ anchor fileName ] ].
	^ 'no replica file name'
]

{ #category : #accessing }
FamixReplica >> replicatedFragment [ 
	^ replicatedFragment
]

{ #category : #accessing }
FamixReplica >> replicatedFragment: aReplicatedFragment [
	replicatedFragment := aReplicatedFragment
]

{ #category : #accessing }
FamixReplica >> startLine [
	<navigation: 'Starting line of the replica'>
	^ startLine
]

{ #category : #accessing }
FamixReplica >> startLine: anObject [
	startLine := anObject
]
