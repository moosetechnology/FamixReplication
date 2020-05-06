Class {
	#name : #FamixRepTestMethod,
	#superclass : #FamixRepTestEntity,
	#traits : 'FamixTMethod + FamixTSourceEntity + TDependencyQueries + TEntityMetaLevelDependency',
	#classTraits : 'FamixTMethod classTrait + FamixTSourceEntity classTrait + TDependencyQueries classTrait + TEntityMetaLevelDependency classTrait',
	#category : #'FamixReplication-Tests-TestModel'
}

{ #category : #meta }
FamixRepTestMethod class >> annotation [
	<FMClass: #Method super: #FamixRepTestEntity>
	<package: #'Famix-Replication-Tests'>
]
