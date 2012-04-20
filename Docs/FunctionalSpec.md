# GTIO Functional Spec

## Version History
- 2012-04-20 - Scott Penrose - Initial Version

---

### General Questions

	Good place to place general questions and mark assumptions on the general functional spec of the application these 
	should be brought up with the client and clarified as well as documented here.

### Deployment Targets
	Supported devices/os versions should be listed here
- iOS 5.0+

---

## 1. Initial user experience 

### 1.1 Launch Splash Screen

#### Overview

Default launch screen is a static Default.png loaded at app launch. And then displayed for 3 seconds after the application has loaded.

#### Mockups

<img src="https://github.com/twotoasters/project-example/raw/master/Design/Mockups/Default.png" width="240px">

#### API Usage

- None.

#### Stories

- The user launches the app and is presented with a default launch screen
	- The user has already logged in and is routed to (1.2 Home)
	- The user is not logged in and is routed to (1.3 Login)
	
- The user launches the app and is routed to (1.2 Home), but the Access Token has expired or has been revoked.
	- The user is returned to 1.1 and then sent to (1.3 Login)
