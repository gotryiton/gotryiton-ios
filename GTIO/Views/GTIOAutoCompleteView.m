//
//  GTIOAutoCompleteView.m
//  auto complete stand alone app for GTIOv4
//
//  Created by Simon Holroyd on 6/12/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//


static int const kGTIOAutoCompleteMatchCharacterDefault = 2;


#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#import "GTIOAutoCompleteView.h"
#import "NSString+GTIOAdditions.h"


static CGFloat kGTIOMaxCharacterCount = 255.0;
static CGFloat kGTIOSearchTextTimerLength = 0.75;
static CGFloat kGTIOSearchTextFastTimerLength = 0.45;

@implementation GTIOAutoCompleteView


- (id)initWithFrame:(CGRect)frame outerBox:(CGRect)outerFrame placeholder:(NSString *) text
{
    self = [super initWithFrame:outerFrame];
    if (self) {
        // the autoCompleteArray 
        _autoCompleteArray = [[NSMutableArray alloc] init];
        
        // the array of visible autocomplete buttons in the scroll view
        _autoCompleteButtonOptions = [[NSMutableArray alloc] init];
        
        // keep track of text in the input box
        _inputText = @"";

        // keep track of the position of the last word the user typed
        _positionOfLastWordTyped = NSMakeRange(0,1);
        
        // keep track of the position of the last two words the user typed
        _positionOfLastTwoWordsTyped = NSMakeRange(0,1);

        // keep track of the position of the last two words the user typed
        _positionOfCursor = NSMakeRange(0,0);

        CGRect editingFrame = CGRectMake(CGRectGetMinX(frame) , CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame) -50);
        CGRect inputFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame) + 16, CGRectGetHeight(frame) - 50);
        
        _placeholderText = text;

        /** Set up a textView to allow a user to edit text
         */
        _textInput = [[UITextView alloc] initWithFrame:inputFrame];
        _textInput.returnKeyType = UIReturnKeyDone;
        _textInput.backgroundColor = [UIColor clearColor];
        _textInput.contentInset =  UIEdgeInsetsMake(-10,-8,0,0);        
        _textInput.scrollEnabled = NO;
        [_textInput setDelegate:self];
        [_textInput setFont: [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:14.f]];
        _textInput.textColor = [UIColor gtio_grayTextColor404040];
        [self addSubview:self.textInput];


        // setup colors for rich text editing
        // NOTE: these are assigned to the attrString but are not displayed 
        // this is pending a refactor for iOS 6 support where they will be displayed
        _ACInputColor = CGColorRetain([UIColor gtio_grayTextColor404040].CGColor);
        _ACPlaceholderColor = CGColorRetain([UIColor gtio_grayTextColorB3B3B3].CGColor);
        _ACHighlightColor = CGColorRetain([UIColor gtio_linkColor].CGColor);

        _ACPlaceholderFont = [UIFont gtio_verlagCoreTextFontWithWeight:GTIOFontVerlagLightItalic size:14.f];
        _ACHighlightFont = [UIFont gtio_verlagCoreTextFontWithWeight:GTIOFontVerlagLight size:14.f];
        _ACInputFont = [UIFont gtio_verlagCoreTextFontWithWeight:GTIOFontVerlagLight size:14.f];
        


        /** Create the text layer to display a preview of what the user is typing 
         */
        _previewTextView = [[CATextLayer alloc] init];
        _previewTextView.backgroundColor = [UIColor clearColor].CGColor;
        _previewTextView.wrapped = YES;
        _previewTextView.frame = editingFrame;
        _previewTextView.contentsScale = [[UIScreen mainScreen] scale]; 
        _previewTextView.alignmentMode = kCAAlignmentLeft;
        _previewTextView.opacity = 0;
        [self.layer addSublayer:self.previewTextView];
        

        /** Add a scroll view for the autocomplete buttons to be viewable in
         */
        CGRect scrollFrameBox = CGRectMake( 0, 0, CGRectGetWidth(self.bounds), 50);
        
        UIView *inputAccessoryView = [[UIView alloc] initWithFrame:scrollFrameBox];
        inputAccessoryView.clipsToBounds = YES;
        self.textInput.inputAccessoryView = inputAccessoryView;
        

        _scrollView = [[GTIOAutoCompleteScrollView alloc] initWithFrame:scrollFrameBox];
        _scrollView.autoCompleteDelegate = self;
        [self.textInput.inputAccessoryView addSubview:self.scrollView];
        

        _isScrollViewShowing = NO;


        _autoCompleteMatchCharacterCount = kGTIOAutoCompleteMatchCharacterDefault;
        _autoCompleteMode = nil;
        // set up attr string to track the data associated with autocompletes
        _attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    return self;
}

- (void)addCompleters:(NSMutableArray *)completers
{
    for (GTIOAutoCompleter *completer in completers) {
        [self.autoCompleteArray addObject:completer];    
    }
}


- (void)showButtonsWithAutoCompleters:(NSArray *)foundAutoCompleters
{
    [self.scrollView showButtonsWithAutoCompleters: foundAutoCompleters];
    
}


#pragma mark UITextViewDelegate methods

- (BOOL)textView:(UITextView *)field shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)inputString 
{
    [self.searchTextTimer invalidate];
    
    self.isTyping = YES;
    
    //resign if the user's done
    if([inputString isEqualToString:@"\n"]) {
        //close the keyboard and hide the text input
        [field resignFirstResponder];
        
        self.isTyping = NO;
        return NO;
    }
    
    if ([self availableCharactersIn:field.text input:inputString range:range]<0){
        self.isTyping = NO;
        return NO;
    }

    //if in the process of inserting
    if (self.preventTyping){
        self.isTyping = NO;
        return NO;
    }

    [self textView:self.textInput shouldChangeTextWithAutoCompleteInRange:range replacementText:inputString];
}

- (BOOL)textView:(UITextView *)field shouldChangeTextWithAutoCompleteInRange:(NSRange)range replacementText:(NSString *)inputString 
{   
    // always hide the placeholder text if the user is inputtting
    [self hidePlaceholderText];

    //update the cursor position
    self.positionOfCursor = [self getUpdatedCursorPositionByReplacingCharactersInRange:range existingString:field.text inputString:inputString];

    // figure out the new input text
    self.inputText = [field.text stringByReplacingCharactersInRange:range withString:inputString];

    // display the newly inputted text
    [self updateAttributedStringInRange:range string:inputString];
    [self setPositionOfLastWordsTypedInText:[self stringThroughCursorPositionWithRange:range]];
    
    CGFloat searchTime = kGTIOSearchTextTimerLength;
    
    if (self.inputText.length > 0) {

        [self highlightHashTag];
        
        if ([self hashtagMode] && ![self isValidHashTag:[self lastWordTyped]]){
            // NSLog(@"hashtagMode");
            [self resetAutoCompleteMode];
        } else if (![self hashtagMode] && [self isValidHashTag:[self lastWordTyped]]){
            // NSLog(@"checking for hashtagMode");
            [self autoCompleterModeSelected:@"#"];
        } else if (![self attagMode] && [[self lastWordTyped] isEqualToString:@"@"]){
            // NSLog(@"checking for attagMode");
            [self autoCompleterModeSelected:@"@"];
        } else if ([[self lastWordTyped] isEqualToString:@" "] && range.length == 1){
            [self resetAutoCompleteMode];
        }

        if ([self brandtagMode] || [self attagMode]){
            searchTime = kGTIOSearchTextFastTimerLength;
        }
            
    } else {
        [self resetAutoCompleteMode];
        [self.scrollView showScrollViewNav];
        [self displayPlaceholderText];
    }
    
    self.searchTextTimer = [NSTimer scheduledTimerWithTimeInterval:searchTime target:self selector:@selector(delayedAutoCompleteTextSearch) userInfo:nil repeats:NO];
    
    self.isTyping = NO;
    return YES;
}

- (void)delayedAutoCompleteTextSearch
{
    [self.searchTextTimer invalidate];

    if (![self hashtagMode] && !self.isTyping){
        NSArray *foundAutoCompleters = [self searchLastTypedWordsForAutoCompletes];
        if (![self hashtagMode] && ![self brandtagMode] && ![self attagMode] && [foundAutoCompleters count] == 0) {
            // NSLog(@"notHash mode resetting");
            [self resetAutoCompleteMode];         
        }

        if ([foundAutoCompleters count] > 0) {
            [self.scrollView clearScrollView];
            [self showButtonsWithAutoCompleters: foundAutoCompleters];
        } 
    }
    [self cleanUpAttrString];
    
    return;
}

- (NSInteger)availableCharactersIn:(NSString *)existingString input:(NSString *)inputString range:(NSRange)range
{
    // limit input to 255 characters    
    NSString * newText = [existingString stringByReplacingCharactersInRange:range withString:inputString];

    return  kGTIOMaxCharacterCount -newText.length;
}

- (NSString *)stringThroughCursorPositionWithRange:(NSRange)range 
{
    return [self.inputText substringWithRange:NSMakeRange(0,self.positionOfCursor.location)];    
}

- (void)setPositionOfLastWordsTypedInText:(NSString *)str 
{
    NSInteger length = str.length;
    self.positionOfLastWordTyped = NSMakeRange(MAX(0,length-1), MIN(length, 1));
    self.positionOfLastTwoWordsTyped = NSMakeRange(MAX(0,length-1), MIN(length, 1));
    // NSLog(@"default: %@", NSStringFromRange( self.positionOfLastWordTyped ));
    //regex:  (\s?[\w\.\@\#&-]+?)?$
    NSRegularExpression* lastWordRegex = [[NSRegularExpression alloc] initWithPattern:@"\\s?([\\w\\.\\@\\#&-]+?)?$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *lastWordMatches = [lastWordRegex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    for (NSTextCheckingResult *match in lastWordMatches) {
        if ([match rangeAtIndex:1].location != NSNotFound && [match rangeAtIndex:1].length > 0) {
            // NSLog(@"match 1: %@", NSStringFromRange([match rangeAtIndex:1] ));
            self.positionOfLastWordTyped = [match rangeAtIndex:1];
        }
    }
    //regex: ([\w\.\@\#&-]+?\s?[\w\.\@\#&-]?)$
    NSRegularExpression* lastTwoWordsRegex = [[NSRegularExpression alloc] initWithPattern:@"([\\w\\.\\@\\#&-]+?\\s?[\\w\\.\\@\\#&-]?)$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *lastTwoWordsMatches = [lastTwoWordsRegex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    for (NSTextCheckingResult *match in lastTwoWordsMatches) {
        if ([match rangeAtIndex:1].location != NSNotFound && [match rangeAtIndex:1].length > 0 )
            self.positionOfLastTwoWordsTyped =  [match rangeAtIndex:1];
    }
    // NSLog(@"first: <%@> second: <%@>", [self lastWordTyped], [self lastTwoWordsTyped]);
}

-(NSRange) getUpdatedCursorPositionByReplacingCharactersInRange:(NSRange)range existingString:(NSString *)existingString inputString:(NSString *)input
{
    return NSMakeRange(ABS(MAX(range.location, range.location + range.length) + input.length - range.length), 0);
        
}

- (NSString *)lastCharacterTyped
{
    if (self.inputText.length==0){
        return @"";
    }
    return [self.inputText substringWithRange:[self positionOfLastCharacterTyped]];
}

-(NSRange) positionOfLastCharacterTyped 
{
    return NSMakeRange(MAX(MIN(self.positionOfCursor.location-1, self.inputText.length-1), 0), 1);
}

- (NSString *)lastWordTyped
{
    return [[self lastWordTypedInText:self.inputText] lowercaseString];
}

- (NSString *)lastTwoWordsTyped
{
    return [[self lastTwoWordsTypedInText:self.inputText] lowercaseString];
}

- (NSString *)lastWordTypedInText:(NSString *)str
{
    if (str.length == 0) {
        return @"";
    }
    return [str substringWithRange:self.positionOfLastWordTyped];
}

- (NSString *)lastTwoWordsTypedInText:(NSString *)str
{
    if (str.length == 0) {
        return @"";
    }
    return [str substringWithRange:self.positionOfLastTwoWordsTyped];
}

- (void)updateAttributedStringInRange:(NSRange)range string:(NSString *)string
{   
    

    NSDictionary *inputTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)self.ACInputFont, (id)kCTFontAttributeName,
                                   [NSNumber numberWithFloat:0.0], kCTKernAttributeName,                                
                                   self.ACInputColor, (id)kCTForegroundColorAttributeName,
                                   nil];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string attributes:inputTextAttr];

    [self.attrString replaceCharactersInRange:range withAttributedString:attrStr];
    /* Set the attributes string in the text layer :) */
    // self.textView.string = self.attrString;
}

- (void)highlightAttributedStringInRange:(NSRange)range completerID:(NSString *)completerID type:(NSString *)type
{
    // NSLog(@"highlighting range: %@ completer: %@ type: %@", NSStringFromRange(range), completerID, type );
    // NSLog(@"self.attrString length: %i", self.attrString.length);
    NSDictionary *highlightTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                       (id)self.ACHighlightColor, (id)kCTForegroundColorAttributeName, 
                                       completerID, @"completerId",
                                       type, @"completerType",
                                       nil];
    
    [self.attrString addAttributes:highlightTextAttr range:range];
    /* Set the attributes string in the text layer :) */
    // self.textView.string = self.attrString;
}

- (void)unHighlightAttributedStringInRange:(NSRange)range 
{
    // NSLog(@"unhighlighting range: %@ ", NSStringFromRange(range) );
    [self updateAttributedStringInRange:range string:[[self.attrString string] substringWithRange:range]];
}

- (void)displayPlaceholderText 
{
    NSArray *highlights = [[NSArray alloc] init];
    [self displayPlaceholderText:self.placeholderText highlightedStrings:highlights];

    if (self.previewTextView.opacity ==0){
        [UIView animateWithDuration:1.75 delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
            self.previewTextView.opacity = 1;
        } completion:nil];
    }
}

- (void)displayPlaceholderText:(NSString *)text highlightedStrings:(NSArray *)highlights
{
    NSDictionary *placeholderTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                         (id)self.ACPlaceholderFont, (id)kCTFontAttributeName,
                                         [NSNumber numberWithFloat:0.0], kCTKernAttributeName,
                                         self.ACPlaceholderColor, (id)kCTForegroundColorAttributeName,
                                         nil];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text attributes:placeholderTextAttr];

    NSDictionary *highlightTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                       (id)self.ACHighlightColor, (id)kCTForegroundColorAttributeName, 
                                       nil];

    for (NSString *highlight in highlights) {
        NSRange range = [[attrStr string] rangeOfString:highlight];
        if (range.location != NSNotFound) {
            [attrStr addAttributes:highlightTextAttr range:range];
        }
    }

    self.previewTextView.string = attrStr;
}

- (void) hidePlaceholderText 
{
    if (self.previewTextView.opacity==1){
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
            self.previewTextView.opacity = 0;
        } completion:nil];    
    }
}

- (void) showPlaceholderText
{
    if (self.inputText.length == 0) {
        [self displayPlaceholderText];
    }
}

- (void) highlightHashTag
{
    NSString *lastword = [self lastWordTyped];
    if (lastword.length>0){
        if ([[lastword substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"]){
            // NSLog(@"highlighting hash: %@", NSStringFromRange(self.positionOfLastWordTyped));
            [self highlightAttributedStringInRange:self.positionOfLastWordTyped completerID:[[self lastWordTyped] substringWithRange:NSMakeRange(1, [self lastWordTyped].length - 1 )] type:@"#" ];    
        }
    }
}

- (NSMutableArray *)searchLastTypedWordsForAutoCompletes
{
    // Put anything that starts with this substring into the autocompleteButtons array
    // The items in this array is what will show up in the scroll view
    NSMutableArray *foundAutoCompleters = [[NSMutableArray alloc] init];
    NSArray *completers = self.autoCompleteArray;
    if ([self attagMode]){
        completers = [self atTagCompleters];
    }
    if ([self brandtagMode]){
        completers = [self brandTagCompleters];
    }
    for (GTIOAutoCompleter *option in completers) {
        if (self.isTyping){
            break;
        }        
        if ([self startedTypingCompleterInLastTwoWords:option]) {
            [foundAutoCompleters addObject:option];  
        }
        else if ([self startedTypingCompleterInLastWord:option] ){
            [foundAutoCompleters addObject:option];
        }
    }
    return foundAutoCompleters;
}

- (BOOL)startedTypingCompleterInLastTwoWords:(GTIOAutoCompleter *)completer
{
    if ([self lastTwoWordsTyped].length == 0){
        return false;
    }
    if ([[completer.name lowercaseString] rangeOfString:[self lastTwoWordsTyped]].location == 0 && [self lastTwoWordsTyped].length > self.autoCompleteMatchCharacterCount) {
        return true; 
    }
    else if ([[[self lastTwoWordsTyped] substringWithRange:NSMakeRange(0,1)] isEqualToString:@"@"] && [self lastTwoWordsTyped].length > self.autoCompleteMatchCharacterCount){
        NSRange substringRange = [[completer.name lowercaseString] rangeOfString:[[self lastTwoWordsTyped] substringWithRange:NSMakeRange(1, [self lastTwoWordsTyped].length - 1)]];
        if (substringRange.location == 0 && [completer.type isEqualToString:@"@"]){
            return true; 
        }
    }
    return false;
}

- (BOOL)startedTypingCompleterInLastWord:(GTIOAutoCompleter *)completer
{
    if ([self lastWordTyped].length == 0){
        return false;
    }
    if ([[completer.name lowercaseString] rangeOfString:[self lastWordTyped]].location == 0 && [self lastWordTyped].length > self.autoCompleteMatchCharacterCount) {
        return true;
    }
    else if ([[[self lastWordTyped] substringWithRange:NSMakeRange(0,1)] isEqualToString:@"@"] && [self lastWordTyped].length > self.autoCompleteMatchCharacterCount ){
        NSRange substringRange = [[completer.name lowercaseString] rangeOfString:[[self lastWordTyped] substringWithRange:NSMakeRange(1, [self lastWordTyped].length - 1)]];
        if (substringRange.location == 0 && [completer.type isEqualToString:@"@"]){
            return true;
        }
    }
    return false;
}



- (bool)hashtagMode
{
    return [self.autoCompleteMode isEqualToString:@"#"];
}

- (bool)attagMode
{
    return [self.autoCompleteMode isEqualToString:@"@"];
}


- (bool)brandtagMode
{
    return [self.autoCompleteMode isEqualToString:@"b"];
}

- (void)resetAutoCompleteMode
{
    self.autoCompleteMode = nil;
    self.autoCompleteMatchCharacterCount = kGTIOAutoCompleteMatchCharacterDefault;
    [self.scrollView clearScrollView];
    [self.scrollView showScrollViewNav];
}


#pragma mark - GTIOAutoCompleteViewDelegate

- (void)autoCompleterIDSelected:(NSString*)completerID 
{
    GTIOAutoCompleter *completer = [self completerWithID:completerID];
    
    self.autoCompleteMatchCharacterCount = 0;

    NSRange range = NSMakeRange(0,0);
    // NSLog(@"autoCompleterIDSelected lastword: %@", [self lastWordTyped]);
    if ([self startedTypingCompleterInLastWord:completer] | [[self lastWordTyped] isEqualToString:@"@"] ) {
        // NSLog(@"matched on first word");
        range = self.positionOfLastWordTyped;
    }
    else if ([self startedTypingCompleterInLastTwoWords:completer]){
        // NSLog(@"matched on second word");
        range = self.positionOfLastTwoWordsTyped;
    }
    // NSLog(@"completer goiing at range: %@", NSStringFromRange(range));
    NSRange editedRange = [self insertIntoInput:[NSString stringWithFormat:@"%@ ", [completer completerString]] range:range];
    if (editedRange.location!=NSNotFound) {
        editedRange = NSMakeRange(editedRange.location, editedRange.length-1);
        [self highlightAttributedStringInRange:editedRange completerID:completer.completerID type:completer.type];
    }
    [self resetAutoCompleteMode];
}

- (void)autoCompleterModeSelected:(NSString*)mode 
{
    
    self.autoCompleteMode = mode;

    if ([self attagMode] | [self hashtagMode]){
        if (self.inputText.length==0 | [self lastWordTyped].length == 0 | [[self lastWordTyped] isEqualToString:@" "]) {
            [self insertIntoInput:mode];
        }
    }
    [self.scrollView clearScrollView];
    [self.scrollView showPromptTextForMode:mode];

    if ([self attagMode] | [self brandtagMode]){
        self.autoCompleteMatchCharacterCount = 0;
    }
    
}



#pragma mark -

- (GTIOAutoCompleter *)completerWithID:(NSString *)completerID 
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"completerID like %@", completerID];
    NSArray *results = [self.autoCompleteArray filteredArrayUsingPredicate:predicate];

    if ([results count] > 0) {
        return [results objectAtIndex:0];    
    }
    
    return nil;
}


-(NSRange) insertIntoInput:(NSString *)str 
{
    self.preventTyping = YES;

    self.positionOfCursor = [self getUpdatedCursorPositionByReplacingCharactersInRange:self.textInput.selectedRange existingString:self.inputText inputString:@""];

    int padded = 0;
    if (![[self lastCharacterTyped] isEqualToString:@""] && ![[self lastCharacterTyped] isEqualToString:@" "]){
        str = [NSString stringWithFormat:@" %@", str];
        padded = 1;
    }

    NSRange editedRage = [self insertIntoInput:str range:self.positionOfCursor];   
    if (editedRage.location!=NSNotFound) {
        return NSMakeRange(editedRage.location + padded, editedRage.length );
    }

    return editedRage;

}

-(NSRange) insertIntoInput:(NSString *)str range:(NSRange)range
{
    self.preventTyping = YES;

    NSRange editedRange = NSMakeRange(NSNotFound, 0);

    if (self.inputText.length == 0) {
        
        if ([self textView:self.textInput shouldChangeTextWithAutoCompleteInRange:NSMakeRange(0,0) replacementText:str]){
            self.textInput.text = str;
            
            editedRange = NSMakeRange(0, str.length);

        }
            
    }
    else {
        
        if ([self textView:self.textInput shouldChangeTextWithAutoCompleteInRange:range replacementText:str]){
            self.textInput.text = [self.textInput.text stringByReplacingCharactersInRange:range withString:str];
             editedRange = NSMakeRange(range.location, str.length);
        }
    }

    UITextPosition *beginning = self.textInput.beginningOfDocument;
    UITextPosition *start = [self.textInput positionFromPosition:beginning offset:self.positionOfCursor.location];
    UITextPosition *end = [self.textInput positionFromPosition:start offset:self.positionOfCursor.length];
    [self.textInput setSelectedTextRange:[self.textInput textRangeFromPosition:start toPosition:end]];
    
    self.preventTyping = NO;

    return editedRange;
}

- (NSArray *)atTagCompleters
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type like %@", @"@"];
    return [self.autoCompleteArray filteredArrayUsingPredicate:predicate];
}

- (NSArray *)brandTagCompleters
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type like %@", @"b"];
    return [self.autoCompleteArray filteredArrayUsingPredicate:predicate];
}

- (BOOL)showAtTagButtons 
{
    if([[self lastWordTyped] isEqualToString:@"@"]) {
        NSArray *completers = [self atTagCompleters];
        if ([completers count] > 0){
            [self showButtonsWithAutoCompleters:[self atTagCompleters]];
            [self autoCompleterModeSelected:@"@"];
            return true;
        }
    }
    return false;
}

- (void)cleanUpAttrString 
{
    NSDictionary *attributes;
    NSRange effectiveRange = { 0, 0 }; 
    if ([self.attrString length]>0) {
        do { 
            NSRange range = NSMakeRange (NSMaxRange(effectiveRange), [self.attrString length] - NSMaxRange(effectiveRange));
            attributes = [self.attrString attributesAtIndex:range.location longestEffectiveRange: &effectiveRange inRange:range ];
            
            if ([attributes objectForKey:@"completerType"]) {
                GTIOAutoCompleter * completer = [self completerWithID:[attributes objectForKey:@"completerId"]];

                //if its a hashtag, make sure the hashtag is at the front of the string
                if ([[attributes objectForKey:@"completerType"] isEqualToString:@"#"] ){
                    if (![self isValidHashTag:[[self.attrString string] substringWithRange:effectiveRange]]){
                        [self unHighlightAttributedStringInRange:effectiveRange];
                    }
                }
                // if its some other tag, make sure the string still matches
                else if (![[[self.attrString string] substringWithRange:effectiveRange] isEqualToString:[completer completerString]]){
                    [self unHighlightAttributedStringInRange:effectiveRange];
                }
            }
        } while (NSMaxRange(effectiveRange) < [self.attrString length]); 
    }
}

-(BOOL) isValidHashTag:(NSString *) str {
     NSRange hash = [str rangeOfString:@"#"];
     NSRange space = [str rangeOfString:@" "];
     // NSLog(@"testing hash validity hash:%@ space:%@", NSStringFromRange(hash) ,NSStringFromRange(space));
     return (hash.location ==0 && space.location == NSNotFound);
}

- (NSString *)processDescriptionString
{
    [self resetAutoCompleteMode];

    if ([self.attrString length] == 0) {
        return @"";
    }
    
    NSString *response = @"";
    NSDictionary *attributes;
    NSRange effectiveRange = { 0, 0 }; 
    do { 
        NSRange range = NSMakeRange (NSMaxRange(effectiveRange), [self.attrString length] - NSMaxRange(effectiveRange));
        attributes = [self.attrString attributesAtIndex:range.location longestEffectiveRange: &effectiveRange inRange:range ];

        if ([attributes objectForKey:@"completerType"] ){
            response = [response stringByAppendingFormat:@"{%@{%@{%@}}}", [attributes objectForKey:@"completerType"], [attributes objectForKey:@"completerId"], [[self.attrString string] substringWithRange:effectiveRange]];

        } else {
            response = [response stringByAppendingString:[[self.attrString string] substringWithRange:effectiveRange]];    
        }
    } while (NSMaxRange(effectiveRange) < [self.attrString length]); 

    NSLog (@"submission string: %@ ", response);
    
    return response;
}

- (void)resetView
{
    self.inputText = @"";
    self.attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    self.textInput.text = @"";
    // self.textView.string = self.attrString;
}

@end
