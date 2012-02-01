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

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-7-outfit-page-default-unchanged.png" width="240px">

1.1.b outfit details expanded view:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-7-outfit-page-expanded.png" width="240px">

#### Tracking Usage

- Track button clicks on 'suggest' Flurry as 'Suggest Button'

#### Stories

- The user expands the outfit page details and is presented with a 'suggest' button
	- The user taps 'suggest' and has already logged in and is routed to (2.1 WebView Picker)
	- The user taps 'suggest' and is not logged in and is routed to (1.2 Login View)

### 1.2 Login View

#### Overview

The login view is exactly the same as when a user attempts to review when not logged in.  The end result of the login process should be to return the user into the standard flow (i.e. redirect them to 2.1 WebView Picker)

### 1.3 Reviews page

#### Overview

The iOS app should spawn a webview with custom top nav bar and hidden bottom nav bar.  The webview loads a GTIO page which will communicate with the native app, modify the top and bottom nav bars and trigger API requests.

#### Screen Mockups

1.3.a reviews page:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-6-review-page.png" width="240px">

1.3.b reviews page showing comments with recommendations:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-5-recommendation-submitted.png" width="240px">

1.3.c reviews page, submitting a review (single outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-6-review-page-keyboard-up.png" width="240px">

1.3.d reviews page, submitting a review (multiple outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-6-review-page-mult-keyboard-up.png" width="240px">

1.3.e reviews page, submitting recommendation (short product image) (single outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-5-submitting-rec-single-short.png" width="240px">

1.3.f reviews page, submitting recommendation (tall product image) (single outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-5-submitting-rec-single-tall.png" width="240px">

1.3.g reviews page, submitting recommendation (short product image) (multiple outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-5-submitting-rec-mult-short.png" width="240px">

1.3.h reviews page, submitting recommendation (tall product image) (multiple outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-5-submitting-rec-mult-tall.png" width="240px">

#### API Usage

- ***I HAVE NO IDEA***

#### JavaScript & gtio:// Interactions

- gtio://recommend/[product_id]
	-When the webview container redirects to this gtio-url:
		- the user is routed to 1.x
		- the iOS native app submits an API request using the product_id 



#### Tracking Usage

- ****TRACKING USAGE*****

#### Stories

- The user should see an overlaid dark area with a custom 'suggest a product for this look' button at the bottom of the reviews page (screen 1.3.a)
	- The button should bring you to (2.1 WebView Picker)
	- The button should have custom on and off states
- The user should see standard reviews as well as reviews that include product suggestions, in the form of a 'suggested for this look!' banner, an image of a product, a product description, brand, and price (screen 1.3.b)
	- ******details*****
- The user should see a custom control bar directly above the keyboard when submitting a review (screens 1.3.c, 1.3.d)
	- The bar should have a custom background texture, border and drop shadow
	- The bar should have a custom button on the left with an icon which brings the user to (2.1 WebView Picker)
		- This button should have custom on and off states
	- The bar should have a stylized arrow and text on it saying 'add a product suggestion!'
	- The bar should have a custom button on the right labeled 'done!' which submits the review
		- This button should have exactly the same function as the iOS keyboard's 'done' button
			- This button should have custom on and off states
- A user should see a preview of their recommendation after selecting a product from the (2.1 WebView Picker) (screens 1.3.e, 1.3.f, 1.3.g, 1.3.h)
	- The review text area should already be selected, and keyboard should be popped
	- The prefilled text should read "add a comment about this, or just hit 'done'!"
	- The preview should have a banner reading 'suggested for this look!'
	- The preview should have a product description
	- The preview should have a brand
	- The preview should have a price
	- The preview should have a close button which disappears the preview
	- The preview will have two different widths depending on whether the outfit is a single or multiple
	- The preview will have a minimum height that is determined by the area needed to show product info
	- The preview will have a maximum height that is determined by the height of the product image
	- The user should be able to submit the 'review' without entering any text, or optionally entering text
	- The user should be presented with a confirmation dialog if they attempt to close the review page at this stage
		- The dialog should have a title of 'wait!'
		- The dialog comment first line should read 'suggest this product'
		- The dialog comment second line should read 'without a comment?'
		- The dialog should allow the user to either 'cancel' or 'yes'
			- 'yes' should submit the recommendation without any review text included
			- 'cancel' should bring the user to the front of the outfit page without submitting anything


### 2.1 WebView Picker Default view

#### Overview

The iOS app should spawn a webview with custom top nav bar and hidden bottom nav bar.  The webview loads a GTIO page which will communicate with the native app, modify the top and bottom nav bars and trigger API requests.

#### Screen Mockups

2.1.a webview picker, initial view:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-1-default-1.png" width="240px">

2.1.b webview picker, manually browsing:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-4-manual-on.png" width="240px">

#### API Usage

- 

#### JavaScript & gtio:// Interactions

- gtio://recommend/[product_id]
	-When the webview container redirects to this gtio-url:
		- the user is routed to 1.x
		- the iOS native app submits an API request using the product_id 



#### Tracking Usage

- ****TRACKING USAGE*****

#### Stories

- The user first arrives on the webview picker and sees a custom top nav bar
	- The title of the nav bar is 'SUGGEST'
	- The back button of the nav bar is 'reviews' shaped as a standard back button
	- The user taps on 'reviews' and is taken back to their original entrance point - either view 1.1 (outfit page) or view 1.x (reviews page)
	- The top right button of the top nav bar is a button that has text ('for') and a thumbnail (the outfit thumbnail)
	- The outfit thumbnail should be drawn from the Outift->smallThumb url provided as part of the Outfit API response
	- The user taps on the 'for' button and is shown a full screen overlay of the outfit image (drawn from Outfit->mainImg)
		- The behavior of the full scren view should be the same as when a user taps on a outfit thumnail in 3.1.x (thunbnail 1 for instance)
- The user first arrives on the webview picker and sees no bottom nav bar
- The user scrolls or drags or reorients the webview picker and the position of the page should stay fixed in portrait mode
	- If the user drags the 'search' bar for instance, the webview page should not move
	- If the user drags internal scrollable elements, they should scroll within the selected html div (if a user drags the 'shopbop' logo left and right, the row should scroll left and right)
	- If the user turns their phone, the webview picker and native page should stay in portrait mode

