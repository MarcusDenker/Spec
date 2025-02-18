"
Add functionality to verify if there is a backend updating in course. 
This is used to prevent cycles when announcing changes from-to the backend.
"
Trait {
	#name : #SpTBackendUpdating,
	#instVars : [
		'backendUpdating'
	],
	#traits : 'TEmpty',
	#classTraits : 'TEmpty classTrait',
	#category : #'Spec2-Adapters-Morphic-Base'
}

{ #category : #private }
SpTBackendUpdating >> backendDetectCyclesDo: aBlock [ 

	self isBackendUpdating ifTrue: [ ^ self ].
	^ aBlock value
]

{ #category : #private }
SpTBackendUpdating >> backendUpdatingDo: aBlock [ 
	| oldStatus |

	oldStatus := backendUpdating.
	backendUpdating := true.
	aBlock ensure: [ 
		backendUpdating := oldStatus ]
]

{ #category : #initialization }
SpTBackendUpdating >> initializeTBackendUpdating [

	backendUpdating := false
]

{ #category : #private }
SpTBackendUpdating >> isBackendUpdating [

	^ backendUpdating
]
