Class {
	#name : #SpOverlayLayout,
	#superclass : #SpExecutableLayout,
	#instVars : [
		'singleChild',
		'overlays'
	],
	#category : #'Spec2-Layout-Overlay'
}

{ #category : #private }
SpOverlayLayout >> adapterName [
	
	^ #OverlayAdapter
]

{ #category : #accessing }
SpOverlayLayout >> addOverlay: aPresenter [
	
	self
		add: aPresenter
		withConstraints: [ :constraints | constraints beOverlay ].
	overlays add: aPresenter.
	self announceChildAdded: aPresenter
]

{ #category : #accessing }
SpOverlayLayout >> addOverlay: aPresenter withConstraints: aBlock [
	
	self
		add: aPresenter
		withConstraints: [ :constraints | 
			constraints beOverlay.
			aBlock value: constraints ].
	overlays add: aPresenter.
	self announceChildAdded: aPresenter
]

{ #category : #accessing }
SpOverlayLayout >> child [

	^ singleChild
]

{ #category : #accessing }
SpOverlayLayout >> child: aPresenter [

	singleChild ifNotNil: [ self remove: singleChild ].
	self
		add: aPresenter
		withConstraints: [ :constraints | ].
	singleChild := aPresenter.
	self announceChildAdded: aPresenter
]

{ #category : #private }
SpOverlayLayout >> constraintsClass [
	
	^ SpOverlayConstraints
]

{ #category : #accessing }
SpOverlayLayout >> initialize [
	super initialize.
	overlays := OrderedCollection new
]

{ #category : #accessing }
SpOverlayLayout >> remove: aPresenter [
	
	singleChild := nil.
	super remove: aPresenter
]

{ #category : #accessing }
SpOverlayLayout >> removeOverlay: aPresenter [

	overlays remove: aPresenter.	
	self remove: aPresenter
]
