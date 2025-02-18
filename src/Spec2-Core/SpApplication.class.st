"
I'm a class that handles many aspects of a Spec Application (hence its name) in a convenient fashion. 
I handle your application initialization, configuration, and its resources. I also keep the windows you have currently opened. 
I'm shared among the presenters that compose the application. This way a common icon manager can be shared between all the presenters.

## Initialization
During initialization of an application, it can optionally configure the backend you want to use, add useful resources, and define a `start` method that will call your initial window.

### Configure backend
Spec2 includes several backends (for the moment, Morphic and Gtk). A SpApplication configures a Morphic backend by default, but you can change it using `useBackend:` or `#useBackend:with:` and sending the backend identifier and optionally a configuration (you may want to do specific backend things to configure your application behavior.

####NOTE: 
It is  important that after you initiate your application, you ==run== it.

The following example shows how to change the backend of an application. 

```

| app |
""You want to subclass SpApplication to create your app""
app := SpApplication new.
app useBackend: #Gtk.
app run
```
See also: `SpApplicationConfiguration`

## Add resources
During initialization, you may want to add special resources (like icons, themes, etc.).
While you can add your own way to access resources, `SpApplication` provides a property registration mechanism (a simple Dictionary and accessors), you may find useful to browse the `accessing properties` protocol.


## Defining a start method.
This is useful to give your application a starting window (in general, this is what you want).

Example: 
```
MyApplication>>start

   (self new: MyMainPresenter) openWithSpec
```


"
Class {
	#name : #SpApplication,
	#superclass : #Object,
	#instVars : [
		'backend',
		'windows',
		'properties',
		'configuration',
		'iconManager',
		'iconProvider'
	],
	#classVars : [
		'DefaultApplication'
	],
	#category : #'Spec2-Core-Base'
}

{ #category : #accessing }
SpApplication class >> defaultApplication [

	^ DefaultApplication ifNil: [ DefaultApplication := SpNullApplication new ]
]

{ #category : #private }
SpApplication class >> defaultApplication: anApplication [
	"To be used for testing purposes"

	DefaultApplication := anApplication
]

{ #category : #accessing }
SpApplication class >> defaultBackendName [

	^ #Morphic
]

{ #category : #examples }
SpApplication class >> example1 [
	"This example shows how to change the backend of an application" 
	| app |
	
	"You want to subclass SpApplication to create your app"
	app := SpApplication new.
	app useBackend: #Gtk.
	app run
]

{ #category : #examples }
SpApplication class >> example2 [
	"This example shows how to change the backend of an application" 
	| app |
	
	"You want to subclass SpApplication to create your app"
	app := SpApplication new.
	"You want to subclass SpGtkConfiguration to create your own cofiguration"
	app useBackend: #Gtk with: SpApplicationConfiguration new.
	app run
]

{ #category : #private }
SpApplication >> adapterBindings [
	
	^ self backend adapterBindings
]

{ #category : #'accessing - backend' }
SpApplication >> backend [

	^ backend ifNil: [ 
		self useBackend: self class defaultBackendName.
		backend ]
]

{ #category : #showing }
SpApplication >> close [
	
	self 
		deprecated: 'Use #closeAllWindows instead' 
		transformWith: '`@receiver close' -> '`@receiver closeAllWindows'.
	self closeAllWindows
]

{ #category : #accessing }
SpApplication >> closeAllWindows [

	self windows do: [ :each | each close ]
]

{ #category : #'accessing - backend' }
SpApplication >> configuration [

	^ configuration
]

{ #category : #showing }
SpApplication >> defaultBlockedDialogWindowPresenterClass [

	^ SpBlockedDialogWindowPresenter
]

{ #category : #showing }
SpApplication >> defaultDialogWindowPresenterClass [
		
	^ SpDialogWindowPresenter
]

{ #category : #showing }
SpApplication >> defaultModalWindowPresenterClass [
		
	^ SpModalWindowPresenter
]

{ #category : #showing }
SpApplication >> defaultWindowPresenterClass [
		
	^ SpWindowPresenter
]

{ #category : #ui }
SpApplication >> defer: aBlock [
	"doInUIThread: ?"
	self backend defer: aBlock
]

{ #category : #ui }
SpApplication >> forceDefer: aBlock [
	"doInUIThread: ?"
	self backend forceDefer: aBlock
]

{ #category : #testing }
SpApplication >> hasWindow: aWindow [
	
	^ self windows includes: aWindow
]

{ #category : #icons }
SpApplication >> iconManager [

	^ iconManager ifNil: [ iconManager := Smalltalk ui icons ]
]

{ #category : #icons }
SpApplication >> iconManager: anIconManager [

	iconManager := anIconManager 
	
]

{ #category : #'accessing - resources' }
SpApplication >> iconNamed: aString [

	^ self iconProvider iconNamed: aString
]

{ #category : #'accessing - resources' }
SpApplication >> iconProvider [

	^ iconProvider ifNil: [ iconProvider := self newIconProvider ]
]

{ #category : #accessing }
SpApplication >> locale [

	^ Locale current
]

{ #category : #factory }
SpApplication >> new: aPresenter [
	"a synonym for #newPresenter:"
	
	^ self newPresenter: aPresenter
]

{ #category : #'private - factory' }
SpApplication >> newIconProvider [
	
	^ SpPharoThemeIconProvider new
]

{ #category : #factory }
SpApplication >> newPresenter: aPresenterClass [

	^ aPresenterClass newApplication: self
]

{ #category : #'ui - notifying' }
SpApplication >> notify: aSpecNotification [
	"how notifications are handled depends on the backend"

	aSpecNotification dispatchTo: self backend
]

{ #category : #'accessing - properties' }
SpApplication >> properties [

	^ properties ifNil: [ properties := SmallDictionary new ]
]

{ #category : #'accessing - properties' }
SpApplication >> propertyAt: aKey [

	^ self properties at: aKey
]

{ #category : #'accessing - properties' }
SpApplication >> propertyAt: aKey ifAbsent: aBlock [

	^ self properties 
		at: aKey
		ifAbsent: aBlock
]

{ #category : #'accessing - properties' }
SpApplication >> propertyAt: aKey ifAbsentPut: aBlock [

	^ self properties 
		at: aKey
		ifAbsentPut: aBlock
]

{ #category : #'accessing - properties' }
SpApplication >> propertyAt: aKey ifPresent: aBlock [

	^ self properties
		at: aKey 
		ifPresent: aBlock
]

{ #category : #'accessing - properties' }
SpApplication >> propertyAt: aKey ifPresent: aBlock ifAbsent: absentBlock [

	^ self properties
		at: aKey 
		ifPresent: aBlock
		ifAbsent: absentBlock
]

{ #category : #'accessing - properties' }
SpApplication >> propertyAt: aKey ifPresent: aBlock ifAbsentPut: absentBlock [

	^ self properties
		at: aKey 
		ifPresent: aBlock
		ifAbsentPut: absentBlock
]

{ #category : #'accessing - properties' }
SpApplication >> propertyAt: aKey put: aValue [

	^ self properties 
		at: aKey
		put: aValue
]

{ #category : #private }
SpApplication >> registerWindow: aWindow [

	self windows add: aWindow
]

{ #category : #accessing }
SpApplication >> reset [ 

	self closeAllWindows.
	windows removeAll.
	self backend resetAdapterBindings
]

{ #category : #running }
SpApplication >> run [ 

	self start
]

{ #category : #'ui - dialogs' }
SpApplication >> selectDirectoryTitle: aString [

	^ self backend selectDirectoryTitle: aString
]

{ #category : #'ui - dialogs' }
SpApplication >> selectFileTitle: aString [

	^ self backend selectFileTitle: aString
]

{ #category : #ui }
SpApplication >> showWaitCursorWhile: aBlock [

	self backend 
		showWaitCursorWhile: aBlock 
		inApplication: self
]

{ #category : #running }
SpApplication >> start [ 
	"Override this to start your app"
]

{ #category : #accessing }
SpApplication >> topWindow [

	^ self windows 
		detect: [ :each | each isTopWindow ]
		ifNone: [ nil ]
]

{ #category : #private }
SpApplication >> unregisterWindow: aWindow [

	self windows remove: aWindow ifAbsent: [  ]
]

{ #category : #'accessing - backend' }
SpApplication >> useBackend: aName [

	backend := SpApplicationBackend findBackendNamed: aName
]

{ #category : #'accessing - backend' }
SpApplication >> useBackend: aName with: aConfiguration [

	self useBackend: aName.
	configuration := aConfiguration.
	aConfiguration configure: self
]

{ #category : #windows }
SpApplication >> windowClosed: aWindowPresenter [
	
	self unregisterWindow: aWindowPresenter
]

{ #category : #accessing }
SpApplication >> windows [
	
	^ windows ifNil: [ windows := Set new ]
]
