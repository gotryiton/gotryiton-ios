# GTIO 4.0 Functional Spec

## Version History
- 2012-04-20 - Scott Penrose - Initial Version
- 2012-04-20 - Simon Holroyd - First Pass

---

### General Questions

1. There will be questions... definitely.

### Deployment Targets
- iOS 4
- iOS 5
- All standard devices and iOS versions agreed to with Rachit and Matt last year should still apply


---

## 1. Welcome screens



### 1.1 Splash screen

#### Overview
static image used while app is loading

#### Mockups
([wireframe](http://invis.io/PC2NYJUX))

#### API Usage
api request for app config

#### Stories
- the app should know if this is a user's first time here
   - if user is brand new to the app ==> (view 1.2)
   - if user is a returning user to the app ==> (view 1.9)


### 1.2 Intro screens 

#### Overview
A uiPageControl should be used to introduce new users to screens of the app

#### Mockups
([wireframe](http://invis.io/QS2OBFDF)) 

#### API Usage
Array of images is part of the response in (view 1.1)

#### Stories
- on the user's first load of the app, they should be able to swipe through intro screens
  - maximum of 5 screens (not including final login screen)
  - swipe moves to next image in arrray
  - next button in bottom right **taps** ==> next image in array
  - sign in btn **taps** ==> (view 1.3)
  - uiPageControl dots represent flow through intro screens 
  - last **swipe** OR next **tap** ==> sign in screen (view 1.3)
      - last dot in uiPageControl represents sign in screen (view 1.3)



### 1.3 Sign in screen (first use)

#### Overview	
First time users of the app see a screen where they can sign up

#### Mockups
([wireframe](http://invis.io/TW2OBGAK))

#### API Usage
Tracking (details coming)
Facebook Sign in (details coming)

#### Stories
  - A new user is presented with a sign in screen and can sign up
	  -sign up with facebook btn
	    - **tap** ==> Facebook app for SSO
	    - return makes call to sign up api
	  - im a returning user **tap** ==> (view 1.4)
	  - sign up with another provider btn **tap** ==> (view 1.5)
	  - skip btn **tap** ==> (view 2.0)
	  - uiPageControl represent flow through intro screens and sign in screen
	      - swiping backwards brings user to the previous intro screen

### 1.4 Returning users 

#### Overview	
Returning users can sign in with Facebook or Janrain

#### Mockups
([wireframe](http://invis.io/5W2OBHJ7))

#### API Usage
Tracking (details coming)
Facebook Sign in (details coming)
Janrain Sign in (details coming)

#### Stories
- A returning user is presented with a sign in screen and can sign in
   - sign in with facebook btn **tap** ==> Facebook SSO
      - upon successful return: calls api for sign in
   - aol/google/twiter/yahoo janrain options
		- **tap** ==> to janrain SDK for each
		- upon successful return: calls api for sign in   
			- failed api request to sign in ==> (view 1.6)


### 1.5 Janrain Sign up

#### Overview  
New users can sign up with Facebook or Janrain

#### Mockups
([wireframe](http://invis.io/EQ2OBJ6W))

#### API Usage
Tracking (details coming)
Janrain Sign in (details coming)

#### Stories
- new users can sign up with janrain sdk (aol/google/twitter/yahoo options)
   - **tap** ==> to janrain SDK for each
      - on successful return: request api for sign up
         - successful sign up **tap** ==> (view 1.7)
         - existing user response **tap** ==> (view 8.1)

### 1.6 Failed sign in 

#### Overview  
When a user fails to sign in, they're presented with an error screen allowing them to try again

#### Mockups
([wireframe](http://invis.io/CR2OBKVK))

#### API Usage
None

#### Stories
- When a user fails to sign in, they're presented with an error screen allowing them to try again
   - try again **tap** ==> view 1.4
   - im a new user **tap** ==> view 1.3
   - email support **tap** ==>  email compose
      - adressee is support@gotryiton.com
      - subject 'Sign in help'


### 1.7 Almost done 

#### Overview  
When a new user signs up, the app confirms they have a complete GTIO profile

#### Mockups
([wireframe](http://invis.io/XB2OBL7A))

#### API Usage
/User api

#### Stories
- if a new user doesnt have a complete profile, they can edit a form to complete it
   - mimmick existing form (GTIO v3)
   - combine first name and last initial into a single name field
   - add website field
   - edit profile picture **tap** ==> (view 7.3)
   - save **tap** ==> (view 1.8)




### 1.8 Quick add 

#### Overview  
When a new user signs up, they can quickly add people to follow

#### Mockups
[wireframe1](http://invis.io/9P2OBMUR)  
[wireframe2](http://invis.io/AE2OBO7F)

#### API Usage
/User 
/Follow/Quick-Add

#### Stories
- When a new user signs up, they can quickly add people to follow
   - mimmick existing page (GTIO v3)
   - edit user **tap** ==> (view 7.4)
   - list of users defined in api 
      - users default to checked state
      - unchecking all contacts greys out follow x people btn and changes button text to 'follow'
      - selecting and deselecting increments/decrements follow x people btn
   - invite friends **tap** ==> (view 5.1)
   - skip **tap** ==> (view 9.1)
   - follow button 
      - makes api requests
      - **tap** ==> to (view 8.1)

### 1.9 Sign in screen (2nd load)

#### Overview  
When a returning (non-logged in) user starts the app, they see a screen asking them to login (and skip the intro screens)

#### Mockups
([wireframe](http://invis.io/SC2OBNJM))

#### API Usage
Tracking (details coming)
Facebook Sign in (details coming)

#### Stories

- When a returning (non-logged in) user starts the app, they see a screen asking them to login (and skip the intro screens)
   - sign up with facebook btn
       - **tap** ==> Facebook app for SSO
       - return makes call to sign up api
   - im a returning user btn **tap** ==> view 1.4
   - sign up with another provider btn **tap** ==> view 1.5
   - skip directs **tap** ==> 9.1
   - ? btn **tap** ==> view 1.2


