"
Description
--------------------

I represent a configuration to run a replication detection.

Examples
--------------------

	 FamixRepConfiguration
		sourcesCleaner: FamixRepCPPCleaner new
		minimumNumberOfReplicas: 5
		ofLines: 10
		ofCharacters: 80
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	minimumNumberOfCharacters:		<anInteger>		Minimum number of characters in replicated fragment. Too small code fragment are not interesting.
	minimumNumberOfLines:				<anInteger>		Minimum number of lines of code. It is important not to report all the replica but those which have a certain size.
	minimumNumberOfReplicas:			<anInteger>		The number of times a snippet is replicated. For example, correcting those copied ten times have much more impact on code quality than those copied only twice.
	sourcesCleaner:						<aCleaner>		The cleaner used to clean the code before detecting replication.
"
Class {
	#name : 'FamixRepConfiguration',
	#superclass : 'Object',
	#instVars : [
		'sourcesCleaner',
		'minimumNumberOfReplicas',
		'minimumNumberOfCharacters',
		'minimumNumberOfLines'
	],
	#category : 'FamixReplication-Detection',
	#package : 'FamixReplication',
	#tag : 'Detection'
}

{ #category : 'instance creation' }
FamixRepConfiguration class >> sourcesCleaner: aSourcesCleaner minimumNumberOfReplicas: anInteger ofLines: anotherInteger ofCharacters: yetAnotherInteger [
	^ self new
		minimumNumberOfReplicas: anInteger;
		minimumNumberOfLines: anotherInteger;
		minimumNumberOfCharacters: yetAnotherInteger;
		sourcesCleaner: aSourcesCleaner
]

{ #category : 'ston-core' }
FamixRepConfiguration class >> stonName [
	^ #ReplicationConfiguration
]

{ #category : 'accessing' }
FamixRepConfiguration >> minimumNumberOfCharacters [
	^ minimumNumberOfCharacters
]

{ #category : 'accessing' }
FamixRepConfiguration >> minimumNumberOfCharacters: anInteger [
	minimumNumberOfCharacters := anInteger
]

{ #category : 'accessing' }
FamixRepConfiguration >> minimumNumberOfLines [
	^ minimumNumberOfLines
]

{ #category : 'accessing' }
FamixRepConfiguration >> minimumNumberOfLines: anInteger [
	minimumNumberOfLines := anInteger
]

{ #category : 'accessing' }
FamixRepConfiguration >> minimumNumberOfReplicas [
	^ minimumNumberOfReplicas
]

{ #category : 'accessing' }
FamixRepConfiguration >> minimumNumberOfReplicas: anInteger [
	minimumNumberOfReplicas := anInteger
]

{ #category : 'accessing' }
FamixRepConfiguration >> sourcesCleaner [
	^ sourcesCleaner
]

{ #category : 'accessing' }
FamixRepConfiguration >> sourcesCleaner: aSourceCleaner [
	sourcesCleaner := aSourceCleaner
]
