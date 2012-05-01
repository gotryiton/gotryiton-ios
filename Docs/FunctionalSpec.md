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
   3.1 [Outfit Post Detail Page](#31-outfit-post-detail-page)   
   3.2 [Post detail with verdict](#32-post-detail-with-verdict)   
   3.3 [Post detail full screen](#33-post-detail-full-screen)   
   3.4 [Reviews page](#34-reviews-page)   
   3.5 [Who hearted this](#35-who-hearted-this)   
   3.6 [Product post detail page](#36-product-post-detail-page)   
4. [Product pages](#4-product-pages)   
   4.1 [Product page view](#41-product-page-view)   
   4.2 [Suggest a product](#42-suggest-a-product)   
   4.3 [Phone Contact List](#43-phone-contact-list)   
   4.4 [Email Compose](#44-email-compose)   
   4.5 [Facebook Contacts](#45-facebook-contacts)   
   4.6 [Gotryiton Contacts](#46-gotryiton-contacts)   
   4.7 [Post a product](#47-post-a-product)   
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
8. [The Feed](#8-the-feed)   
   8.1 [Feed view](#81-feed-view)   
   8.3 [Feed verdict view](#83-feed-verdict-view)   
   8.4 [Upload in progress view](#84-upload-in-progress-view)   
   8.5 [Feed after completed upload](#85-feed-after-completed-upload)   
9. [Explore Looks](#9-explore-looks)   
   9.1 [Popular Looks Grid](#91-popular-looks-grid)   
10. [Shop Tab](#10-shop-tab)   
   10.1 [Shop landing page](#101-shop-landing-page)   
   10.2 [Shop Browse Webview Container](#102-shop-browse-webview-container)   
   10.3 [Shop 3rd Party Webview Container](#103-shop-3rd-party-webview-container)   
   10.4 [Default 3rd Party Webview Container](#104-default-3rd-party-webview-container)   
   10.5 [Shop Browse Products](#105-shop-browse-products)   
11. [Logged out views](#11-logged-out-views)   
   11.1 [Logged out view inactive tabs](#111-logged-out-view-inactive-tabs)   
   11.2 [Logged out default tab](#112-logged-out-default-tab)   
   11.3 [Logged out post detail page](#113-logged-out-post-detail-page)   
   11.4 [Logged out reviews page](#114-logged-out-reviews-page)   
12. [Upload](#12-upload)   
   12.1 [Upload Start](#121-upload-start)   
   12.2 [Upload Confirm](#122-upload-confirm)   
   12.3 [Post a look](#123-post-a-look)   
13. [Universal Elements and Behavior](#123-post-a-look)   
   13.1 [UITabBar default behavior](#131-uitabbar-default-behavior)   
   13.2 [UITabBar shopping list animation](#132-uitabbar-shopping-list-animation)   
   13.3 [Error messages](#133-error-messages)   
   13.4 [Follow buttons](#134-follow-buttons)   
   13.5 [Authentication](#135-authentication)   
   13.6 [Pull to refresh behavior](#136-pull-to-refresh-behavior)   


---

### General Questions

1. ~~**progress bars**: Will we be able to show a progress bar during the upload process?  Relatedly, will we be able to show a progress bar during the image download process (after a user's feed API call has returned, but before the user has loaded images from that API response).~~ easy

2.  ~~**retry requests**: Similar to Question 1, We've noticed that Instagram employs a 'retry' button for both uploads and image downloads.  This seems to be so that they can force a strict timeout length on their uploads and downloads and maintain an overal appearance of speed throughout the app.  We'd like to investigate the difficulty of something similar.  (to experience it in instagram, switch to edge and load a feed-- most images will give a 'couldnt load image. tap to retry' message).~~ easy.

3.  ~~On the Popular Looks Grid (view 9.1), We're showing a grid view of a feed of posts.  On the Feed view (view 8.1) we're showing the same data in a feed view.  We'd like for a button on the Popular looks grid (9.1) to allow a user to switch between the feed view and grid view consumption of the list.  (this feature will only be available for view 9.1, view 8.1 will always be consumed in a feed view).  Is this simple to implement or does it add complexity?~~  simple.

4.  ~~In spec'ing out the Share Settings screen (view 7.2), we determined that maintaining flexibility about the fields in the list means that it would be easier to implement as a webview (similar to the FourSquare app).  Since this view will need to make api calls that have a device token (in order to enable and disable push alerts), will there be any issues with Apple approval if that device token is passed in the clear to a webview?  (we're already passing it in the clear to an api in our current app, but wanted to confirm you guys dont see any issues before we revise the design).~~ shouldnt be an issue

5. ~~We're interested in customizing the standard iOS dialog message view throughout the app.  What is the scale of complexity to acheive this.  We'd use this dialog for all places in this spec that reference a dialog message.~~ doable.



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

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.1.Splash.png" width=420px>

#### User flow
**entry screens:**    
user starts app    
**exit screens:**    
([view 1.2](#12-intro-screens))   
([view 1.9](#19-sign-in-screen-2nd-load))   
([view 8.1](#81-feed-view))    


#### API Usage
/Config  
/User/Auth  

request params: None

reponse:

```json
{
   "config" : {
      "intro_screens" : [
         { 
            "image_url" : "http://path/to/cdn/image",
            "id" : "id_of_screen"
         }
      ]
   }
}
```

**notes:**

```intro_screens``` will be an array of no more than 5 items



#### Stories
- the app should know if this is a user's first time here
   - if user is brand new to the app ==> (view 1.2)
   - if user is a returning user to the app (and not logged in) ==> (view 1.9)
   - if user is a returning user to the app (and logged in) ==> (view 8.1)
   - if a user is upgrading from 3.0 they should be treated as a brand new logged out user
   - if a user is upgrading from 4.0 to 4.x they should be treated as an existing user and logged in (skip intro screens)


### 1.2 Intro screens 

#### Overview
A uiPageControl should be used to introduce new users to screens of the app

#### Mockups
1.2 Intros ([wireframe](http://invis.io/QS2OBFDF)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.2.Intro.1.png" width=420px>

1.2.1 Intro screen 2 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.2.Intro.2.png" width=420px>

#### User flow
**entry screens:**   
([view 1.1](#11-splash-screen))   
**exit screens:**   
([view 1.2.1](#12-intro-screens))   
([view 1.3](#13-sign-in-screen-first-use))  

#### API Usage

```intro_screens``` will be part of the response in (view 1.1)

/Tracking (usage TBD)

#### Stories
- on the user's first load of the app, they should be able to swipe through intro screens
  - maximum of 5 screens (not including final login screen)
  - swipe moves to next image in arrray
  - next button in bottom right **taps** ==> next image in array
  - sign in btn **taps** ==> (view 1.3)
  - uiPageControl dots represent flow through intro screens 
  - last **swipe** OR last next **tap** ==> sign in screen (view 1.3)
      - last dot in uiPageControl represents sign in screen (view 1.3)



### 1.3 Sign in screen (first use) 

#### Overview	
First time users of the app see a screen where they can sign up

#### Mockups
1.3 Sign in ([wireframe](http://invis.io/TW2OBGAK))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.3.Sign.In.First.Use.png" width=420px>

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
Tracking (details coming)

User/Auth/Facebook (details coming)

#### Stories
  - A new user is presented with a sign in screen and can sign up
	  -sign up with facebook btn
	    - **tap** ==> Facebook app for SSO (view 1.10)
	    - return makes call to sign up api
	  - im a returning user **tap** ==> (view 1.4)
	  - sign up with another provider btn **tap** ==> (view 1.5)
	  - skip btn **tap** ==> (view 11.2)
	  - uiPageControl represent flow through intro screens and sign in screen
	      - swiping backwards brings user to the previous intro screen


### 1.4 Returning users 

#### Overview	
Returning users can sign in with Facebook or Janrain

#### Mockups
1.4 Returning users ([wireframe](http://invis.io/5W2OBHJ7))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.4.Returning.Users.png" width=420px>

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
Tracking (details coming)

User/Auth/Facebook (details coming)

User/Auth/Janrain (details coming)

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


### 1.5 Janrain Sign up 

#### Overview  
New users can sign up with Facebook or Janrain

#### Mockups

1.5 Janrain Sign up ([wireframe](http://invis.io/EQ2OBJ6W))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.5.Janrain.Sign.Up.png" width=420px>

#### User flow
**entry screens:**   
([view 1.4](#14-returning-users))   

**exit screens:**  
([view 8.1](#81-feed-view)) via ([view 1.11](#111-janrain-sdk))     
([view 1.7](#17-almost-done)) via ([view 1.11](#111-janrain-sdk))   
previous screen   

#### API Usage
Tracking (details coming)

User/Auth/Janrain (details coming)

#### Stories
- new users can sign up with janrain sdk (aol/google/twitter/yahoo options)
   - **tap** ==> to janrain SDK for each
      - **successful janrain auth** ==> /User/Auth/Janrain request
            - **successful new user response** ==> (view 1.7)
            - **error** ==> dialog, (view 1.5)
            - **successful existing user** ==> (view 8.1)

### 1.6 Failed sign in  

#### Overview  
When a user fails to sign in, they're presented with an error screen allowing them to try again

#### Mockups

1.6 Failed sign in ([wireframe](http://invis.io/CR2OBKVK))  

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.6.Failed.Sign.In.png" width=420px>


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


### 1.7 Almost done 

#### Overview  
When a new user signs up, the app confirms they have a complete GTIO profile

#### Mockups

1.7 Almost done ([wireframe](http://invis.io/XB2OBL7A)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.7.Almost.Done.png" width=420px>

1.7 Scrolled

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.7.Almost.Done.Scrolled.png" width=420px>

#### User flow
**entry screens:**   
([view 1.9](#19-sign-in-screen-2nd-load))   
([view 1.5](#15-janrain-sign-up))   

**exit screens:**  
([view 7.3](#73-edit-profile-pic))   
([view 1.8](#18-quick-add))   


#### API Usage
/User/Auth (api details coming soon)
/User

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



### 1.8 Quick add  

#### Overview  
When a new user signs up, they can quickly add people to follow

#### Mockups
[wireframe1](http://invis.io/9P2OBMUR)  

1.8

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.8.Quick.Add.png" width=420px>


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
/User 

/User/Quick-Add

/Follow

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
1.9 ([wireframe](http://invis.io/SC2OBNJM))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/1.9.Sign.In.2nd.Load.png" width=420px/>

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
Tracking (details coming)

User/Auth/Facebook (details coming)

#### Stories

- When a returning (non-logged in) user starts the app, they see a screen asking them to login (and skip the intro screens)
   - sign in with facebook btn **tap** ==> Facebook SSO
      - **successful SSO** ==> /User/Auth/Facebook (with SSO token)
         - **successful existing user response** ==> (view 8.1)
         - **successful new user response** ==> (view 1.7)
   - im a returning user btn **tap** ==> (view 1.4)
   - sign up with another provider btn **tap** ==> (view 1.5)
   - skip directs **tap** ==> (view 9.1)
   - ? btn **tap** ==> (view 1.2)


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
Tracking (details coming)

User/Auth/Facebook (details coming)

#### Stories

- A user can log in with facebook using facebook SSO
   - permissions requested should come from /Config api call in (view 1.1)
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

<img src="http://assets.gotryiton.com/img/spec/4.0/1/2.1.Navbar.Notifications.New.png" width=420px/>

2.1.2 No New notifications  

<img src="http://assets.gotryiton.com/img/spec/4.0/1/2.2.Navbar.Notifications.No.New.png" width=420px/>

2.1.3 Logged out notifications

<img src="http://assets.gotryiton.com/img/spec/4.0/1/2.3.Navbar.Notifications.Logged.Out.png" width=420px/>

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

### 2.2 Notifications view 

#### Overview  
When a user is on one of the top level tabs, they see a navigation bar with notifications 

#### Mockups
2.2 Notifications ([wireframe](http://invis.io/QR2OBP8N))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/2.4.Notifications.png" width=420px/>

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




## 3. Product and Outfit Post Detail pages

### 3.1 Outfit Post Detail Page  

#### Overview 
A user can see a detailed view of a single outfit post

#### Mockups
3.1 Outfit Post Detail Page [wireframe](http://invis.io/SX2OBQUG) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.1.Outfit.Detail.png" width=420px/>

3.1.1 Outfit Detail No Voting ([wireframe](http://invis.io/W22OBRHF) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.1.Outfit.Detail.No.Voting.png" width=420px/>


#### User Flow

**entry screens:**   
([view 8.1](#81-feed-view))   
([view 8.4](#84-upload-in-progress-view))   
([view 8.5](#85-feed-after-completed-upload))   
([view 9.1](#91-popular-looks-grid))   
([view 3.3](#33-post-detail-full-screen))     
([view 2.2](#22-notifications-view))    


**exit screens:**   
([view 7.7](#77-profile-page))   
([view 3.4](#34-reviews-page))   
([view 3.5](#35-who-hearted-this))   
([view 3.2](#32-post-detail-with-verdict))   
([view 4.2](#42-suggest-a-product))   
([view 1.10](#110-facebook-sso))   
([view 3.3](#33-post-detail-full-screen))     
previous screen


#### API Usage
/Outfit

#### Stories
- When a user views an outfit post detail page, they should see details about the outfit post
   - Name and location in navbar
   - profile button in top right in navbar
      - image in button should be user->profileIcon
      - **tap** ==> (view 7.7)
   - full description
   - full brands
   - reviews button with reviews count
      - **tap** ==> (view 3.4)
- A user can heart the outfit from an outfit page
   - heart action button in top left of image
      - **tap** ==> api request
   - heart count + heart icons
      - **tap** ==> (view 3.5)
- A user can vote on the outfit from an outfit page (that has voting enabled)
   - wear it button & change it buttons at bottom of page
      - conditionally included
         - reference api ??
         - if not included see (view 3.1.1)
      - **tap** ==> api request
         - upon tap, buttons are not tappable anymore
         - verdict info (from api response) is displayed (see view 3.2)
- A user can take additional actions on an outfit
   - ... btn 
      - raises custom actionsheet menu
         - outfit post owner: tweet, facebook, delete
         - outfit post viewer: tweet, suggest, flag
- A user can tweet the outfit post from an outfit post page
   - makes api call for tweet text
   - conditionally visible based on if twitter is activated
   - raises twitter compose window
      - twitter text is given in response from api
- A user can flag an outfit from an outfit post page
   - pop up dialog asking to confirm
      - confirm: sends api request 
      - cancel: clears dialog
- An outfit post owner can facebook share the outfit from the outfit post page
   - if user is not facebook authenticated
      - kick out to facebook app SSO
   - dialog asking if they're sure
      - ok: sends api request
      - cancel: closes dialog
- An outfit post owner can delete the outfit from the outfit post page
   - dialog asking if they're sure
      - ok: sends api request
         - kicks user back from outfit post page and reloads list 
      - cancel: closes dialog


### 

### 3.2 Post Detail With Verdict

#### Overview 
A user can vote on an outfit from the outfit detail page and see voting results

#### Mockups
3.2 Verdict displayed ([wireframe](http://invis.io/HS2PNQD6)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.1.Outfit.Detail.Mine.Verdict.png" width=420px/>

3.2.1 Verdict displayed on Product Page ([wireframe](http://invis.io/842PNRNU)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.6.Product.Post.Detail.Verdict.png" width=420px/>


#### User Flow

**entry screens:**   
([view 8.1](#81-feed-view))   
([view 8.4](#84-upload-in-progress-view))   
([view 8.5](#85-feed-after-completed-upload))   
([view 9.1](#91-popular-looks-grid))   
([view 3.3](#33-post-detail-full-screen))     

**exit screens:**   
([view 7.7](#77-profile-page))   
([view 3.4](#34-reviews-page))   
([view 3.5](#35-who-hearted-this))      
([view 3.3](#33-post-detail-full-screen))      
([view 4.2](#42-suggest-a-product))   
([view 1.10](#110-facebook-sso))   
previous screen


#### API Usage
/Outfit/Vote

#### Stories
- A user can see voting results after they vote


### 3.3 Post Detail Full screen

#### Overview 
A user can see a full screen detail of an outfit

#### Mockups
3.3 Outfit Full Screen ([wireframe](http://invis.io/F72PNPKB))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.1.Outfit.Detail.No.Voting.Fullscreen.png" width=420px/>

3.3.1 Product Post Full Screen ([wireframe](http://invis.io/XB2PNTT9))   

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.6.Product.Post.Detail.Fullscreen.png" width=420px/>

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


### 3.4 Reviews page  

#### Overview 
A user can read reviews from an outfit post or a product post page

#### Mockups
3.4 Reviews Page ([wireframe](http://invis.io/NE2OBV7J))

<img src="http://assets.gotryiton.com/img/spec/4.0/2/3.4.Reviews.png" width=420px/>

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
/Post/Reviews

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


### 3.5 Who hearted this 

#### Overview 

A User can see other users who have hearted an outfit or product post

#### Mockups

3.5 Who Hearted this ([wireframe](http://invis.io/N22OBX9Q)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.5.Who.Hearted.This.png" width=420px/>

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


### 3.6 Product Post Detail Page

#### Overview 
A user can see a detailed view of a Product Post

#### Mockups
3.6 Product Post Detail ([wireframe](http://invis.io/UA2OBZHJ))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.6.Product.Post.Detail.Mine.png" width=420px/>

#### User Flow

**entry screens:**   
([view 8.1](#81-feed-view))   
([view 8.4](#84-upload-in-progress-view))   
([view 8.5](#85-feed-after-completed-upload))   
([view 9.1](#91-popular-looks-grid))   
([view 3.3](#33-post-detail-full-screen))     
([view 2.2](#22-notifications-view))    


**exit screens:**   
([view 7.7](#77-profile-page))   
([view 3.4](#34-reviews-page))   
([view 3.5](#35-who-hearted-this))   
([view 3.2](#32-post-detail-with-verdict))   
([view 1.10](#110-facebook-sso))   
([view 3.3](#33-post-detail-full-screen))     
([view 7.8](#78-shopping-list))     
previous screen


#### API Usage

#### Stories
- When a user views a product post detail page, they should see details about the product post
   - Name and location in navbar
      - NOTE: nav bar for product posts is transparent 
   - profile button in top right in navbar
      - image in button should be user->profileIcon
      - **tap** ==> (view 7.7)
   - full user-generated description text
      - similar to an outfit description on an outfit page
   - reviews button with reviews count
      - **tap** ==> view 3.4 
   - product name with brand and price
      - this will be part of the product object in the api
   - photo aligned to top 
      - TBD: matt to provide specs
   - wear it button & change it button 
      - conditionally included
         - reference api ??
         - if not included see (view 3.1.1)
      - **tap** ==> api request
         - upon tap, buttons are not tappable anymore
         - verdict info (from api response) is displayed (see view 3.2)

- A user can take additional actions on an Product Post
   - ... btn 
      - raises custom actionsheet menu
         - post owner: tweet, facebook, delete
         - post viewer: tweet, suggest, flag
- A user can tweet the post from an post page
   - makes api call for tweet text
   - conditionally visible based on if twitter is activated
   - raises twitter compose window
      - twitter text is given in response from api
- A user can suggest a product from an post page
   - only available for post viewers
   - **tap** ==> view 4.2
- A user can flag a post from an post page
   - pop up dialog asking to confirm
      - confirm: sends api request 
      - cancel: clears dialog
- An post owner can facebook share the post from the post page
   - if user is not facebook authenticated
      - kick out to facebook app SSO
   - dialog asking if they're sure
      - ok: sends api request
      - cancel: closes dialog
- An post owner can delete the post from the post page
   - dialog asking if they're sure
      - ok: sends api request
         - kicks user back from post page and reloads list 
      - cancel: closes dialog
- A user can tap to buy a prodcut in a product post
  - **tap** raises actionsheet with options:
     - email to me
        - dialog confirming
           - ok: sends api request
           - cancel closes dialog
     - go to store site
        - opens buy url in safari 
     - view in my shopping list
        - sends api request
        - **tap** ==> view 7.8

## 4. Product Pages

### 4.1 Product page view  

#### Overview 
A user can view a detailed page about a single product

#### Mockups
4.1 Product Page View ([wireframe](http://invis.io/8Y2OC5N7))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.1.Product.Detail.png" width=420px/>

#### User Flow

**entry screens:**   
([view 10.3](#103-shop-3rd-party-webview-container))   
([view 10.5](#105-shop-browse-products))   

**exit screens:**   
  
([view 4.7](#47-post-a-product))   
([view 3.5](#35-who-hearted-this))   
([view 4.2](#42-suggest-a-product))   
([view 10.4](#104-default-3rd-party-webview-container)) via ([view 4.1.1](#411-product-buy-actionsheet))   
([view 7.8](#78-shopping-list)) via ([view 4.1.1](#411-product-buy-actionsheet))   
([view 4.1.2](#412-product-full-screen))   

previous screen


#### API Usage
/Product

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
   - Post btn **tap** ==> (view 4.7)
- A user can suggest a product from a product page
   - suggest btn **tap** ==> (view 4.2)
- A user can buy a product from a product page
   - buy btn **tap** ==> raises actionsheet (see view 4.1.1)

### 4.1.1 Product Buy Actionsheet  

#### Overview 
A user can see options of how to buy the product

#### Mockups
4.1.1 Product Buy Actionsheet ([wireframe](http://invis.io/PS2QI79V))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.1.Product.Detail.Actionsheet.png" width=420px/>

#### User Flow
**entry screens:**   
([view 4.1](#41-product-page-view))   
**exit screens:**   
([view 10.4](#104-default-3rd-party-webview-container))    
([view 7.8](#78-shopping-list))   
([view 4.1](#41-product-page-view))   



#### API Usage
TBD

#### Stories
- A user can email the product to themselves
   - email btn **tap** raises dialog confirm
         - ok **tap** ==> api request
         - cancel: closes dialog
- A user can go to store mobile site to view the product
   - 'go to store site' btn **tap** ==> opens buy url in default safari view (view 10.5)
- A user can view the item in their shopping list
   - 'view in shopping list' btn **tap** ==> makes api request
      - upon successful api response: ==> (view 7.8)


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


### 4.2 Suggest a product  

#### Overview 
A user can suggest a product to another user

#### Mockups
4.2 Suggest a product ([wireframe](http://invis.io/NT2OC8QM))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.2.Suggest.A.Product.png" width=420px/>

#### User Flow
**entry screens:**   
([view 4.1](#41-product-page-view))   
**exit screens:**   
([view 4.6](#46-gotryiton-contacts))    
([view 4.3](#43-phone-contact-list))   
([view 4.4](#44-email-compose))   
([view 4.5](#45-facebook-contacts))   
([view 4.1.2](#412-product-full-screen))   

#### API Usage
/Product/Suggest

/Product/Suggest/Email

#### Stories
- A user can see details about a product before suggesting it 
   - product detail area includes:
      - product name
      - brand
      - price
      - square thumbnail
         - thumbnail **tap** ==> full screen image (view 4.1.1)
         - heart toggle in top left
- A user can select from their GTIO contacts to suggest from the Suggest a Product Page
   - gotryiton contacts btn **tap** ==> (view 4.6)
- A user can select from their Phone contacts to SMS a suggestion from the Suggest a Product Page
   - sms contacts btn **tap** ==> (view 4.3)
- A user can Email a suggestion from the Suggest a Product Page
   - email contacts btn **tap** ==> api request
      - successful api response ==> (view 4.4)
- A user can select from their Facebook contacts to suggest from the Suggest a Product Page\
   - facebook btn 
      - if user is not facebook authenticated
         - **tap** ==> facebook SSO
            - success: request authentication api 
      - else:
         - **tap** ==> api request
            - successful response  ==> (view 4.5)
   
### 4.3 Phone contact list  

#### Overview 
A user can select from their phone contacts to SMS a suggestion

#### Mockups
4.3 ([wireframe](http://invis.io/DW2OC9PN))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.3.Suggest.Phone.Contact.List.png" width=420px/>

4.3.1 ([wireframe](http://invis.io/MR2OCAUP))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.3.1.Suggest.SMS.Compose.png" width=420px/>

#### User Flow
**entry screens:**   
([view 4.2](#42-suggest-a-product-post-detail-page))    
**exit screens:**   
previous screen
([view 4.2](#42-suggest-a-product-post-detail-page)) via SMS Compose (view 4.3.1)   


#### API Usage
/Product/Suggest/SMS

/Tracking?

#### Stories
- A user can select from their phone's contacts to suggest a product
   - List should only include contacts that have phone numbers
   - List is Alpha sorted and has Alpha shortcuts
   - list item **tap** => api request
      - successful response ==> (view 4.3.1)
- A user can send an SMS from a native SMS compose window to suggest a product
   - to: filled with users name from (view 4.3)
   - body: from api call
   - tracking on send??
   - after successful send ==> (view 4.2)


### 4.4 Email compose  

#### Overview 
A user can email a product suggestion from a native compose window

#### Mockups
4.4 ([wireframe](http://invis.io/4R2OCBCW))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.4.Suggest.Email.Compose.png" width=420px/>

#### User Flow
**entry screens:**   
([view 4.2](#42-suggest-a-product-post-detail-page))    
**exit screens:**   
previous screen

#### API Usage
/Tracking?

#### Stories
A user can email a product suggestion from a native compose window
  - to: empty
   - body: from api response in (view 4.1)
   - tracking on send???
   - after successful send ==> (view 4.2)



### 4.5 Facebook contacts  

#### Overview 
A user can choose from their facebook contacts and post on their wall to suggest a product

#### Mockups
4.5 ([wireframe](http://invis.io/AG2OCC3Z))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.5.Suggest.Facebook.Contacts.png" width=420px/>

4.5.1 Facebook post confirm

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.5.Suggest.Facebook.Contacts.Compose.png" width=420px/>

#### User Flow
**entry screens:**   
([view 4.2](#42-suggest-a-product-post-detail-page))    
**exit screens:**   
previous screen


#### API Usage
/Product/Suggest/Facebook

#### Stories
- A user can see a list of their facebook contacts
   - alpha sorted with alpha shortcut
- A user can select a facebook contact and post on their wall
   - list item **tap** ==> makes api request
      - On successful response ==> raises facebook post ui using Facbook SDK (view 4.5.1)
            - post url is populated by api response


### 4.6 Gotryiton contacts  

#### Overview 
A user can select from the users they are following to suggest a product

#### Mockups
4.6 ([wireframe](http://invis.io/QB2OCDVE))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.6.Suggest.GTIO.Contacts.png" width=420px/>

#### User Flow
**entry screens:**   
([view 4.2](#42-suggest-a-product-post-detail-page))    
([view 4.6.1](#461-gotryiton-contacts-sent-overlay))    
**exit screens:**   
([view 4.6.2](#426-suggestion-compose))    
previous screen


#### API Usage
/Product/Suggest/Following

#### Stories
- A user can see a list of the users they are following to suggest a product
   - title (from api)
   - line of text with connection count (from api)
   - filter search 
   - list of contacts (from api) with: 
      - user icons
      - name
- A user can select a user they are following to suggest a product
   - contact name **tap** ==> (view 4.6.2)
- After a user sends a suggestion to one GTIO contact, they can send another 
   - after suggestion is sent, show sent overlay 
   - show done btn in top right
       - after sending one suggestion done btn appears 
       - **tap** ==> back to (view 4.2)

### 4.6.1 Gotryiton contacts (sent overlay)

#### Overview 
A user sees a confirmation that their suggestion was sent

#### Mockups
4.6.1  ([wireframe](http://invis.io/UA2OBZHJ))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.6.1.Suggest.GTIO.Contacts.Confirm.png" width=420px/>

#### User Flow
**entry screens:**   
([view 4.6.2](#426-suggestion-compose))  
**exit screens:**   
([view 4.6](#426-gotryiton-contacts))    
previous screen

#### API Usage
None.

#### Stories
- A user sees a confirmation after they have sent a suggestion
   - overlay displays temporarily then disappears to (view 4.6)

### 4.6.2 Suggestion compose

#### Overview 
A user sees a compose window where they can send a message with their suggestion

#### Mockups
4.6.2 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.6.Suggest.GTIO.Contacts.Description.png" width=420px/>

#### API Usage
/Product/Suggest

#### Stories
- A user sees a compose window where they can send a message with their suggestion
   - the text field has suggestion text that disappears when the user starts typing (and reappears if the text field is empty)
- A user can send their suggestion 
   - a send button in the top right
      - **tap** ==> make api request, (view 4.6.1)
   - a user can send their suggestion with or with out entering text


### 4.7 Post a product  

#### Overview 
A user can post a product to their feed from a product page

#### Mockups
([wireframe](http://invis.io/U92OCEF2))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/4.7.Post.A.Product.png" width=420px/>

#### User Flow
**entry screens:**   
([view 4.1](#41-product-page-view))   
**exit screens:**   
([view 8.1](#81-feed-view))    
([view 4.1.2](#412-product-full-screen))   

#### API Usage
/Product/Post

#### Stories
A user can post a product to their feed from a product page
   - title: post a product
   - product detail (same behavior as product detail in (view 4.2)) 
      - product name
      - brand
      - price
      - square thumbnail
         - thumbnail **tap** ==> (view 4.1.1)
         - heart toggle button in top left
            - **tap** makes api request   
   - post btn
      - **tap** ==> makes api request
         - **success** ==> feed (view 8.4)
         - **error** ==> error dialog
- A user can optionally add a description to a product post
   - post description input box
      - optional input
      - raises keyboard
- A user can turn voting on or off on their product post
   - voting on/off toggle
      - default state set by api


## 5. Invite 

### 5.1 Invite friends  

#### Overview 
A user can invite friends to GTIO via SMS, Email, Facebook

#### Mockups
5.1 invite friends  ([wireframe](http://invis.io/TW2OCGBR))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/5.1.Invite.Friends.png" width=420px/>

5.1.1 invite friends actionsheet  ([wireframe](http://invis.io/NB2PNCHD))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/5.1.Invite.Friends.Actionsheet.png" width=420px/>

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


## 6. Friends management

### 6.1 Find my friends

#### Overview
A user can find friends to follow 

#### Mockups
6.1 ([wireframe](http://invis.io/XM2OCN3P))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/6.1.Find.My.Friends.Profile.png" width=420px/>

6.1.1 No Results ([wireframe](http://invis.io/QK2OCQ56))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/6.1.Find.My.Friends.Profile.No.Result.png" width=420px/>

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



### 6.2 Suggested Friends  

#### Overview
A user can see a list of suggested users to follow

#### Mockups
6.2 Suggested Friends ([wireframe](http://invis.io/VD2OCR5H))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/6.2.Suggested.Friends.png" width=420px/>

#### API Usage
/Friends/Suggested


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
   - list items have profile icon, name, tappable to profile (view 7.7)
   - following btn (toggles state)
- A user can refresh the list of suggested users to see a different set
   - refresh btn top right
       - **tap** ==> api request
          - **success** ==> replaces list with new users



### 6.3 Friends management page

#### Overview
A user can manage their friend relationships via the feed

#### Mockups
6.3 ([wireframe](http://invis.io/R62OCSKJ))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/6.3.Friends.From.Feed.png" width=420px/>


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

### 6.4 Find out-of-network Friends  

#### Overview
A user can search for friends outside of their own network

#### Mockups
6.4 ([wireframe](http://invis.io/MH2OCTA9))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/6.4.Find.Friends.Unconnected.png" width=420px/>


#### User Flow
**entry screens:**   
([view 6.1](#61-find-my-friends))   
([view 6.3](#63-friends-management-page))   
**exit screens:**   
([view 7.7](#77-profile-pages))   
previous screen   

#### API Usage
/Friends/Search

#### Stories
- A user can search for friends outside of their own network
   - search field
   - on **submit** ==> api request
      - results show in list
      - has profile icon, name, tappable to profile (view 7.7)
      - following btn (toggles state)

### 6.5 Following List  

#### Overview
A User A can see a list of who a User B is following.  User A and User B can be the same user.

#### Mockups
6.5 ([wireframe](http://invis.io/CS2OCU2W))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/6.5.I'm.Following.png" width=420px/>

#### User Flow
**entry screens:**   
([view 7.1](#71-my-mananagement-page))   
([view 7.7](#77-profile-pages))   
**exit screens:**   
([view 7.7](#77-profile-pages))   
previous screen   

#### API Usage
/User/Following

#### Stories
- A user can see a list of who they (or another user) are following
   - title (from api)
   - youre following x (from api)
   - list of users (from api)
      - alpha sort
      - has profile icon, name, tappable to profile, 
      - following toggle


### 6.6 Followers List  

#### Overview
A User A can see a list of User B's followers.  User A and User B can be the same user.

#### Mockups
6.6 Followers List ([wireframe](http://invis.io/Y92OCV3E))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/6.6.My.Followers.png" width=420px/>

#### User Flow
**entry screens:**   
([view 7.1](#71-my-mananagement-page))   
([view 7.7](#77-profile-pages))   
**exit screens:**   
([view 7.7](#77-profile-pages))   
previous screen   

#### API Usage
/User/Followers

#### Stories
- A user can see a list of who their (or another user's) followers
   - title (from api)
   - x following you (from api)
   - list of users (from api)
      - alpha sort
      - has profile icon, name, tappable to profile, 
      - following toggle



## 7. Profile pages


### 7.1 My management page  

#### Overview
A logged in user can manage their profile, share settings, looks, and friends

#### Mockups
7.1 Management Page [wireframe1](http://invis.io/TQ2OCXAV) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.1.My.Management.png" width=420px/>

7.1 Management page scrolled [wireframe2](http://invis.io/ND2OCYR4)

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.1.My.Management.Scrolled.png" width=420px/>

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
([view 6.1](#61-find-my-friends))   
([view 5.1](#51-invite-friends))   
([view 7.2](#72-settings))   
([view 1.9](#19-sign-in-screen-2nd-load))   


#### API Usage
/User

#### Stories
- A logged in user can see a management page on the 5th tab
   -  top nav bar
   - user detail view
      - thumbnail
         - **tap** ==> (view 7.3)
      - name, location
      - following: x
         - **tap** ==> (view 6.5)
      - followers: x
         - **tap** ==> (view 6.6)
      - edit btn
         - **tap** ==> (view 7.4)
   - my shopping list btn
      - **tap** ==> (view 7.8)
   - my hearts btn
      - **tap** ==> (view 7.5)
   - my posts
      - **tap** ==> (view 7.6)
   - find my friends
      - **tap** ==> (view 6.1)
   - invite friends
      - **tap** ==> (view 5.1)
   - share settings
      - **tap** ==> (view 7.2)
   - sign out
      - confirmation dialog
         - ok:  api request
            - **success** ==> (view 1.9)
         - cancel: close dialog
   - looks are private toggle
      - confirm dialog if you're turng OFF
      - api request
   - "messaging about private looks"
      - this is static copy GTIO will provide


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

#### Stories
- A user can edit when they receive notifications from GTIO
   - load a webview which will allow a user to turn on and off notifications


### 7.3 Edit profile pic  

#### Overview
A logged in user can edit their profile icon

#### Mockups
7.3 ([wireframe](http://invis.io/MF2QIO3Y))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.3.Edit.Profile.Pic.png" width=420px/>

7.3.1 No facebook connect, and no looks  

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.3.Edit.Profile.Pic.Nulls.png" width=420px/>

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

#### Stories
- A user can edit their profile icon
   - a user sees a list of profile icon options
   - a user can tap on each profile icon option and see a preview of their icon with their GTIO display name and location
   - a user can tap to clear profile icon, which sets the icon to the GTIO default icon
      - api for /User/Icon will provide default icon 
- If a user is not connected to facebook, they can connect from this screen to add their fb profile icon (GTIOv3 behavior)
   - if the user is not facebook connected, their facebook icon has a 'connect' btn
      - **tap** ==> Facebook SSO
         - **success** ==> api request to /User/Facebook-Connect
            - **success** ==> refresh (view 7.3)
   - if the user **is** facebook connected, then the fb connect button is hidden

### 7.4 Edit profile  

#### Overview
A logged in user can edit their profile 

#### Mockups
7.4 ([wireframe](http://invis.io/VY2OD0HD))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.4.Edit.Profile.png" width=420px/>

7.4 scrolled 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.4.Edit.Profile.Scrolled.png" width=420px/>

#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
([view 1.8](#18-quick-add))   
**exit screens:**   
previous screen    


#### API Usage
/User/Edit

#### Stories
- A user can edit their profile
   - mimmick existing form
   - add website field
   - edit profile picture **tap** ==> (view 7.3)
   - save:
      - **tap** ==> api request
         - **success** ==> returns you to previous screen
         - **error** ==> dialog message




### 7.5 My hearts  

#### Overview
A logged in user can view their hearted items

#### Mockups
7.5 My hearts ([wireframe](http://invis.io/KD2OD28X))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.5.My.Hearts.png" width=420px/>


#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
**exit screens:**   
([view 3.1](#31-outfit-post-detail-page))   
([view 4.1](#41-product-page-view))   
previous screen    


#### API Usage
/User/Hearts

#### Stories
- A logged in user can view their hearted items
   - masonry view of hearts (posts and products)
   - thumbnails have heart toggle upper left
      - see standard heart toggle behavior
   - destination link provided in api


### 7.6 My posts

#### Overview
A logged in user can view their posts

#### Mockups
7.6 ([wireframe](http://invis.io/732OD3ZH))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.6.My.Posts.png" width=420px/>


#### User Flow
**entry screens:**   
([view 7.1](#71-my-management-page))   
**exit screens:**   
([view 3.1](#31-outfit-post-detail-page))   
([view 3.6](#36-product-post-detail-view))   
previous screen    

#### API Usage
/User/Posts

#### Stories
- A logged in user can view their posted items
   - masonry view of hearts (posts and products)
   - thumbnails have heart toggle upper left
      - see standard heart toggle behavior
   - destination link provided in api



### 7.7 Profile page  

#### Overview
Each user has a profile page

#### Mockups
7.1 basic: ([wireframe](http://invis.io/732OD3ZH))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.7.Profile.Page.Others.Following.png" width=420px/>

7.7.1 other's profile, not following: ([wireframe](http://invis.io/AD2PMYYW))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.7.Profile.Page.Others.Not.Following.png" width=420px/>

7.7.2 other's profile, following requested: ([wireframe](http://invis.io/4Q2PMZHE))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.7.Profile.Page.Others.Not.Following.Follow.Request.png" width=420px/>

7.7.3 other's profile, with banner: ([wireframe](http://invis.io/RW2POUXA))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.7.3.Profile.Page.Branded.Banner.png" width=420px/>

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
/User/Profile

#### Stories
- a user can view the profile of another user (or their self)
   - title: profile
   - settings btn in top right
      - tapping (if not your own profile) raises actionsheet:
         - options are:
            - turn on/off alerts 
            - follow/unfollow toggle
            - block/unblock toggle
         - current on/off states determined by api
      - tapping if IS your own profile
         - sends to view 7.1
- a user can read another user's bio
   - see (view 7.7.1)
   - 'Atlantic-Pacific :-)' will be bio text from API response
- a user can follow another user from their profile if not already following (view 7.7.1)
   - follow btn (toggle)
      - see standard documentation for follow btn
- a user can see who another user is following
   - following btn
      - **tap** ==> (view 6.5)
- a user can see who another user follows
   - followers btn
      - **tap** ==> (view 6.6)
- A user can see additional info about another user 
   - each profile has a customizable text field (view 7.7.1)
      - icon (sent from api)
      - text (sent from api)
         - supports ```<b>```
- Special branded users can display a banner in their profile
   - banner area (view 7.7.3)
      - image and link served via api
      - behavior mimics GTIOv3
- A users profile can show a button linking to an external site
   - button defined by api (view 7.7.1)
      - two button types
      - text
      - action
- A users profile shows a masonry list of their hearts and looks
   - hearts and looks
      - sent from api
      - thumbnails with heart toggle
      - **tap** ==> (view 4.1), (view 3.1), or (view 3.6)
  

### 7.8 Shopping list  

#### Overview
Each user has a shopping list

#### Mockups
7.8 Shopping list ([wireframe](http://invis.io/8W2OD45T))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/7.8.Shopping.List.png" width=420px/>

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


## 8. The Feed 

### 8.1 Feed view  

#### Overview
Each user has a personalized feed of content on the first tab.  The content contains product posts and outfit posts.  Users can take actions directly from the feed view

#### Mockups
8.1 ([wireframe](http://invis.io/P32OE57R)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.1.Feed.png" width=420px/>

8.1.1 product in feed with voting disabled: ([wireframe](http://invis.io/NS2PAHQA)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.1.Feed.Scrolled.Further.png" width=420px/>

8.1.2a Outfit dot options: ([outfit item](http://invis.io/N92PN2YP)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.1.Feed.Dot.Options.png" width=420px/>

8.1.2b Product dot options: ([product item](http://invis.io/WN2PN693)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.1.Feed.Scrolled.Further.Dot.Options.png" width=420px/>

8.1.3 feed scrolled: ([wireframe](http://invis.io/DA2PN3TC)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.1.Feed.Scrolled.png" width=420px/>

8.1.4 feed empty:  ([wireframe](http://invis.io/3W2OH9G2)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.1.Feed.Empty.png" width=420px/>

8.1.3 feed with voting results: 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.1.Feed.Scrolled.Verdict.png" width=420px/>

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
/Posts/Feed

#### Stories  
- A user can see a personalized feed of content
   - display details (matt to flesh this out)
      - User detail area
         - profile icon 
         - user name
         - time since upload
         - location
         - description (truncated)
            - truncation details (??matt??)
         - user detail area catches during scroll
            - catches at top of visible area (view 8.1.3)
            - scrolls out of view and replaced by next user detail of next item in feed (a la instagram)
   - post area
      - main image
         - heart toggle in top left
      - reviews button w/ reviews count
         - **tap** ==> (view 3.4)
- A user can heart an outfit or product post from the feed
   - heart toggle btn in top left corner of each photo   
   - see universal heart toggle behavior
- If a post has voting enabled, a user can vote from the feed
   - user **tap** on wear it or change it ==> api request
      - **success** ==> (view 8.3)
- If a post does not have voting enabled, a user can see an indication of this fact
   - (view 8.1.1)
- A user can tap on a '...' btn to see more actions 
   - see (views 8.1.2)
      - the ... button
         - tweet
            - grab details from above
         - flag
             - grab details from above
         - delete (outfit owner)
      - wear it / change it btn
         - api call
         - show verdict view 8.x??
      - heart count + heart callouts
         - users defined by api
         - tappable to view 3.5
      - brand keywords
         - tappable to (view 10.5)


      - the ... button
         - post
         - suggest
         - buy
            - raises actionsheet (see above)
         - tweet
            - grab details from above
         - flag (non outfit owner)
             - grab details from above
         - delete (outfit owner)
      - wear it / change it btn
         - api call
         - show verdict view 8.x??
      - heart count + heart callouts
         - users defined by api
         - tappable to view 3.5
      - brand keywords
         - tappable defined by api
- A user can paginate through multiple pages of their feed
   - pagination detail api details to come
- A user can pull to refresh their feed
   - see (section 13.6)
- If the user's feed is empty they see messaging encouraging them to add friends
   - see (view 8.1.4)

###  8.3 Feed Verdict view  

#### Overview
A user can see voting results in the feed

#### Mockups
8.3 ([wireframe](http://invis.io/EK2OE7BD)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.1.Feed.Scrolled.Verdict.png" width=420px/>

#### User Flow
same as 8.1

#### API Usage
/Post/Vote

#### Stories  
- A user can see voting results in the feed
   - numbers and graph bars
   - matt will fill y'all in....

###  8.4 Upload in progress view  

#### Overview
A user can see their pending upload in their feed

#### Mockups
8.4 ([wireframe](http://invis.io/642OE8AC)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.4.Upload.In.Progress.png" width=420px/>

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
9.1 Popular looks grid: ([wireframe](http://invis.io/W82OEAFH)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/9.1.Explore.Looks.Grid.png" width=420px/>

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
feed: ([view 10.5](#105-shop-browse-products))   
feed: ([view 10.3](#103-default-3rd-party-webview-container))   
feed: ([view 8.3](#83-default-3rd-party-webview-container))   

#### API Usage
/Posts/Popular

#### Stories 
- A user can see a grid of popular looks on GTIO
   - Api will respond with items to populate the feed
      - each item has heart toggle (see standard behavior)
- A user can switch to a different tab of looks
   - tab choices can have 2, 3 or 4 items
   - tab names are specified by api
   - tab apis are specified by api 
      - similar behavior to lists in GTIOv3
- A user can switch to consume the list of popular looks in a feed view (like view 8.1) rather than a grid view
   - see (view 9.1.1)
   - see question# 3 for clarification
- A list can have a custom image above the grid
   - banner area (view TBD)
      - image and link served via api
- A user can pull to refresh the list of looks
   - see 13.6
- A user can tap on a look in a grid and see a post detail page 
   - the destination is conditional on the type of the post (outfit or product) either (view 3.1) or (view 3.6), respectively



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



### 10.3 Shop 3rd Party webview Container 

#### Overview
A user can browse to a 3rd party site to look for products to heart or post

#### Mockups
10.3 ([wireframe](http://invis.io/N92OENXT)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/10.3.Shop.3rd.Party.WV.png" width=420px/>

#### User Flow
**entry screens:**   
([view 10.1](#102-shop-landing-page))   
([view 10.2](#102-shop-browse-webview-container))   
([view 10.3](#103-shop-3rd-party-webview-container))   
**exit screens:**   
([view 10.3](#103-shop-3rd-party-webview-container))   
([view 7.8](#78-shopping-list))   
([view 4.1](#41-product-page-view))   
([view 4.7](#47-post-a-product))   
previous screen   

#### API Usage
/Shop/Scrape

/Product/Heart

/Tracking

#### Stories 
- A user can browse to a 3rd party site to look for products to heart or post
   - top nav bar is same as Shop Browse navbar (see view 10.2)
   - top right btn 'shopping list'
      - shows count of unread shopping list items
      - responds to gtio:// trigger for updating shopping list count
      - see universal behaivor
   - each user page load trigters api scrape
      - similar behavior to GTIOv3
   - default uitabbar is NOT visible
   - url of webview is customized via gtio:// link that spawned the container
   - bottom nav:
      - standard webview forward and back browse buttons 
      - heart btn
         - wait for scrape api to finish (with spinner like suggest feature in GTIO3.0)
            - **tap** ==> make api call to heart api
               - **success** ==> (view 4.1)
      - post this btn
         - wait for scrape api to finish (with spinner like suggest feature in GTIO3.0)
            - **tap** ==> tracking api call
            - **tap** ==> (view 4.7)


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



## 11. Logged out views

### 11.1 Logged out view inactive tabs  

#### Overview
A logged out user can browse to non-active tabs and see an intro screen to that tab.  They can also tap to sign up from that screen

#### Mockups
([wireframe](http://invis.io/US2PNOWQ)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/11.1.Explore.Looks.Logged.Out.png" width=420px/>

#### User Flow
**entry screens:**   
([view 11.2](#112-logged-out-default-tab))   
**exit screens:**   
([view 1.9](#19-sign-in-screen-2nd-load))   

#### API Usage
/Config

#### Stories 
- A logged out user can browse to non-active tabs and see an intro screen to that tab
   - all tabs except for explore looks tab will have an image url specified in the Config api
- A logged out user can tap to sign up from that screen
   - **tap** on image ==> (view 1.9) 


### 11.2 Logged out default tab  

#### Overview
A non-logged in user can browse to the explore looks tab and see popular looks.  They have a limited ability to interact with the content they see.

#### Mockups
11.2 login wall: ([wireframe](http://invis.io/BA2POGZT)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/11.1.Explore.Looks.Logged.Out.png" width=420px/>

#### User Flow
**entry screens:**   
([view 11.1](#111-logged-out-view-inactive-tabs))   
**exit screens:**   
([view 1.9](#19-sign-in-screen-2nd-load))   
([view 11.3](#113-Logged-out-post-detail-page))   
previous screen

#### API Usage
/Posts/Popular

#### Stories 
- A non-logged in user can browse to the explore looks tab and see popular looks.  
   - A user can view the page in the grid view
   - A user cannot switch to a feed view
- A non-logged in user has limited ability to take actions
   - for following actions, open dialog 
      - heart toggle button
   - dialog info
      - see (view 11.2)
      - text:  you must be logged in to do that
      - login:  **tap** ==> (view 1.9)
      - cancel: closes dialog


### 11.3 Logged out Post detail page

#### Overview
A non-logged in user can browse to a post detail page.  They have a limited ability to interact with the content they see.

#### Mockups

11.3

<img src="http://assets.gotryiton.com/img/spec/4.0/1/11.3.Outfit.Detail.Logged.Out.png" width=420px/>

#### User Flow
**entry screens:**   
([view 11.2](#112-Logged-out-default-tab))   
**exit screens:**   
([view 11.4](#114-logged-out-reviews-page))   
([view 1.9](#19-sign-in-screen-2nd-load))   
previous screen


#### API Usage
/Posts/Popular

#### Stories 
- A non-logged in user can browse to a post detail page. 
- A non-logged in user has limited ability to take actions
   - for following actions, open dialog (view 11.2)
      - heart btn
      - vote btns
      - profile btn
      - any action under ... btn
   - dialog info
      - text:  you must be logged in to do that
      - login:  **tap** ==> (view 1.9)
      - cancel: closes dialog

### 11.4 Logged out Reviews page

#### Overview
A non-logged in user can browse to a Reviews page page.  They have a limited ability to interact with the content they see.

#### Mockups

11.4

<img src="http://assets.gotryiton.com/img/spec/4.0/1/11.4.Reviews.Logged.Out.png" width=420px/>

#### User Flow
**entry screens:**   
([view 11.2](#112-Logged-out-default-tab))   
**exit screens:**   
([view 1.9](#19-sign-in-screen-2nd-load))   

#### API Usage
/Posts/Reviews

#### Stories 
- A non-logged in user can browse to a post detail page. 
- A non-logged in user has limited ability to take actions
   - for following actions, open dialog (view 11.2)
      - agree
      - flag
      - tap into review area
      - tap on users name
   - dialog info
      - text:  you must be logged in to do that
      - login:  **tap** ==> (view 1.9)
      - cancel: closes dialog



## 12. Upload


### 12.1  Upload start  

#### Overview
A user can start an upload by opening their camera within the GTIO app.  They can use the camera to take subsequent photos for a framed upload.

#### Mockups
12.1 ([wireframe](http://invis.io/WD2OERMP))

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.1.Upload.Start.png" width=420px/>


12.1.1 Upload start (with frames) ([wireframe1](http://invis.io/HB2OESTA) [2](http://invis.io/NW2OETS6) [3](http://invis.io/WE2OEUV5))  

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.1.1.Upload.Start.Frame.Left.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.1.1.Upload.Start.Frame.Right.Top.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.1.1.Upload.Start.Frame.Right.Bottom.png" width=420px/>


#### API Usage
/Tracking

/Post/Config

#### Stories 
- A user can start an upload by opening their camera within the GTIO app
   - TT to flesh out details here.
- A user can select a photo from their photo library
- A user can use their camera to take subsequent photos (for framed uploads)
   - The camera has a guide overlay that matches frame (view 12.1.1)
   - The camera has a mini-map of frame with current frame highlighted (view 12.1.1)
- When a user starts an upload, the app gets config data from the server
   - /Post/Config
      - will respond with Facebook Toggle status
      - will respond with Voting Toggle status
      - will respond with Brands dictionary

### 12.2  Upload confirm  

#### Overview
A user can confirm that they want to upload the photo they've taken or selected.  They can apply filters at this stage

#### Mockups
([wireframe](http://invis.io/9M2OEVED) [2](http://invis.io/2Z2OEWB8) [3](http://invis.io/QB2OEYM7) [4](http://invis.io/4F2OEZGK))  

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.2.Upload.Confirm.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.2.1.Upload.Confirm.Frame.Right.Top.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.2.1.Upload.Confirm.Frame.Left.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.2.1.Upload.Confirm.Frame.Right.Bottom.png" width=420px/>

#### API Usage
/Tracking

#### Stories 
- A user can apply a filter to a photo they have taken or selected
   - filter menu
      - 5 only
         - tasteful filters
         - labels
   - one filter is a 'no filter' option which removes any applied filter
- A user can select if they want to use the photo they've selected (and filtered)
   - use this photo yes/no
      - yes ==> (view 12.3)
      - no ==> (view 12.1)


### 12.3 Post a look  

#### Overview
A user can add details to their post before they submit.  They can select to use frames.  They can edit photos in their frames. 

#### Mockups
([wireframe](http://invis.io/J92OF18E)) 

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.3.Post.A.Look.png" width=420px/>

12.3.1 Post a look (Description with keyboard) ([wireframe](http://invis.io/AC2OF2GX))  

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.3.1.Post.A.Look.Description.Keyboard.png" width=420px/>

12.3.2 Post a look (Photo preview with frames) ([wireframe](http://invis.io/5K2OF0W8))  

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.3.2.Post.A.Look.Frames.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/1/12.3.2.Post.A.Look.Frames.2nd.png" width=420px/>

#### API Usage
/Tracking

/User/Facebook-Connect

/Post/Upload

#### Stories 
- A user can add details to their post before they submit.
   - description (optional)
      - page slides down and keyboard is raised (view 12.3.1)
   - tag brands
      - page slides down and keyboard is raised (view 12.3.1)

- When a user enters brands that are recognized by the app, the app offeres autocomplete
   - dictionary used is passed back in /Post/Config
- A user can select to use frames in their upload
   - frames buttons
      - multi frame button converts to (view 12.3.2)
      - single frame button converts back to (view 12.3)
- A user can toggle facebook on or off
   - initial toggle state set by API
   - if a user is not facebook connected
      - **tap** ==> Facebook SSO
         - **success** ==> api request /User/Facebook-Connect
         - toggles on state
- A user can toggle voting on or off
   - initial toggle state set by API
- A user can cancel their post
   - cancel btn
      - **tap** ==> returns you to your previous tab in previous state
- A user can edit the photos in their Post
   - frame camera buttons
      - **tap** ==> (view 12.1.1)
   - frame cancel btn
      - clears the photo stored in that frame
      - **tap** ==> (view 12.1.1)
- A user can edit the photo in their single image Post
   - main image close button **tap** ==> (view 12.1)
- A user cannot post their upload if they have frames turned on but fewer than 3 photos 
   - if frames enabled and < 3 photos 
      - post button is grayed out and disabled
- A user can post their upload
   - post btn
      - if description is empty
         - show dialog
            - text: Are you sure ...
            - ok: send api request
            - cancel: select description field and ==> (view 12.3.1)
      - **tap** ==> api request /Post/Upload
- A user can move a photo within a frame
   - Each photo in frame is draggable
      - photo cannot be dragged outside of frame
   - Each photo in frame is pinchable
      - photo cannot be resized out of frame



## 13. Universal Elements and Behavior

### 13.1 UITabBar default behavior  

#### Overview
The app has a universal UITabBar that allows the user to move from tab to tab

#### Mockups
see (view 8.1), (view 9.1), (view 12.1), (view 10.1), (view 7.1)

#### API Usage
None.

#### Stories
- A user can switch between tabs of the app
   - matt to define visual display
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
The app should display a custom dialog whenever the API responds with an error

#### Mockups
None.

#### API Usage
An error response from the gtio api will look like this:

```json
{
   error : {

      status : "error",

      message : "Hi, this is your error",

      title : "Optional title to the dialog"

   }
} 
```

#### Stories
- When a user encounters an error, they should see a standard error response
   - error messages should appear as standard dialogs
   - if no error message is defined by the api:
      - display "Gotryiton is not responding right now"
   - if error message is defined in the api response, display it
   - if a title is defined in the error reponse use it
      - otherwise use 'error'



### 13.4 Follow buttons  

#### Overview
In many places where there is a user's name, there is a follow button.  This button can have many states

#### Mockups

#### API Usage
```/User```  each user may contain a following_button object

```json
user : {
   
   following_button : {
      text : "string for content of button",

      action: "api/path/to/hit",

      state: 1,

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
      - follow button shows 'pending' if the request to follow is pending
   - the button's color/state will be defined by the api ```state``` attribute
      - 0: off (not yet following)
      - 1: on (currently following)
      - 2: requested (button inactive, follow requested)
- When a user sees their own name, the follow button will not be visible
   - User objects do not contain following_button of the user who made the request
- When a user taps on the button and it takes an action, the button updates
   - upon **successful** api response, update the button


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

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.1.Outfit.Detail.Refresh.1.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.1.Outfit.Detail.Refresh.2.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/1/3.1.Outfit.Detail.Refresh.3.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.1.Feed.Refresh.1.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.1.Feed.Refresh.2.png" width=420px/>

<img src="http://assets.gotryiton.com/img/spec/4.0/1/8.1.Feed.Refresh.3.png" width=420px/>



#### API Usage
Don't pass an e-tag cache ```If-None-Match``` id and send the same request.

#### Stories
- A user can refresh a feed
   - pull to refresh is active on the feed in (view 8.1) and the popular lists in (view 9.1) only







