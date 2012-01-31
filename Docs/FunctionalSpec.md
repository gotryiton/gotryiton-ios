# Project Functional Spec

## Version History
- 2012-01-31 Simon Holroyd - Initial Version

---

### General Questions

	This doc is in reference to the changes for the GTIO 3.4 release only.  All other functional questions should reference prior specs delivered from GTIO to TwoToasters or should be asked of Simon Holroyd (simon@gotryiton.com) or Matt Varghese (matt@gotryiton.com)

1. 

### Minimum requirements for iOS App
	Supported devices/os versions should be listed here
- iOS 4
- iOS 5
- All standard devices and iOS versions agreed to with Rachit and Matt last year should still apply

---

## 1. 3.4 Development Spec

### 1.1 Outfit Page

#### Overview

The Outfit page should now include a 'suggest' button in the outfit details expanded view (1.1.b).  The unexpanded default view is unchanged (1.1.a).

#### Screen Mockups

1.1.a default outfit page:
<img src="https://github.com/twotoasters/GTIOv3/tree/master/Docs/Mockups/picker-7-outfit-page-default-unchanged.png" width="240px">

1.1.b outfit dettails expanded view:
<img src="https://github.com/twotoasters/GTIOv3/tree/master/Docs/Mockups/picker-7-outfit-page-expanded.png" width="240px">


#### Tracking Usage

- Track button clicks on 'suggest' Flurry as 'Suggest Button'

#### Stories

- The user expands the outfit page details and is presented with a 'suggest' button
	- The user taps suggest and has already logged in and is routed to (2.1 WebView Picker)
	- The user taps suggest and is not logged in and is routed to (1.2 Login View)

### 1.2 Login View

#### Overview

The login view is exactly the same as when a user attempts to review when not logged in.  The end result of the login process should be to return the user into the standard flow (ie. redirect them to 1.3 WebView Picker)

<!-- ### 2.1 WebView Picker Default view

#### Overview

The iOS app should spawn a webview with custom top nav bar and hidden bottom nav bar.  The webview loads a GTIO page which will communicate with the native app, modify the top and bottom nav bars and trigger API requests.

#### Screen Mockups

2.1.a initial webview picker mockup
<img src="https://github.com/twotoasters/GTIOv3/tree/master/Docs/Mockups/picker-7-outfit-page-default-unchanged.png" width="240px">
<img src="https://github.com/twotoasters/GTIOv3/tree/master/Docs/Mockups/picker-7-outfit-page-expanded.png" width="240px">

#### API Usage

- 

#### JavaScript & gtio:// Interactions

- gtio://recommend/[product_id]
	-When the webview container redirects to this gtio-url:
		- the user is routed to 1.x
		- the iOS native app submits an API request using the product_id 



#### Tracking Usage

- Track button clicks on 'suggest' Flurry as 'Suggest Button'

#### Stories

- The user first arrives on the webview picker and sees a custom top nav bar
	- The title of the nav bar is 'RECOMMEND'
	- The back button of the nav bar is 'reviews' shaped as a standard back button
	- The user taps on 'reviews' and is taken back to either view 1.1 (outfit page) or view 1.x (reviews page)
	- The top right button of the top nav bar is a button that has text ('for') and a thumbnail (the outfit thumbnail)
	- The outfit thumbnail should be drawn from the Outift->smallThumb url provided as part of the Outfit API response
	- The user taps on the 'for' button and is shown a full screen overlay of the outfit image (drawn from Outfit->mainImg)
		- The behavior of the full scren view should be the same as when a user taps on a outfit thumnail in 3.1.x (thunbnail 1 for instance)
- The user first arrives on the webview picker and sees no bottom nav bar
- The user scrolls or drags or reorients the webview picker and the position of the page should stay fixed in portrait mode
	- If the user drags the 'search' bar for instance, the webview page should not move
	- If the user drags internal scrollable elements, they should scroll within the selected html div (if a user drags the 'shopbop' logo left and right, the row should scroll left and right)
	- If the user turns their phone, the webview picker and native page should stay in portrait mode



 -->