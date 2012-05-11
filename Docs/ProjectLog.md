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