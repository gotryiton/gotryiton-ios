# GTIO 4.0 Functional Spec 

## Version History
- 2012-04-20 - Scott Penrose - Initial Version
- 2012-04-20 - Simon Holroyd - First Pass
- 2012-04-23 - Simon Holroyd - A bunch more stuff...  (let's keep version notes in git?)

## Table of Contents
1. [Welcome Screen](#1-welcome-screens)   
   1.1 [Splash Screen](#11-splash-screen)   
   1.2 [Intro Screens](#12-intro-screens)   
   1.3 [Sign In Screen (first use)](#13-sign-in-screen-first-use)   
   1.4 [Returning Users](#14-returning-users)   
   1.5 [Janrain Sign up](#15-janrain-sign-up)   
   1.6 [Failed Sigin In](#16-failed-sign-in)   
   1.7 [Almost Done](#17-almost-done)   
   1.8 [Quick Add](#18-quick-add)   
   1.9 [Sign in Screen (2nd load)](#19-sign-in-screen-2nd-load)   
2. [Global Nav Bar and Notifications](#2-global-nav-bar-and-notifications)   
   2.1 [Navbar with notifications](#21-navbar-with-notifications)   
   2.2 [Notifications view](#22-notifications-view)   
3. [Product Post and Outfit Post Detail pages](#3-product-and-outfit-post-detail-pages)   
   3.1 [Post Detail Page](#31-post-detail-page)   
   3.2 ~~Post detail with verdict~~   
   3.3 [Post detail full screen](#33-post-detail-full-screen)   
   3.4 [Reviews page](#34-reviews-page)   
   3.5 [Who hearted this](#35-who-hearted-this)   
   3.6 ~~Product post detail page~~   
4. [Product pages](#4-product-pages)   
   4.1 [Product page view](#41-product-page-view)   
   4.2 ~~Suggest a product~~   
   4.3 ~~Phone Contact List~~   
   4.4 ~~Email Compose~~   
   4.5 ~~Facebook Contacts~~   
   4.6 ~~Gotryiton Contacts~~   
   4.7 ~~Post a product~~   
   4.8 [Shop this look](#48-shop-this-look)   
5. [Invite](#5-invite)   
   5.1 [Invite friends](#51-invite-friends)   
6. [Friends Management](#6-friends-management)   
   6.1 [Find my friends](#61-find-my-friends)   
   6.2 [Suggested Friends](#62-suggested-friends)   
   6.3 [Friends management page](#63-friends-management-page)   
   6.4 [Find out-of-network Friends](#64-find-out-of-network-friends)   
   6.5 [Following List](#65-following-list)   
   6.6 [Followers List](#66-followers-list)   
7. [Profile Pages](#7-profile-pages)   
   7.1 [My management page](#71-my-management-page)   
   7.2 [Settings](#72-settings)   
   7.3 [Edit profile pic](#73-edit-profile-pic)   
   7.4 [Edit profile](#74-edit-profile)   
   7.5 [My Hearts](#75-my-hearts)   
   7.6 [My Posts](#76-my-posts)   
   7.7 [Profile Page](#77-profile-page)   
   7.8 [Shopping list](#78-shopping-list)   
   7.9 [My Stars](#79-my-stars)   
   7.10 [Search tags](#710-search-tags)   
8. [The Feed](#8-the-feed)   
   8.1 [Feed view](#81-feed-view)   
   8.3 ~~Feed verdict view~~   
   8.4 [Upload in progress view](#84-upload-in-progress-view)   
   8.5 [Feed after completed upload](#85-feed-after-completed-upload)   
9. [Explore Looks](#9-explore-looks)   
   9.1 [Popular Looks Grid](#91-popular-looks-grid)   
10. [Shop Tab](#10-shop-tab)   
   10.1 [Shop landing page](#101-shop-landing-page)   
   10.2 [Shop Browse Webview Container](#102-shop-browse-webview-container)   
   10.3 ~~Shop 3rd Party Webview Container~~   
   10.4 [Default 3rd Party Webview Container](#104-default-3rd-party-webview-container)   
   10.5 [Shop Browse Products](#105-shop-browse-products)   
11. ~~Logged out screens~~
12. [Upload](#12-upload)   
   12.1 [Upload Start](#121-upload-start)   
   12.2 [Upload Confirm](#122-upload-confirm)   
   12.3 [Post a look](#123-post-a-look)   
   12.4 [Photoshoot Grid](#124-photoshoot-grid)   
   12.5 [Photoshoot Mode](#125-photoshoot-mode)   
   12.6 [Select a product](#126-select-a-product)   
13. [Universal Elements and Behavior](#13-universal-elements-and-behavior)   
   13.1 [UITabBar default behavior](#131-uitabbar-default-behavior)   
   13.2 [UITabBar shopping list animation](#132-uitabbar-shopping-list-animation)   
   13.3 [Error messages](#133-error-messages)   
   13.4 [Follow buttons](#134-follow-buttons)   
   13.5 [Authentication](#135-authentication)   
   13.6 [Pull to refresh behavior](#136-pull-to-refresh-behavior)   
   13.7 [User Badges](#137-user-badges)   
   13.8 [Custom UIActionsheet](#138-custom-uiactionsheet)   
   13.9 [Custom UIAlertView](#139-custom-uialertview) 
   13.10 [Unified autocomplete](#1310-unified-autocomplete)

---

### General Questions

---

### Api Documentation

Api docs will be hosted on gotryiton.  The most up-to-date documentaiton can be found at:

[GTIO Api Docs](http://gtio-dev.gotryiton.com/docs/)   
user: tt   
pass: toast   

---

### Deployment Targets
- iOS 5, iOS 6
- Iphone 3GS, Iphone 4, Iphone 4S, Iphone 5(?)


---

## 1. Welcome screens

### 1.1 Splash screen  

#### Overview
static image used while app is loading

#### Mockups
1.1 Splash ([wireframe](http://invis.io/PC2NYJUX))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/1.1.Splash.png" width=420px/>

#### User flow
**entry screens:**    
user starts app    
**exit screens:**    
([view 1.2](#12-intro-screens))   
([view 1.9](#19-sign-in-screen-2nd-load))   
([view 8.1](#81-feed-view))    


#### API Usage
GET /Config  

reponse:

```json
{
   "config" : {
      "intro_screens" : [
         { 
            "image_url" : "http://path/to/cdn/image",
            "id" : "id_of_screen",
            "track" : {
                  "id" : "app-intro",
                  "page_number" : 2
                }
         }
      ]
   }
}
```

GET /User/me  (see documentation [Api-Users](http://gtio-dev.gotryiton.com/docs/api-users) )

response: 

```json
{
   "user" : {
      "id": "1DB2BD0",
      "name": "Blair G.",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
      "born_in": 1984,
      "is_brand": false,
      "location": "California",
      "about_me": "Something",
      "badge": 
         {
            'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
         },
      "city": "NY",
      "state": "NY",
      "gender": "female",
      "service": "Twitter",
      "auth": false,
      "is_new_user": false,
      "has_complete_profile" : true
   } 
}
```


POST /track  (see documentation [Api-Track](http://gtio-dev.gotryiton.com/docs/api-track) )

request: 

```json
{
   "id" : "visit",
   "visit" : {
      "latitude" : 40.720577,
      "longitude" : -74.000478,
      "ios_version" : 5.1,
      "ios_device" : "Iphone 4S",
      "build_version" : 4.0.0,
   } 
}
```


**notes:**

```intro_screens``` will be an array of no more than 5 items


#### Stories
- the app should request global config settings
   - every first load should include a request to ```config``` endpoint
   - the splash screen displays at least the duration of this api request
- the app should track a users visit to the app
   - when the app starts it should make a request to ```/track``` to track a visit
   - always pass a ```Tracking-Id``` parameter to the ```/track``` endpoint
   - when the app resumes from a Background/Suspended state, it should also make a POST request to ```/track``` to track a visit
- the app should know if this is a user's first time here
   - if a user has an authentication token, pass it to the ```user/me``` endpoint
      - if user is new to the app (has no authentication token) route directly to ==> (view 1.2)
         - let ```/track``` complete in the background
      - if user is a returning user to the app (and has an authentication token):
         - stay on splash screen until ```/user/me``` endpoint has responded:
            - if user is not logged in route to ==> (view 1.9)
            - if user logged in, route to ==> (view 8.1)
   - if a user is upgrading from 3.0 they should be treated as a brand new logged out user (their gtioToken from GTIOv3 should be ignored)
   - if a user is upgrading from 4.0 to 4.x they should be treated as an existing user if they have a token

#### Graphical Assets / Usage
- Background
   - 'Splash.png'
   - Top of image should be visible via UIStatusBarStyleBlackTranslucent 

### 1.2 Intro screens 

#### Overview
A uiPageControl should be used to introduce new users to screens of the app

#### Mockups
1.2 Intros ([wireframe](http://invis.io/QS2OBFDF)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/1.2.0.Intro.Screen.png" width=420px>

1.2.1 Intro screen 2 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/1.2.1.Intro.Screen.2.png" width=420px>

#### User flow
**entry screens:**   
([view 1.1](#11-splash-screen))   
**exit screens:**   
([view 1.2.1](#12-intro-screens))   
([view 1.3](#13-sign-in-screen-first-use))  

#### API Usage

```intro_screens``` will be part of the response in (view 1.1)

#### Stories
- on the user's first load of the app, they should be able to swipe through intro screens
   - maximum of 5 screens (not including final login screen)
   - swipe moves to next image in arrray
   - next button in bottom right **taps** ==> next image in array
   - sign in btn **taps** ==> (view 1.3)
   - uiPageControl dots represent flow through intro screens 
   - last **swipe** OR last next **tap** ==> sign in screen (view 1.3)
      - last dot in uiPageControl represents sign in screen (view 1.3)
   - when image is first viewed by a user, an api request to the ```track``` endpoint should be triggered (POST the ```track``` object that is part of the ```intro_screen``` object)
     - subsequent swipes back and forth to the intro screens can be ignored
   - if ```intro_screens``` array is empty, skip directly to the sign in screen with no uiPageControl (view 1.3.1)

#### Graphical Assets / Usage
- Control Bar
   - background
      - 'intro-bar-bg.png'
      - placed flush with bottom of screen
   - buttons
      - left button is 'intro-bar-sign-in...png'
      - right button is 'intro-bar-next...png'
      - assets include ON and OFF states
      - placed 6px from left edge (sign in), right edge (next), bottom edge (sign in / next) of screen
   - page controls
      - 'intro-bar-page-OFF.png' and 'intro-bar-page-ON.png'
      - if customizable, ON is selected page, OFF asset is unselected
      - if not customizable, Matt may provide alternate background image which simulates white halo around dots
      - if customizable, placement:
         - bottom edge of custom dot asset is 16px up from bottom edge of screen
         - allow 5px margin between custom dot assets
         - horizontally center the group of dots together



### 1.3 Sign in screen (first use) 

#### Overview	
First time users of the app see a screen where they can sign up

#### Mockups
1.3 Sign in ([wireframe](http://invis.io/TW2OBGAK))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/1.3.Sign.In.First.Use.png" width=420px>


1.3.1 Sign in with no intro screens 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/1.9.Sign.In.2nd.Load.png" width=420px>

#### User flow
**entry screens:**   
([view 1.2](#12-intro-screens))   
([view 1.2.1](#12-intro-screens))   
**exit screens:**   
([view 1.2.1](#12-intro-screens))   
([view 1.4](#14-returning-users))   
([view 1.10](#110-facebook-sso))    
([view 11.2](#112-logged-out-default-tab))   

#### API Usage
POST /track

```json
{
   "track" : {
      "id" : "Sign in view"
   }
}
```

POST User/Signup/Facebook (see documentation [Api-Users](http://gtio-dev.gotryiton.com/docs/api-users))



#### Stories
  - A new user is presented with a sign in screen and can sign up
	  -sign up with facebook btn
	    - **tap** ==> Facebook app for SSO (view 1.10)
	    - return makes call to sign up api
	  - im a returning user **tap** ==> (view 1.4)
	  - sign up with another provider btn **tap** ==> (view 1.5)
	  - uiPageControl represent flow through intro screens and sign in screen
	      - swiping backwards brings user to the previous intro screen
         - uiPageControl nav is absent if there are no intro screens

#### Graphical Assets / Usage
   - Background
      - 'login-bg-logo.png'
      - includes status bar area for UIStatusBarStyleBlackTranslucent
   - Buttons
      - Facebook
         - 'fb-sign-up.png' ON and OFF states
         - horizontally centered, starts 265px down from top of screen
      - I'm a returning user
         - 'returning-user.png' ON and OFF states
         - horizontally centered, starts 320px down from top of screen
   - 'another provider' text
      - normal: 6pt Proxima Nova Regular #8f8f8f
      - link portion: 6pt Proxima Nova Regular #ff6a72 underlined
      - horizontally centered, baseline is 405px down from top of screen


### 1.4 Returning users 

#### Overview	
Returning users can sign in with Facebook or Janrain

#### Mockups
1.4 Returning users ([wireframe](http://invis.io/5W2OBHJ7))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/1.4.Returning.Users.png" width=420px>

#### User flow
**entry screens:**   
([view 1.3](#13-sign-in-screen-first-use))   
([view 1.9](#19-sign-in-screen-2nd-load))   

**exit screens:**  
([view 8.1](#81-feed-view)) via ([view 1.10](#110-facebook-sso))   
([view 8.1](#81-feed-view)) via ([view 1.11](#111-janrain-sdk))   
([view 1.6](#16-failed-sign-in)) via ([view 1.10](#110-facebook-sso))   
([view 1.6](#16-failed-sign-in)) via ([view 1.11](#111-janrain-sdk))   
previous screen

#### API Usage

POST User/Auth/Facebook (see documentation [Api-Users](http://gtio-dev.gotryiton.com/docs/api-users))

POST User/Auth/Janrain (see documentation [Api-Users](http://gtio-dev.gotryiton.com/docs/api-users))

#### Stories
- A returning user is presented with a sign in screen and can sign in
   - sign in with facebook btn **tap** ==> Facebook SSO
      - **successful SSO** ==> /User/Auth/Facebook (with SSO token)
         - **successful response** ==> (view 8.1)
   - aol/google/twiter/yahoo janrain options
		- **tap** ==> to janrain SDK for each
         - **successful janrain auth** ==> /User/Auth/Janrain request
            - **successful response** ==> (view 8.1) 
            - **failed signin** ==> (view 1.6)

#### Graphical Assets / Usage
- Nav Bar
   - Background
      - 'login-nav.png'
      - only used for Login views
      - placed directly below Status bar
   - Button
      - 'login-nav-back.png'
      - no ON state
      - only used for Login views
      - placed 27px below top edge of screen (7px below Status bar)
- Buttons
   - Facebook
      - 'fb-sign-in.png' with ON and OFF states
      - horizontally centered
      - shown 144px down from top edge of screen
   - Janrain table
      - four buttons (ON and OFF) laid out edge to edge to simulate table view
         - naming convention is 'janrain-table-1-aol-ON.png' where '1' is the cell number from top to bottom
      - horizontally centered
      - top button shown 209px down from top edge of screen


### 1.5 Janrain Sign up 

#### Overview  
New users can sign up with Facebook or Janrain

#### Mockups

1.5 Janrain Sign up ([wireframe](http://invis.io/EQ2OBJ6W))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/1.5.Janrain.Sign.Up.png" width=420px>

#### User flow
**entry screens:**   
([view 1.4](#14-returning-users))   

**exit screens:**  
([view 8.1](#81-feed-view)) via ([view 1.11](#111-janrain-sdk))     
([view 1.7](#17-almost-done)) via ([view 1.11](#111-janrain-sdk))   
previous screen   

#### API Usage

POST User/Signup/Janrain (see documentation [Api-Users](http://gtio-dev.gotryiton.com/docs/api-users))

#### Stories
- new users can sign up with janrain sdk (aol/google/twitter/yahoo options)
   - **tap** ==> to janrain SDK for each
      - **successful janrain auth** ==> /User/Auth/Janrain request
            - **successful new user response** ==> (view 1.7)
            - **error** ==> dialog, (view 1.5)
            - **successful existing user** ==> (view 8.1)

#### Graphical Assets / Usage
- Nav Bar
   - Background
      - 'login-nav.png'
      - only used for Login views
      - placed directly below Status bar
   - Button
      - 'login-nav-back.png'
      - no ON state
      - only used for Login views
      - placed 27px below top edge of screen (7px below Status bar)
- Buttons
   - Janrain table
      - four buttons (ON and OFF) laid out edge to edge to simulate table view
         - naming convention is 'janrain-table-1-aol-ON.png' where '1' is the cell number from top to bottom
      - horizontally centered
      - top button shown 180px down from top edge of screen


### 1.6 Failed sign in  

#### Overview  
When a user fails to sign in, they're presented with an error screen allowing them to try again

#### Mockups

1.6 Failed sign in ([wireframe](http://invis.io/CR2OBKVK))  

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/1.6.Failed.Sign.In.png" width=420px>


#### API Usage
None

#### Stories
- When a user fails to sign in, they're presented with an error screen allowing them to try again
   - try again **tap** ==> (view 1.4)
   - im a new user **tap** ==> (view 1.3)
   - email support **tap** ==>  email compose
      - adressee is support@gotryiton.com
      - subject 'Sign in help'
   - back **taps** ==> (view 1.4)


#### Graphical Assets / Usage
- Nav Bar
   - Background
      - 'login-nav.png'
      - only used for Login views
      - placed directly below Status bar
   - Button
      - 'login-nav-back.png'
      - no ON state
      - only used for Login views
      - placed 27px below top edge of screen (7px below Status bar)
- Buttons
   - 'Fail' table
      - three buttons (ON and OFF) laid out edge to edge to simulate table view
         - naming convention is 'fail-table-1-try-again-ON.png' where '1' is the cell number from top to bottom
      - horizontally centered
      - top button shown 208px down from top edge of screen


### 1.7 Almost done 

#### Overview  
When a new user signs up, the app confirms they have a complete GTIO profile

#### Mockups

1.7 Almost done ([wireframe](http://invis.io/XB2OBL7A)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/1.7.Almost.Done.png" width=420px>

1.7 Scrolled

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/1.7.Almost.Done.Scrolled.png" width=420px>

#### User flow
**entry screens:**   
([view 1.9](#19-sign-in-screen-2nd-load))   
([view 1.5](#15-janrain-sign-up))   

**exit screens:**  
([view 7.3](#73-edit-profile-pic))   
([view 1.8](#18-quick-add))   


#### API Usage

POST /track

```json
{
   "track" : {
      "id" : "Almost done view"
   }
}
```

POST /User (see documentation [Api-Users](http://gtio-dev.gotryiton.com/docs/api-users))



#### Stories
- if a new user doesnt have a complete profile, they can edit a form to complete it
   - each entry maps to a user attribute (see api details)
   - edit profile picture **tap** ==> (view 7.3)
   - save **tap** ==> api request
      - **success** ==> (view 1.8)
      - **error** ==> dialog 
         - the dialog message will be used to inform users about required fields
- if a user has a complete profile already, they skip this screen and go straight to (view 1.8)
   - ```User->has_complete_profile (bool)``` will mark whether this screen is required or not.
   - ```User->required_attributes (array)``` will mark which fields are still required for the user
- A user can see example text in the form
   - tapping in each field clears these fields and opens the keyboard
- A user can go through each entry quickly
   - keyboard has a 'next' button on each entry until the last, which says 'done'

#### Design Stories
- Will provide green 'save' button background along with Notifications/Nav Bar final assets (2.1/2.2)
- List tables/cells
   - Cell dividers and outside stroke should be #e2e1db
   - Profile picture
      - displayed at 55px x 55px
      - overlaid by 'icon-mask-110.png'
      - Profile picture and overlay should have 13px of top, bottom, and left side padding inside table cell
   - "edit profile picture?" text
      - 7pt Proxima Nova Semibold #8f8f8f
      - 10px away from right edge of profile picture
      - vertically centered inside table cell
   - text for field labels
      - 7pt Proxima Nova Semibold #8f8f8f
      - mandatory field labels (name, email, gender) - 7pt Proxima Nova Semibold #ff6a72
   - example input text
      - 7pt Proxima Nova Light Italic #a4a4a4
   - actual input text
      - 7pt Proxima Nova Regular #8f8f8f
   - text prompting picker controls (select, select year)
      - 7pt Proxima Nova Semibold #8f8f8f

### 1.8 Quick add  

#### Overview  
When a new user signs up, they can quickly add people to follow

#### Mockups
[wireframe1](http://invis.io/9P2OBMUR)  

1.8

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/3/1.8.Quick.Add.png" width=420px>

scrolled

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/1.8.Quick.Add.Scrolled.png" width=420px>

#### User flow
**entry screens:**   
([view 1.7](#17-almost-done))   
([view 1.9](#19-sign-in-screen-2nd-load))   
([view 1.5](#15-janrain-sign-up))   

**exit screens:**  
([view 8.1](#81-feed-view))   
([view 9.1](#91-popular-looks-grid))   
([view 5.1](#51-invite-friends))   
([view 7.4](#74-edit-profile))   


#### API Usage

GET /User/Quick-Add

POST /Users/Follow-Many

Request should include an array of user objects (nested under ```users```) that includes the user's id attribute.  Request should also include a track object that includes ```"screen" : "Quick add"``` to specify which screen this request is originating from.

```json
{
    "users" : [
        {
            "id": "1DB2BD0",
        },
        {
            "id": "7178E1D",
        }
    ], 
    "track" : {
        "screen" : "Quick add"
    }
} 
```

#### Stories
- When a new user signs up, they can quickly add people to follow
   - mimmick existing page (GTIO v3)
   - edit user **tap** ==> (view 7.4)
   - list of users defined in ```/user/quick-add``` response 
      - users default to checked state
      - unchecking all contacts greys out follow x people btn and changes button text to 'follow'
      - selecting and deselecting increments/decrements follow x people btn
      - each user has ```user.description``` attribute which should be used in place of location
   - skip **tap** ==> (view 9.1)
   - follow button 
      - makes api requests
         - POST ```users``` array to ```/users/follow-many```
      - **tap** ==> to (view 8.1)

#### Design Stories
- Top module (success, user info)
   - 'top-info-container.png'
   - place asset (inc. shadow) 4px down from status bar
   - user icon resized to 46px x 46px, placed underneath mask area of 'top-info-container.png'
   - user name
      - Archer Medium Italic, rgb(255,106,114), 20pt
      - 10px to the right of user icon
      - if location exists, baseline is 25px up from the bottom of the user icon
      - if location does not exist, baseline is 6px up from the bottom of the user icon
   - location
      - Proxima Nova Regular, rgb(143,143,143), 12pt
      - 10px to right of user icon
      - 6px up from bottom of user icon
   - edit button
      - 'edit-info.png' with active and inactive versions
      - place asset (including shadow) 38px from right edge of screen
      - vertically center inside gray 'info' area
- 'style is better when shared!'
   - Archer Book Italic, 17pt, rgb(64,64,65)
   - baseline is 170px from bottom of status bar
   - text is horizontally centered
- 'Connect with friends...'
   - first line is "Connect with friends, bloggers and brands"
   - second line is "to discover great style from the start."
   - Proxima Nova Regular, 11pt, rgb(156,156,156)
   - baseline of first line is 190px from bottom of status bar
- suggested user table
   - cell height is 53px (not including outline)
   - table width is 302px (not including outline)
   - border / separator lines are rgb(217,215,206) and 1px thick
   - user icons
      - sized to 36px x 36px
      - 18px from left edge of screen
      - vertically centered within cell
      - overlaid by 'mask-user-72.png'
   - user name
      - Verlag Book, rgb(114,114,114), 18pt
      - 10px from right edge of user icon
      - if location exists, baseline is 18px up from bottom of user icon
      - if location does not exist, text is vertically centered in cell
   - User Badge
      - use size "32_32.png" for 2x
      - use size "16_16.png" for 1x
      - 4px away from right edge of user name
      - bottom of asset is 2px below baseline of user name
   - location
   - description
      - Proxima Nova Regular, 10pt, rgb (167,167,167)
      - all caps
      - baseline is 4px up from bottom of user icon
   - checkbox
      - 'checkbox.png' with on and off states
      - 21px from right edge of screen, vertically centered in cell
- skip link
   - Proxima Nova Regular, 12pt, rgb(166,166,165)
   - text is 'or, skip this step'
   - 'skip this step' portion is underlined and tappable
   - horizontally centered
   - baseline is 25px below bottom of suggested user table (including table outline) (should appear to be approximately vertically centered between suggested user table and top of 'following' button background area)
- scrollable content area is scrollable until bottom of suggested user table is 96px above bottom edge of screen
- 'follow' button
   - background
      - 'post-button-bg.png' asset from 12.3
      - flush with bottom of screen
   - button
      - 'follow-button.png' with on, off, disabled states
      - label
         - active/inactive: Archer Medium Italic, 16pt, rgb(85,85,86)
         - disabled button state: rgb(143,143,144)
         - baseline is 13px up from bottom of button
         - horizontally centered




### 1.9 Sign in screen (2nd load)

#### Overview  
When a returning (non-logged in) user starts the app, they see a screen asking them to login (and skip the intro screens)

#### Mockups
1.9 ([wireframe](http://invis.io/SC2OBNJM))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/1.9.Sign.In.2nd.Load.png" width=420px/>

#### User flow
**entry screens:**   
([view 1.1](#11-splash-screen))   
([view 7.1](#71-my-management-page))   

**exit screens:**  
([view 8.1](#81-feed-view)) via ([view 1.10](#110-facebook-sso))   
([view 1.7](#17-almost-done))    via ([view 1.10](#110-facebook-sso))      
([view 1.4](#14-returning-users))   
([view 1.5](#15-janrain-sign-up))   
([view 9.1](#91-popular-looks-grid))   
([view 1.2](#12-intro-screens))   
   

#### API Usage

POST User/Auth/Facebook (see documentation [Api-Users](http://gtio-dev.gotryiton.com/docs/api-users))

#### Stories

- When a returning (non-logged in) user starts the app, they see a screen asking them to login (and skip the intro screens)
   - sign in with facebook btn **tap** ==> Facebook SSO
      - **successful SSO** ==> /User/Auth/Facebook (with SSO token)
         - **successful existing user response** ==> (view 8.1)
         - **successful new user response** ==> (view 1.7)
   - im a returning user btn **tap** ==> (view 1.4)
   - sign up with another provider btn **tap** ==> (view 1.5)


#### Graphical Assets / Usage
   - Background
      - 'login-bg-logo.png'
      - includes status bar area for UIStatusBarStyleBlackTranslucent
   - Buttons
      - Facebook
         - 'fb-sign-up.png' ON and OFF states
         - horizontally centered, starts 265px down from top of screen
      - I'm a returning user
         - 'returning-user.png' ON and OFF states
         - horizontally centered, starts 320px down from top of screen
      - "?" Button
         - 9px margin from bottom and left edge of screen
         - no 'ON' state
   - 'another provider' text
      - normal: 6pt Proxima Nova Regular #8f8f8f
      - link portion: 6pt Proxima Nova Regular #ff6a72 underlined
      - horizontally centered, baseline is 405px down from top of screen


### 1.10 Facebook SSO

#### Overview  
A user can log in with facebook using facebook SSO.

#### Mockups
1.10 Facebook SSO

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.10.Facebook.SSO.png" width=420px/>

1.10.1 Facebook SSO Permissions

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.10.Facebook.SSO.2.png" width=420px/>

#### User flow
**entry screens:**   
([view 1.3](#13-sign-in-screen))   
([view 1.4](#14-returning-users))   
([view 1.9](#19-sign-in-screen-2nd-load))   

**exit screens:**  
([view 8.1](#81-feed-view))
([view 1.7](#17-almost-done))
previous screen   

#### API Usage

POST User/Auth/Facebook (see documentation [Api-Users](http://gtio-dev.gotryiton.com/docs/api-users))   

POST User/Signup/Facebook (see documentation [Api-Users](http://gtio-dev.gotryiton.com/docs/api-users))   

#### Stories

- A user can log in with facebook using facebook SSO
   - permissions requested is available as ```facebook_permissions_requested``` in the config object (returned by ```/Config``` request in (view 1.1)
   - app key and secret should be hard coded into app
   - pass fb_token to /User/Auth/Facebook or /User/Signup/Facebook to log in a user


## 1.11 Janrain SDK

#### Overview
A user should be able to log in via Janrain SDK

#### Mockups

1.5.1 Janrain Google login

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.5.Janrain.Google.png" width=420px>

1.5.2 Janrain Yahoo login

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.5.Janrain.Yahoo.png" width=420px>

1.5.3 Janrain Yahoo login

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.5.Janrain.Aol.png" width=420px>

1.5.4 Janrain Yahoo login

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.5.Janrain.Twitter.png" width=420px>

#### User Flow

**entry screens:**   
([view 1.4](#14-returning-users))   
([view 1.5](#15-janrain-sign-up))   

**exit screens:**
([view 1.6](#16-failed-sign-in))   
([view 8.1](#81-feed-view))   
([view 1.7](#17-almost-done))   

#### Stories
- A user should be able to log in via Janrain SDK


## 2. Global Nav bar and Notifications


### 2.1 Navbar with Notifications  

#### Overview  
When a user is on one of the top level tabs, they see a navigation bar with notifications 

#### Mockups
([wireframe](http://invis.io/P32OE57R))

2.1.1 New notifications  

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/2.1.Notifications.Unread.png" width=420px/>

2.1.2 No New notifications  

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/2.1.Notifications.Already.Read.png" width=420px/>

2.1.3 Logged out notifications

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/2.1.Notifications.None.png" width=420px/>

#### User Flow

**viewable on:**   
([view 7.1](#71-my-management-page))   
([view 8.1](#81-feed-view))   
([view 8.4](#84-upload-in-progress-view))   
([view 8.5](#85-feed-after-completed-upload))   
([view 9.1](#91-popular-looks-grid))   
([view 10.1](#101-shop-landing-page))   

**exit screens:**   
([view 2.2](#22-notifications-view))   

#### API Usage
/Notifications

#### Stories
- When a user is not logged in the nav bar is disabled (view 2.1.3)
   - gotryiton is not clickable
   - logo is centered
- When a user has zero new notifications, the nav bar has an empty notifications container (view 2.1.2)
   - notification container and gotryiton logo tappable if total notifications > 0
      - **tap** ==> (view 2.2) 
      - TBD: matt to add animation details
   - if total notifications = 0, notification container and logo are not tappable
- When a user has more than zero new notifications the navbar notifications icon is highlighted (view 2.1.1)
   - the nav bar contains number of new notifications
   - notification container and gotryiton logo tappable
      - **tap** ==> (view 2.2) (!!matt to add animation details)

#### Design Stories
- Background
   - 'nav.bar.bg.png'
- Shadow
   - 'nav.bar.shadow.png'
   - shown immediately below nav bar on all screens with this nav bar, overlays content area
- Buttons
   - Normal
      - 'nav.button.png'
         - middle is stretchable
         - 2px nonstretchable on left and right
   - Back
      - 'nav.button.back.png'
         - middle is stretchable
         - 2px nonstretchable on right
         - 8px nonstretchable on left
   - Font
         - Proxima Nova Regular
         - 5.5pt
         - rgb(143,143,143)
- Notifications View
   - 'nav.logo.png' as title
      - asset is padded to allow vertical and horizontal centering
      - position is the same whether counter is present/not present
   - 'nav.counter.png' is bubble container for notification count
      - ACTIVE, INACTIVE, EMPTY ACTIVE, EMPTY INACTIVE versions
      - asset is padded to allow vertical centering
      - should be placed 81px from right edge of screen
      - notification count
         - Verlag Book
         - 7pt
         - rgb(255,255,255)
         - horizontally and vertically centered within bubble
- Custom Title View
   - Archer Light Italic
   - 8pt
   - rgb(64,64,65)
   - baseline should be 4px lower than normal



### 2.2 Notifications view 

#### Overview  
When a user is on one of the top level tabs, they see a navigation bar with notifications 

#### Mockups
2.2 Notifications ([wireframe](http://invis.io/QR2OBP8N))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/2.2.notifications.png" width=420px/>

#### User Flow

**entry screens:**   
([view 7.1](#71-my-management-page))   
([view 8.1](#81-feed-view))   
([view 8.4](#84-upload-in-progress-view))   
([view 8.5](#85-feed-after-completed-upload))   
([view 9.1](#91-popular-looks-grid))   
([view 10.1](#101-shop-landing-page))   

**exit screens:**   
TBD


#### API Usage
/Notifications

#### Stories
- A user can view their notifications in a notifications view
   - View has close button in top left
      - closes overlay 
      - TBD: matt to add animation details
   - View has cell layout with dynamic text
      - description text allows for bold html styling
         - ```<b>```Person's Name```</b>``` should make the name appear bold
      - heights depending on description text
- A user can tap on each notification item
   - each notification item has a destination 
      - can be gtio:// link or http:// link
- The app will only highlight the number of notifications that the user has not seen
   - app will keep track of notificiation ids
      - ids that have been seen will get a read state
      - ids that have not been seen will be treated as NEW notifications
         - new notifications will populate the notification navbar container number
         - new notifications will get an unread state the first time they are seen
      - this behavior will mimmick current 3.0 behavior

#### Design Stories
- Text: 16pt Verlag Bold/Light
	- Active State: rgb(98,98,98) #626262
	- Read State: rgb(143,143,143) #8f8f8f
	- Top/Bottom Padding: 16px
- Icons: 21x21px
	- 8px from left
	- Vertically centered
	- 10px right padding to text
- Cell:
	- Active State: rgb(255,255,255)
	- Read State: rgb(255,255,255) with an alpha of .45
	- Bottom border: 1px rgb(217,215,206) #d9d7ce
 

## 3. Product and Outfit Post Detail pages

### 3.1 Post Detail Page  

#### Overview 
A user can see a detailed view of a single post

#### Mockups
See (view 8.1).  A post detail page is now feed of one item.


#### User Flow

**entry screens:**   
([view 9.1](#91-popular-looks-grid))   
([view 2.2](#22-notifications-view))    


**exit screens:**   
([view 7.7](#77-profile-page))   
([view 3.4](#34-reviews-page))   
([view 3.5](#35-who-hearted-this))   
([view 1.10](#110-facebook-sso))   
([view 3.3](#33-post-detail-full-screen))     
previous screen


#### API Usage
/post/:post_id


#### Stories
- Behavior matches the behavior of (view 8.1) with no pagination
- Top left should include a back button (this view should get added to the stack on the 2nd tab)


### ~3.2 Post Detail With Verdict~


### 3.3 Post Detail Full screen

#### Overview 
A user can see a full screen detail of an outfit

#### Mockups
3.3 Post Full Screen ([wireframe](http://invis.io/F72PNPKB))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/3.3.Full.Screen.Full.Height.png" width=420px/>

3.3.1 Post Full Screen - square aspect ratio ([wireframe](http://invis.io/XB2PNTT9))   

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/3.3.Full.Screen.Min.Height.png" width=420px/>

#### User Flow

**entry screens:**   
([view 3.1](#31-outfit-post-detail-page))    
([view 3.6](#31-product-post-detail-page))    


**exit screens:**   
previous screen   


#### API Usage
None.

#### Stories
- A user can see a full screen image of an Outfit Detail or Product detail page
   - If a user is looking at a product full screen, then the nav bar disappears too
- A user can dismiss the full screen image by tapping anywhere on the image.
   - state of the post view returns to prior state

#### Design Stories
- Image
   - display at 640px wide, original aspect ratio is preserved
   - vertically centered within content area (does not include status bar)
   - background is white


### 3.4 Reviews page  

#### Overview 
A user can read reviews from an outfit post or a product post page

#### Mockups
3.4 Reviews Page ([wireframe](http://invis.io/NE2OBV7J))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/6afe6be3f1d8879dbc9d7522c8357e40c43caaf7/GTIO/Application/Resources/Mockups/3.4.reviews.png" width=420px/>

3.4 Reviews with direct link 

<img src="https://github.com/twotoasters/GTIO-iOS/raw/6afe6be3f1d8879dbc9d7522c8357e40c43caaf7/GTIO/Application/Resources/Mockups/3.4.reviews.direct.link.png" width=420px/>

3.4.1 Reviews with keyboard 

<img src="http://assets.gotryiton.com/img/spec/4.0/2/3.4.Reviews.Keyboard.png" width=420px/>

3.4.2 Reviews Empty

<img src="http://assets.gotryiton.com/img/spec/4.0/2/3.4.Reviews.Empty.png" width=420px/>


**entry screens:**   
([view 3.1](#31-outfit-post-detail-page))    
([view 3.6](#31-product-post-detail-page))    
([view 2.2](#22-notifications-view))    

**exit screens:**   
previous screen   


#### API Usage
/Reviews/for-post/:post_id

/Review/Agree

/Review/Flag

/Review/Remove

#### Stories
- A User can read reviews other users have written for a post
   - the review api will populate:
      - review text
      - user name, icon, badges
      - agree votes
      - this api should respond with all comments, no pagination needed here
      - The text field shows 'I think...' as pre-filled text
   - if the reviews array is empty, see (view 3.4.2)
- A user can see a full screen image of the post
   - a square post thumbnail is displayed next to the review text 
      - **taps** ==> (view 3.3)
- A user can agree with a review
   - **taps** ==> api request
      - **success** ==> button is left in on state (no other action)
- A user can flag a review
   - **taps** ==> opens dialog
      - text: 'Flag this review as inappropriate?'
      - flag: api request
         - **success** ==> button is left in on state (no other action)
      - cancel: close dialog
- A user can remove their own review
   - if the user is the review's owner
      - the flag button is hidden
      - the agree button is replaced with a 'remove' bttn
         - **taps** ==> opens dialog
            - text: 'Delete this review?'
            - delete: api request
               - **success** ==> button is left in on state (no other action)
            - cancel: close dialog

#### Design Stories

- Top Area
	- Background (3/reviews.top.bg.png) Repeat/stretch background horizontal
	- 87px tall
	- Avatar
		- Overlay (3/reviews.top.avatar.overlay.png)
		- 75x75px
		- 5px from left, 6px from top and bottom
	- Text
		- Name: Archer Book Italic 16px rgb(255,106,114) #ff6a72
		- Time Stamp: Proxima Nova Regular 10px rgb(156,156,156) #9c9c9c
	- Comment input
		- Background (3/reviews.top.input.box.png)
		- 230x35px
		- Verlag Light Italic 14px rgb(183,183,183) #b7b7b7
- Comment
	- Background: (3/reviews.cell.bg.png)
		- Stretch it from the middle, 4px top and 7px bottom anchors
	- 314px wide
	- Padding includes shadows from image
		- 12px padding on right/left
		- 12px padding on top
		- 15px padding on bottom
	- Text
		- Comment: 14px Verlag Light rgb(64,64,65) #404041
		- Hashtags/@replies: 14px Verlag Book rgb(255,106,114) #ff6a72
		- Author: Proxima Nova Regular 11px rgb(255,106,114) #ff6a72
		- Time Stamp: Proxima Nova Regular 8px rgb(188,188,188) #bcbcbc
		- Heart #: Proxima Nova Regular 12px rgb(214,214,214) #d6d6d6
	- Delete X
		- 3/reviews.cell.delete.inactive.png
			- Active: 3/reviews.cell.delete.active.png
		- 9x9px
	- Flag
		- 3/reviews.cell.flag.inactive.png
			- Active: 3/reviews.cell.flag.active.png
		- Flagged: 3/reviews.cell.flag.flagged.inactive.png
			- Active: 3/reviews.cell.flag.flagged.active.png
	- Heart Button
		- 3/reviews.cell.heart.inactive.png
			- Active: 3/reviews.cell.heart.active.png
		- Hearted: 3/reviews.cell.heart.hearted.inactive.png
			- Active: 3/reviews.cell.heart.hearted.active.png
	- Avatar 
		- Overlay (3/reviews.cell.avatar.overlay.png)
		- 27x27px
   - User Badge (post owner)
      - use size "28_28.png" for 2x
      - use size "14_14.png" for 1x
      - 4px away from right edge of user name
      - bottom of asset is 2px below baseline of user name   
   - User Badge (commenter)
      - use size "20_20.png" for 2x
      - use size "10_10.png" for 1x
      - 3px away from right edge of user name
      - bottom of asset is 1px below baseline of user name

### 3.5 Who hearted this 

#### Overview 

A User can see other users who have hearted an outfit or product post

#### Mockups

3.5 Who Hearted this ([wireframe](http://invis.io/N22OBX9Q)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/3.5.Who.Hearted.This.png" width=420px/>

#### User Flow
**entry screens:**   
([view 3.1](#31-outfit-post-detail-page))    
([view 3.6](#31-product-post-detail-page))    

**exit screens:**   
previous screen   

#### API Usage

/Post/Hearts

#### Stories
- A user can view a list of other users who have hearted a post
   - cell list view 
   - profile icons, name
   - follow btn
      - state of button is either unfollow or follow
      - **tap** ==> api request and changes state of button

#### Design Stories
- Custom Title Bar
   - 'who.hearted.this.title.png'
   - horizontally and vertically centered
- List tables/cells
   - All Cells
      - Height: 48px (without border)
      - Background: rgb(255,255,255) #ffffff
      - Active State background: rgb(237,235,224) #edebe0
      - Font: Verlag Light 16pt rgb(143,143,143) #8f8f8f
      - Text-shadow: 1px 90 degrees (point down), rgb(255,255,255) #ffffff
      - Bottom border: 1px rgba(217,215,206) #d9d7ce
   - Profile Icons
      - 36x36px
      - Inner shadow overlay (general/large-profile-overlay-inner-shadow.png)
      - 6px from left of cell
      - Vertically centered in cell
      - 10px padding from profile icon and username text
   - Follow buttons
      - 10px from left edge of screen
- Transitions
   - slides in from right
   - normal behavior in navigation stack


### 3.6 ~Product Post Detail Page~



## 4. Product Pages

### 4.1 Product page view  

#### Overview 
A user can view a detailed page about a single product

#### Mockups
4.1 Product Page View ([wireframe](http://invis.io/8Y2OC5N7))

<img src="http://assets.gotryiton.s3.amazonaws.com/img/spec/4.0/mockups/1/Product.Detail.Light.BG.png" width=420px/>


#### User Flow

**entry screens:**   
([view 4.8](#48-shop-this-look))   
([view 7.8](#78-shopping-list))   
([view 10.5](#105-shop-browse-products))   

**exit screens:**   
  
([view 12.3](#123-post-a-look))   
([view 3.5](#35-who-hearted-this))   
([view 7.8](#78-shopping-list))   
([view 4.1.2](#412-product-full-screen))   

previous screen


#### API Usage
/product/:product_id
/product/:product_id/add-to-my-shopping-list/

#### Stories
- A user can view a detailed page about a single product
   - transparent navbar 
      - TBD: matt to provide guidance
   - full product name with brand and price
   - photo aligned to top 
      - tapping routes to full screen view of product (view 4.1.2)
- A user can heart a Product and see who has hearted a product
   - standard heart button with count
   - **tap** on count ==> (view 3.5)
- A user can post a product from a product page
   - Post btn **tap** ==> (view 12.3)
- A user can add a product to their shopping list
   - + shopping list button adds the item to their list

#### Design Stories
- Navigation Bar
	- Background (4/product.nav.bar.bg.png) (48px high with shadow)
	- Back button 11px from top, 5px from left
	- When tapped to full screen product image, display product.nav.bar.top.png (4px high)
- Heart Button
	- Background (product.heart.inactive.png)
		- On tap (product.heart.active.png)
		- Highlighted (product.heart.highlight.png)
			- On tap (product.heart.highlight.active.png)
	- 89x34px
	- 4px from left
	- 3px from navigation bar (51px from top of screen)
	- Count Text: Verlag bold 15px rgb(88,88,88) #585858
		- Right aligned
		- 11px from edge of element
		- Vertically aligned in element
- Bottom Info
	- Background (product.info.overlay.bg.png)--stretch image horizontally
	- 260px high including shadow
	- Inner info area 
		- 8px below the start of bottom area (including shadow in product.info.overlay.bg.png image)
		- Background (product.info.rounded.bg.png), image is anchored 5px top/bottom and 5px left/right so you stretch only the inner most 1px
		- Width: 310px
		- Height: 66px
		- Text - Starts 10px from left and 12px from top
			- Product name: Verlag Book 15px rgb(8,8,8), #585858
			- Brand: Proxima Nova Semibold 12px rgb(143,143,143) #8f8f8f
			- Price: Verlag 22px Bold 22px rgb(88,88,88) #585858
				- 10px from right, 10px from bottom
		- Social Icons (product.social.fb.active.png) & (product.social.twit.active.png)
			- 18x18px
			- 9px from top/right
			- 7px in between
		- Bottom Buttons
			- Background (product.info.button.bg.inactive.png) stretch image
				- On tap (product.info.button.bg.active.png)
				- Highlighted/added to list (product.info.button.bg.highlight.inactive.png)
					- On tap (product.info.button.bg.highlight.active.png)
			- Text: Archer Medium 16px rgb(85,85,86) #555556
			- 5px padding
			- 4px in between buttons
			- Width: 153x46px

### 4.1.2 Product Full Screen  

#### Overview 
A user can see a full screen view of a product

#### Mockups
4.1.2 Product Full Screen

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.6.Product.Post.Detail.Fullscreen.png" width=420px/>

#### User Flow
**entry screens:**   
([view 4.1](#41-product-page-view))   
([view 4.2](#41-suggest-a-product))   
**exit screens:**   
previous screen   


#### API Usage
None.

#### Stories
- A user can see a full screen view of a product
   - tapping on the full screen view returns the user to the previous screen


### ~4.2 Suggest a product~  


### ~4.3 Phone contact list~  

### ~4.4 Email compose~  

### ~4.5 Facebook contacts~  

### ~4.6 Gotryiton contacts~  

### ~4.7 Post a product~  

### 4.8 Shop this look

#### Overview

A user can see a list of products contained in a post.  They can tap each one to arrive at a product page

#### Mockups

<img src="https://github.com/twotoasters/GTIO-iOS/raw/as-slices/GTIO/Application/Resources/Mockups/4.8.shop.this.look.png" width=420px/>

#### User flow

**entry screens**   
([view 8.1](#81-feed-view))   
([view 9.1](#91-popular-looks-grid))   
([view 3.1](#31-post-detail-page))   

**exit screens**   
([view 4.1](#41-product-page-view))   

#### Routing
gtio://products/in-post/:post_id

#### Api usage

/products/in-post/:post_id

#### Stories

- A user can see a list of products contained in a post
   - each product taps to ([view 4.1](#41-product-page-view))

#### Design Stories
- Cell
	- Background (4/shop.cell.png)
	- 314x105px - height includes extra shadow from image, without shadow the cell is only 101px tall
	- Chevron (general/general.chevron.png)
	- Image
		- 106x101px
		- Position on top left of cell
		- Overlay with 7/shopping.cell.image.overlay.png
	- Text 
		- Product Name: Verlag Light 14px rgb(89,81,85) #595155
		- Brand: Proxima Nova semibold 11px rgb(187,187,187) #bbbbbb
		- Price: Verlag Bold 16px rgb(255,106,114) #ff6a72		

## 5. Invite 

### 5.1 Invite friends  

#### Overview 
A user can invite friends to GTIO via SMS, Email, Facebook

#### Mockups
5.1 invite friends  ([wireframe](http://invis.io/TW2OCGBR))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/5.1.invite.friends.png" width=420px/>

5.1.1 invite friends actionsheet  ([wireframe](http://invis.io/NB2PNCHD))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/5.1.1.invite.actionsheet.png" width=420px/>

5.1.2 invite friends SMS ([wireframe](http://invis.io/YX2PND9V))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.3.1.Suggest.SMS.Compose.png" width=420px/>

5.1.3 invite friends EMAIL  ([wireframe](http://invis.io/R22PNE35))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.4.Suggest.Email.Compose.png" width=420px/>

#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
([view 6.3](#63-friends-management-page))   
([view 1.8](#18-quick-add))   
**exit screens:**   
previous screen   
`
#### API Usage
/Invite/SMS

/Invite/Email

/Invite/Facebook

#### Routing
gtio://invite-friends



#### Stories
- A user can invite friends to GTIO via SMS, Email, Facebook 
   - A user can see buttons to select SMS, Email, Facebook
   - A user can see a list of their phone contacts
      - contacts should include both those with phone numbers and email addresses
- A user can compose an SMS by entering their own recipients
   - sms btn
      - **tap** ==> sends api request (for body of SMS)
      - successful api response ==> (view 5.1.2)
- A user can compose an Email by entering their own recipients
   - email btn
      - **tap** ==> sends api request (for body of email)
      - successful api response ==> (view 5.1.3)
- A user can select to invite via facebook
   - facebook btn
      - **tap** ==> sends api request (for facebook contact list)
      - successful api response ==> (view 4.5)
- A user can select to invite a particular friend from their contact list
   - **tap** ==> raises actionsheet of available contacts (phone number or email addres) (view 5.1.1)
      - actionsheet **tap** ==> api request (SMS or Email depending on type of contact)
         - **success** ==> (view 5.1.2) or (view 5.1.3) (with contact populated in the to field)

#### Design Stories
- All text in cells that is left aligned has a 11px left padding
- Top Area
	- Height: 140px
	- Background: Transparent with image (general/dark.overlay.png) - Image has stretchable area in middle with nonstretchable area extending 7px from all sides
	- Buttons are all 97x32px
	- Buttons are 7px from left and right side of the screen with 8px padding between each button. There is 8px padding below the buttons
	- Text is about 10px below the top of the cell
		- Font: Verlag 14pt rgb(255,255,255) #ffffff
- Phone option section header
	- Height: 28px (without borders)
	- Background: rgb(235,242,239) #ebf2ef
	- 1px top border rgb(255,255,255) #ffffff
	- 1px bottom border rgb(211,217,215) #d3d9d7
	- Font: Verlag Light 14pt rgb(143,143,143) #8f8f8f (16px from top)
- Letter section headers
	- Height: 29px
	- Background: rgb(240,240,240) #f0f0f0
	- Font: Proxima Nova Bold rgb(143,143,143) #8f8f8f (9px from top)
	- Bottom border 1px rgb(217,215,206) #d9d7ce
- Contact Cells
	- Height: 44px
	- Background: rgb(255,255,255) #f0f0f0
	- Font: 14pt Verlag Light/Bold rgb(143,143,143) #8f8f8f (16px from top)
	- Bottom border 1px rgb(217,215,206) #d9d7ce

## 6. Friends management

### 6.1 Find my friends

#### Overview
A user can find friends to follow 

#### Mockups
6.1 ([wireframe](http://invis.io/XM2OCN3P))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/6.1.1.find.my.friends.png" width=420px/>

6.1.1 No Results ([wireframe](http://invis.io/QK2OCQ56))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/6.1.2.find.friends.no.results.png" width=420px/>

#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
**exit screens:**   
([view 6.2](#62-suggested-friends))   
([view 6.4](#64-find-out-of-network-friends))   
([view 7.7](#77-profile-pages))   


#### API Usage
/Friends/Find?

/Friends/Search


#### Routing
gtio://find-friends

#### Stories
- A user can find friends to follow
   - title: find my friends
   - suggested friends btn
      - includes profile icons from api 
      - **tap** ==> (view 6.2)
   - you are following x
      - text populated by api
   - list of users (who you are following)
      - has profile icon, name, following btn, tappable to profile (view 7.7)
      - following toggle btn
         - tapped state: following
- A user can search through their existing friends by typing in the search box
   - typing should immediately start filtering your following list
   - if filter search comes up empty, see (view 6.1.1)
- When a user searches for friends and doesnt find the user they are looking for, they can search the entire community
   - the filter search has custom empty text 
      - 'We couldnt find "search string" do you want to try searching the entire GTIO community' button
         - **tap** ==> api request
            - **success** ==> (view 6.4)

### Design Stories
- List tables/cells
	- All Cells
		- Height: 48px (without border)
		- Background: rgb(255,255,255) #ffffff
		- Active State background: rgb(237,235,224) #edebe0
		- Font: Verlag Light 16pt rgb(143,143,143) #8f8f8f
		- Text-shadow: 1px 90 degrees (point down), rgb(255,255,255) #ffffff
		- Bottom border: 1px rgba(217,215,206) #d9d7ce
		- Chevrons: 8px from the right and vertically centered within the cell
      - User Badge
         - use size "32_32.png" for 2x
         - use size "16_16.png" for 1x
         - 4px away from right edge of user name
         - bottom of asset is 2px below baseline of user name
	- "Suggested Friends" Cell
		- No bottom border
		- Profile Icons are 25px with an inner shadow overlay (general/small-profile-overlay-inner-shadow.png), 6px padding between profile icon
	- Profile Icons
		- 36x36px
		- Inner shadow overlay (general/large-profile-overlay-inner-shadow.png)
		- 6px from left of cell
		- Vertically centered in cell
		- 10px padding from profile icon and username text
	- Follow buttons
		- 9px left from chevrons
	- Search area
		- Height: 66px
		- Background transparent, with image (6/search.area.background.shadow.png)
		- Font: Proxima Nova light 10pt rgb(143,143,143) #8f8f8f
		- Where font is bold, use Proxima Nova Bold
		- Search Field
			- Field is 320x31px (with border), use background image to draw (general/search.field.background.png)
			- Font: Proxima Nova light 12pt rgb(143,143,143) #8f8f8f
			- When field is unselected, text has a 0.6 alpha
			- Mag icon is 5px from top and 5px from left
	- Search No Results
		- Empty image is 46px down and horizontally centered (6/search.area.background.shadow.png)
		- Empty text is 45px down
		- "couldn't find [search query]": 16pt Proxima Nova Light rgb(143,143,143) #8f8f8f
		- "do you want to try": 14pt Proxima Nova Light rgb(143,143,143) #8f8f8f
		- "searching the community?": 14pt Proxima Nova Light rgb(255,106,113) #ff6a71
			

### 6.2 Suggested Friends  

#### Overview
A user can see a list of suggested users to follow

#### Mockups
6.2 Suggested Friends ([wireframe](http://invis.io/VD2OCR5H))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/6.2.suggested.friends.png" width=420px/>

#### API Usage
/user/suggested-friends  [api-users](http://gtio-dev.gotryiton.com/docs/api-users)

#### Routing
gtio://suggested-friends

#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
([view 6.3](#63-friends-management-page))   
**exit screens:**   
([view 7.7](#77-profile-pages))   
previous screen


#### Stories
- A user can see a list of suggested users to follow
   - page loads a list of users
   - list items have: ```user.icon```, ```user.name```, and ```user.description``` tappable to profile (view 7.7)
   - following btn (toggles state)
- A user can refresh the list of suggested users to see a different set
   - refresh btn top right
      - **tap** ==> api request to the pagination endpoint (```pagination.next```)
      - during request, replace refresh button with a spinner (centered where the button was)
      - **success** ==> replaces list with new users

#### Design Stories
- Refresh Icon
	- 16px from top, 9px from right
- For cells and button placement, refer to 6.1 design stories, with the following exceptions:
   - user name
      - Verlag Book, rgb(114,114,114), 18pt
      - 10px from right edge of user icon
      - if description exists, baseline is 18px up from bottom of user icon
      - if description does not exist, text is vertically centered in cell
   - description
      - Proxima Nova Regular, 10pt, rgb (167,167,167)
      - All caps
      - baseline is 4px up from bottom of user icon

### 6.3 Friends management page

#### Overview
A user can manage their friend relationships via the feed

#### Mockups
6.3 ([wireframe](http://invis.io/R62OCSKJ))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/6.3.friends.png" width=420px/>


#### User Flow
**entry screens:**   
([view 8.1](#81-feed-view))   
**exit screens:**   
([view 5.1](#51-invite-friends))   
([view 6.4](#64-find-out-of-network-friends))   
([view 6.2](#62-suggested-friends))   
([view 7.7](#77-profile-pages))   
previous screen


#### API Usage
/Friends?


#### Stories
- A user can manage their friend relationships via the feed
   - title: friends
   - invite friends btn
      - **tap** ==> (view 5.1)
   - find friends btn
      - **tap** ==> (view 6.4)
   - suggested friends btn
      - **tap** ==> (view 6.2)
   - youre following x (from api response)
- A user can see a list of the users they follow and edit those users
   - list of users 
      - filter search enabled
      - has profile icon, name, tappable to profile (view 7.7)
      - following btn (toggles state)
      - if filter search comes up empty
         - custom empty text 
            - 'We couldnt find "search string" do you want to try searching the entire GTIO community' button
            - **tap** ==> (view 6.4)

#### Design Stories
- First three cells
	- Height: 43px (without borders)
	- Background: rgb(235,242,239) #ebf2ef
	- Top Border: 1px rgb(243,247,245) #f3f7f5
	- Bottom Border: 1px rgb(211,217,215) #d3d9d7
	- "suggested friend" cell has no bottom border and has height of 49px
- For cells and button placement, refer to 6.1 design stories

### 6.4 Find out-of-network Friends  

#### Overview
A user can search for friends outside of their own network

#### Mockups
6.4 ([wireframe](http://invis.io/MH2OCTA9))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/6.4.1.search.empty.png" width=420px/>

<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/6.4.2.search.results.png" width=420px/>

#### User Flow
**entry screens:**   
([view 6.1](#61-find-my-friends))   
([view 6.3](#63-friends-management-page))   
**exit screens:**   
([view 7.7](#77-profile-pages))   
previous screen   

#### API Usage
/Friends/Search

#### Routing
gtio://search-friends

#### Stories
- A user can search for friends outside of their own network
   - search field
   - on **submit** ==> api request
      - results show in list
      - has profile icon, name, tappable to profile (view 7.7)
      - following btn (toggles state)

#### Design Stories
- Search area
	- Background transparent with image (6/search.area.background.shadow.small.png)
- Search Empty
	- 64px from top, 169px from left
	- Text begins 16px below icon
	- "search through the entire" 16pt Proxima Nova Light rgb(143,143,143) #8f8f8f
	- "Go Try It On community" 16pt Proxima Nova Bold rgb(143,143,143) #8f8f8f
- For cells and button placement, refer to 6.1 design stories	

### 6.5 Following List  

#### Overview
A User A can see a list of who a User B is following.  User A and User B can be the same user.

#### Mockups
6.5 ([wireframe](http://invis.io/CS2OCU2W))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/6.5.following.png" width=420px/>

#### User Flow
**entry screens:**   
([view 7.1](#71-my-mananagement-page))   
([view 7.7](#77-profile-pages))   
**exit screens:**   
([view 7.7](#77-profile-pages))   
previous screen   

#### API Usage
/User/Following

#### Routing
gtio://user/:id/following   
gtio://my-following   

#### Stories
- A user can see a list of who they (or another user) are following
   - title (from api)
   - youre following x (from api)
   - list of users (from api)
      - alpha sort
      - has profile icon, name, tappable to profile, 
      - following toggle

#### Design Stories
- For cells and button placement, refer to 6.1 design stories

### 6.6 Followers List  

#### Overview
A User A can see a list of User B's followers.  User A and User B can be the same user.

#### Mockups
6.6 Followers List ([wireframe](http://invis.io/Y92OCV3E))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/6.6.followers.png" width=420px/>

#### User Flow
**entry screens:**   
([view 7.1](#71-my-mananagement-page))   
([view 7.7](#77-profile-pages))   
**exit screens:**   
([view 7.7](#77-profile-pages))   
previous screen   

#### API Usage
/User/Followers


#### Routing
gtio://user/:id/followers   
gtio://my-followers   

#### Stories
- A user can see a list of who their (or another user's) followers
   - title (from api)
   - x following you (from api)
   - list of users (from api)
      - alpha sort
      - has profile icon, name, tappable to profile, 
      - following toggle

#### Design Stories
- For cells and button placement, refer to 6.1 design stories

## 7. Profile pages


### 7.1 My management page  

#### Overview
A logged in user can manage their profile, share settings, looks, and friends

#### Mockups
7.1 Management Page [wireframe1](http://invis.io/TQ2OCXAV) 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.1.My.Management.png" width=420px/>

7.1 Management page scrolled [wireframe2](http://invis.io/ND2OCYR4)

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.1.My.Management.Scrolled.png" width=420px/>

#### User Flow
**entry screens:**   
any screen with uiTabBar   
**exit screens:**   
([view 7.3](#73-edit-profile-pic))   
([view 6.5](#65-following-list))   
([view 6.6](#66-followers-list))   
([view 7.4](#74-edit-profile))   
([view 7.8](#78-shopping-list))   
([view 7.5](#75-my-hearts))   
([view 7.6](#76-my-looks))   
([view 7.9](#79-my-stars))   
([view 7.10](#710-search-tags))   
([view 6.1](#61-find-my-friends))   
([view 5.1](#51-invite-friends))   
([view 7.2](#72-settings))   
([view 1.9](#19-sign-in-screen-2nd-load))   


#### API Usage

Request:  ```GET /user/management```  [api-users](http://gtio-dev.gotryiton.com/docs/api-users)

Response:  Will respond with the extended user object for the currently logged in user.

#### Routing

gtio://my-management

#### Stories
- A logged in user can see their user info on the management page
   - ```user.name```, ```user.location```, ```user.icon``` are displayed at the top of the page
- a user can edit their profile icon
   - profile icon is tappable to edit profile icon
      - **tap** ==> (view 7.3)
- a user can edit their profile information
   - edit button **tap** routes to (view 7.4)
- a user can see their following count, followers count, and stars count
   - each button is defined in ```user.following_button```, ```user.followers_button```, and ```user.stars_button``` in api response
      - button includes count and action for destination tap
      - buttons tap to (view 6.5), (view 6.6), (view 7.9) respectively
- a user can tap to their shopping list
   - my shopping list btn
      - **tap** ==> (view 7.8)
- a user can tap to see their hearted posts
   - my hearts btn
      - **tap** ==> (view 7.5)
- a user can tap to see their posts
   - my posts
      - **tap** ==> (view 7.6)
- a user can tap to search for tags
   - search tags button
      - **tap** ==> (view 7.10)
- a user can tap to find friends
   - find my friends button
      - **tap** ==> (view 6.1)
- a user can tap to invite friends
   - invite friends button
      - **tap** ==> (view 5.1)
- a user can edit their settings
   - settings button
      - **tap** ==> (view 7.2)
- a user can sign out
   - sign out button:
      - confirmation dialog
         - text: "are you sure you want to log out?""
         - ok:  api request to ```/user/logout```
            - on response, discard token and route to (view 1.9)
         - cancel: close dialog
- a user can toggle their state to private
   - looks are private toggle
      - confirm dialog if you're turng ON
         - text: "Are you sure you want to make your posts private? From now on, only followers you approve will see your posts."
      - confirm dialog if you're turng OFF
         - text: "Are you sure you want to make your posts public? From now on, anyone will be able to follow your posts."
      - api request:
         - POST to ```/user/update``` with ```public:true``` or ```public:false``` 
   - text under the toggle should read: "turn this option ON to require your permission before someone can follow your posts."
      - use this copy not the copy in the mockup!


#### Design Stories
- Top Area
	- Transparent Background with image (profile.top.bg)
		- Anchor top and bottom 8px (don't stretch top and bottom 8px blocks)
	- Height: 72px
	- Edit Icon (profile.top.icon.edit.png)
		- 26x26px
		- Top right corner of profile area (end of icon should appear approx same distance from top and right edges)
	- Profile Image
		- 110x110px without shadow (with shadow background image 128x128)
		- 4px from top 4px from left (including shadow background)
	- Name Text: Archer Medium Italics 16pt rgb(255,255,255) #ffffff (11px from top, 3px from profile image)
	- Location Text: Proxima Nova Regular 10pt rgb(186,186,186) #bababa (6px from top, 3px from profile image)
      - string should be displayed in ALL UPPERCASE
   - User Badge
      - use size "38_38.png" for 2x
      - use size "17_17.png" for 1x
      - 2px away from right edge of user name
      - bottom of asset is 4px below baseline of user name
	- Following/Followers/Featured Buttons
		- Should align with bottom of profile image (~7-8px)
		- 3px from left
		- 7px between buttons
		- Use profile.top.buttons.bg.left.png for left side
			- Following/Followers is 54px wide
			- Featured is 21px wide
			- Text: Archer Medium Italic 11pt rgb(157,157,157) #9d9d9d
		- Use profile.top.buttons.bg.right.png for right side
			- Each has variable width to accommodate length of number 1-99,999
            - width should accommodate 7px of padding on left of number, 7px of padding on right of number
			- Text: Proxima Nova Bold 12pt rgb(210,210,210) #d2d2d2
- Grouped Table View
	- Border color: rgb(217,215,206) #d9d7ce
	- Chevron is 10px from right
   - 'my hearts'
      - insert apostrophe (U+2019) before the 's' and after the heart graphic in 'my hearts' menu item.  try to ensure at least 1.5px visual gap between heart and apostrophe (3px on Retina looks right).

### 7.2 Settings  

#### Overview
A logged in user can edit their settings

#### Mockups
7.2 Settings ([wireframe](http://invis.io/C22OCZBZ))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.2.Settings.png" width=420px/>

#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
**exit screens:**   
([view 7.3](#73-edit-profile-pic))   
previous screen    


#### API Usage
/User/Settings

#### Routing

gtio://StandardWebview/Settings/http://gtio-dev.gotryiton.com/user/settings

#### Stories
- A user can edit when they receive notifications from GTIO
   - load a webview which will allow a user to turn on and off notifications


### 7.3 Edit profile pic  

#### Overview
A logged in user can edit their profile icon

#### Mockups
7.3 ([wireframe](http://invis.io/MF2QIO3Y))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.3.Edit.Profile.Picture.png" width=420px/>

7.3.1 No facebook connect, and no looks  

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.3.Edit.Profile.Picture.Nulls.png" width=420px/>

#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
([view 7.7](#74-edit-profile))   
([view 1.7](#17-almost-done))   
**exit screens:**   
previous screen    


#### API Usage
/User/Icon

/User/Facebook-Connect

#### Routing

gtio://edit-my-icon


#### Stories
- A user can edit their profile icon
   - a user sees a list of profile icon options
   - a user can tap on each profile icon option and see a preview of their icon with their GTIO display name and location
   - a user can tap to clear profile icon, which sets the icon to the GTIO default icon (```default_icon``` in the api response)
      - api for /User/Icon will provide default icon 
- If a user is not connected to facebook, they can connect from this screen to add their fb profile icon (GTIOv3 behavior)
   - if the user is not facebook connected, their facebook icon has a 'connect' btn
      - **tap** ==> Facebook SSO
         - **success** ==> api request to /User/Facebook-Connect
            - **success** ==> refresh (view 7.3)
   - if the user **is** facebook connected, then the fb connect button is hidden

#### Design Stories
- Table Cell 1
   - 183px tall
   - outside stroke rbg(217,215,206)
   - 'choose from'
      - Archer Light Italic
      - 8pt
      - rgb(255,106,114)
      - 28px from left edge of screen
      - baseline is 29px from top of table cell
   - 'facebook'
      - 'edit.profile.pic.fb.png'
      - 31px from left edge of screen
      - 51px from top of table cell
   - 'my looks'
      - Verlag Light
      - 6pt
      - rgb(143,143,143)
      - 36px from left edge of screen
      - baseline is 60px from top of table cell
   - thumbs
      - facebook
         - 25px from left edge of screen
         - 71px from top of table cell
         - overlaid by 'edit.profile.pic.thumb.mask.png'
      - my looks
         - 195px wide area
         - first thumb
            - 100px from left edge of screen
            - 71px from top of table cell
         - all thumbs
            - overlaid by 'edit.profile.pic.thumb.mask.png'
            - 5px gap between thumbnails
         - scrollbar
            - only visible if there is overflow
            - 10px below bottom of thumbnails
            - 'thumbs-scroll.png' with OVER and UNDER versions
      - selected thumb
         - overlaid by 'edit profile.pic.selected,png'
            - position is offset by 1px to the left and 1px up from thumb position
   - 'f connect' button
      - 'edit.profile.pic.fb.connect.png' with ACTIVE and INACTIVE versions
      - 25px from left edge of screen
      - 10px below accompanying thumbnail
- Table Cell 2
   - 200px tall
   - outside stroke rbg(217,215,206)
   - 'preview'
      - Archer Light Italic
      - 8pt
      - rgb(255,106,114)
      - 28px from left edge of screen
      - baseline is 29px from top of table cell
   - preview area
      - bg is 'edit.profile.pic.preview.cell.png'
         - 26px from left edge of screen
         - 54px from top of table cell
      - thumb
         - overlaid by 'edit.profile.pic.thumb.mask.png'
         - 39px from left edge of screen
         - vertically centered inside 'edit.profile.pic.preview.cell.png'
            - trying for 13px of padding on top, left, bottom of thumb
      - user name
         - Archer Medium Italic
         - max width of text is 172px wide
         - 9pt max, 7pt min
         - rgb(255,106,114)
         - 108px from left edge of screen
         - baseline is 91px from top of table cell
            - if user location is not available, baseline is 110px from top of table cell
      - user location (if available)
         - Proxima Nova Regular
         - All caps
         - 6pt
         - rgb(143,143,143)
         - 108px from left edge of screen
         - baseline is 110px from top of table cell
   - 'clear profile picture' button
         - 'edit.profile.pic.clear.png' with ACTIVE and INACTIVE versions
         - 26px from left edge of screen
         - 151px from top of table cell

### 7.4 Edit profile  

#### Overview
A logged in user can edit their profile 

#### Mockups
7.4 ([wireframe](http://invis.io/VY2OD0HD))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.4.Edit.Profile.png" width=420px/>

7.4 scrolled 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.4.Edit.Profile.Scrolled.png" width=420px/>

#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
([view 1.8](#18-quick-add))   
**exit screens:**   
previous screen    


#### API Usage
/User/Edit

#### Routing

gtio://edit-my-profile


#### Stories
- A user can edit their profile
   - mimmick existing form
   - add website field
   - edit profile picture **tap** ==> (view 7.3)
   - save:
      - **tap** ==> api request
         - **success** ==> returns you to previous screen
         - **error** ==> dialog message


#### Design Stories
- List tables/cells
   - Cell dividers and outside stroke should be #e2e1db
   - Profile picture
      - displayed at 55px x 55px
      - overlaid by 'icon-mask-110.png' (asset delivered for 1.7 - Almost Done)
      - Profile picture and overlay should have 13px of top, bottom, and left side padding inside table cell
   - "edit profile picture?" text
      - 7pt Proxima Nova Semibold #8f8f8f
      - 10px away from right edge of profile picture
      - vertically centered inside table cell
   - text for field labels
      - 7pt Proxima Nova Semibold #8f8f8f
      - mandatory field labels (name, email, gender) - 7pt Proxima Nova Semibold #ff6a72
   - example input text
      - 7pt Proxima Nova Light Italic #a4a4a4
   - actual input text
      - 7pt Proxima Nova Regular #8f8f8f
   - text prompting picker controls (select, select year)
      - 7pt Proxima Nova Semibold #8f8f8f


### 7.5 My hearts  

#### Overview
A logged in user can view their hearted items

#### Mockups
7.5 My hearts ([wireframe](http://invis.io/KD2OD28X))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.5.My.Hearts.png" width=420px/>


#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
**exit screens:**   
([view 3.1](#31-outfit-post-detail-page))   
([view 4.1](#41-product-page-view))   
previous screen    


#### API Usage
/User/Hearts

#### Routing

gtio://my-hearts

or

gtio://hearted-by-user/:user_id


#### Stories
- A logged in user can view their hearted items
   - masonry view of hearts (posts and products)
   - thumbnails have heart toggle upper left
      - see standard heart toggle behavior
   - destination link provided in api

#### Design Stories
- Custom Title Bar
   - 'my.hearts.title.png'
   - horizontally and vertically centered
- no extra shadow under navigation bar
- Tab Bar
   - All images are profile.tabbar.[position].[state].png
   - Text: 12px Archer Book Italic 14pt rgb(85,85,85) #555556
      - baseline is 16px from top of tab asset, horizontally centered
   - Fixed position
      - content area scrolls 'under' tab graphics
- Photo Grid
   - Images are sized to 94px wide, variable height
   - Top images are 9px from top of content area
   - Leftmost column images are 7px from left edge of screen
   - Rightmost images are 7px from right edge of screen
   - In columns, images be separated by 12px of vertical gap
   - 6px gaps between 1st and 2nd and 3rd columns
   - 'grid-thumbnail.frame.png'
      - placed under each image
      - position relative to image is offset by (-4px,-4px)
      - vertical middle is stretchable
      - 4px nonstretchable on top
      - 6px nonstretchable on bottom

### 7.6 My posts

#### Overview
A logged in user can view their posts

#### Mockups
7.6 ([wireframe](http://invis.io/732OD3ZH))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.6.My.Posts.png" width=420px/>


#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
**exit screens:**   
([view 3.1](#31-outfit-post-detail-page))   
([view 3.6](#36-product-post-detail-view))   
previous screen    

#### API Usage
/Posts/by-user/:user_id

#### Routing
gtio://my-posts

or

gtio://posted-by/:user_id

#### Stories
- A logged in user can view their posted items
   - masonry view of hearts (posts and products)
   - thumbnails have heart toggle upper left
      - see standard heart toggle behavior
   - destination link provided in api

#### Design Stories
- Photo Grid
   - Images are sized to 94px wide, variable height
   - Top images are 9px from top of content area
   - Leftmost column images are 7px from left edge of screen
   - Rightmost images are 7px from right edge of screen
   - In columns, images be separated by 12px of vertical gap
   - 6px gaps between 1st and 2nd and 3rd columns
   - 'grid-thumbnail.frame.png'
      - placed under each image
      - position relative to image is offset by (-4px,-4px)
      - vertical middle is stretchable
      - 4px nonstretchable on top
      - 6px nonstretchable on bottom

### 7.7 Profile page  

#### Overview
Each user has a profile page

#### Mockups
7.1 basic: ([wireframe](http://invis.io/732OD3ZH))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.7.1.Other.Profile.Following.png" width=420px/>

7.7.1 other's profile, not following: ([wireframe](http://invis.io/AD2PMYYW))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.7.1.Other.Profile.Following.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.7.1.Other.Profile.Not.Following.Bio.Site.png" width=420px/>

7.7.2 other's profile, following requested: ([wireframe](http://invis.io/4Q2PMZHE))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.7.2.Follow.Requested.png" width=420px/>

7.7.3 other's profile, with banner: ([wireframe](http://invis.io/RW2POUXA))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.7.3.Banner.png" width=420px/>

7.7.4 other's profile, empty state:

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.7.Profile-Empty.png" width=420px/>

7.7.5 other's private profile, posts:

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.7.Profile-Private-Hearts.png" width=420px/>

7.7.6 other's private profile, hearts:

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/7.7.Profile-Private-Hearts.png" width=420px/>


#### User Flow
**entry screens:**   
([view 3.1](#31-outfit-post-detail-page))   
([view 3.2](#32-post-detail-with-verdict))   
([view 3.6](#36-product-post-detail-view))   
([view 6.1](#61-find-my-friends))   
([view 6.2](#62-suggested-friends))   
([view 6.3](#63-friends-management-page))   
([view 6.4](#64-find-out-of-network-friends))   
([view 6.5](#65-following-list))   
([view 6.6](#66-followers-list))   

**exit screens:**   
([view 3.1](#31-outfit-post-detail-page))   
([view 3.6](#36-product-post-detail-view))   
([view 4.1](#41-product-page-view))   
([view 6.5](#65-following-list))   
([view 6.6](#66-followers-list))   
previous screen    


#### API Usage
/user/:id/profile  (see documentation [api-users](http://gtio-dev.gotryiton.com/docs/api-users))

#### Routing
gtio://profile/:user_id

#### Stories
- a user can view the profile info of another user (or their self)
   - ```user.name```, ```user.location```, ```user.icon``` are displayed at the top of the page
      - ```user.badge``` is displayed next to name.
         - path to the badge is defined in api: ```user.badge.path```
         - file is defined in app:
            - use size "38_38.png" for 2x
            - use size "17_17.png" for 1x
- a user can follow another user (but not theirself)
   - follow button displayed in top right corner
   - defined in api response ```user.button```
      - if null (requesting user is the same as profiled user -- or user is just not follow-able for some reason), do not display
- a user can edit the settings of their relationship to the profiled user
   - button opens an actionsheet if ```ui.settings.buttons``` is not empty
      - if ```ui.settings``` is null, do not display the settings button
   - tapping raises actionsheet with buttons that are contained in the settings_button object:
      - items in the actionsheet are defined by the buttons in the array
- a user can read another user's bio
   - bio is defined as ```user.about```
- a user can see who another user is following
   - ```ui.buttons``` will include a button with ```name:following``` 
   - button will define destination and count for the following button
   - routes to ```gtio://user/:user_id/following``` (view 6.5)
- a user can see who another user's followers are
   - ```ui.buttons``` will include a button with ```name:followers``` 
   - button will define destination and count for the followers button
   - routes to ```gtio://user/:user_id/followers``` (view 6.6)
- a user can see who another user's starred posts (editors picks)
    - ```ui.buttons``` will include a button with ```name:stars``` 
   - button will define destination and count for the stars button
   - routes to ```gtio://user/:user_id/followers``` (view 6.5)
- A user can see additional info about another user 
   - each profile has a customizable text fields (view 7.7.1)
      - defined in api as ```ui.profile_callouts``` array
      - each item has ```icon``` and ```text```
      - text should support ```<b>``` tags for highlighting bold text
      - items are not tappable
- Special branded users can display a banner in their profile
   - banner area (view 7.7.3)
      - button is defined in the api with ```ui.buttons```
      - banner button will have ```name:banner-ad```
      - banner button will have ```image:[url]``` to define the image to display (will be a 2x image)
- A users profile can show a button linking to an external site
   - seen in (view 7.7.1)
   - button defined by api through ```ui.buttons```
   - button will have ```name:website-button```
   - button includes ```text``` and ```action``` 
- A users profile shows a masonry list of their hearts and looks
   - api responds with ```hearts_list``` and ```posts_list``` which will be identical responses to ```/posts/hearted-by-user/:user_id``` and ```/posts/by-user/:user_id``` respectively
      - api paginates in the usual manner
   - each post is displayed as a thumbnail using ```post.photo.thumbnail```
      - **tap** ==> (view 4.1)


#### Design Stories
- Top Area
	- Cog Icon
		- 26x26px
		- 8px from top and right
	- Profile Text
		- 11pt Proxima Nova Regular rgb(186,186,186) #bababa
   - User Badge
      - use size "38_38.png" for 2x
      - use size "17_17.png" for 1x
      - 2px away from right edge of user name
      - bottom of asset is 4px below baseline of user name
- Friend Request
	- 32px high rgb(0,0,0) 0.22 alpha
	- Text: 11pt Proxima Nova Regular rgb(255,255,255) #ffffff
		- 12px from left and 12px padding above
	- Buttons
		- Width: 55x21px
		- 11pt Proxima Nova Bold rgb(255,255,255) #ffffff
		- Text should be have about 5px padding from top to center
- Tab Bar
	- All images are profile.tabbar.[position].[state].png
	- Text: 12px Archer Book Italic 14pt rgb(85,85,85) #555556
		- baseline is 16px from top of tab asset, horizontally centered
- Photo Grid
   - Images are sized to 94px wide, variable height
   - Top images are 9px from top of content area
   - Leftmost column images are 7px from left edge of screen
   - Rightmost images are 7px from right edge of screen
   - In columns, images be separated by 12px of vertical gap
   - 6px gaps between 1st and 2nd and 3rd columns
   - 'grid-thumbnail.frame.png'
      - placed under each image
      - position relative to image is offset by (-4px,-4px)
      - vertical middle is stretchable
      - 4px nonstretchable on top
      - 6px nonstretchable on bottom
- Empty State
   - Text Callout
      - text appears overlaid on 'empty.message.container.png'
      - Archer Book Italic, 14pt, rgb(148,148,148)
      - 'empty.message.container' is horizontally and vertically centered within content area
      - baseline of text is 17px up from bottom of 'empty.message.container' asset
- Viewing Private User (when not following them)
   - Text Callout
      - text appears overlaid on 'empty.message.container.png'
      - Archer Book Italic, 14pt, rgb(148,148,148)
      - user name is Archer Medium Italic, 14pt, rgb(255,106,114)
      - 'empty.message.container' is horizontally and vertically centered within content area
      - stretch 'empty.message.container' to accommodate text
         - vertical middle is stretchable
         - 5px nonstretchable at top
         - 5px nonstretchable at bottom
         - baseline of 2nd line of text is 17px up from bottom of 'empty.message.container' asset
         - baseline of 1st line should be 25px away from top of 'empty.message.container' asset
   - Lock Icon
      - 'profile-lock.png'
      - 13px gap between bottom of lock and top of empty.message.container

### 7.8 Shopping list  

#### Overview
Each user has a shopping list

#### Mockups
7.8 Shopping list ([wireframe](http://invis.io/8W2OD45T))

<img src="https://github.com/twotoasters/GTIO-iOS/raw/as-slices/GTIO/Application/Resources/Mockups/7.8.shopping.list.png" width=420px/>

<img src="https://github.com/twotoasters/GTIO-iOS/raw/as-slices/GTIO/Application/Resources/Mockups/7.8.shopping.list.empty.png" width=420px/>


7.8.1 shopping list confirm: ([wireframe](http://invis.io/5Q2PN0WX))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.8.Shopping.List.Confirm.png" width=420px/>


#### User Flow
**entry screens:**   
([view 3.1](#31-outfit-post-detail-page))   
([view 3.2](#32-post-detail-with-verdict))   
([view 3.6](#36-product-post-detail-view))   
([view 6.1](#61-find-my-friends))   
([view 6.2](#62-suggested-friends))   
([view 6.3](#63-friends-management-page))   
([view 6.4](#64-find-out-of-network-friends))   
([view 6.5](#65-following-list))   
([view 6.6](#66-followers-list))   

**exit screens:**   
([view 4.1](#41-product-page-view))   
([view 10.4](#104-default-3rd-party-webview-container))   
previous screen    

#### API Usage
/User/Shopping-list

#### Routing
gtio://my-shopping-list

#### Stories    
- Each user has a shopping list page
   - title: shopping list
   - products shown in customized cells
      - item description:
         -user icons, names, and description text (api customized)
         - ```<b>``` text activated
         - whole item is linkable
         - delete button on each description
            - ??
      - product item view
         - same as view in 4.2 and 4.7
         - includes buy button
- A user can buy an item in their shopping list
   - shopping list items include buy button
      - **tap** ==> raises actionsheet
         - email to myself
            - **tap** ==> api request
               - **success** ==> show 'emailed' overlay (view 7.8.1)
         - go to store site
            - **tap** ==> opens url in standard webview 
- A user can delete an item from their shopping list
   - each description area has a delete btn
      - **tap** ==> sends api request
         - **success** ==> refreshes list
- A user can email themselves their shopping list 
   - top right btn: email list
      - raises dialog
         - ok: api request 
            - **success** ==> show 'emailed' overlay (view 7.8.1)
         - cancel: closes dialog

#### Design Stories
- Cell
	- Background (7/shopping.cell.png)
	- 314x105px - height includes extra shadow from image, without shadow the cell is only 101px tall
	- Chevron (7/shopping.chevron.png)
	- Text 
		- Product Name: Verlag Light 14px rgb(89,81,85) #595155
		- Brand: Proxima Nova semibold 11px rgb(187,187,187) #bbbbbb
		- Price: Verlag Bold 16px rgb(255,106,114) #ff6a72
	- Image
		- 106x101px
		- Position on top left of cell
		- Overlay with 7/shopping.cell.image.overlay.png
	- X Button
		- Use 7/shopping.cell.close.inactive.png
			- 7/shopping.cell.close.active.png for tap state
		- 12x11px
		- 4px from top and right edge of cell
	- Buy Button
		- Background (7/shopping.button.buy.inactive.png)
			- Active state (7/shopping.button.buy.active.png)
		- 39x21px
		- Proxima Nova semibold 9px rgb(143,143,143) #8f8f8f	
		- 15px from bottom
		- 10px from right
	- Email Button
		- Background (7/shopping.button.email.inactive.png)
			- Active state (7/shopping.button.email.active.png)
		- 39x21px
		- Proxima Nova semibold 9px rgb(143,143,143) #8f8f8f	
		- 15px from bottom
		- 6px padding from buy button
- Nav bar share button
	- 33x26px
	- Background (7/shopping.navigation.bar.button.share.inactive.png)
		- Active state (7/shopping.navigation.bar.button.share.active.png)
- Bottom Area
	- Background (7/shopping.bottom.bg.png) stretch/repeat horizontally
	- 74px high
	- Cells
		- Overlay (7/shopping.bottom.image.overlay.png)
			- Active (7/shopping.bottom.image.overlay.active.png)
		- 60x60px
		- Images are 55x55px
		- Can clip image using (7/shopping.bottom.image.alpha.png) as an alpha
		- Plus Button (7/shopping.bottom.plus.inactive.png)
			- Active (7/shopping.bottom.plus.active.png)

### 7.9 My Stars

#### Overview
A logged in user can view their (or someone else's) posts that have been selected as editors picks

#### Mockups

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/3/7.9.My.Stars.png" width=420px/>


#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
([view 7.7](#77-profile-page))   
**exit screens:**   
([view 3.1](#31-outfit-post-detail-page))   
([view 3.6](#36-product-post-detail-view))   
previous screen    

#### API Usage
/Posts/stars-by-user/:user_id

#### Routing
gtio://my-stars

or

gtio://stars-by-user/:user_id


#### Stories
- A logged in user can view their posted items that have editors pick stars
   - masonry view of starred posts
   - destination link provided in api

#### Design Stories
- Photo Grid
   - Images are sized to 94px wide, variable height
   - Top images are 9px from top of content area
   - Leftmost column images are 7px from left edge of screen
   - Rightmost images are 7px from right edge of screen
   - In columns, images be separated by 12px of vertical gap
   - 6px gaps between 1st and 2nd and 3rd columns
   - 'grid-thumbnail.frame.png'
      - placed under each image
      - position relative to image is offset by (-4px,-4px)
      - vertical middle is stretchable
      - 4px nonstretchable on top
      - 6px nonstretchable on bottom
   - Star Corner
      - 'star-corner-grid.png'
      - placed at top right corner of post image (should appear to curve seamlessly into photo frame)
   - Accent Line
      - place accent line behind grid in same position as appears on (and spec'd from) Feed type view


### 7.10 Search Tags

#### Overview
A logged in user can view their (or someone else's) posts that have been selected as editors picks

#### Mockups
Coming soon.


#### User Flow
Coming soon.  

#### API Usage
GET /tags/search/:query

#### Stories
- A user can search tags 




## 8. The Feed 

### 8.1 Feed view  

#### Overview
Each user has a personalized feed of content on the first tab.  The content contains product posts and outfit posts.  Users can take actions directly from the feed view

#### Mockups
8.1 ([wireframe](http://invis.io/P32OE57R)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/_0000_Feed.AP.png" width=420px/>

8.1.a no user location   

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/_0002_Feed.UG.No.Location.png" width=420px/>

8.1.b short image

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/_0015_Feed.Product.Shot.png" width=420px/>

8.1.c no shop this look button

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/_0013_Feed.VJ.Scrolled.No.Shop.png" width=420px/>

8.1.2 Post dot options: ([outfit item](http://invis.io/N92PN2YP)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/_0011_Feed.VJ.Scrolled.Dot.Options.png" width=420px/>

8.1.3 feed scrolled: ([wireframe](http://invis.io/DA2PN3TC)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/_0010_Feed.VJ.Scrolled.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/_0012_Feed.VJ.Scrolled.Further.No.Description.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/_0014_Feed.VJ.Scrolled.Further.Description.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/_0014_Feed.VJ.Scrolled.Further.Tags.Only.png" width=420px/>

8.1.3.a feed scrolled with next feed item

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/_0023_Feed---Next-Item.png" width=420px/>


8.1.4 feed empty:  ([wireframe](http://invis.io/3W2OH9G2)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/8.1.Feed.Empty.png" width=420px/>
  

#### User Flow
**entry screens:**   
any screen with uiTabBar
([view 1.1](#11-splash-page))   
([view 1.8](#18-quick-add))   
([view 1.9](#18-sign-in-screen-2nd-load)) via ([view 1.10](#110-facebook-sso)) or ([view 1.11](#111-janrain-sdk))     
([view 1.4](#14-returning-users)) via ([view 1.10](#110-facebook-sso)) or ([view 1.11](#111-janrain-sdk))     
([view 1.5](#15-janrain-sign-up)) via ([view 1.11](#111-janrain-sdk))     
**exit screens:**   
([view 3.1](#31-outfit-post-detail-page))   
([view 3.6](#36-product-post-detail-page))   
([view 3.4](#34-reviews-page))   
([view 3.5](#35-who-hearted-this))   
([view 7.7](#77-profile-page))   
([view 10.5](#105-shop-browse-products))   
([view 10.3](#103-default-3rd-party-webview-container))   
([view 8.3](#83-default-3rd-party-webview-container))   

#### API Usage
/Posts/Feed  [Post Docs](http://gtio-dev.gotryiton.com/docs/api-posts)

#### Routing
gtio://posts/feed


#### Stories  
- A user can see a personalized feed of content
   - each post has a user description bar:
      - name: ```post.user.name```
      - location: ```post.user.location```
         - location may be empty, in which case name is displayed on the base line
      - created at time: ```post.created_when```
   - user detail area catches during scroll
      - catches at top of visible area (view 8.1.3)
      - scrolls out of view and replaced by next user detail of next item in feed (a la instagram)
   - each post shows a photo
      - main image: ```post.photo.main_image```
      - photo size should be displayed at ???px wide
      - photo ratio will vary between 1:1 and 3:2 tall
   - each post may show a description below the photo:
      - description text: ```post.description```
      - text may be empty
      - description text may include html anchor tags 
         - @ tags:
            - tap to: ```gtio://profile/:user_id```
         - # tags:
            - tap to ```gtio://explore/posts-with-hashtag/:tag```
         - brand tags:
            - tap to ```gtio://explore/posts-with-brand-tag/:tag```
   - each post may include brand buttons
      - brand buttons are displayed below description text
      - button objects: ```post.brands[].button```
      - routes to ```gtio://ShopBrowse/[title (urlencoded)]/[api path (url encoded)]``` (defined in api)
- each post can be hearted by the user
   - heart button object is in the buttons array: ```post.buttons```
   - heart is displayed in the top left corner of the photo
- a user can tap to see reviews of the post
   - reviews button w/ reviews count is included in: ```post.buttons```
   - routes to ```gtio://reviews-for-post/:post_id``` (defined in api)
- a user can tap to "shop this look"
   - shop button is included in: ```post.buttons```
   - button is conditionally included.  may be excluded from the ```post.buttons``` array for some posts.
   - routes to ```gtio://shop-post/:post_id``` (defined in api)
- A user can tap on a '...' btn to see more actions 
   - button options are included in: ```post.dot_options.buttons```
- A user can paginate through multiple pages of their feed
   - pagination details are available in: [Api Docs](http://gtio-dev.gotryiton.com/docs/api-documentation)
- A user can pull to refresh their feed
   - see (section 13.6)
- If the user's feed is empty they see messaging encouraging them to add friends
   - see (view 8.1.4)

#### Design Stories
- accent line
   - 'accent-line.png'
      - (assets are designed to show an element exactly 2px wide on both @1x and @2x displays)
      - vertically stretchable
      - stretch to form a vertical line 24px from right edge of the screen
   - line should be interrupted (shows a gap) and overlaid with separators by timestamp (story below)
   - line should be interrupted (shows a gap) and overlaid with a separator by 'wear this?' callout (story below)
   - line should be overlaid by various buttons (stories below)
- post items
   - user info area
      - user icon
         - 7px from left edge of screen
         - user icon from API displayed at 42px x 42px
         - image should be masked by 'user-pic-84-mask.png' (to hide corners)
         - image should be overlaid by 'user-pic-84-shadow-overlay.png'
      - name / location
         - background is 'user-info-bg.png'
            - 7px to the right of user icon
         - name is Archer Book Italic, 16pt, rgb(255,106,114)
            - 7px left padding inside background area
            - if location exists, baseline is 23px up from bottom of background area
            - if location does not exist, baseline is 8px up from bottom of background area
         - location is Proxima Nova Regular, 10pt, rgb(156,156,156)
            - 7px left padding inside background area
            - baseline is 8px up from bottom of background area
         - User Badge
            - use size "28_28.png" for 2x
            - use size "14_14.png" for 1x
            - 4px away from right edge of user name
            - bottom of asset is 2px below baseline of user name            
   - timestamp
      - 34px high gap in accent line, vertically centered/aligned with position of user info
      - text is Archer Medium Italic, 10pt, rgb(143,143,143)
         - vertically centered inside gap
         - horizontally centered around accent line
      - separators
         - 'accent-line-separator-top.png' horizontally centered around accent line, at top of gap
         - 'accent-line-separator-bottom.png' horizontally centered around accent line, at bottom of gap
   - photo
      - background (big frame) is 'photo-bg.png'
         - positioning
            - left edge of frame (not including shadow, including stroke outline) should line up with left edge of user icon
            - top edge of frame asset (including any transparent area) should be 7px from bottom of user icon
         - vertical middle is stretchable
         - 10px nonstretchable on top
         - 12px nonstretchable on bottom
         - frame asset should be stretched to height which is sum of:
            - photo height
            - 22px (for top and bottom frame edges w/ padding)
            - total height required to accommodate photo description.  brand buttons and extra padding for those elements (story below)
         - photo is placed offset 7px down from top of frame asset
         - photo is placed vertically centered within frame asset (should be 5px from the left edge of asset)
      - heart toggle
         - 'heart-toggle.png' with on/off states, each with active and inactive
         - asset is placed 9px down from top of photo
         - asset is placed 9px from left edge of photo
      - Star Corner
         - 'star-corner-feed.png'
         - placed at top right corner of post image (should appear to curve seamlessly into photo frame)
   - post description
      - shown inside photo frame between bottom edge of frame and bottom edge of photo
      - Verlag Extra Light, 13pt, rgb(35,35,35), #232323
      - any tags: Verlag Book, 13pt, rgb(255,106,114), #ff6a72
      - text area
         - 240px wide
         - horizontally centered inside frame background
         - baseline of first line of text is 19px from bottom of photo
   - heart info
      - 'heart-bullet.png'
         - left edge of heart shape should line up with left edge of photo (approx 13px from left edge of screen, not including 'glow' padding in heart asset)
         - top edge of heart is 12px down from bottom edge of photo frame
      - text is Proxima Nova Semibold, 13pt, rgb(172,172,172)
         - baseline of first line of text is 23px from bottom edge of photo frame
         - text area is 228px wide, lines should wrap (right edge of text area should be be same as right edge of photo)
   - buttons
      - if photo height < 247px and voting is ON, assume photo height is 247px to accommodate max number of buttons and minimum gaps required
      - brand buttons
         - 'button-brand.png' with active and inactive versions
         - text is 13pt Archer Book Italic, rgb(88,88,88)
         - horizontal middle is stretchable
         - 5px nonstretchable on left
         - 5px nonstretchable on right
         - positioning
            - first button is 18px from left edge of screen
            - top row of buttons are 11px away from baseline of last line of description or bottom of photo
            - 8px gap between buttons
            - if a row exceeds 240px, last button should wrap to an additional row
               - additional rows have 8px padding from previous rows
      - review button
         - 'button-review.png' with active and inactive states
         - top of circle (not including 'glow') should line up with top of photo
         - horizontally centered around accent line
      - review button count
         - Verlag Book, 12pt, rgb(143,204,177)
         - horizontally centered around accent line
         - vertically centered within button asset
      - product info button
         - 'button-shopbag.png' with active and inactive states
         - horizontally centered around accent line
         - circle is 9px away from review circle (not including 'glow' areas)
      - dot dot dot button
         - 'button-dot.png' with active and inactive states
         - horizontally centered around accent line
         - bottom of circle (not including 'glow') should line up with bottom of photo (see minimum height note above)
         - triggers 'dot dot dot menu' (see story below)
   - dot dot dot menu
      - assets are 'dot-menu.png' with top/middle/bottom states, each with active and inactive
      - bottom cell
         - position 7px from right edge of screen (point of arrow should appear to be horizontally centered inside dot dot dot button)
         - position 24px from bottom of dot dot dot button (should overlap about 20% of the dot dot dot button)
      - middle cell
         - position flush with top of below cell
         - use multiple instances for menus with more items
      - top cell
         - position flush with top of topmost 'middle' cell
      - text is Proxima Nova Regular, 12pt, rgb(88,88,88)
         - each line vertically and horizontally centered within respective cell
   - feed posts positioning
      - top item
         - user icon is 7px away from bottom of navigation bar
         - user icon is 7px away 7px from left edge of screen
      - other items' positioning
         - user icon is 7px away 24px below bottommost element in previous item
         - user icon is 7px away 7px from left edge of screen
   - empty state (screen 8.1.4)
      - use 'empty-bg-overlay.png' in content area


### 8.3 ~Feed verdict view~

###  8.4 Upload in progress view  

#### Overview
A user can see their pending upload in their feed

#### Mockups
8.4 ([wireframe](http://invis.io/642OE8AC)) 

<img src="https://github.com/twotoasters/GTIO-iOS/raw/6afe6be3f1d8879dbc9d7522c8357e40c43caaf7/GTIO/Application/Resources/Mockups/8.4.upload.in.progress.png" width=420px/>

<img src="https://github.com/twotoasters/GTIO-iOS/raw/6afe6be3f1d8879dbc9d7522c8357e40c43caaf7/GTIO/Application/Resources/Mockups/8.4.upload.in.progress.finalizing.png" width=420px/>

<img src="https://github.com/twotoasters/GTIO-iOS/raw/6afe6be3f1d8879dbc9d7522c8357e40c43caaf7/GTIO/Application/Resources/Mockups/8.4.upload.in.progress.success.png" width=420px/>



Upload Fail

<img src="https://github.com/twotoasters/GTIO-iOS/raw/6afe6be3f1d8879dbc9d7522c8357e40c43caaf7/GTIO/Application/Resources/Mockups/8.4.upload.in.progress.fail.png" width=420px/>

#### User Flow
**entry screens:**   
([view 4.7](#47-post-a-product))   
([view 12.3](#123-post-a-look))   

**exit screens:**   
([view 3.1](#31-outfit-post-detail-page))   
([view 3.6](#36-product-post-detail-page))   
([view 3.4](#34-reviews-page))   
([view 3.5](#35-who-hearted-this))   
([view 7.7](#77-profile-page))   
([view 10.5](#105-shop-browse-products))   
([view 10.3](#103-default-3rd-party-webview-container))   
([view 8.3](#83-default-3rd-party-webview-container))   

#### API Usage
/Post/Upload

#### Stories  
- A user can see their pending upload in their feed
   - text 'Just a moment...'
   - progress bar marking upload progress
   - on **success** from upload api ==> (view 8.5)
   - on **fail** ==> retry?

#### Design Stories
- Text
	- left side: Archer Medium Italic 11px rgb(156,156,156) #9c9c9c
	- right side: Archer Medium Italic 11px rgb(88,88,88) #585858
- Retry Overlay
	- 8/uploading.fail.avatar.overlay.inactive.png
		- Active (8/uploading.fail.avatar.overlay.active.png)

###  8.5 Feed after completed upload  

#### Overview
A user can see their new upload in their feed

#### Mockups
8.5 ([wireframe](http://invis.io/ZS2PN997)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.5.Feed.After.Upload.png" width=420px/>

#### User Flow
**entry screens:**   
([view 8.4](#84-upload-in-progress-view))   

**exit screens:**   
([view 3.1](#31-outfit-post-detail-page))   
([view 3.6](#36-product-post-detail-page))   
([view 3.4](#34-reviews-page))   
([view 3.5](#35-who-hearted-this))   
([view 7.7](#77-profile-page))   
([view 10.5](#105-shop-browse-products))   
([view 10.3](#103-default-3rd-party-webview-container))   
([view 8.3](#83-default-3rd-party-webview-container))   

#### API Usage
/Post/Upload

#### Stories  
- A users just completed can be viewed at the top of their feed
   - insert item from completed api request in 8.4 at top of list


## 9. Explore Looks

###  9.1 Popular Looks Grid  

#### Overview
A user can see a grid of popular looks on GTIO and tab to other groups of looks

#### Mockups
9.1 Popular looks grid (three tabs):

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/9.1.Explore.Looks.Light.Rounded.3.tabs.png" width=420px/>

9.1 Popular looks grid (four tabs, scrolled left):

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/9.1.Explore.Looks.Light.Rounded.4.tabs.scrolled.left.png" width=420px/>

9.1 Popular looks grid (four tabs, scrolled right):

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/9.1.Explore.Looks.Light.Rounded.4.tabs.scrolled.right.png" width=420px/>

9.1.1 popular as feed: ([wireframe](http://invis.io/HX2PNHZC)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/9.1.Explore.Looks.Column.png" width=420px/>

#### User Flow
**entry screens:**   
any screen with uiTabBar
([view 1.8](#18-quick-add))   
([view 1.9](#18-sign-in-screen-2nd-load))    
**exit screens:**   
feed+grid: ([view 3.1](#31-outfit-post-detail-page))   
feed+grid: ([view 3.6](#36-product-post-detail-page))   
feed: ([view 3.4](#34-reviews-page))    
feed: ([view 3.5](#35-who-hearted-this))   
feed: ([view 7.7](#77-profile-page))   

#### API Usage
/Posts/Popular

#### Stories 
- A user can see a grid of popular looks on GTIO
   - Api will respond with items to populate the feed
- A user can switch to a different tab of looks
   - tab choices are driven by api response
      - similar behavior to lists in GTIOv3
- A user can switch to consume the list of popular looks in a feed view (like view 8.1) rather than a grid view
   - see (view 9.1.1)
   - see question# 3 for clarification
- A user can pull to refresh the list of looks
   - see 13.6
- A user can tap on a look in a grid and see a post detail page 
   - the destination is conditional on the type of the post (view 3.1) 

#### Design Stories
- Nav Bar Toggle
   - 'nav-toggle.png' in Feed and Grid/Active and Inactive versions
   - vertically centered within nav bar area
   - 12px from left edge of screen
- Tabs
   - leftmost tab is 'tab-left.png' in selected/unselected versions, with active and inactive
      - horizontal middle is stretchable
      - 1px nonstretchable on right
      - 3px nonstretchable on left
   - middle tab is 'tab-middle.png' in selected/unselected versions, with active and inactive
      - horizontal middle is stretchable
      - 2px nonstretchable on right and left
      - multiple instances OK
   - rightmost tab is 'tab-right.png' in selected/unselected versions, with active and inactive
      - horizontal middle is stretchable
      - 1px nonstretchable on left
      - 3px nonstretchable on right
   - positioning
      - leftmost tab is 4px away from left edge of screen (or left edge of scrollable area)
      - rightmost tab is 4px away from right edge of screen (or right edge of scrollable area)
      - -1px gaps (adjoining buttons should overlap by 1px)
         - 'selected' tab should always be placed over 'unselected' tabs
   - sizing
      - if three tabs:
         - leftmost tab should be minimum 104px wide
         - middle tab should be minimum 103px wide
         - rightmost tab should be minimum 104px wide
      - if four or more tabs:
         - each tab should be minimum 90px wide
   - labels
      - horizontally centered within tab with at least 12px left and right padding (respecting minimum widths listed above, stretching if necessary)
      - baseline of text is 5px above bottom edge of tab (not including pointer)
      - unselected: Archer Book Italic, 11pt, rgb(135,135,135)
      - selected: Archer Book Italic, 11pt, rgb(85,85,86)
      - star icon
         - 2px distance from right of accompanying label
         - bottom of asset is 4px below baseline of accompanying label
- Photo Grid
   - Images are sized to 94px wide, variable height
   - Top images are 9px from top of content area
   - Leftmost column images are 7px from left edge of screen
   - Rightmost images are 7px from right edge of screen
   - In columns, images be separated by 12px of vertical gap
   - 6px gaps between 1st and 2nd and 3rd columns
   - 'grid-thumbnail.frame.png'
      - placed under each image
      - position relative to image is offset by (-4px,-4px)
      - vertical middle is stretchable
      - 4px nonstretchable on top
      - 6px nonstretchable on bottom
   - Star Corner
      - 'star-corner-grid.png'
      - placed at top right corner of post image (should appear to curve seamlessly into photo frame)
   - Accent Line
      - place accent line behind grid in same position as appears on Feed type view
      - top should end at background asset for tabs



## 10. Shop tab


### 10.1 Shop landing page  

#### Overview
A user can see a page of shopping options on GTIO

#### Mockups
10.1 ([wireframe](http://invis.io/2R2OEKY8)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/10.1.Shop.Landing.WV.png" width=420px/>


#### User Flow
**entry screens:**   
any screen with uiTabBar
**exit screens:**   
([view 10.2](#102-shop-browse-webview-container))   
([view 10.3](#103-shop-3rd-party-webview-container))   
([view 10.4](#104-default-3rd-party-webview-container))   
([view 7.8](#78-shopping-list))   

#### API Usage
/Shop

#### Stories 
- A user can see a page of shopping options on GTIO
   - top nav bar is standard native bar
   - top right btn 'shopping list'
      - shows count of unread shopping list items
      - responds to gtio:// trigger for updating shopping list count
      - see story
   - Main content of page is webview (source is /Shop)
- A user can tap on elements on the Shopping page
   - /Shop page can have spawn 4 different types of pages:
      - Shop Browse Webview Container (view 10.2)
         - triggered by: gtio://ShopBrowseWebview/[title (urlencoded)]/[url (url encoded)]
      - Shop 3rd Party Webview Container (view 10.3)
         - triggered by: gtio://3rdPartyShopWebview/[title (urlencoded)]/[url (url encoded)]
      - Default 3rd Party Webview Container (view 10.4)
         - triggered by: gtio://3rdPartyDefaultWebview/[url (url encoded)]
      - Shop Browse Products Container (view 10.5)
         - triggered by: gtio://ShopBrowse/[title (urlencoded)]/[api path (url encoded)]
- A user can get to their shopping list page by tapping on the top right button 
   - **tap** ==> (view 7.8)


### 10.2 Shop Browse Webview Container  

#### Overview
A user can browse to a 2ndary webview page of navigation

#### Mockups
([wireframe](http://invis.io/NX2OELBZ)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/10.2.Shop.Browse.WV.png" width=420px/>

#### User Flow
**entry screens:**   
([view 10.1](#102-shop-landing-page))   
**exit screens:**   
([view 10.2](#102-shop-browse-webview-container))   
([view 10.3](#103-shop-3rd-party-webview-container))   
([view 10.4](#104-default-3rd-party-webview-container))   
([view 7.8](#78-shopping-list))   
previous screen   

#### API Usage
dynamic

#### Stories 
- A user can browse to a 2ndary webview page of navigation
   - top nav bar is custom nav bar
      - customizable title: via gtio link that spawned the container
      - shopping list btn visible
      - back btn to return to previous container
   - default uitabbar is visible
   - url of webview is customized via gtio:// link that spawned the container



### 10.3 ~Shop 3rd Party webview Container ~
 

### 10.4 Default 3rd party webview container  

#### Overview
A user can browse to a 3rd party site with a default browsing experience

#### Mockups
10.4 ([wireframe](http://invis.io/XF2OEOYU)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/10.4.Default.3rd.Party.WV.png" width=420px/>

10.4.1 actionsheet: ([wireframe](http://invis.io/F32PNLA5)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/10.4.Default.3rd.Party.WV.Actionsheet.png" width=420px/>

#### User Flow
**entry screens:**   
([view 10.1](#102-shop-landing-page))   
([view 10.2](#102-shop-browse-webview-container))   
**exit screens:**   
previous screen   

#### API Usage
None.

#### Stories 
- A user can browse to a 3rd party site with a default browsing experience  
   - default webview container
   - may contain custom assets
   - forward, back navigation
   - standard options button
      - raises actionsheet as (view 10.4.1)
   


### 10.5 Shop Browse Products  

#### Overview
A user can browse to a native list of products

#### Mockups
10.5 ([wireframe](http://invis.io/E22OEQDR)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/10.5.Shop.Browse.Products.png" width=420px/>

10.5.1 Shop Browse Products without standard cell ([wireframe](http://invis.io/GP2OEPH9))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/10.5.Shop.Browse.Products.No.Link.png" width=420px/>

#### User Flow
**entry screens:**   
([view 10.1](#102-shop-landing-page))   
([view 10.2](#102-shop-browse-webview-container))   
([view 8.1](#81-feed-view))   
**exit screens:**   
([view 10.3](#103-shop-3rd-party-webview-container))   
([view 10.4](#104-default-3rd-party-webview-container))   
([view 7.8](#78-shopping-list))   
([view 4.1](#41-product-page-view))   
previous screen   

#### API Usage
dynamic

#### Stories 
- A user can browse to a native list of products
   - top nav bar is custom nav bar
      - customizable title: via gtio link that spawned the container
      - shopping list btn visible
         - **tap** ==> (view 7.8)
      - back btn to return to previous container
   - list of products in masonry view
      - list defined by api
- A user can see a custom header on certain Browse Products pages
   - custom visual header (optional)
       - image specified by api
       - link specified by api
- A user can see a customized standard cell call to action on certain Browse Products pages
   - customizable standard cell (optional)
       - styled text
       - chevron on right
       - text set by api
       - destination set by api
- A user can select from a menu picker to sort the list
   - customizable standard picker menu
      - items defined by apis
      - selected item defined by api
      - api path for each item defined by api
      - api design will be similar to list tabs in GTIOv3





## 12. Upload

### User flow

[User Flow Diagram PDF](http://assets.gotryiton.s3.amazonaws.com/img/spec/4.0/pdf/12.Upload.FlowChart.pdf)

[Upload Transitions Diagram PDF](http://assets.gotryiton.s3.amazonaws.com/img/spec/4.0/pdf/12.Upload.Transitions.pdf)

### 12.1 Upload start  

#### Overview
A user can start an upload by opening their camera within the GTIO app.  They can use the camera to take subsequent photos for a framed upload.

#### Mockups
12.1 ([wireframe](http://invis.io/WD2OERMP))

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/12.1.0.Upload.Start.png" width=420px/>

12.1.1 Upload start (with frames) ([wireframe1](http://invis.io/HB2OESTA) [2](http://invis.io/NW2OETS6) [3](http://invis.io/WE2OEUV5))  

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/12.1.Upload.Start.Frame.Bottom.Right.png" width=420px/>

12.1.2 Upload Start in Photoshoot Mode

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/12.1.B.Upload.Start.Photoshoot.Popup.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/12.1.C.Upload.Start.Photoshoot.png" width=420px/>

12.1.3 Upload Start with Grid button

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/12.1.E.Upload.Start.with.Grid.png" width=420px/>

#### API Usage

POST /track

see documentation [Api-Track](http://gtio-dev.gotryiton.com/docs/api-track)

```json
{
   "track" : {
      "id" : "Upload start",
      "photos_in_frame" : 0,
   }
}
```


#### Stories 
- A user can start an upload by opening their camera within the GTIO app
   - After camera capture button is pressed
      - capture photo @ 640px wide
      - route to (view 12.2)
- A user can select a source to import a photo
   - tapping on photoroll button opens a custom menu with camera roll, hearted products, and popular products selections
      - after a photo is selected:
         - resize photo to 640px wide
         - route to (view 12.2)
- A user can use their camera to take subsequent photos (for framed uploads)
   - The camera has a mini-map of frame with current frame highlighted (view 12.1.1)
- A user can turn on Photoshoot Mode
   - toggling the photoshoot toggle button within the camera capture button turns on and off Photoshoot mode
      - with photoshoot mode on, shutter button changes to represent photoshoot mode (view 12.1.2)
      - the first two times a user activates photoshoot mode, an info popup should appear (view 12.1.2)
         - popup only appears max of once per session
         - popup should simultaneously fade out and animate moving upwards after 2 seconds
   - capture button routes to (view 12.5)
- A user can select a photo from their photoshoot grid (if available)
   - if a user has previously done a photoshoot, they can access the grid to choose a photo
      - grid button **tap** ==> (view 12.4)
   - the toggle state is remembered the next time this view is accessed

### Design Stories
- Bottom Bar
	- Height: 58px (with shadow) (non-shadow portion is only: 53px high)
	- Background: (12/upload.bottom.bar.bg)
	- Capture Button
		- 10px from top of bar (including bar's shadow overlay, only 6px from top if don't include bar's shadow overlay)
		- Horizontally Centered when no photoshoot reel button icon
			- Move 20px to the right when icon is present
		- Background: Stretch image (12/upload.bottom.bar.camera.button.bg.off.png)
		- Activate state: Stretch image (12/upload.bottom.bar.camera.button.bg.on.png)
		- Width: 93px (Including shadow in image)
		- Height: 45px (Including shadow in image)
		- Capture Icon: Centered, 11px from top of button (12/upload.bottom.bar.camera.button.icon.normal.png)
		- Photoshoot Icon: Centered, 10px from top of button (12/upload.bottom.bar.camera.button.icon.photoshoot.png)
	- Divider (12/upload.bottom.bar.divider.png) repeating-y
		- 1px wide
		- 53px high
	- X Button (12/upload.bottom.bar.icon.x.png)
		- 22px from top of bar (18px from top if not including bar's shadow overlay)
		- 11px left/right padding
	- Photoroll Button (12/upload.bottom.bar.icon.photoroll.png)
		- 19px from top of bar (15px from top if not including bar's shadow overlay)
		- 9px left/right padding
	- Photoshoot Reel Button (12/upload.bottom.bar.icon.photoshootreel.png)
		- 19px from top of bar (15px from top if not including bar's shadow overlay)
		- 8px left/right padding
	- Photo capture mode switch
		- Switch
			- Background: image (12/upload.bottom.bar.switch.bg.png)
			- 9px left/right padding
			- 8px from bottom
			- Width: 61px
			- Height: 17px
			- Button: image (12/upload.bottom.bar.switch.png)
				- Width: 35px
				- Height: 32px
				- Clip entire button in 61x17px area with borders that have 5px radius (rounded)
				- When switch button is on either side, move button another 2px within clipping mask to hide the shadow in the image
		- Normal Small Icon
			- 14px from top of bar (10px from top if not including bar's shadow overlay)
			- 13px from left
		- Photoshoot Small Icon
			- 14px from tp of bar (10px from top if not including bar's shadow overlay)
			- 13px from right
- Flash Icon
	- Background: image (upload.flash.off.png)
		- Active State: (upload.flash.on.png)
	- Height: 42px
	- Width: 78px
	- 6px from top
	- 5px from left
- Frame Indication Icon
	- Background images (upload.frames.indicator.photo.overlay.[location].png)
	- Height: 53px
	- Width: 56px
	- 10px from top and right
- Loader
	- Vertically and horizontally center in viewfinder
	- For background: image (upload.loader.bg.png)
	- Animating portion:
		- Center within background image
		- Image (upload.loader.inner.png)
		- Incrementally reveal/draw portion of it like clock

### 12.2 Upload confirm  

#### Overview
A user can confirm that they want to upload the photo they've taken or selected.  They can apply filters at this stage

#### Mockups
([wireframe](http://invis.io/9M2OEVED) [2](http://invis.io/2Z2OEWB8) [3](http://invis.io/QB2OEYM7) [4](http://invis.io/4F2OEZGK))  

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/12.2.3.1.Photo.Filter.png" width=420px/>

12.2.1 Upload confirm with grid button

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/12.2.3.2.Photo.Filter.Back.To.Grid.png" width=420px/>

#### API Usage
/Tracking

#### Stories 
- A user can apply a filter to a photo they have taken or selected
   - tapping on a filter icon applies that filter to the photo
   - first filter is 'no filter' option which removes any applied filter
   - remaining filters delivered in [PhotoFilters-iOS](https://github.com/twotoasters/PhotoFilters-iOS)
- A filter that a user selects should be applied quickly
   - when the user first loads this view, filter processing should begin in the background before the user taps on the filter icons
   - processing should be cancelled if a user exits this screen
- A user can select if they want to use the photo they've selected (and filtered)
   - use this photo check button **tap** ==> (view 12.3)
   - If a user arrived on this screen via the upload start screen, they can return to that screen via the x icon (seen in view 12.2)
      - 'x' button **tap** => (view 12.1)
   - If a user arrived on this screen via the Photoshoot grid, they can return to the grid via a grid icon (seen in view 12.2.1)
      - grid button **tap** => (view 12.4)
- Product Photos / different aspect ratios
   - Filter should be applied only to source image and not to any letterboxed areas that may be shown
   - Filter masks should scale along with particular size and ratio of source image

### Design Stories
- Bottom Bar
	- X Button
		- 17px padding left/right
		- 22px from top of bar (18px from top if not including bar's shadow overlay)
	- Check Button
		- 13px padding left/right
		- 22px from top of bar (18px from top if not including bar's shadow overlay)
	- Middle Text: 18px Archer Light Italic rgb(64,64,65) #404041
		- 22px from top of bar (18px from top if not including bar's shadow overlay)
- Filter Buttons
	- 69x69px including shadow
	- Filter Image: 61x61px with 5px radius (10px @2x)
	- On active state place (upload.filter.overlay.selected.png) behind filter area
	- 5px padding on left side
	- 3px padding between each filter button
	- Text is Proxima Nova Semibold 5pt rgb(255,255,255) #ffffff
      - Selected filter text is 80% opacity
      - Non-selected filter text is 60% opacity
- Background shadow
	- 101px high shadow behind filter buttons using (upload.filter.shadow.bg.png) which should stretch horizontally
- Product Photos / different aspect ratios
   - if a source photo has an aspect ratio that is shorter than that of the available content area (320 x 427), photo should be displayed so that it is screen width, while preserving original aspect ratio (letterboxing top and bottom)
   - if a source photo has an aspect ratio that is taller than that of the available content area, photo should be displayed so that it is 427px high, while preserving original aspect ratio (letterboxing left and right)
   - if a source photo doesn't fit width or height we will scale the image up to fit either height or width while perserving the original aspect ration
   - content area behind photo (visible wherever source photo is not filling screen) is rgb(100,100,100)
      - overlay edges of letterbox towards source photo with 'filter-letterbox-shadow.png' (has vertical top/bottom, horizontal left/right versions)

### 12.3 Post a look  

#### Overview
A user can add details to their post before they submit.  They can select to use frames.  They can edit photos in their frames. 

#### Mockups
([wireframe](http://invis.io/J92OF18E)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/3/12.3.Post.A.Look.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/3/12.3.Post.A.Look.Filled.Text.png" width=420px/>

12.3.1 Post a look (Description with keyboard) ([wireframe](http://invis.io/AC2OF2GX))  

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/3/12.3.Post.A.Look.Description.png" width=420px/>

12.3.2 Post a look (Photo preview with frames) ([wireframe](http://invis.io/5K2OF0W8))  

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/3/12.3.Post.A.Look.Framed.With.Photos.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/3/12.3.Post.A.Look.Framed.png" width=420px/>

12.3.3 Post a look (edit actionsheet) ([wireframe](http://invis.io/5K2OF0W8))  

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/12.3.B.Post.A.Look.Framed.Edit.Actionsheet.png" width=420px/>

#### API Usage

POST /track  

see documentation [Api-Track](http://gtio-dev.gotryiton.com/docs/api-track)


```json
{
   "track" : {
      "id" : "Post a look",
      "photos_in_frame" : 0,
   }
}
```

POST /User/Facebook-Connect

request 

```json
{
   "fb_token" : "xyz123",
}
```

response is documented in [Users API](ApiUsers.md)


POST /photo/create

documented in [Photo API](ApiPhotos.md)

request:

```json
{
   "photo" : {
      "image" : "<image data>",
      "using_filter" : "FilterName",
      "using_frame" : true
   }
}
```

response:

```json
{
  "photo": {
    "id": "E15F09D",
    "user_id": "A23CC82",
    "url": "/path/to/image.jpg",
    "width": 640,
    "height": 852
  }
}
```

#### Stories 
- A user can add details to their post before they submit.
   - description (optional)
      - page slides down and keyboard is raised (view 12.3.1)
   - tag brands
      - page slides down and keyboard is raised (view 12.3.1)
- A user can select to use frames in their upload
   - frames buttons
      - multi frame button converts to (view 12.3.2)
      - single frame button converts back to (view 12.3)
- A user can toggle facebook on or off
   - initial toggle state set by API
      - ```/config``` object will include Facebook Toggle status:  ```facebook_share_default_on```
   - if a user is not facebook connected (use attribute ```user->is_facebook_connected```)
      - **tap** ==> Facebook SSO
         - **success** ==> api request /User/Facebook-Connect
         - toggles on state
- A user can toggle voting on or off
   - initial toggle state set by API
      - ```/config``` object will include Voting Toggle status: ```voting_default_on```
- A user can cancel their post
   - cancel btn (if post button is INACTIVE)
      - **tap** ==> returns you to your previous tab in previous state
   - cancel btn (if post button is ACTIVE)
      - **tap** ==> opens dialog
         - text: "Are you sure you want to exit without posting?"
         - ok: ==> returns you to your previous tab in previous state
         - cancel: ==> closes dialog
- A user can edit the photos in their Post
   - empty frame camera buttons
      - **tap** ==> (view 12.1.1)
   - frame edit btn (camera icon in circle)
      - raises actionsheet (view 12.3.3)
         - replace photo ==> (view 12.1.1)
         - add a filter ==> (view 12.2)
         - swap with A
            - swaps current framed photo with next framed section (next over, clockwise)
         - swap with B
            - swaps current framed photo with previous framed section (previous, counter-clockwise)
- A user can edit the photo in their single image Post
   - edit button (camera icon in circle)
         - raises actionsheet (view 12.3.3)
            - replace photo ==> (view 12.1.1)
            - add a filter ==> (view 12.2)
- A user cannot post their upload if they have frames turned on but fewer than 3 photos 
   - if frames enabled and < 3 photos 
      - post button is grayed out and disabled
- A user can post their upload
   - post btn
      - if description is empty
         - show dialog
            - text: "Are you sure you want to post without a description?"
            - ok: send api request
            - cancel: select description field and route to (view 12.3.1)
      - **tap** ==> route to (view 8.4)
         - if ```photo/create``` request is finished and the app has a valid photo object with id
            - POST to ```post/create```
            - let request finish in the background
      - Tapping on the post button also saves the composite image to the user's photo roll.
- A user can move a photo within a frame
   - Each photo in frame is draggable
      - photo cannot be dragged outside of frame
   - Each photo in frame is pinchable
      - photo cannot be resized out of frame
- A user can toggle between frame mode and single photo mode
   - Use the first photo (left most frame photo) as the single photo image (and vice-versa)
   - If a user has more than one photo in frame mode
      - Use left most frame photo as single photo
      - Save existing framed photos if a user returns to frame mode
- A user can upload a photo 
   - The ```photo/create``` request should be started in the background before a user has tapped on 'post'
   - The request should get sent on a 2 second delay after the user loads view 12.3 
      - The request should not get sent if the user has an incomplete frame view
      - the timer delay should get restarted if:
         - the user moves a photo in the frame
         - the user resizes a photo in the frame
   - The request should get cancelled if it has not finished and:
      - the user moves a photo in the frame
      - the user resizes a photo in the frame
      - the user clears a photo in the frame
      - the user cancels their post
   - The photo should be a composite image of 3 photos included in the frame (if frames are used)
      - the photo uploaded should not include the white border around the framed image, but should include the white internal border
      - the photo uploaded should be 640px wide
      - the image data for the photo should be sent as ```image``` in the POST request

#### Design Stories
- Photo Frame
   - 'photo-frame.png'
   - 3px from left edge of screen, 4px from bottom edge of nav bar
   - should be overlaid by applicable photos
      - if user has single photo, vertically and horizontally centered within frame
      - if user has multiple photos
         - photo 1 is 13px from left edge of screen, 13px from bottom edge of nav bar
         - photo 2 (upper right) is 129px from left edge of screen, 13px from bottom edge of nav bar
         - photo 3 (lower right) is 129px from left edge of screen, 204px from bottom edge of nav bar
   - Resize Handle
      - 'photo-frame-handle.png' active and inactive versions
      - bottom of asset should be 10px below bottom edge of user's photo (not the frame)
      - asset should be horizontally centered within entire photo frame
- Edit Photo Controls (camera icon in circle)
   - 'edit-photo-button.png' (on and off states)
   - Control 1 (for leftmost frame or single photo)
      - 6px from left side of user photo
      - 6px from top of user photo
   - Control 2 (for upper right frame)
      - 6px from right side of top right framed photo
      - 6px from top of user photo
   - Control 3 (for lower right frame)
      - 6px from right side of bottom right framed photo
      - 6px from top of bottom right framed photo
- Edit Photo Actionsheet
   - 'swap with' shows minimap
      - 'swap-map.png' with 1,2,3 versions
         - 9px from edge of accompanying text
         - vertically centered within button
         - swap-map and text together should be horizontally centered within button 
- Empty Frame Icon
   - 'frame-camera-icon.png' with ON and OFF states
   - horizontally and vertically centered within framed image areas when no image is yet present
- Single/Framed Toggle
   - 'frames-toggle.png' (SINGLE and MULTIPLE versions)
   - no tap 'ON' state, switches between SINGLE and MULTIPLE versions after tap
   - 7px from right edge of screen
   - 12px from bottom of nav bar
- Facebook Toggle Container
   - 'toggle-fb-container.png'
      - right side of asset is 7px from right edge of screen
      - bottom of asset is 6px below bottom of post photo
   - Toggles
      - 'switch-....png' assets
      - FACEBOOK: 287px from bottom of nav bar, 17px from right edge of screen
      - Tap area is entire container, not just toggle switch
- Text Boxes
   - Description
      - 'description-box.png'
      - 330px from bottom edge of nav bar, 5px from left edge of screen
      - 'description-box-icon.png' placed in upper right corner with 8px of top and right padding
      - 'add a description' text in Archer Medium Italic, 6pt, rgb(183,183,183)
         - 11px of left padding inside box
         - 21px of top padding inside box
      - Input Area
         - When tapped or if text is left in field, 'description-box-icon' and 'add a description' text are not shown
         - 165px x 125px vertically and horizontally centered within box
         - ACTIVE (user is typing): Verlag Light, rgb(64,64,65), 7pt
         - INACTIVE (text is left in field): Verlag Light, rgb(143,143,143), 7pt
   - Brands
      - 'brands-box.png'
      - 330px from bottom edge of nav bar, 5px from left edge of screen
      - 'brands-box-icon.png' placed in upper right corner with 8px of top and right padding
      - 'tag brands' text in Archer Medium Italic, 6pt, rgb(183,183,183)
         - 11px of left padding inside box
         - 21px of top padding inside box
      - Input Area
         - When tapped or if text is left in field, 'brands-box-icon' and 'tag brands' text are not shown
         - 97px x 125px vertically and horizontally centered within box
         - ACTIVE (user is typing): Verlag Light, rgb(64,64,65), 7pt
         - INACTIVE (text is left in field): Verlag Light, rgb(143,143,143), 7pt
- 'Post a Look' CTA
   - Background
      - 'post-button-bg.png'
      - flush with bottom of screen
   - Button
      - 'post-button...png' with ON, OFF, DISABLED states
   - Overlays all other content, position is fixed
- Text Input
   - When user taps Description or Brands, all elements on page (except navigation bar and 'post a look' element) scroll up by 277px, keyboard is shown
      - If typing in Description, keyboard action button is 'Next' (gray) which brings user to input of Brands
      - If typing in Brands, keyboard action button is 'Done' (gray) which disappears keyboard and scrolls back up by 277px



### 12.4 Photoshoot grid

#### Overview
A user can select from 9 photos taken during photoshoot mode.

#### Mockups
([wireframe](http://invis.io/J92OF18E)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/12.2.2.Photoshoot.select.png" width=420px/>


#### User Flow
**entry screens:**   
([view 12.5](#125-photoshoot-mode))
**exit screens:**   
([view 12.1](#121-upload-start))   
([view 12.3](#123-post-a-look))           

#### API Usage
None.


#### Stories 
- A user can select from the 9 photos taken during photoshoot mode
   - the 9 photos are arranged in the order in which they were taken
   - check button **tap** ==> (view 12.3)
   - all 9 photos are kept in memory for potential use in frames or as replacement images
      - if a user enters photoshoot mode for a 2nd time, the 9 photos in storage are cleared
   - tapping back routes to (view 12.1)
      - on view 12.1:
         - photoshoot mode should still be turned on
         - photoshoot grid button should be active

#### Design Stories
- Thumbnails
   - With frame/shadow: 90x120px image (upload.photoreel.vertical.divider.png)
   - Photo Thumbnail: 84x112px
      - 3px from top
      - 3px from left/right
      - 5px from bottom
   - Positioning 
      - 1st row is 12px from top
      - Left-most thumbnail in each row: 11px from left
      - Middle thumbnail in each row: horizontally centered
      - Right-most thumbnail in each row: 11px from right
   - Horizontal Lines/indicators (upload.photoreel.horizontal.divider.png)
      - 59px from top
   - Vertical Lines/indicators (upload.photoreel.vertical.divider.png)  
      - 47px from left edge of bottom image
      - 38px from right of top image


### 12.5 Photoshoot Mode

#### Overview
A user can take photos in photoshoot mode (a timer + burst mode hybrid)

#### Mockups
([wireframe](http://invis.io/J92OF18E)) 

**12.5** with timer running and progress bar empty   
<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/12.5.Upload.Photoshoot.Mode.1.First-Countdown.png" width=420px/>

**12.5.1** with 2nd timer running and progress bar showing 3/9   
<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/12.5.Upload.Photoshoot.Mode.2.In.Progress.png" width=420px/>

**12.5.2** with shutter flash on 4th photo progress bar showing 4/9   
<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/2/12.5.Upload.Photoshoot.Mode.3.Photo.Taken.png" width=420px/>


#### API Usage
None.

#### User Flow
**entry screens:**   
([view 12.1](#121-upload-start))   
**exit screens:**   
([view 12.4](#124-photoshoot-grid))   


#### Stories 
- A user can take 9 photos during photoshoot mode
   - When the user is in photoshoot mode on screen 12.1 (view 12.1.x) and they tap the shutter button
      1. The initial timer starts and counts down from ```photoshoot_first_timer``` value in /Config (value is in seconds)
         - see view 12.5
      2. At the end of the first timer, 3 photos are taken in as quick succession as the device's camera can allow
         - a sound is played (sound should be of 3 consecutive shutter fires.  the default shutter sound can be used)
         - during each capture, the view shows a white transparent flash (see view 12.5.2)
         - during each capture, a button on the photoshoot progress bar is turned on (see view 12.5.2)
      3. The second timer starts and counts down from ```photoshoot_second_timer``` 
         - see view 12.5.1
      4. At the end of the 2nd timer, 3 more photos are taken in the same fashion
      5. The third timer starts and counts down from ```photoshoot_third_timer```
      6. Three more photos are taken in photoshoot mode.
   - once these steps are complete, the user is routed to (view 12.4)
   - each photo should be captured at 640px wide.
- A user can view a progress bar showing their place in the photoshoot
   - each time an image is captured, the progress bar updates with a new dot filled in

#### Design Stories
- Progress Bar
   - background (lines)
      - 'timer-progress-bg.png'
      - horizontally and vertically centered within tab bar area
   - dots
      - 'timer-progress-dot.png' with ON and OFF states
      - all dots vertically centered within tab bar area
      - positioning:
         - 1st dot is 47px from left edge of screen
         - 2nd dot is 68px from left edge of screen
         - 3rd dot is 89px from left edge of screen
         - 4th dot is 132px from left edge of screen
         - 5th dot is 153px from left edge of screen
         - 6th dot is 174px from left edge of screen
         - 7th dot is 217px from left edge of screen
         - 8th dot is 238px from left edge of screen
         - 9th dot is 259px from left edge of screen
- Timer
   - outer circle, static
      - outer diameter is 74px
      - inner diameter is 70px
      - rgb(255,255,255)
   - inner circle, fills in clockwise starting from '12 oclock' position
      - outer diameter is 66px
      - inner diameter is 54px
      - rgb(119,226,179)
- Snap Overlay
   - 'snap-overlay.png'
   - flashes as overlay onscreen when photo is taken

### 12.6 Pick A Product

#### Overview
A user can get a product photo by choosing from a grid with two tabs showing their hearted products and popular products

#### Mockups

**12.6**
<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/12.6.Pick.A.Product.png" width=420px/>

#### API Usage

#### User Flow
**entry screens:**   

#### Stories 

#### Design Stories
- Custom Tab Label
   - 'my.hearts.tab.title.png'
   - position 19px away from top of content area, horizontally centered within single tab area
- no extra shadow under navigation bar
- Tab Bar
   - All images are profile.tabbar.[position].[state].png (from assets for section 7)
   - Text: 12px Archer Book Italic 14pt rgb(85,85,85) #555556
      - baseline is 16px from top of tab asset, horizontally centered
   - Fixed position
      - content area scrolls 'under' tab graphics
- Photo Grid
   - Images are sized to 94px wide, variable height
   - Top images are 9px from top of content area
   - Leftmost column images are 7px from left edge of screen
   - Rightmost images are 7px from right edge of screen
   - In columns, images be separated by 12px of vertical gap
   - 6px gaps between 1st and 2nd and 3rd columns
   - 'grid-thumbnail.frame.png'
      - placed under each image
      - position relative to image is offset by (-4px,-4px)
      - vertical middle is stretchable
      - 4px nonstretchable on top
      - 6px nonstretchable on bottom

## 13. Universal Elements and Behavior

### 13.1 UITabBar default behavior  

#### Overview
The app has a universal UITabBar that allows the user to move from tab to tab

#### Mockups
see (view 8.1), (view 9.1), (view 12.1), (view 10.1), (view 7.1)

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/13.1.ui-tab.png" width=420px/>

#### API Usage
None.

#### Stories
- A user can switch between tabs of the app
   - 5 tabs
      - 1st tab starts on (view 8.1)
      - 2nd tab starts on (view 9.1)
      - 3rd tab starts on (view 12.1)
      - 4th tab starts on (view 10.1)
      - 5th tab starts on (view 7.1)
   - tapping on a tab brings you to the page and position in which you left that tab
   - tapping the tab a 2nd time when you are already viewing a tab routes you to the landing page of that tab (see above)
- A user who has left the app inactive for 24 hours has their tabs reset.
   - if a user returns to the app after >24 hours of inactivity
      - maintains your selected tab
      - brings you to the landing page of that tab

#### Graphical Assets / Usage
- Background
   - 'UI-Tab-BG.png'
   - Should be slightly transparent
- Icons
   - Assets use naming convention 'UI-Tab-1-OFF.png'
      - '1' is the tab number
      - 'OFF' or 'ON' indicates if user is seeing ON or OFF state
   - Assets are 128px wide (@2x), should be placed edge to edge horizontally and flush with bottom edge of screen.


### 13.2 UITabbar Shopping list animation  

#### Overview
The app has a universal UITabBar that allows the user to move from tab to tab

#### Mockups
([wireframe](http://invis.io/X92POXGZ)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/13.2.Feed.Scrolled.Further.Hearted.png" width=420px/>

#### API Usage
None.

#### Stories
- When a user is not on the 4th tab and they trigger an action to increment the Shopping list count, they should see an animation
   - when shopping list count is incremented
   - display animation over 4th tab (view 13.1)



### 13.3 Error messages  

#### Overview
The app should display a custom dialog if the API responds with an error

#### Mockups
None.

#### API Usage
An error response from the gtio api will include an error object.  The error object will always include a 'status' attribute which will be a meaningful error message for a developer.  The error object will optionally include an alert object whcih should trigger a dialog message.

```json
{
   "error" : {

      "status" : "meaningful error message for a developer",

      "alert" : { 

         "text" : "user-facing message about the error",

         "title" : "Optional title to the dialog",

         "buttons" : [
            {
               "text" : "ok",
               
               "action" : null
            },
         ]
   
      }
      
   }
} 
```

#### Stories
- When a user encounters an error that includes an alert object, they should see a standard error response
   - error messages should appear as custom dialog windows
   - if alert object is defined in the api response, display it
      - if a title is defined in the error reponse use it
         - otherwise use 'error'



### 13.4 Follow buttons  

#### Overview
In many places where there is a user's name, there is a follow button.  This button can have many states

#### Mockups

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/13.4.following-buttons.png" width=420px/>

#### API Usage
```/User```  each user may contain a following_button object

```json
"user" : {
   
   "follow_button" : {
      "text" : "follow",

      "action" : "/user/:id/follow",

      "state" : 1,

   }
   
} 
```

```/User/Follow``` Each request to the follow api responds with another ```user->following_button``` object


#### Stories
- When a user sees another user they can follow, they can take action via a standard button
   - default case:
      - button text: follow
      - action: defined by api
   - the button may have no action associated 
      - follow button shows 'requested' if the request to follow is pending
   - the button's color/state will be defined by the api ```state``` attribute
      - 0: off (file: follow-OFF.png, button color: peach)
      - 1: on (file: following-OFF.png, button color: green)
      - 2: requested (file: requested-OFF.png, button color: gray)
   - after a button is tapped, the button is replaced with a standard spinner @24px high in light gray, centered where the butotn used to be.
      - when the api request has completed, the spinner is replaced with the new follow_button returned by the api response
- When a user sees their own name, the follow button will not be visible
   - User objects do not contain follow_button of the user who made the request
- When a user taps on the button and it takes an action, the button updates
   - upon **successful** api response, update the button

#### Graphical Assets / Usage
- Button placement
   - TBD pending completion of list designs
- Buttons
   - Assets use naming convention 'following-OFF.png'
      - states indicated in file name are 'follow' (medium green), 'following' (light green), 'requested' (white)
      - 'OFF' or 'ON' indicates if user is seeing ON or OFF state
- Text
   - 11pt (@2x)
   - Proxima Nova (Regular weight)
   - #555556
   - Centered within button width (140px @2x)
   - Baseline of text should be 10px higher than bottom edge of button


### 13.5 Authentication  

#### Overview
When a user logs into the GTIO app, they should remain logged in

#### API Usage
When the GTIO api responds with an gtioToken, this token should be saved (overwrite existing tokens) and passed with all subsequent requests to the api.

More api details to come.

#### Stories
- When a user logs into the GTIO app, they should remain logged in


### 13.6 Pull to refresh behavior  

#### Overview
A user can refresh a feed

#### Mockups

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/13.6.Pull.To.Refresh.1.Pull.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/13.6.Pull.To.Refresh.2.Release.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/13.6.Pull.To.Refresh.3.Update.png" width=420px/>



#### API Usage
Don't pass an e-tag cache ```If-None-Match``` id and send the same request.

#### Stories
- A user can refresh a feed
   - pull to refresh is active on the feed in (view 8.1) and the popular lists in (view 9.1) only

#### Design Stories
- Background area
   - 'ptr-bg.png'
      - pulling down 55px of this is sufficient to activate (before release), but user can pull a bit further
- Arrow
   - 'arrow.png', placed 13px above bottom of background area and vertically centered around 'accent line' on background
   - points down on 'PULL' instruction, spins, points up on RELEASE instruction
- Text
   - right aligned, right edge of this text is 51px away from right edge of screen
      - right edge should appear to line up with right edge of user info box and photo frame on feed
   - baseline is 14px up from bottom of background area
   - PULL/RELEASE states: Archer Medium Italic 10pt, rgb(143,143,143)
   - UPDATING state: Archer Medium Italic 10pt, rgb(88,88,88)
- Spinner (UPDATING state only)
   - 15px x 15px
   - rgb(154,154,153)
   - top of spinner is 27px away from bottom of background area
   - right of spinner is 6px away from left edge of text


### 13.7 User badges

#### Overview
In many places where there is a user's name, there may be a badge icon next to a users name.  This icon will be specified by the api, but may use a different url depending on the screen.  Previously the GTIOv3 app supported multiple icons.  4.0 will only support 1.

#### Mockups

#### API Usage
```/User```  each user may contain a badges array

```json
"user" : {
   
   "badge" : {
      'page_type_1' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
      'page_type_2' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
      'page_type_3' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
   }
   
} 
```


#### Stories
- When a user's name appears in the app and they have a badge, the appropriate badge icon should appear next to their name


### 13.8 Custom UIActionSheet

#### Mockups
<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/13.8.actionsheet.png" width=420px/>

#### Design Stories
- Buttons (use general/large.button.[color].[state].png)
	- 14px padding left/right & top/bottom
	- Between action cells (buttons that are not cancel buttons) the vertical padding is 8px
	- Height: 42px
	- Width: 292px
	- Text
		- Proxima Nova Bold/Regular rgb(85,85,86) #555556
		- Cancel button: rgb(143,143,143) #8f8f8f
		- Vertically/horizontally centered in button
- Background (general/actonsheet.bg)
	- Top/Bottom anchors: 18px
	- Stretch middle area

### 13.9 Custom UIAlertView

#### Mockups
<img src="https://github.com/twotoasters/GTIO-iOS/raw/master/GTIO/Application/Resources/Mockups/13.9.custom.dialog.png" width=420px/>

#### Design Stories
- Background Stretchable Image (general/alert.bg.png)
	- Top Anchor: 11px
	- Bottom Anchor: 14px
	- Left/Right Anchor: 13px
- Width (with shadow) 284px
- Width of center white area: 278px
- Heading Text
	- 22pt Archer Light Italic rgb(0,0,0) #000000
	- 21px padding from top including shadow in height (without shadow: 18px)
	- Horizontally centered
- Secondary Text
	- 16pt Verlag Light rgb(143,143,143) #8f8f8f
	- 23px padding/left right including shadow (without shadow: 19px)
- Buttons (use general/large.button.[color].[state].png)
	- 15px from bottom (9px without shadow)
	- 16px from left/right (12px without shadow)
	- 10px padding between buttons horizontally
	- Height: 42px
	- Width: 125px
	- Text
		- Proxima Nova Bold/Regular rgb(85,85,86) #555556
		- Cancel button: rgb(143,143,143) #8f8f8f
		- Vertically/horizontally centered in button

### 13.10 Unified Autocomplete

#### Mockups

Control hidden/lowered
<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/3.4.Reviews.1.Input.png" width=420px/>

Control raised, populating brands
<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/3.4.Reviews.2.Input.Brands.png" width=420px/>

Control raised, populating users
<img src="http://assets.gotryiton.com/img/spec/4.0/mockups/1/3.4.Reviews.3.Input.People.png" width=420px/>

#### Design Stories
- Background Area
   - 'keyboard-top-control-bg.png'
   - when 'expanded', is placed directly above keyboard
   - 'collapsed' state should show 6px of top of asset above keyboard
   - should animate in and out from underneath the keyboard when needed/not needed
- Buttons
   - 'keyboard-top-control-button.png' with active and inactive states
   - horizontal middle is stretchable
      - 3px nonstretchable on left
      - 3px nonstretchable on right
   - 5px of padding on top, bottom, left, right (5px gaps between buttons)
   - text is Proxima Nova Regular, 14pt, rgb(64,64,64)
   - Brands
      - allow 12px of padding on left and right of text inside button
   - Users
      - user icon is displayed at 26px x 26px with 'user-icon-overlay-52.png' placed directly over (masks edges and overlays a shadow)
         - 4px of padding from top, bottom and left edges of button
      - user name
         - allow 6px of padding from right edge of user icon and right edge of button
