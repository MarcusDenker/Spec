Class {
	#name : #SpPresenterFocusOrderTest,
	#superclass : #TestCase,
	#traits : 'SpTMorphicUIRedrawer',
	#classTraits : 'SpTMorphicUIRedrawer classTrait',
	#instVars : [
		'mock'
	],
	#category : #'Spec2-Morphic-Backend-Tests'
}

{ #category : #private }
SpPresenterFocusOrderTest >> focusedPresenter [
	
	^ mock allPresentersInFocusOrder 
		detect: [ :each | each adapter widget hasKeyboardFocus ]
		ifNone: [ nil ]
]

{ #category : #emulating }
SpPresenterFocusOrderTest >> keyDown: keyCode shift: shiftBoolean meta: metaBoolean control: controlBoolean option: optionBoolean [
	
	^ self 
		keyEvent: #keyDown
		code: keyCode 
		shift: shiftBoolean 
		meta: metaBoolean 
		control: controlBoolean 
		option: optionBoolean
]

{ #category : #emulating }
SpPresenterFocusOrderTest >> keyEvent: type code: keyCode shift: shiftBoolean meta: metaBoolean control: controlBoolean option: optionBoolean [
	| evt modifiers widget |
	
	widget := self focusedPresenter adapter widget.
	modifiers := 0.
	shiftBoolean ifTrue: [ modifiers := modifiers | 8 ].
	metaBoolean ifTrue: [ modifiers := modifiers |
		(Smalltalk os isWindows | Smalltalk os isUnix
			ifTrue: [ 2r00010000 ]
			ifFalse: [ 2r01000000 ]) ].
	controlBoolean ifTrue: [ modifiers := modifiers | 2r00010000 ].
	optionBoolean ifTrue: [ modifiers := modifiers |
		(Smalltalk os isWindows | Smalltalk os isUnix
			ifTrue: [ 2r01000000 ]
			ifFalse: [ 2r00100000 ]) ].
		
	evt := KeyboardEvent new
		setType: type
		buttons: modifiers
		position:  widget position + (1 @ 1)
		keyValue: keyCode
		charCode: keyCode
		hand: self currentWorld activeHand
		stamp: Time millisecondClockValue.

	evt key: (KeyboardKey fromCharacter: keyCode asCharacter).
	evt sentTo: widget.
	"Some time to allow things to happen?"
	10 milliSeconds wait
]

{ #category : #emulating }
SpPresenterFocusOrderTest >> keyPressed: keyCode shift: shiftBoolean meta: metaBoolean control: controlBoolean option: optionBoolean [
	
	^ self 
		keyEvent: #keystroke
		code: keyCode asciiValue
		shift: shiftBoolean 
		meta: metaBoolean 
		control: controlBoolean 
		option: optionBoolean
]

{ #category : #emulating }
SpPresenterFocusOrderTest >> pressShiftTab [

	self 
		keyDown: Character tab
		shift: true
		meta: false
		control: false
		option: false.
	self waitUntilUIRedrawed		
]

{ #category : #emulating }
SpPresenterFocusOrderTest >> pressTab [

	self 
		keyDown: Character tab
		shift: false
		meta: false
		control: false
		option: false.
	self waitUntilUIRedrawed		
]

{ #category : #running }
SpPresenterFocusOrderTest >> setUp [
	super setUp.
	self initializeSemaphore
]

{ #category : #emulating }
SpPresenterFocusOrderTest >> takeKeyboardFocus: aPresenter [

	aPresenter takeKeyboardFocus.
	self waitUntilUIRedrawed
]

{ #category : #running }
SpPresenterFocusOrderTest >> tearDown [

	mock ifNotNil: [ 
		mock hasWindow ifTrue: [ 
			mock window close ] ].
	
	super tearDown
]

{ #category : #tests }
SpPresenterFocusOrderTest >> testCustomFocusOrder [

	mock := SpMockFocusOrderPresenter new.
	mock focusOrder 
		add: (mock thirdPresenter);
		add: (mock firstPresenter);
		add: (mock secondPresenter).
	mock openWithSpec.
	
	"Focus third"
	self takeKeyboardFocus: mock.
	self assert: (mock thirdPresenter) equals: self focusedPresenter.
	"Focus first"
	self pressTab.
	self assert: (mock firstPresenter) equals: self focusedPresenter.
	"Focus second"
	self pressTab.
	self assert: (mock secondPresenter) equals: self focusedPresenter.
	"Focus third again"
	self pressTab.
	self assert: (mock thirdPresenter) equals: self focusedPresenter
]

{ #category : #tests }
SpPresenterFocusOrderTest >> testFocusRotationBackwards [

	mock := SpMockFocusOrderPresenter new
		openWithSpec;
		yourself.
	
	"Focus first"
	self takeKeyboardFocus: mock.
	self assert: (mock presenterAt: #firstPresenter) equals: self focusedPresenter.
	"Focus third"
	self pressShiftTab.
	self assert: (mock presenterAt: #thirdPresenter) equals: self focusedPresenter.
	"Focus second"
	self pressShiftTab.
	self assert: (mock presenterAt: #secondPresenter) equals: self focusedPresenter.
	"Focus first again"
	self pressShiftTab.
	self assert: (mock presenterAt: #firstPresenter) equals: self focusedPresenter
]

{ #category : #tests }
SpPresenterFocusOrderTest >> testFocusRotationForward [

	mock := SpMockFocusOrderPresenter new
		openWithSpec;
		yourself.
		
	"Focus first"
	self takeKeyboardFocus: mock.
	self assert: (mock presenterAt: #firstPresenter) equals: self focusedPresenter.
	"Focus second"
	self pressTab.
	self assert: (mock presenterAt: #secondPresenter) equals: self focusedPresenter.
	"Focus third"
	self pressTab.
	self assert: (mock presenterAt: #thirdPresenter) equals: self focusedPresenter.
	"Focus first again"
	self pressTab.
	self assert: (mock presenterAt: #firstPresenter) equals: self focusedPresenter
]

{ #category : #tests }
SpPresenterFocusOrderTest >> testTakeKeyboardFocus [

	mock := SpMockFocusOrderPresenter new
		openWithSpec;
		yourself.
		
	"Focus first"
	self takeKeyboardFocus: mock.
	self assert: (mock presenterAt: #firstPresenter) equals: self focusedPresenter.
	"Focus second"
	self takeKeyboardFocus: (mock presenterAt: #secondPresenter).
	self deny: (mock presenterAt: #firstPresenter) equals: self focusedPresenter.
	self assert: (mock presenterAt: #secondPresenter) equals: self focusedPresenter.
	"Focus first again"
	self takeKeyboardFocus: (mock presenterAt: #firstPresenter).
	self assert: (mock presenterAt: #firstPresenter) equals: self focusedPresenter.
	self deny: (mock presenterAt: #secondPresenter)  equals: self focusedPresenter
]
