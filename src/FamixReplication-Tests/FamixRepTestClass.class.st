Class {
	#name : #FamixRepTestClass,
	#superclass : #FamixRepTestEntity,
	#traits : 'FamixTClass + FamixTSourceEntity',
	#classTraits : 'FamixTClass classTrait + FamixTSourceEntity classTrait',
	#category : #'FamixReplication-Tests-TestModel'
}

{ #category : #meta }
FamixRepTestClass class >> annotation [
	<FMClass: #Class super: #FamixRepTestEntity>
	<package: #'Famix-Replication-Tests'>
]
