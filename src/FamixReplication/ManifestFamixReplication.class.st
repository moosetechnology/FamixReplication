"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestFamixReplication',
	#superclass : 'PackageManifest',
	#category : 'FamixReplication-Manifest',
	#package : 'FamixReplication',
	#tag : 'Manifest'
}

{ #category : 'asserting' }
ManifestFamixReplication class >> shouldBeIncludedByDefaultInMetamodelsWith: aCollectionOfPackages [
	^ true
]
