## Version History
- 2012-02-28 Justin Marshall - Initial Version
---

### General Questions
	This doc is in reference to the changes for the GTIO 3.4.1 release only.  All other functional questions should reference prior specs delivered from GTIO to TwoToasters or should be asked of Simon Holroyd (simon@gotryiton.com) or Matt Varghese (matt@gotryiton.com)

1. What will happen when a User creates an account with Facebook?
	- **NOTE:** This question is answered in section 1.1 Creating an Account with Facebook, story "When a User goes to their settings, they should be able to turn on and off Facebook sharing"

2. What will happen if a User is NOT signed in with Facebook: ie using Twitter, Google etc?
	- **NOTE:** This question is answered in section 2.1 Settings Page, story "When a User goes to their settings, they should be able to turn on and off Facebook sharing"  

3. What will happen if a User changes the options in settings after already completing prior Product Suggestions
	- **NOTE:** This question is answered in section 2.1 Settings Page, story "When a User goes to their settings, they should be able to turn on and off Facebook sharing"  

### Minimum requirements for iOS App
	Supported devices/os versions should be listed here
- iOS 4
- iOS 5
- All standard devices and iOS versions agreed to with Rachit and Matt last year should still apply

---

## 1. 3.4.1 Development Spec

### 1.1 Creating an Account with Facebook

#### Overview

Users will see a revised Sign In screen with copy changes under the "sign in using Facebook" button (1.1.a). When a new User creates an account with Facebook, they will see two Request for Permission screens (1.1.b and 1.1.c).

### Screen Mockups
**1.1.a** Revised copy on Sign In Screen:

<img src="http://assets.gotryiton.com/img/spec/3.4.1/1/1.1.a._login_fb_copy.png" width="240px">

**1.1.b** Request for Permission Screen on First Login:

<img src="http://assets.gotryiton.com/img/spec/3.4.1/1/1.1.b.permissions-screen-on-first-login.jpg" width="240px">
 

**1.1.c** Request for Permission Second Screen:

<img src="http://assets.gotryiton.com/img/spec/3.4.1/1/1.1.c.permissions_second%20screen.png" width="240px"> 

#### Stories

- A User will see a revised Sign In screen
   - The revised copy underneath the Facebook button should be justified center and read:
**"you can sign in with Facebook and still remain completely anonymous if you like.**
**… and we'll NEVER share your activity to your network without your consent."**

- A User creates an account with Facebook
   - After tapping the "sign in with Facebook" button, the User will be redirected to Facebook, which will ask permission from the User to share their "Product Suggestions" activity on Facebook (see Project Functional Spec for V3.4), and select who can see them (1.1.b). 
   - After tapping "log in" in Facebook, a second Optional Permission screen allows Users to opt-in to additional permissions (1.1.c). 


### 1.2 Already Logged in With Facebook

#### Overview

When a User has already created a GO TRY IT ON account with Facebook prior to the 3.4.1 update, they will see a revised Permission Screen asking for permission to allow GO TRY IT ON to share "Product Suggestions" they make on Facebook.

### Screen Mockups
**1.2** Permission Second Login Screen:

<img src="http://assets.gotryiton.com/img/spec/3.4.1/1/1.2.permissions_screen%20on_2nd_login.png" width="240px"> 

### 2.1 Settings Page

#### Overview

The Settings Page of a logged in User should now include an 'ON/OFF' toggle button in a menu list titled "Facebook Share Settings" (2.1.a). This menu list will come directly after the "Email + alert me" menu, and before the "need assistance" copy/links. The ON or OFF state of this button is dependent firstly on if permission was given the Facebook "Request for Permission" screens (1.1.a, 1.1.b, 1.2).

### Screen Mockups
**2.1.a** updated default Settings Page:

- **CREATIVE NOTE:** Though it is not indicated in this mockup, the patterned bg should continue to the bottom of the screen and not be cut off.

<img src="http://assets.gotryiton.com/img/spec/3.4.1/1/2.1.a.jpg" width="240px"> 


**2.1.b** Toggle Button in the OFF position:

<img src="http://assets.gotryiton.com/img/spec/3.4.1/1/2.1.b.jpg" width="240px"> 

#### API usage

- Like other settings in the settings panel, the Facebook share setting should be toggled via the /rest/v4/user endpoint
- the /rest/v4/user/ endpoint will now return a boolean facebookSuggestionShare, which should map to the toggle switch
- if in the /rest/v4/user/ object isFacebookConnected = false, the toggle switch should not be shown at all

#### Stories

- When a User goes to their settings, they should be able to turn on and off Facebook sharing
   - If the user has not authenticated through Facebook, they should NOT see this toggle switch and accompanying text at all

   - If the User has authenticated through Facebook and given permission to post Product Suggestion activity to Facebook, the switch should be in the ON state. A User should be able to turn OFF sharing Product Suggest activity on Facebook by tapping the toggle switch. All their past Product Suggestions will remain in their Facebook Activity.

   - If the User has authenticated through Facebook, and has NOT given permission to post Product Suggestions activity to Facebook, the switch should be in the OFF state. A User should be able to turn ON sharing Product Suggestion activity on Facebook by tapping the toggle switch. When they toggle the switch, they should be redirected to the 2nd Request Permission screen (1.1.b) and all options should be allowed. After a User taps, "Allow All", they should be brought back to the Settings screen (2.1). All their past Product Suggestions will remain hidden from their Facebook Activity.

### 3.1 Posting to Facebook

#### Overview

When a User has given permission for GO TRY IT ON to share their Product Suggestion activity to Facebook, the App will comply with who they have allowed to see this activity and post accordingly to Facebook (1.1.a).