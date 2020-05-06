"
I am a baseline to define the structure and dependencies of the FamixReplication project.
"
Class {
	#name : #BaselineOfFamixReplication,
	#superclass : #BaselineOf,
	#category : #BaselineOfFamixReplication
}

{ #category : #baseline }
BaselineOfFamixReplication >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ "Dependencies"
			self
				famix: spec;
				stonCustomizer: spec;
				tinyLogger: spec.

			"Packages"
			spec
				package: 'FamixReplication' with: [ spec requires: #('Famix' 'TinyLogger' 'STONCustomizer') ];
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

{ #category : #dependencies }
BaselineOfFamixReplication >> famix: spec [
	spec
		baseline: 'Famix'
		with: [ spec
				loads: 'FamixTraits';
				repository: 'github://moosetechnology/Moose:development/src' ]
]

{ #category : #accessing }
BaselineOfFamixReplication >> projectClass [
	^ MetacelloCypressBaselineProject
]

{ #category : #dependencies }
BaselineOfFamixReplication >> stonCustomizer: spec [
	spec baseline: 'STONCustomizer' with: [ spec repository: 'github://jecisc/STONCustomizer:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfFamixReplication >> tinyLogger: spec [
	spec
		baseline: 'TinyLogger'
		with: [ spec
				loads: #('Core');
				repository: 'github://jecisc/TinyLogger:v1.x.x/src' ]
]
