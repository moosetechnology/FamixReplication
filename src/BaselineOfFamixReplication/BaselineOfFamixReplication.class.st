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
	spec for: #common do: [ 
		"Dependencies"
		self
			stonCustomizer: spec;
			tinyLogger: spec.

		"Packages"
		spec
			package: 'FamixReplication'
			with: [ spec requires: #( 'TinyLogger' 'STONCustomizer' ) ];
			package: 'FamixReplication-CPP'
			with: [ spec requires: #( 'FamixReplication' ) ];
			package: 'FamixReplication-Smalltalk'
			with: [ spec requires: #( 'FamixReplication' ) ];
			package: 'FamixReplication-Tests' with: [ 
				spec requires:
						#( 'FamixReplication-CPP' 'FamixReplication-Smalltalk' ) ].

		"If Famix is not already present"
		spec for: #NeedsFamix do: [ 
			self famix: spec.
			spec
				package: 'FamixReplication' with: [ spec requires: #( 'Famix' ) ];
				package: 'FamixReplication-Smalltalk'
				with: [ spec requires: #( 'FamixReplication' 'FamixSmalltalk' ) ] ].

		"Groups"
		spec
			group: 'Core' with: #( 'FamixReplication' );
			group: 'Smalltalk' with: #( 'FamixReplication-Smalltalk' );
			group: 'CPP' with: #( 'FamixReplication-CPP' );
			group: 'Tests' with: #( 'FamixReplication-Tests' ) ]
]

{ #category : #accessing }
BaselineOfFamixReplication >> customProjectAttributes [

	'BaselineOfFamix' asPackageIfAbsent: [ ^ #( #NeedsFamix ) ].
	^ #( )
]

{ #category : #dependencies }
BaselineOfFamixReplication >> famix: spec [

	| version |
	version := 'development'.
	spec for: #( #'pharo10.x' #'pharo9.x' ) do: [ version := 'v1.x.x' ].
	
	spec
		baseline: 'Famix' with: [
			spec
				loads: 'BasicTraits';
				repository:
					('github://moosetechnology/Famix:{1}/src' format: { version }) ];
		project: 'FamixSmalltalk'
		copyFrom: 'Famix'
		with: [ spec loads: 'EntitiesSmalltalk' ]
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
