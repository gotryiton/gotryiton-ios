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