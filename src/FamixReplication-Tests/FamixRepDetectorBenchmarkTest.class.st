Class {
	#name : 'FamixRepDetectorBenchmarkTest',
	#superclass : 'FamixRepDetectorTest',
	#category : 'FamixReplication-Tests-Detection',
	#package : 'FamixReplication-Tests',
	#tag : 'Detection'
}

{ #category : 'running' }
FamixRepDetectorBenchmarkTest >> assertReasonableTimeToRun: sourceCodes [
	| detector timeToRun |
	timeToRun := [ detector := FamixRepDetector
		runOn: (self mockEntityWithAll: sourceCodes)
		with:
			(FamixRepConfiguration
				sourcesCleaner: FamixRepFakeCleaner new
				minimumNumberOfReplicas: 2
				ofLines: 5
				ofCharacters: 30) ] timeToRun.

	'----------------------' record.
	('Benchmarking: ' , self asString) record.
	'----------------------' record.
	('# Fragments: ' , detector replicatedFragments size asString) record.
	('# Programs: ' , sourceCodes size asString) record.
	('# Total program lines: ' , (sourceCodes sum: [ :each | each lines size ]) asString) record.
	('Time to run: ' , timeToRun asString) record.
	self assert: timeToRun < 15 seconds
]

{ #category : 'accessing' }
FamixRepDetectorBenchmarkTest >> defaultTimeLimit [
	^ 30 seconds
]

{ #category : 'samples' }
FamixRepDetectorBenchmarkTest >> sampleMediumSizeSources [
	^ Array
		streamContents: [ :stream | 
			150
				timesRepeat: [ stream
						nextPut: self newUniqueLine;
						nextPut: self sourceCodeExample ] ]
]

{ #category : 'samples' }
FamixRepDetectorBenchmarkTest >> sampleSmallSizeSources [
	^ Array
		streamContents: [ :stream | 
			500
				timesRepeat: [ stream
						nextPut: self newUniqueLine;
						nextPut: self pizzaExample ] ]
]

{ #category : 'tests' }
FamixRepDetectorBenchmarkTest >> testLargeSizeSources [
	self assertReasonableTimeToRun: self sampleLargeSizeSources
]

{ #category : 'tests' }
FamixRepDetectorBenchmarkTest >> testMediumSizeSources [

	self flag: 'Test can be flaky, depends on the speed of the computer :-('.

	self assertReasonableTimeToRun: self sampleMediumSizeSources
]

{ #category : 'tests' }
FamixRepDetectorBenchmarkTest >> testSmallSizeSources [
	self assertReasonableTimeToRun: self sampleSmallSizeSources
]
