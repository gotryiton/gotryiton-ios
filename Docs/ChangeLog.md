#### GTIO Build Changelog

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