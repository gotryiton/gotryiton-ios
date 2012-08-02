#### GTIO Build Changelog

#### Build 4.0.0.21
August 2, 2012

### Build Summary
Mid sprint 7 build. Lots of bug fixes.

### Development

**Features**
- #508 - Feed images now show download progress
- #486 - 4.1 product detail page feature tweaks
- #487 - 8.1 add SHOP THIS LOOK button to feed, remove current
- #470 - 1.8 Quick Add styling tweaks

**Bugs**
- #413 - Fixed bug where UITabBar would go opaque
- #422 - Attempt at fixing the feed pull to refresh going over nav bar
- #328 - Fixed bug when taking photo and using photo set mode with no left image. Switching to single image now looks at top image and then bottom and switches it to main/left
- #442 - 1.7 tweaks - native picker options, input limits
- #514 - some hashtags in descriptions are no longer tappable
- #516 - 8.1 Feed - one starred item in your list makes all appear with stars
- #518 - using follow button from search results has indefinite spinner
- #506 - 9.1 pointer arrow on 4th/custom tab is out of position
- #488 - Notification count not updating immediately after login
- #502 - edit profile pic - connecting facebook swaps icons around
- #485 - 12.3 change dialog action button labels
- #515 - Line height for multiple line notifications is oddly tight
- #521 - 1.7 cannot choose 'female' in gender picker without picking another option first
- #480 - 7.1 should update immediately when returning from changing profile info

---

#### Build 4.0.0.20
August 1, 2012

### Build Summary
Mid sprint 7 build. Lots of bug fixes.

### Development

**Features**
- 479 - Replace example text on post a look + leave a comment + comments page
- 232 - ... Pop over buttons not connected to actions
- 475 - 5.1 remove facebook, add twitter
- 497, 394 - Error handling
- 495 - Refresh feed view on every load if no posts
- 389 - Added Flurry Analytics

**Bug Fixes**
- 396 - After tapping on "follow" button on profile, profile_callouts should replace existing
- 450 - Follow buttons spinner
- 482 - 3.4 top of comment text sometimes gets cut off
- 489 - Heart button oddly slow to activate on Shop Lists
- 474 - 5.1 invite text for SMS or email should be from API
- 424 - 5.1 Invite alpha shortcut bugs
- 432 - gtio://full-screen-image/[url] does not load url
- 430 - 4.1 normal/fullscreen photos out of position
- 423 - Feed photos should be tappable to view full screen
- 453 - Fixed DTCoreText font loading issues
- 365 - Open brand and hashtags in looks tab
- 478 - Fixed bug on feed where you could not click last post

---

#### Build 4.0.0.19
July 30, 2012

### Build Summary
Simon bug fix build

### Development

**Bug Fixes**
- 457 - 7.8 heart suggestions (at bottom) are not using square thumbs
- 339 - line height issue on post description and reviews
- 454 - 7.6 posts not tappable on 'my posts'
- 412 - 'Star Corner' not visible in 9.1 and 8.1
- 406 - custom slider on 7.1
- 459 - 3.4 comment buttons (flag, delete, heart) not working
- 420 - 3.4 Reviews design tweaks
- 344 - Tap area issues
- 377 - Heart buttons delayed update on Shopping List and Review table cells
- 461 - need hearts on Shop This Look and Style Lists
- 427 - Nothing is tappable on single post view
- 417 - pull to refresh elements have incorrect vertical positioning
- 428 - Single post view does not need 'catching' scroll behavior
- 415 - Added quick add bg
- 422 - After successfully post a feed item the pull to refresh was over the nav bar
- 441 - When posting a feed item it will switch to feed tab and scroll to top

---

#### Build 4.0.0.18
July 27, 2012

### Build Summary
Final Sprint 6 build for dev/staging/production. 

### Development

**Bug Fixes**
- 415 - Added quick add bg
- 422 - After successfully post a feed item the pull to refresh was over the nav bar
- 441 - When posting a feed item it will switch to feed tab and scroll to top

---

#### Build 4.0.0.17
July 27, 2012

### Build Summary
Final Sprint 6 build. Bug fixes, style changes, loading spinner customization, etc...

### Development

**Screens / Features**
- 410 - 13.7 Add verified user badges to appropriate screens
- 403 - Production api should point at api.gotryiton.com
- 414 - Find friends design tweaks
- 436 - Styling of find friends empty screens
- 446 - 7.7 Profile design tweaks
- 414 - add unique background screen to 1.8
- 252 - User bar on feed view should be tappable to profile
- 255 - increase tap area for hearts on feed views
- 420 - 3.4 Reviews design tweaks
- 299 - Create new account loading spinner
- 243 - Post Feed loading spinner
- 188 - 8.1 Empty Feed
- 429 - spinner states

**Bug Fixes**
- 211 - 1.7 styling bugs
- 342 - User and profile icon on reviews should be tappable to user's profile
- 431 - 8.1 Feed design tweaks
- 418 - 3.4 scrolling up and down shows incorrect assets
- 244 - Viewfinder should 'freeze' when photo is taken
- 374 - Feed Posts image sizes are hard coded
- 404 - Who hearted this not pulling correct list
- 237 - Who hearted "147 hearted this" button not connected to action
- 421 - Same description when posting two looks in a row
- 402 - UIWebview cache not respecting cache-control header

---

#### Build 4.0.0.16
July 25, 2012

### Build Summary
Mid sprint 6 build. Bug fixes, search tags, finished invite friends, pick a product.

### Development

**Bug Fixes**
- 397 - Posting products will now attach all the product IDs
- 327 - Posting images will now attach all the filter names
- 360 - Reversed the settings post are private switch

**Screens / Features**
- 391 - Enable gtio:// routing from external links
- 350 - Handle profile button open gtio:// links
- 294 - Search Tags
- 273 - Invite Friends
- 285 - Pick a product view and load into camera

---

#### Build 4.0.0.15
July 23, 2012

### Build Summary
Mid sprint 6 build. Bug fixes, push notifications, partial of invite friends.

### Development

**Bug Fixes**
- 400 - Profile shadow should not show while profile icon is loading
- 399 - dot dot dot menu mis-positioned with 3 items
- 251 - dot dot dot menu should close when button is tapped again
- 382 - 3.4 empty state persists after no longer empty
- 357 - remove 'my looks' label from 7.3
- 381 - 3.4 empty state - add action

**Screens / Features**
- 317 - Push notifications w/ urban airship
- 269 - 3.5 Who Hearted This

**In Progress**
- 273 - Invite Friends

---

#### Build 4.0.0.14
July 20, 2012

### Build Summary
Mid sprint 6 build. Bug fixes, shopping list, notifications, and pull to load more and pull to refresh.

### Development

**Bug Fixes**
- 248, 141, 369 - Post a look scrolling issues
- 370 - Feed pull to refresh is too high
- 383 - crash going to camera on iPod touch 4th gen
- 348 - title bar on gtio://internal-webview not set correctly
- 153 - 12.4 photoshoot grid layout tweaks (nav title italics)
- 368 - post icons in my hearts masonry do not tap to single post view

**Screens / Features**
- 338, 366 - Notifications now working
- 372 - Dual view mason grid pagination / refresh
- 275 - 7.8 Shopping list
- 272 - 4.8 Shop this look
- 282 - 10.5 Shop Browse Products
- 242 - Mason Grid Load More
- 235 - Post Feed Load More

---

#### Build 4.0.0.12
July 17, 2012

### Build Summary
Bug fixes from sprint 5 and Explore looks tab.

### Development

**Bug Fixes**
- 343 - User icon on reviews should have no border when tapped
- 336 - Status bar background is not consistent.
- 335 - Profile not showing posts or hearts data
- 177 - quick add follow button does not route (screen 1.8)
- 261 - Endless spinner on profile/management pages
- 253 - Heart button on feed not connected to action

**Screens / Features**
- 278 - 9.1 Popular looks - mason grid
- 277 - 9.1 Popular looks - segmented control

---

#### Build 4.0.0.11
July 13, 2012

### Build Summary
Final sprint 5 build. Bug fixes, notifications, rework of post multi-frame and resizing to allow scroll bouncing, composite images at bigger size.

### Development

**Bug Fixes**
- 320 - Profile website button only shows if user has bio (screen 7.7)
- 321 - If I'm not following a public user, I can't see their posts

**Screens / Features**
- 265 - 2.2 Notifications View Styling
- 323 - Composite post images at bigger size
- 279 - Style tab web view
- 280 - Internal web view
- 281 - Default web view

---

#### Build 4.0.0.10
July 11, 2012

### Build Summary
Sprint 5 mid build. Bug fixes, reviews screen, post multi-frame and resizing.

### Development

**Bug Fixes**
- 177 - quick add follow button does not route (screen 1.8)
- 211 - 1.7 styling bugs
- 314 - suggested friends button on Find Friends screen (/user/friends) is not tappable

**Screens / Features**
- 199 - 7.6 My Posts
- 267 - 3.4 Reviews Page Table Header
- 268 - 3.4 Reviews Page Cell Styling
- 302 - Styling of the camera toolbar
- 306 - Camera source pop over
- 305 - Photo shoot mode pop over view
- 307 - Remove voting switch and fix facebook switch
- 283 - Photo multiple frame support
- 283 - Photo action sheet
- 284 - Resize the post a look frame

---

#### Build 4.0.0.9
July 06, 2012

### Build Summary
Sprint 5 mid build. Lots of bug fixes, post a photo upload progress, pull to refresh on mason grids.

### Development

**Bug Fixes**
- 264 - On Find Friends screen becomes untappable
- 263 - Masonry photo sizing issue
- 262 - Profile empty state should say 'their' not 'his'
- 261 - Endless spinner on profile/management pages
- 260 - Custom Actionsheet doesnt support more than 3 buttons
- 259 - Settings button on profile should not exist if null in api response
- 258 - My looks icons on Edit Profile Picture screen are not tappable
- 254 - <b> tags not rendered correctly on user profile_callouts
- 250 - 7.1 following/followers/stars button asset tweak
- 247 - Suggested friends button icons (find my friends view) is not tappable
- 246 - suggested friends does not paginate correctly
- 212 - 7.1 styling bugs
- 148 - 'sign up with another provider' target area too small (1.3 Sign In)

**Screens / Features**
- 287 - 13.6 Pull to refresh
- 276 - 8.4-5 Feed Upload Progress View

---

#### Build 4.0.0.8
July 2, 2012

### Build Summary
New filters merged in. Updated JSON for UI keys.

---

#### Build 4.0.0.6/7
June 29, 2012

### Build Summary
Sprint 5 build. Post feed view, find my friends view and profile views.

### Planned Work

- Post Feed View
- Find My Friends Views
- Profile views

### Ongoing Development

**Known Issues**
- 232 - ... Pop over buttons not connected to actions
- 233 - Shopping bag, reviews button actions aren't connected to actions
- 234 - Post feed pull to refresh
- 235 - Post feed load more
- 236 - Post feed section header background goes clear on navigation
- 237 - Who hearted "147 hearted this" button not connected to page
- 238 - brand buttons not connected to page
- 239 - Post Description/Who hearted text sizing, text origin, link actions
- 240 - Post feed cell loading is jerky
- 243 - Post Feed loading spinner

**Screens / Features**
- 199 - 7.6 My Posts
- 198 - 7.5 My Hearts
- 197 - 7.9 My Stars
- 188 - 8.1 Empty feed
- 182 - 8.1 Nav Bar
- 241 - Mason Grid Pull to refresh
- 242 - Mason Grid Load More

---

#### Build 4.0.0.5 
June 25, 2012

### Build Summary
This is a build of Geoff's work on the profile pages. If you go to the me tab and then click on following it is hard coded to take you to Rachit's profile. There are also a few additions to The Feed view from Scott.

### Work In Progress

- 192 - 7.7 Follow you view
- 193 - 7.7 Profile Header Callout View
- 195 - 7.7.5-6 Others Private Profile View
- 182 - Nav Bar (After talking to Matt this needs to be changed)

---

#### Build 4.0.0.4 - June 22, 2012

### Build Summary
This is a build of scott's work on the post feed. I ran into some merging problems getting Geoff's code in and didn't want to delay the build till monday. That is why I am release this with only my code. I plan on doing another build monday with merged code.

### Work In Progress

- 183 - 8.1 Table section header
- 184 - 8.1 Photo of person/product
- 185 - 8.1 Description text

---

#### Build 4.0.0.3 - June 20, 2012

### Build Summary
This is a bugfix build.

### Completed Development

**Bug Fixes**
- 215 - Use description in place of location on Quick Add Screen
- 213 - 7.1 Styling tweaks
- 211 - 1.7 styling bugs
- 210 - 7.3 styling bugs
- 178 - management screen, following, followers, stars buttons (screen 7.1)
- 177 - quick add follow button does not route (screen 1.8)
- 176 - Quick add table rows should not be tappable (screen 1.8)
- 180 - app crashes when attempting to **not** add filters (screen 12.2)
- 179, 138 - flash button is not tappable because the focus indicator supercedes it (screen 12.1)
- 141 - scrolling on description and brands fields (screen 12.3)

---

#### Build 4.0.0.2 - June 14, 2012

### Build Summary
This build adds management pages, quick add page, uploading of photos, camera focusing, filtering of photo (currently crashes b/c of memory warning), minor tweaks and bug fixes.

### Completed Development

**Planned Work (5/21)**
- 134 - 7.1 My Management Table View
- 133 - 7.1 My Management Table View Header Styling
- 132 - 1.8 Quick Add API
- 131 - 1.8 Quick Add styling
- 128 - Nav Bar w/ Noficiations
- 127 - Login doesnt respect is_new_user and has_complete_profile states
- 126 - Camera Status Bar
- 125 - Custom UISwitch styling on Post Photo View
- 124 - Post View Nav Bar Styling
- 123 - Hard to click switches on Post Photo View
- 122 - Post button not enabled initially
- 121 - Photo Shoot Countdown View and Flash Animations
- 120 - "Select One Photo" view transition
- 119 - Post View Switch Default Values
- 118 - Burst mode optimize photo processing
- 99 - 12.3 POST /post
- 98 - 12.3 Upload photo

**Updates to Planned Work / Additional Work Added**
- 160 - Update navigation button images
- 153 - 12.4 photoshoot grid layout tweaks
- 152 - 12.3 post a look design tweaks
- 150 - 7.3 thumbnail styling bugs
- 149 - shutter button can be hit multiple times (12.1)
- 148 - 'sign up with another provider' target area too small (1.3 Sign In)
- 147 - Photos should always fill their frame
- 146 - exiting app during photoshoot has bad consequences
- 145 - single photo upload on screen 12.3 doesnt have active post button
- 142 - cancel button while post button is active (screen 12.3)
- 141 - scrolling on description and brands fields (screen 12.3)
- 140 - "next" button should appear in the keyboard not a bar over the keyboard (screen 12.3)
- 139 - tap to focus should be available during camera capture
- 138 - no flash button available during non-photoshoot camera capture
- 137 - website and about me not saving correctly on almost done
- 158 - updated 'snap' overlay for 12 Upload
- 157 - use new active/inactive states for nav bar buttons
- 154 - edit profile icon cleared state (screen 7.3)
- 151 - 1.7 (and 7.4) text formatting
- 135 - /user/signup/janrain api request is not passing http auth
- 122 - Post button not enabled initially

### Ongoing Development

**Known Issues**
- 170 - App crashes in camera flow because filters are taking to much memory

**Screens / Features**
- 90 - 12.1 Photo Frame Shooting mode
- 115 - Almost done text issues

---

#### Build 4.0.0.1 - June 1st, 2012

### Build Summary
The build on the remaining signin functionalty utilizing Janrain and contains the several styled screens withing the Photo shoot process

### Completed Development

**Planned Work (5/21)**

- 79 - 7.3 Edit profile pic
- 78 - 1.7 Almost done - endpoint
- 77 - 1.7 Almost done - styling
- 76 - 1.5 Janrain sign in - endpoint
- 75 - 1.5 Janrain sign up - endpoint
- 74 - 1.5 Janrain sign up - styling
- 73 - 1.4 Connect buttons to janrain screens
- 72 - Loading spinner when coming back from Facebook SSO
- 71 - Failed sign-in Email support
- 70 - Auth Token Nested
- 69 - Tracking
- 68 - No Intro Screens Hide Bottom Bar
- 43 - Returning Users

**Updates to Planned Work / Additional Work Added**
- 104 - 12.5 Play sound when taking photo
- 103 - 12.5 Burst photos on timer
- 102 - 12.5 Photo shoot progress bar
- 101 - 12.5 Photo shoot timer view
- 100 - 12.4 Photo shoot grid view
- 99 - 12.3 POST /post
- 98 - 12.3 Upload photo
- 96 - 12.3 Photo frames view
- 95 - 12.3 Style the photo frame mode view
- 94 - 12.3 Style the post options view
- 93 - 12.3 Description and tag brands views
- 92 - 12.2 Filter page toolbar view
- 91 - 12.2 Filter page view
- 90 - 12.1 Photo frame overlay 
- 89 - 12.1 Photo picker
- 85 - 12.1 Camera control bar
- 84 - 12.1 Show Camera
- 83 - Intro Screen animate buttons

### Ongoing Development

**Known Issues**
 - 115 - Almost done Text Issues
 - 118 - Burst mode optimize photo processing
 - 119 - Post View Switch Default Values
 - 120 - "Select One Photo" view transition
 - 121 - Photo Shoot Countdown View and Flash Animations
 - 122 - Post button not enabled initially
 - 123 - Hard to click switches on Post Photo View
 - 124 - Post View Nav Bar Styling

**Screens / Features**
 - 90 - 12.1 Photo Frame Shooting mode
 - 98 - 12.3 Upload photo
 - 99 - 12.3 POST /post

---