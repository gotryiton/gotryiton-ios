# Project Functional Spec

## Version History
- 2012-01-31 Simon Holroyd - Initial Version
- 2012-01-31 Matt Varghese - Initial Version Part Deux
- 2012-01-31 Simon Holroyd - Initial Version Part III
---

### General Questions

	This doc is in reference to the changes for the GTIO 3.4 release only.  All other functional questions should reference prior specs delivered from GTIO to TwoToasters or should be asked of Simon Holroyd (simon@gotryiton.com) or Matt Varghese (matt@gotryiton.com)

1. What happens if the "suggest this" button is hit (Section 2.1, view 2.1.b) before the API request to /rest/v4/scrape has returned a productId
	- options:
		- disable the button until the API has responded (maybe show a spinner?)
		- allow the user to move to Section 3.2 anyway
			- let the API request finish asynchronously
			- populate the recommendation preview once the API has responded
			- prevent the user from submitting a review until the request has finished
	- **NOTE:** This question is answered but is pending design and technical direction to be added to the document

2. How easy is it to customize the nav bars in view 2.1.b based on the response of the /rest/v4/scrape response?  We'd ideally like to be able to have that response:
	- make the 'suggest this' button active or inactive
	- show a thumbnail in the bottom nav area (Product->thumbnail)
	- show a product name (Product->productName)
	- customize the top nav bar title area (view 2.1.b has 'm.shopbop.com' as the title, we'd like this to be the Product->brand field if possible)
		- the title in the top nav might need to be static if this is not feasible
		- if not feasible, use 'suggest' as the title throughout
	- **NOTE:** This question is answered but is pending design and technical direction to be added to the document

3.  When a user leaves the reviews page with a recommendation selected (hits 'cancel' in view 3.2.e), what happens to the recommendation?  
	- **NOTE:** this question has been answered.  See Story "The user should be presented with a confirmation dialog"

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

**1.1.a** default outfit page:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-7-outfit-page-default-unchanged.png" width="240px">

**1.1.b** outfit details expanded view:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-7-outfit-page-expanded.png" width="240px">

#### Tracking Usage

- Track button clicks on 'suggest' Flurry as 'Suggest Button'

#### Stories

- The user expands the outfit page details and is presented with a 'suggest' button
	- The user taps 'suggest' and has already logged in and is routed to (2.1 WebView Picker)
	- The user taps 'suggest' and is not logged in and is routed to (1.2 Login View)
	- If the user is the outfit owner, they are *NOT* presented with the 'suggest' button
	- If the user is the outfit owner, they are presented with a 'tools' button (as is in the current app)

### 1.2 Login View

#### Overview

The login view is exactly the same as when a user attempts to review when not logged in.  The end result of the login process should be to return the user into the standard flow (i.e. redirect them to 2.1 WebView Picker)

### 2.1 WebView Picker Default view

#### Overview

The iOS app should spawn a webview with custom top nav bar and hidden bottom nav bar.  The webview loads a GTIO page which will communicate with the native app, modify the top and bottom nav bars and trigger API requests.

#### Screen Mockups

**2.1.a** webview picker, initial view:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-1-default-1.png" width="240px">

**2.1.b** webview picker, manually browsing:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-4-manual-on.png" width="240px">

#### API Usage

- BROWSING: On each change in webview url the native iOS api should make an API request
	- The request endpoint is: /rest/v4/scrape
	- The api request should include the parameters:
		- gtioToken
		- url (the url that the webview controller has navigated to)
	- The api request will respond with:

```
product{ 
			id, // (product id)
			brand, 
			productName,
			price  // ($ will be included in the price response)
			buyUrl,
			thumbnail, 
			description	
		} 
```

	- This product response should be saved and used to populate the data for the story "A user should see a preview of their recommendation" in Section 3.2
	- This product id should be saved and used to populate productId parameter in the API request for submitting reviews in Section 3.2

- RECOMMENDING: When gtio://recommend/[product_id] is navigated to in the webview, the api should make an API request
	- The request endpoint is: /rest/v4/product/[productId]
		- **NOTE** this endpoint changed in name on 2.1.12
	- The request response is:

```
product{ 
			id, // (product id)
			brand, 
			productName,
			price  // ($ will be included in the price response)
			buyUrl,
			thumbnail, // (variable height, maximum width of 384px)
			description	
		} 
```

	- This product response should be saved and used to populate the data for the story "A user should see a preview of their recommendation" in Section 3.2
	- This product id should be saved and used to populate productId parameter in the API request for submitting reviews in Section 3.2

#### JavaScript & gtio:// Interactions

- gtio://recommend/[product_id]
	- When the webview container redirects to this gtio-url:
		- the user is routed to view 3.2.a
		- the iOS native app submits an API request using the product_id 
- gtio:://recommend/bottomNav/hide
	- When the webview container redirects to this url:
		- the bottom nav is hidden
- gtio:://recommend/bottomNav/show
	- When the webview container redirects to this url:
		- the bottom nav is shown

<!-- - gtio://recommend/topNav/default
	- When the webview container redirects to this -->


#### Stories

- The user first arrives on the webview picker and sees a custom top nav bar
	- The title of the nav bar is 'SUGGEST'
	- The back button of the nav bar is 'reviews' or 'outfit' depending on the user's entrance point (either view 1.1.a or 3.1.a)
	- The user taps on 'reviews' and is taken back to their original entrance point - either view 1.1 (outfit page) or view 3.1.a (reviews page) or view 3.1.c/d (submitting a review)
	- The top right button of the top nav bar is a button that has text ('for') and a thumbnail (the outfit thumbnail)
	- The outfit thumbnail should be drawn from the Outift->smallThumb url provided as part of the Outfit API response
	- The user taps on the 'for' button and is shown a full screen overlay of the outfit image (drawn from Outfit->mainImg)
		- The behavior of the full scren view should be the same as when a user taps on a outfit thumnail in 3.1.a/b/c/d 
- The user first arrives on the webview picker and sees no bottom nav bar
- The user scrolls or drags or reorients the webview picker and the position of the page should stay fixed in portrait mode
	- If the user drags the 'search' bar for instance, the webview page should not move
	- If the user drags internal scrollable elements, they should scroll within the selected html div (if a user drags the 'shopbop' logo left and right, the row should scroll left and right)
	- If the user turns their phone, the webview picker and native page should stay in portrait mode
- The user taps on "suggest this" in the bottom nav, they should be taken to the reviews page (view 3.2.a/f/g/h)

### 3.1 Reviews page

#### Overview

The Reviews page should now allow users to move to the suggest screen (2.1 webview) via a suggest button at the bottom of the screen.  The reviews page should also allow a user to read reviews with recommended products attached.  

#### Screen Mockups

**3.1.a** reviews page:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-6-review-page.png" width="240px">

**3.1.a.i** reviews page scrolled to bottom:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/spec-reviews-bottom.png" width="240px">

**3.1.b** reviews page showing comments with recommendations:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-5-recommendation-submitted.png" width="240px">

	- **NOTE:**  Bottom 'suggest a product for this look' button removed to show full recommendation item for the purposes of this screenshot.  The button *should* appear in this view.

**3.1.c** reviews page, submitting a review (single outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-6-review-page-keyboard-up.png" width="240px">

**3.1.d** reviews page, submitting a review (multiple outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-6-review-page-mult-keyboard-up.png" width="240px">

#### API Usage

- Existing Reviews should be requested as before 
	- Reviews should be requested from:
		- /rest/v4/reviews/[outfit_id]
	- The reviews api request should include:
		- gtioToken
	- The reviews api response will include:

```
reviews {
	[
		outfitId,
		userId,
		text, // (the text of the review)
		agreeVotes, // (the number of existing review agree votes)
		id, // (id of the review)
		timestamp (unixtime)
		user {
			badges [
				{
					since,
					imgURL
				}
			]
			displayName,
		    isBrand, // (boolean representing whether or not the review gets a verified marker)
		    location,
		    profileIcon,

		},
		uid,
		product{ // (OPTIONAL)
			id, // (product id)
			brand, 
			productName,
			price  // ($ will be included in the price response)
			buyUrl,
			thumbnail, // (variable height, maximum width of 384px)
			description	
		} 
	]
}
```
				
- Reviews should be submitted as before 
	- Upon submission of a review, the iOS application should send data to:
		- /rest/v4/review/[outfit_id]
	- The reviews api request should include these parameters:
		- gtioToken (the active token for the logged-in user)
		- reviewText (the text of the review)

#### Tracking Usage


#### Stories

- The user should see an overlaid dark area with a custom 'suggest a product for this look' button at the bottom of the reviews page (screen 3.1.a)
	- The button should bring you to (2.1 WebView Picker)
	- The button should have custom on and off states
- The user should see standard reviews as well as reviews that include product suggestions, in the form of a 'suggested for this look!' banner, an image of a product, a product title, brand, and price (screen 3.1.b)
	- The image of the product should be pulled from Reviews->review->product->thumbnail
	- The product title should be pulled from Reviews->review->product->productName
	- The product brand should be pulled from Reviews->review->product->brand
	- The product price should be pulled from Reviews->review->product->price
	- The click url should be pulled from Reviews->review->product->buyUrl
	- The 'verified' corner icon should appear in the same way it does for existing reviews (based on the boolean Reviews->review->isBrand)
	- The right margin of the product title, product brand, and price should be the same as the review text right margin
- The user should be taken to a standard in-app webview with the url:buyUrl when they tap on the product (as if it were any other link in a review)
	- The tap area for this button is the photo and text characters (the tap area should not extend the width of the view unless the text does)
- The user should see a custom control bar directly above the keyboard when submitting a review (screens 3.1.c, 3.1.d)
	- The bar should have a custom background texture, border and drop shadow
	- The bar should have a custom button on the left with an icon which brings the user to (2.1 WebView Picker)
		- This button should have custom on and off states
	- The bar should have a stylized arrow and text on it saying 'add a product suggestion!'
	- The bar should have a custom button on the right labeled 'done!' which submits the review
		- This button should have exactly the same function as the iOS keyboard's 'done' button
			- This button should have custom on and off states
- The user should *NOT* be able to submit the 'review' without entering any text



### 3.2 Reviews page with attached recommendation

#### Overview

The reviews page should allow a user to complete and submit a recommendation (with or without a review attached).  This view should otherwise have all the same behavior as 3.1 (except where detailed otherwise)

#### Screen Mockups

**3.2.a** reviews page, submitting recommendation (short product image) (single outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-5-submitting-rec-single-short.png" width="240px">

**3.2.b** reviews page, submitting recommendation (tall product image) (single outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-5-submitting-rec-single-tall.png" width="240px">

**3.2.c** reviews page, submitting recommendation (short product image) (multiple outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-5-submitting-rec-mult-short.png" width="240px">

**3.2.d** reviews page, submitting recommendation (tall product image) (multiple outfit):

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-5-submitting-rec-mult-tall.png" width="240px">

**3.2.e** reviews page, closing reviews page with recommendation selected:

<img src="https://github.com/twotoasters/GTIOv3/raw/master/Docs/Mockups/picker-5-submitting-rec-single-tall-close-page.png"  width="240px">


#### API Usage

- Existing Reviews should be requested as before 
	- Reviews should be requested from:
		- /rest/v4/reviews/[outfit_id]
	- The reviews api request should include:
		- gtioToken
	- The reviews api response will include:

```
reviews {
	[
		outfitId,
		userId,
		text, // (the text of the review)
		agreeVotes, // (the number of existing review agree votes)
		id, // (id of the review)
		timestamp (unixtime)
		user {
			badges [
				{
					since,
					imgURL
				}
			]
			displayName,
		    isBrand, // (boolean representing whether or not the review gets a verified marker)
		    location,
		    profileIcon,

		},
		uid,
		product{ // (OPTIONAL)
			id, // (product id)
			brand, 
			productName,
			price  // ($ will be included in the price response)
			buyUrl,
			thumbnail, // (variable height, maximum width of 384px)
			description	
		} 
	]
}
```
				
- Reviews should be submitted as before with one additional parameter, productId
	- Upon submission of a review, the iOS application should send data to:
		- /rest/v4/review/[outfit_id]
	- The reviews api request should include these parameters:
		- gtioToken (the active token for the logged-in user)
		- reviewText (the text of the review)
		- productId (the product id of the recommended product OPTIONAL)

#### Stories

- A user should see a preview of their recommendation after selecting a product from the (2.1 WebView Picker) (screens 3.2.a, 3.2.b, 3.1.c, 3.2.d)
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
- The user should be presented with a confirmation dialog if they attempt to close the review page at this stage (view 3.2.e)
	- The dialog should have a title of 'wait!'
	- The dialog comment first line should read 'suggest this product'
	- The dialog comment second line should read 'without a comment?'
	- The dialog should allow the user to either 'cancel' or 'yes'
		- 'yes' should submit the recommendation without any review text included
		- 'cancel' should bring the user to the front of the outfit page without submitting anything
	- If the user cancels, the unsubmitted recommendation should stay in memory until the outfit is loaded again (either from a list or outfit refresh)
	- If the user cancels, then (at any point later in their browsing of the app) taps on suggest from view 1.1.b, the unsubmitted review is erased and the user proceeds into the Webview Picker (view 2.1.a)

