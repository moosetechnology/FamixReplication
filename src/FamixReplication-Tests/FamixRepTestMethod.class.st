Class {
	#name : #FamixRepTestMethod,
	#superclass : #FamixRepTestEntity,
	#traits : 'FamixTMethod + FamixTSourceEntity',
	#classTraits : 'FamixTMethod classTrait + FamixTSourceEntity classTrait',
	#category : #'FamixReplication-Tests-TestModel'
}

{ #category : #meta }
FamixRepTestMethod class >> annotation [
	<FMClass: #Method super: #FamixRepTestEntity>
	<package: #'Famix-Replication-Tests'>
]
