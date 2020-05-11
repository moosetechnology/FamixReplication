Extension { #name : #FamixStModel }

{ #category : #'*FamixReplication-Smalltalk' }
FamixStModel >> replicationDetectionConfiguration [
	^ FamixRepConfiguration
		sourcesCleaner: FamixRepSmalltalkCleaner new
		minimumNumberOfReplicas: 2
		ofLines: 10
		ofCharacters: 80
]
