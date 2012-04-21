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

## 2. Global Nav bar and Notifications Center


### 2.1 Navbar with Notifications

#### Overview  
When a user is on one of the top level tabs, they see a navigation bar with notifications 

#### Mockups
([wireframe](http://invis.io/P32OE57R))

#### API Usage
/Notifications

#### Stories
- When a user is not logged in the nav bar is disabled
   - gotryiton is not clickable
   - logo is centered
- When a user has zero new notifications, the nav bar has an empty notifications container
   - notification container and gotryiton logo tappable if total notifications > 0
      - **tap** ==> (view 2.2) 
      - TBD: matt to add animation details
   - if total notifications = 0, notification container and logo are not tappable
- When a user has more than zero new notifications the navbar notifications icon is highlighted 
   - the nav bar contains number of new notifications
   - notification container and gotryiton logo tappable
      - **tap** ==> (view 2.2) (!!matt to add animation details)

### 2.2 Notifications view 

#### Overview  
When a user is on one of the top level tabs, they see a navigation bar with notifications 

#### Mockups
([wireframe](http://invis.io/QR2OBP8N))

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
- A user can sometimes tap on a button in the notification
   - each notification item can conditionally include an action button with customizable text and action
      - action can either:
         - direct the user to a url
            - button tap activates on state during transition
         - send an api request
            - button tap activates on state of button persistently
- The app will only highlight the number of notifications that the user has not seen
   - app will keep track of notificiation ids
      - ids that have been seen will get a read state
      - ids that have not been seen will be treated as NEW notifications
         - new notifications will populate the notification navbar container number
         - new notifications will get an unread state the first time they are seen
      - this behavior will mimmick current 3.0 behavior



## 3. Product Post and Outfit Post Detail pages

### 3.1 Outfit Post Detail Page

#### Overview 
A user can see a detailed view of a single outfit post

#### Mockups
3.1 [wireframe](http://invis.io/SX2OBQUG)
3.1.1 Outfit Detail No Voting ([wireframe](http://invis.io/W22OBRHF)

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
      - **tap** ==> view 3.4
- A user can heart the outfit from an outfit page
   - heart action button in top left of image
      - **tap** ==> api request
   - heart count + heart icons
      - **tap** ==> view 3.5
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
- A user can suggest a product from an outfit post page
   - only available for outfit viewers
   - **tap** ==> view 4.2
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

### 3.2 Outfit Post Detail Page verdict displayed 

#### Overview 
A user can vote on an outfit from the outfit detail page and see voting results

#### Mockups
3.2 Verdict displayed 
3.2.1 Verdict displayed on Product Page

#### API Usage
/Outfit/Vote

#### Stories
- A user can see voting results after they vote


### 3.3 Outfit Detail Page Full screen photo ([wireframe](http://invis.io/2W2OFST5))

#### Overview 
A user can see a full screen detail of an outfit

#### Mockups
3.3 Outfit Full Screen ([wireframe](http://invis.io/2W2OFST5))
3.3.1 Product Post Full Screen ([wireframe](http://invis.io/2W2OFST5))

#### API Usage
None.

#### Stories
- A user can see a full screen image of an Outfit Detail or Product detail page
   - If a user is looking at a product full screen, then the nav bar disappears too


### 3.4 Reviews page 

#### Overview 
A user can read reviews from an outfit post or a product post page

#### Mockups
([wireframe](http://invis.io/NE2OBV7J))

#### API Usage
/Outfit/Reviews
/Review/Agree
/Review/Flag

#### Stories
- This feature is mostly unchanged from 3.0.  Here are the details of changes:
   - Suggest a product button is no longer available
   - post thumbnail displayed should be square 
      - **taps** ==> (view 3.3)
   - no longer needs to support multiple outfits
- A user can agree with a review
   - **taps** ==> api request
- A user can flag a review
   - **taps** ==> api request



### 3.5 Who hearted this 

#### Overview 

A User can see other users who have hearted an outfit or product post

#### Mockups

([wireframe](http://invis.io/N22OBX9Q))

#### API Usage

/Post/Hearts

#### Stories
- A user can view a list of other users who have hearted a post
   - cell list view 
   - profile icons, name
   - follow btn
      - state of button is either unfollow or follow
      - **tap** ==> api request and changes state of button


### 3.6 Product Post Detail

#### Overview 
A user can see a detailed view of a Product Post

#### Mockups
([wireframe](http://invis.io/UA2OBZHJ))

#### API Usage

#### Stories
- When a user views a product post detail page, they should see details about the product post
   - Name and location in navbar
      - NOTE: nav bar for product posts is transparent 
   - profile button in top right in navbar
      - image in button should be user->profileIcon
      - **tap** ==> (view 7.7)
   - full description
   - full brands
   - reviews button with reviews count
      - **tap** ==> view 3.4 
   - product name with brand and price
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
([wireframe](http://invis.io/8Y2OC5N7))

#### API Usage
/Product

#### Stories
- A user can view a detailed page about a single product
   - transparent navbar 
      - TBD: matt to provide guidance
   - heart action button
      - sends api request
   - heart action button
   - full product name with brand and price
   - photo aligned to top 
      - **tap** ==> (view 3.3.1)
      - TBD: matt to provide direction
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
([wireframe](http://invis.io/QE2OC6XW))

#### API Usage
TBD

#### Stories
- A user can email the product to themselves
   - email btn **tap** raises dialog confirm
         - ok **tap** ==> api request
         - cancel: closes dialog
- A user can go to store mobile site to view the product
   - 'go to store site' btn **tap** ==> opens buy url in default safari view
- A user can view the item in their shopping list
   - 'view in shopping list' btn **tap** ==> makes api request
      - upon successful api response: ==> (view 7.8)

### 4.2 Suggest a product

#### Overview 
A user can suggest a product to another user

#### Mockups
([wireframe](http://invis.io/NT2OC8QM))

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
         - thumbnail **tap** ==> full screen image (view 3.3.1)
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
4.3.1 ([wireframe](http://invis.io/MR2OCAUP))

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
([wireframe](http://invis.io/4R2OCBCW))

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
([wireframe](http://invis.io/AG2OCC3Z))

#### API Usage
/Product/Suggest/Facebook

#### Stories
- A user can see a list of their facebook contacts
   - alpha sorted with alpha shortcut
- A user can select a facebook contact and post on their wall
   - list item **tap** ==> makes api request
      - On successful response ==> 
         - raises facebook post ui (similar to GTIOv3 functionality using Facbook SDK)
            - content is populated by api


### 4.6 Gotryiton contacts 

#### Overview 
A user can select from the users they are following to suggest a product

#### Mockups
4.6 ([wireframe](http://invis.io/QB2OCDVE))
4.6.1  ([wireframe](http://invis.io/UA2OBZHJ))

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
   - contact name **tap** ==> raises dialog:
      - text: Send this suggestion to ```user.display_name```? 
      - ok: api request
         - on successful response: show 'sent' overlay (view 4.6.1)
      - cancel:  closes dialog
- After a user sends a suggestion to one GTIO contact, they can send another 
   - after suggestion is sent, show sent overlay 
   - show done btn in top right
       - after sending one suggestion done btn appears 
       - **tap** ==> back to (view 4.2)

### 4.7 Post a product

#### Overview 
A user can post a product to their feed from a product page

#### Mockups
([wireframe](http://invis.io/U92OCEF2))

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
         - thumbnail **tap** ==> (view 3.3.1)
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
      - default state set by api (???)


## 5. Invite 

### 5.1 Invite friends

#### Overview 
A user can invite friends to GTIO via SMS, Email, Facebook

#### Mockups
([wireframe](http://invis.io/TW2OCGBR))

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
      - successful api response ==> (view 4.3.1)
- A user can compose an Email by entering their own recipients
   - email btn
      - **tap** ==> sends api request (for body of email)
      - successful api response ==> (view 4.4)
- A user can select to invite via facebook
   - facebook btn
      - **tap** ==> sends api request (for facebook contact list)
      - successful api response ==> (view 4.5)
- A user can select to invite a particular friend from their contact list
   - **tap** ==> raises actionsheet of available contacts (phone number or email addres)
      - actionsheet **tap** ==> api request (SMS or Email depending on type of contact)
         - **success** ==> (view 4.3.1) or (view 4.4) (with contact populated in the to field)




# 6. Friends management

### 6.1 Find my friends via Profile 

#### Overview
A user can find friends to follow 

#### Mockups
6.1 ([wireframe](http://invis.io/XM2OCN3P))
6.1.1 No Results ([wireframe](http://invis.io/QK2OCQ56))

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
      - has profile icon, name, following btn, tappable to profile
      - filter search available
      - if filter search comes up empty, see (view 6.1.1)
      - following toggle btn
         - tapped state: following
- When a user searches for friends and doesnt find the user they are looking for, they can search the entire community
   - the filter search has custom empty text 
      - 'We couldnt find "search string" do you want to try searching the entire GTIO community' button
         - **tap** ==> api request
            - **success** ==> (view 6.4)



### 6.2 Suggested Friends 

#### Overview
A user can see a list of suggested users to follow

#### Mockups
([wireframe](http://invis.io/VD2OCR5H))

#### API Usage
/Friends/Suggested

#### Stories
- A user can see a list of suggested users to follow
   - page loads a list of users
   - list items have profile icon, name, tappable to profile (view 7.7)
   - following btn (toggles state)
- A user can refresh the list of suggested users to see a different set
   - refresh btn top right
       - **tap** ==> api request
          - **success** ==> replaces list with new users



### 6.3 Friends management page (via feed)

#### Overview
A user can manage their friend relationships via the feed

#### Mockups
([wireframe](http://invis.io/R62OCSKJ))

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
      - has profile icon, name, tappable to profile
      - following btn (toggles state)
      - if filter search comes up empty
         - custom empty text 
            - 'We couldnt find "search string" do you want to try searching the entire GTIO community' button
            - **tap** ==> (view 6.4)

### 6.4 Find out-of-network Friends

#### Overview
A user can search for friends outside of their own network

#### Mockups
([wireframe](http://invis.io/MH2OCTA9))

#### API Usage
/Friends/Search

#### Stories
- A user can search for friends outside of their own network
   - search field
   - on **submit** ==> api request
      - results show in list
      - has profile icon, name, tappable to profile
      - following btn (toggles state)

### 6.5 Following List

#### Overview
A User A can see a list of who a User B is following.  User A and User B can be the same user.

#### Mockups
([wireframe](http://invis.io/CS2OCU2W))

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
([wireframe](http://invis.io/Y92OCV3E))

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
