Class {
	#name : #SpMorphicBoxLayoutTest,
	#superclass : #TestCase,
	#instVars : [
		'instance',
		'backend'
	],
	#category : #'Spec2-Morphic-Backend-Tests'
}

{ #category : #initialization }
SpMorphicBoxLayoutTest >> initialize [

	super initialize.
	backend := SpMorphicBackendForTest new
]

{ #category : #running }
SpMorphicBoxLayoutTest >> tearDown [
	instance
		ifNotNil: [ instance close.
			instance := nil ].
	super tearDown
]

{ #category : #tests }
SpMorphicBoxLayoutTest >> testAddWithPaddingHorizontal [
	| base presenter layout |

	base := SpBoxLayoutWithTableForTestPresenter new.
	presenter := SpLabelPresenter new.
	
	layout := SpBoxLayout newLeftToRight
		add: presenter expand: false fill: false padding: 10;
		yourself.
		
	base buildAdapterWithSpecLayout: layout.

	"validate the widget is within a parent that keeps the widget with a padding"	
	self 
		assert: presenter adapter widget extent
		equals: (presenter adapter widget owner extent - (20@0))
]

{ #category : #tests }
SpMorphicBoxLayoutTest >> testAddWithPaddingVertical [
	| base presenter layout |

	base := SpBoxLayoutWithTableForTestPresenter new.
	presenter := SpLabelPresenter new.
	
	layout := SpBoxLayout newTopToBottom
		add: presenter expand: false fill: false padding: 10;
		yourself.
		
	base buildAdapterWithSpecLayout: layout.

	"validate the widget is within a parent that keeps the widget with a padding"	
	self 
		assert: presenter adapter widget extent
		equals: (presenter adapter widget owner extent - (0@20))
]

{ #category : #tests }
SpMorphicBoxLayoutTest >> testBeHomogeneous [
	| presenter p1 p2 p3 |

	"not working on CI :("
	self skipOnPharoCITestingEnvironment.

	presenter := SpPresenter new.
	presenter layout: (SpBoxLayout newHorizontal 
		beHomogeneous;
		add: (p1 := presenter newButton);
		add: (p2 := presenter newLabel);
		add: (p3 := presenter newList);
		yourself).

	p1 label: 'Button'.
	p2 label: 'Label'.
	p3 items: #(one two three).

	[ 
		presenter openWithSpec.
	 	backend waitUntilUIRedrawed ]
	ensure: [ presenter withWindowDo: #close ].		

	self assert: presenter adapter widget width 
		>= (p1 adapter widget width 
			+ p2 adapter widget width
			+ p3 adapter widget width).
	self assert: p2 adapter widget width equals: p3 adapter widget width.	
	self assert: p1 adapter widget width equals: p2 adapter widget width
]

{ #category : #tests }
SpMorphicBoxLayoutTest >> testBeHomogeneousWorksWhenContractingWindow [
	| presenter p1 p2 p3 windowWidth presenterWidth width1 width2 width3 |

	"not working on CI :("
	self skipOnPharoCITestingEnvironment.

	presenter := SpPresenter new.
	presenter layout: (SpBoxLayout newHorizontal 
		beHomogeneous;
		add: (p1 := presenter newButton);
		add: (p2 := presenter newLabel);
		add: (p3 := presenter newList);
		yourself).

	p1 label: 'Button'.
	p2 label: 'Label'.
	p3 items: #(one two three).

	[ 
		presenter openWithSpec.
		backend waitUntilUIRedrawed.
		presenter withWindowDo: [ :window |
			window adapter widgetDo: [ :widget |
				widget extent: widget extent - (50@50) ] ].
		backend waitUntilUIRedrawed
	]
	ensure: [ presenter withWindowDo: #close ].		

	windowWidth := presenter window adapter widget width.
	presenterWidth := presenter adapter widget width.
	width1 := p1 adapter widget width.
	width2 := p2 adapter widget width.
	width3 := p3 adapter widget width.
	self assert: presenterWidth >= (width1 + width2 + width3).
	self assert: width1 equals: width2.	
	self assert: width2 equals: width3.
	self assert: windowWidth >= presenterWidth
]

{ #category : #tests }
SpMorphicBoxLayoutTest >> testBeHomogeneousWorksWhenExpandingWindow [
	| presenter p1 p2 p3 |

	presenter := SpPresenter new.
	presenter layout: (SpBoxLayout newHorizontal 
		beHomogeneous;
		add: (p1 := presenter newButton);
		add: (p2 := presenter newLabel);
		add: (p3 := presenter newList);
		yourself).

	p1 label: 'Button'.
	p2 label: 'Label'.
	p3 items: #(one two three).

	[ 
		presenter openWithSpec.
		backend waitUntilUIRedrawed.
		presenter withWindowDo: [ :window |
			window adapter widgetDo: [ :widget |
				widget extent: widget extent + (200@10) ] ].
		backend waitUntilUIRedrawed.
	]
	ensure: [ presenter withWindowDo: #close ].		

	self assert: presenter adapter widget width 
		>= (p1 adapter widget width 
			+ p2 adapter widget width
			+ p3 adapter widget width).
	self assert: p2 adapter widget width equals: p3 adapter widget width.	
	self assert: p1 adapter widget width equals: p2 adapter widget width.
	self assert: presenter window adapter widget width 
		>= presenter adapter widget width
]

{ #category : #tests }
SpMorphicBoxLayoutTest >> testClassIsDisplayedWithCorrectAlignment [
	| presenter table |

	presenter := SpBoxLayoutWithTableForTestPresenter new.
	instance := presenter openWithSpec.

	table := presenter table adapter widget.
	self assert: instance window left <= table left.
	self assert: table left <= table submorphs first left
]

{ #category : #tests }
SpMorphicBoxLayoutTest >> testLayoutHeightTakesAllSpaceNeeded [
	| string presenter textPresenter layout |

	string := String loremIpsum withNoLineLongerThan: 80.

	presenter := SpPresenter new.

	textPresenter := SpTextPresenter new.
	textPresenter text: string.
	textPresenter propagateNaturalHeight: true. 

	layout := SpBoxLayout newTopToBottom 
		add: textPresenter;
		yourself.	
	
	presenter 
		layout: layout;
		buildWithSpec.
	
	self assert: presenter adapter widget height >= (string lines size * string asMorph height).
]

{ #category : #tests }
SpMorphicBoxLayoutTest >> testNestedLayoutModifiesHeightOfTopLayout [
	| base presenter layout |

	base := SpBoxLayoutWithTableForTestPresenter new.

	presenter := SpLabelPresenter new
		label: 'Test';
		yourself.
	
	layout := SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight 
				add: presenter expand: false;
				yourself) 
			expand: false;
		yourself.
		
	base buildAdapterWithSpecLayout: layout.

	"validate the widget is within a parent that keeps the widget with a padding"	
	self 
		assert: presenter adapter widget owner owner height  
		equals: presenter adapter widget height
]

{ #category : #tests }
SpMorphicBoxLayoutTest >> testPresenterTakesRightHeight [
	| presenter l1 l2 |
	
	(presenter := SpPresenter new) 
		layout: (SpBoxLayout newTopToBottom 
			add: (l1 := (presenter newLabel label: 'Line 1')) expand: false;
			add: (l2 := (presenter newLabel label: 'Line 2')) expand: false).
	
	presenter buildWithSpec.	
	
	self 
		assert: presenter adapter widget height 
		equals: l1 adapter widget height + l2 adapter widget height
]
