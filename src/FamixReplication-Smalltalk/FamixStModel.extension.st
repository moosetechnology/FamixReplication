Extension { #name : 'FamixStModel' }

{ #category : '*FamixReplication-Smalltalk' }
FamixStModel >> defaultDetectionConfiguration [

	^ FamixRepConfiguration
		  sourcesCleaner: FamixRepSmalltalkCleaner new
		  minimumNumberOfReplicas: 2
		  ofLines: 10
		  ofCharacters: 80
]
