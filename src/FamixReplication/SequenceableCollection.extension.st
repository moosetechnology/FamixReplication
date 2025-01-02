Extension { #name : 'SequenceableCollection' }

{ #category : '*FamixReplication' }
SequenceableCollection >> concatenatesStrings [
	"Takes as predicament that the collection contains only string and return the concatenation of all string.
	
	Uses #to:do: for performance reasons."

	^ String streamContents: [ :s | 1 to: self size do: [ :ind | s << (self at: ind) ] ]
]
