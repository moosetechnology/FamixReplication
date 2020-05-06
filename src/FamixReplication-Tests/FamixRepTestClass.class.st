Class {
	#name : #FamixRepTestClass,
	#superclass : #FamixRepTestEntity,
	#traits : 'FamixTClass + FamixTSourceEntity + TDependencyQueries + TEntityMetaLevelDependency',
	#classTraits : 'FamixTClass classTrait + FamixTSourceEntity classTrait + TDependencyQueries classTrait + TEntityMetaLevelDependency classTrait',
	#category : #'FamixReplication-Tests-TestModel'
}

{ #category : #meta }
FamixRepTestClass class >> annotation [
	<FMClass: #Class super: #FamixRepTestEntity>
	<package: #'Famix-Replication-Tests'>
]
