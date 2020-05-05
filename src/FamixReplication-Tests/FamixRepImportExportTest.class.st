Class {
	#name : #FamixRepImportExportTest,
	#superclass : #FamixRepDetectorTest,
	#instVars : [
		'dupSys',
		'file'
	],
	#category : #'FamixReplication-Tests-Import-Export'
}

{ #category : #samples }
FamixRepImportExportTest >> export [
	SCExporter export: dupSys inFile: file.
	self assert: file exists.
	self denyEmpty: file contents
]

{ #category : #samples }
FamixRepImportExportTest >> newModel [
	^ MooseModel new
		add: (FamixTest1Class named: 'noname');
		addAll: self someEntities;
		yourself
]

{ #category : #running }
FamixRepImportExportTest >> setUp [
	super setUp.
	dupSys := FamixRepDetector
		runOn: self someEntities
		with:
			(FamixRepConfiguration
				sourcesCleaner: FamixRepFakeCleaner new
				minimumNumberOfReplicas: 2
				ofLines: 4
				ofCharacters: 10).
	file := FileSystem memory / 'export.ston'
]

{ #category : #samples }
FamixRepImportExportTest >> someEntities [
	^ {
		self
			mockEntityWith: 
				'I like pie
				pizza pie 
				apple pie 
				rad squared pi 
				and other PIes'
			named: 'EntityA'.
		self
			mockEntityWith: 
				'UNMATCHED
				I like pie  
				pizza pie 
				apple pie 
				rad squared pi 
				and other PIes'
			named: 'EntityB'.
		}
]

{ #category : #tests }
FamixRepImportExportTest >> testDuplicationExport [
	self export.
	self assert: file exists.
	self denyEmpty: file contents
]

{ #category : #tests }
FamixRepImportExportTest >> testDuplicationImport [
	| importedSys |
	self export.
	importedSys := SCImporter importFromFile: file state: self newModel.
	self assert: importedSys replicatedFragments size equals: dupSys replicatedFragments size.
	self assert: importedSys replicatedFragments first fragmentName equals: dupSys replicatedFragments first fragmentName.
	self assert: importedSys replicatedFragments first replicas first startLine equals: dupSys replicatedFragments first replicas first startLine.
	self assert: importedSys replicatedFragments first replicas first endLine equals: dupSys replicatedFragments first replicas first endLine
]

{ #category : #tests }
FamixRepImportExportTest >> testDuplicationImportSysAttribs [
	| configuration |
	self export.
	configuration := (SCImporter importFromFile: file state: self newModel) configuration.
	self assert: configuration minimumNumberOfLines equals: 4.
	self assert: configuration minimumNumberOfReplicas equals: 2.
	self assert: configuration minimumNumberOfCharacters equals: 10.
	self assert: (configuration sourcesCleaner isKindOf: FamixRepFakeCleaner)
]
