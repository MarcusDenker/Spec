"
I'm a backend for a Spec applications. 
Backends define different things from an application: 
- which UI backend will use (Morphic by default), 
- access to system resources (such as icons),
- access to standard dialogs usually residing in the operating system (but also simulated)
- ...
"
Class {
	#name : #SpApplicationBackend,
	#superclass : #Object,
	#instVars : [
		'adapterBindings'
	],
	#category : #'Spec2-Core-Support'
}

{ #category : #accessing }
SpApplicationBackend class >> backendName [

	^ self subclassResponsibility
]

{ #category : #accessing }
SpApplicationBackend class >> findBackendNamed: aName [

	^ (self allSubclasses 
		detect: [ :each | each backendName = aName ])
		new	
]

{ #category : #accessing }
SpApplicationBackend >> adapterBindings [

	^ adapterBindings
]

{ #category : #private }
SpApplicationBackend >> adapterBindingsClass [

	self subclassResponsibility
]

{ #category : #initialization }
SpApplicationBackend >> initialize [

	super initialize.
	self resetAdapterBindings
]

{ #category : #accessing }
SpApplicationBackend >> name [

	^ self class backendName
]

{ #category : #'ui - notifying' }
SpApplicationBackend >> notify: aSpecNotification [

	aSpecNotification type 
		notify: aSpecNotification
		on: self
]

{ #category : #'ui - notifying' }
SpApplicationBackend >> notifyError: aSpecNotification [

	self subclassResponsibility
]

{ #category : #'ui - notifying' }
SpApplicationBackend >> notifyInfo: aSpecNotification [

	self subclassResponsibility
]

{ #category : #initialization }
SpApplicationBackend >> resetAdapterBindings [

	adapterBindings := self adapterBindingsClass new
]

{ #category : #'ui - dialogs' }
SpApplicationBackend >> selectFileTitle: aString [

	self subclassResponsibility
]

{ #category : #ui }
SpApplicationBackend >> showWaitCursorWhile: aBlock inApplication: anApplication [

	self subclassResponsibility
]
