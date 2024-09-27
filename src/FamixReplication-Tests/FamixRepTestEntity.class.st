Class {
	#name : 'FamixRepTestEntity',
	#superclass : 'MooseEntity',
	#category : 'FamixReplication-Tests-TestModel',
	#package : 'FamixReplication-Tests',
	#tag : 'TestModel'
}

{ #category : 'meta' }
FamixRepTestEntity class >> annotation [
	<FMClass: #Entity super: #MooseEntity>
	<package: #'Famix-Replication-Tests'>
]

{ #category : 'meta' }
FamixRepTestEntity class >> metamodel [
	^ FamixRepTestModel metamodel
]

{ #category : 'testing' }
FamixRepTestEntity >> isClass [
	^ false
]

{ #category : 'testing' }
FamixRepTestEntity >> isMethod [
	^ false
]
