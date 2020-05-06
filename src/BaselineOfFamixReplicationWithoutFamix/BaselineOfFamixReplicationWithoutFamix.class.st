"
I am a baseline to define the structure and dependencies of the FamixReplication project.
"
Class {
	#name : #BaselineOfFamixReplicationWithoutFamix,
	#superclass : #BaselineOf,
	#category : #BaselineOfFamixReplicationWithoutFamix
}

{ #category : #baseline }
BaselineOfFamixReplicationWithoutFamix >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ "Dependencies"
			self
				stonCustomizer: spec;
				tinyLogger: spec.

			"Packages"
			spec
				package: 'FamixReplication' with: [ spec requires: #('TinyLogger' 'STONCustomizer') ];
				package: 'FamixReplication-CPP' with: [ spec requires: #('FamixReplication') ];
				package: 'FamixReplication-Smalltalk' with: [ spec requires: #('FamixReplication') ];
				package: 'FamixReplication-Tests' with: [ spec requires: #('FamixReplication-CPP' 'FamixReplication-Smalltalk') ].

			"Groups"
			spec
				group: 'Core' with: #('FamixReplication');
				group: 'Smalltalk' with: #('FamixReplication-Smalltalk');
				group: 'CPP' with: #('FamixReplication-CPP');
				group: 'Tests' with: #('FamixReplication-Tests') ]
]

{ #category : #accessing }
BaselineOfFamixReplicationWithoutFamix >> projectClass [
	^ MetacelloCypressBaselineProject
]

{ #category : #dependencies }
BaselineOfFamixReplicationWithoutFamix >> stonCustomizer: spec [
	spec baseline: 'STONCustomizer' with: [ spec repository: 'github://jecisc/STONCustomizer:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfFamixReplicationWithoutFamix >> tinyLogger: spec [
	spec
		baseline: 'TinyLogger'
		with: [ spec
				loads: #('Core');
				repository: 'github://jecisc/TinyLogger:v1.x.x/src' ]
]
