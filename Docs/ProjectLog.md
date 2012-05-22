***Monday, May 21th - Standup Notes***

**Attendees**

- TT - Matt, Scott, Geoff
- GTIO - Simon, Matt

**Tasks / To Do List**
- GTIO - Continue documenting Photo upload / Burst mode in functional spec
- TT - Review Burst mode information in Simon's pull request by EOB 5/22
- GTIO / TT - Test No Intro Screen case when disabled in config

**Status**
- 1.7 api for photo upload - Does the user ever upload their own icon?
 - No

**Updates to Planned Work**
- Creation of Photo Upload Issues Pending

**Updates to Important Dates / Deadlines**
- NA

**General Notes**
- NA

---

***Sprint 2 Development Plan (Monday, May 21st 2012 - Friday, June 1st, 2012)***

Iteration Milestone - https://github.com/twotoasters/GTIO-iOS/issues?milestone=2&state=open

**Planned Work**

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

**Important Dates / Deadlines**

- Memorial Day - 5/28

**Open Questions**

- 1.7 API for photo upload - Does the user ever upload their own icon?
- 7.3 - where does the list of profile icon options come from?
- When can we expect mockups for burst mode / updates to functional spec?

**Risks**

- NA

**General Notes**

- TT - Verify that all assets for planned Issues are available.  If any designs are missing, schedule a due date with GTIO on 5/28 standup
- TT - Verify all required API endpoints are available.

**Sprint Deliverables**

- Miletone build with completed issues delivered 6/1

---

***Friday, May 18th - Standup / Retrospective Notes***

**Attendees**

- TT - Matt, Scott
- GTIO - Simon, Matt

**Tasks / To Do List**
- GTIO - when returning to the application from FB login, a splash screen is displayed briefly
 - Need to define behavior for this and other transitions
- TT - Assist Simon with Testflight setup

**Status**
- Outstanding development pushed to Sprint 2
 - Tracking items have
 - Hide the bottom bar on login screen
 - Facebook auth token and rested object
 - email support
- Findings from Janrain research - We are able to utilize custom views
- Tentative plan for next week
 - Photo upload
 - complete Janrain / almost done screens - check with GTIO on Monday, possibly find other work to perform in Sprint 2

**Planned Work Delivered**
- 48 - UI Tab Bar
- 40 - 1.1 Splash Screen
- 39 - Filter Standalone Application
- 49 - Tab Bar Animation
- 47 - 1.10 Facebook SSO
- 46 - 1.9 Sign-in (2nd load)
- 45 - 1.6 Failed Sign-in
- 42 - 1.3 Sign0in Screen (1st use)
- 31 - 1.2 Intro Screens

**Planned Work Pushed to Next Sprint**
- 43 - Returning Users

**Sprint Retrospective**
- All major effort planned delivered on time
- Going forward, break down larger stories into smaller ones to help identify any outstanding requirements on Issues, especially for Issues planned for development later on in the Sprint

---

***Thursday, May 17th - Standup Notes***

**Attendees**

- TT - Matt, Scott
- GTIO - Simon, Matt, Scott

**Tasks / To Do List**
- TT - provide preliminary development schedule for sprint 2
- GTIO - Provide new assets for Nav Bar with padding.  This change applies to all new nav assets
- GTIO - Provide list of recipients for initial builds

**Status**
- Created custom view for returning users instead of utilizing Janrain SDK.  Need to investigate how much work is involved into customizing standard Janrain screen.  This also applies to New User / Other Providers screen.  This additional work requires the delivery of the feature to be pushed to Sprint 2.
- UI Nav Bar has to be 44 pixels, instead of 40.  This requires a significant development effort.
 - Solution: Provide assets that are 44 pixels in height, but bottom 4 buttons are transparent. Avoid changing height of the bar itself.

**Updates to Planned Work**
- 43 - Returning Users Issue will be pushed to Sprint 2

**Updates to Important Dates / Deadlines**
- NA

**General Notes**
- NA

---

***Wednesday, May 16th - Standup Notes***

**Attendees**

- TT - Matt, Scott
- GTIO - Simon

**Tasks / To Do List**
- TT - provide preliminary development schedule for sprint 2

**Status**
- Working on sign in animations
- Add 1.9 to login flow
- Complete styling on 1.2

**Updates to Planned Work**
- NA

**Updates to Important Dates / Deadlines**
- NA

**General Notes**
- NA

---

***Monday, May 14th - Standup Notes***

**Attendees**
- TT - Matt, Scott
- GTIO - Simon

**Tasks / To Do List**
- TT - Begin styling, facebook login
- GTIO - Add documentation for Facebook permissions
- GTIO - push assets for 1.3,1.4,1.5,1.6,1.9 

**Updates to Planned Work**
- NA

**Updates to Important Dates / Deadlines**
- Scott out of the office tommorow, May 15th

**General Notes**
- Tracking on Images - previously utilized a URL, now using ID/Page Number
- Moving forward, Config endpoint to include intro images

---

***Friday, May 11th - Standup / Retrospective Notes***

**Attendees**
- TT - Matt, Scott
- GTIO - Simon

**Tasks / To Do List**
- TT - Tag GTIO v3 branch and mark as legacy
- TT - Merge all open v4 branches into Master
- TT - Research burst photos / how fast photos can be taken
- GTIO - Complete designs due today
- TT - Come up with travel dates for Simon to return to NC during Sprint 2

**Updates to Planned Work**
- NA

**Updates to Important Dates / Deadlines**
- NA

**General Notes**
- Completed splash screen functionality.  waiting for code review
- Filter tentatively pushed back to Sprint 3
- New requirements for Photo upload introduced, slotted for Sprint 2

**Week Retrospective**
- Additional time spent on standalone application, but task has been completed
 - GTIO - Taking standalone a huge success
- UITabbar has been completed
- Splash screen - end points are being hit, loading animations visible
- Next steps, sign in and page controls
- API integration has been painless thus far
- Design delays may be forthcoming at the end of Sprint 1
- Overall, on track to deliver on all planned stories

---

***Thursday, May 10th - Standup Notes***

**Attendees**
- TT - Matt, Scott
- GTIO - Simon, Matt

**Tasks / To Do List**
- TT - Inform Simon one JSON content is posted
- GTIO - Prepare delivery of Edit Profile assets
- TT - Look into Slider implementation options (Matt.gtio's email)
- GTIO - Push changes to filters to branch.
- TT - Work on filter optimization

**Updates to Planned Work**
- Hit Track API in background after Config and user/me
- Additional work on Filters - Optimization 

**Updates to Important Dates / Deadlines**
- NA

**General Notes**
- NA

---

***Wednesday, May 9th - Standup Notes***

**Attendees**
- TT - Matt, Scott
- GTIO - Simon, Matt

**Tasks / To Do List**
- GTIO - Review Filter application after today's standup
- TT - Scott to research possibilities around prompting for location a second time after a user denies access
- GTIO - Add mockups for 1.1 and 1.2 to Functional Spec

**Updates to Planned Work**
- NA

**Updates to Important Dates / Deadlines**
- NA

**General Notes**
- is it possible to reask for location permission after a user denies access?

---

***Tuesday, May 8th - Standup Notes***

**Attendees**
- TT - Matt, Scott
- GTIO - Simon, Matt

**Tasks / To Do List**
- GTIO - Review Filter Standalone app and provide feedback
- TT - Create directory for cut assets.  GTIO to use new directory for designs going forward
- TT - Continue testing custom fonts / Dynamic multiline.  Provide screenshots to showcase spacing
- TT/GTIO - debug code signing error on filter app

**Updates to Planned Work**
- NA

**Updates to Important Dates / Deadlines**
- Assets for 1.1, 1.2 on 5/9

**General Notes**
- Buttons delivered for UITab Bar
- Photo Upload mockups near complete, assets have not been cut.  Work will be continued on during the next iteration based on design priority
- Design specifications in functional spec is perfect.  Please continue to do this!
 - Add additional detail to distinguish between 1x and 2x

---

***Monday, May 7th - Standup Notes***

**Attendees**
- TT - Matt, Scott
- GTIO - Simon, Matt

**Tasks / To Do List**
- TT - Wrap up Filter application, Write basic documentation
- TT - Start working on implementing endpoints as listed in Functional Spec
- GTIO - Make update tweaks and changes as necessary with Scott
- GTIO - Update complete design schedule
- GTIO - Continue to updated API / Functional Spec on features planned in Iteration 1
- GTIO - Supply Dev/Staging Environment URL, HTTP authrequirements

**Updates to Planned Work**
- 49 - Animation will implemented as a proof of concept

**Updates to Important Dates / Deadlines**
- Designs for 13.1, 13.4 will be delivered by EOB 5/7
- Designs for Splash, Intro screens by EOB 5/8
- Designs for Sign in, Sign up by EOB 5/11

**General Notes**
- Endpoints Required for Iteration 1 are already live on Dev

---

***Iteration 1 Sprint Plan (Monday, May 7th 2012 - Friday May 18th, 2012)***

Iteration Milestone - https://github.com/twotoasters/GTIO-iOS/issues?milestone=1&state=open

**Planned Work**

- 39 - Image Filter Standalone Application
- 40 - 1.1 Splash Screen
- 41 - 1.2 Intro Screens
- 42 - Sign in Screen (first use)
- 43 - Returning Users
- 45 - Failed Sign in
- 46 - 1.9 Sign in Screen (second load)
- 47 - Facebook SSO
- 48 - 13.1 UITabBar
- 49 - 13.2 UITabBar Animation


**Important Dates / Deadlines**

- Photo Upload Design - Due 5/7
- Welcome Screen, 13.1, 13.4 - Due 5/7
- Scott out of office on  - 3/15
- API Due Dates TBD

**Open Questions**

- When will login screen assets be delievered?
- When can we expect the following endpoints?
 - Config
 - Sign in / sign up
 - User/Auth
 - User/Auth/Facebook

**Risks**
- API Endpoint due dates are unknown
- Early design deadlines

**General Notes**

- Future API questions - Ask in email, update functional spec with answer/example 

**Sprint Deliverables**

- Standalone Filter Application
- Demo build of application with planned features

---

**Strategy Session 4/30**

**To Do**

- TT - Look at the URL library.
- TT - Put together a demo of camera filter libraries that the GTIO team can look at and see which ones they like.
- GTIO - Put which pages need tracking in spec

**Notes**

- Ask existing users to login again on upgrade
- Prompt user for location by gps on sign up.
- Remove crittercism and add TestFlight for crashes

---

**Strategy Session 4/25**

**To Do**

- GTIO - Add API specifications based on the following priority
 - User Auth
 - Custom Tab Bar
 - Photo Upload
- TT - Investigate general questions 1 & 2 from functional spec
- TT/GTIO - Continue discussion around messaging / popups 
- TT - Investigate app specific ID.  What happens when user gets new phone? formats device? etc
- GTIO - Continue updating functional spec with wireframe images.
       - Add additional detail to screens from v3
       - Revise section 3.6
       - Correct formatting (bullets, nesting)
       - Fix image link for 4.6.1
       - Facebook invite - Add details from v3 for posting on wall
       - 6.4 - Initial view is a search box
       - Add secton for pagination
       - Add secton for popup messages
       - 8.1 when list is visible, tapping outside of the list will perform the action and close the list
       - Open all HTTP links in 10.4
       - 13.1 - Prefer all history is saved. TT to investigate difficulty
       - 13.3 - Prefer errors wrapped in object with attributes
- GTIO - Discuss interally regarding dialog for address book use
- TT - Provide information on creating screen flow document
- GTIO - Screen flow diagram due 4/30

**Notes**

- General question #3 - on the simpler side to implement due to screen resue
- General question #4 - no issue in having Setting page as webview.  Passing notification token as plain text should not be an issue
- General question #5 - Minor work around custom popups.  should be detailed out in functional spec
- Custom loading overlay is possible.  Need individual png for each frame in the animation


---