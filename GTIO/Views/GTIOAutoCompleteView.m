//
//  GTIOAutoCompleteView.m
//  auto complete stand alone app for GTIOv4
//
//  Created by Simon Holroyd on 6/12/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#import "GTIOAutoCompleteView.h"

@implementation GTIOAutoCompleteView

@synthesize autoCompleteArray = _autoCompleteArray;
@synthesize autoCompleteButtonOptions = _autoCompleteButtonOptions;
@synthesize scrollView = _scrollView;
@synthesize scrollViewBackground = _scrollViewBackground;
@synthesize textInput = _textInput;
@synthesize textView = _textView;
@synthesize previewTextView = _previewTextView;
@synthesize attrString = _attrString;
@synthesize positionOfLastWordTyped =_positionOfLastWordTyped;
@synthesize positionOfLastTwoWordsTyped =_positionOfLastTwoWordsTyped;
@synthesize submissionText = _submissionText;
@synthesize dataText = _dataText;
@synthesize inputText = _inputText;


@synthesize ACInputFont = _ACInputFont;
@synthesize ACInputColor = _ACInputColor;
@synthesize ACPlaceholderFont = _ACPlaceholderFont;
@synthesize ACPlaceholderColor = _ACPlaceholderColor;
@synthesize ACHighlightFont = _ACHighlightFont;
@synthesize ACHighlightColor = _ACHighlightColor;

@synthesize isScrollViewShowing = _isScrollViewShowing;


- (id)initWithFrame:(CGRect)frame withOuterBox:(CGRect) outerFrame 
{
    self = [super initWithFrame:outerFrame];
    if (self) {
        
        // Initialization code
        // self.layer.borderWidth = 1;
        // self.layer.borderColor = [UIColor redColor].CGColor;

        
        // the autoCompleteArray 
        _autoCompleteArray = [[NSMutableArray alloc] init];
        
        // the array of visible autocomplete buttons in the scroll view
        _autoCompleteButtonOptions = [[NSMutableArray alloc] init];
        
        // keep track of a string that the user is typing that uses the dictionary's keys in place of the dictionary's display_text
        _dataText = [[NSString alloc] initWithString:@" "];
        
        // keep track of text this view will pass along to the server
        _submissionText = [[NSString alloc] initWithString:@""];
        
        // keep track of text in the input box
        _inputText = [[NSString alloc] initWithString:@""];

        // keep track of the position of the last word the user typed
        _positionOfLastWordTyped = NSMakeRange(0,1);
        
        // keep track of the position of the last two words the user typed
        _positionOfLastTwoWordsTyped = NSMakeRange(0,1);

        
        CGRect editingFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - 45);
        CGRect inputFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame) + 16, CGRectGetHeight(frame) - 45);
        

        /****
        set up a textView to allow a user to edit text
        *****/
        _textInput = [[UITextView alloc] initWithFrame:inputFrame];
        _textInput.returnKeyType = UIReturnKeyDone;
        _textInput.backgroundColor = [UIColor clearColor];
        _textInput.contentInset =  UIEdgeInsetsMake(-10,-8,0,0);
        _textInput.autocorrectionType = UITextAutocorrectionTypeNo;
        [_textInput setDelegate:self];
        [_textInput  setFont: [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:14.f]];
        // [self.textInput  setFont: [UIFont fontWithName:@"ArialMT" size:15]];
        [self addSubview:self.textInput];
        _textInput.textColor = [UIColor greenColor];

        
        _ACInputColor = CGColorRetain([UIColor gtio_darkGrayTextColor].CGColor);
        _ACPlaceholderColor = CGColorRetain([UIColor gtio_lightGrayTextColor].CGColor);
        _ACHighlightColor = CGColorRetain([UIColor gtio_linkColor].CGColor);

        _ACPlaceholderFont = [UIFont gtio_verlagCoreTextFontWithWeight:GTIOFontVerlagLightItalic size:14.f];
        _ACHighlightFont = [UIFont gtio_verlagCoreTextFontWithWeight:GTIOFontVerlagLight size:14.f];
        _ACInputFont = [UIFont gtio_verlagCoreTextFontWithWeight:GTIOFontVerlagLight size:14.f];
        
        /* Create the text layer to display a preview of what the user is typing */
        _textView = [[CATextLayer alloc] init];
        _textView.backgroundColor = [UIColor clearColor].CGColor;
        _textView.wrapped = YES;
        _textView.frame = editingFrame;
        _textView.contentsScale = [[UIScreen mainScreen] scale]; 
        _textView.alignmentMode = kCAAlignmentLeft;
        _textView.opacity = 1.0;
        [self.layer addSublayer:self.textView];
        
        

        /* Create the text layer to display a preview of what the user is typing */
        _previewTextView = [[CATextLayer alloc] init];
        _previewTextView.backgroundColor = [UIColor clearColor].CGColor;
        _previewTextView.wrapped = YES;
        _previewTextView.frame = editingFrame;
        _previewTextView.contentsScale = [[UIScreen mainScreen] scale]; 
        _previewTextView.alignmentMode = kCAAlignmentLeft;
        _previewTextView.opacity = 1.0;
        [self.layer addSublayer:self.previewTextView];
        
        [self displayPlaceholderText];

        /****
        add a scroll view for the autocomplete buttons to be viewable in
        *****/
        _isScrollViewShowing = NO;
        
        CGRect scrollFrameBox = CGRectMake( 0, CGRectGetHeight(self.bounds)-4, CGRectGetWidth(self.bounds), 50);

        _scrollViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keyboard-top-control-bg.png"]];
        [_scrollViewBackground setFrame:scrollFrameBox];
        [self addSubview:self.scrollViewBackground];
        
        _scrollView = [[GTIOAutoCompleteScrollView alloc] initWithFrame:scrollFrameBox];
        _scrollView.autoCompleteDelegate = self;
        [self addSubview:self.scrollView];
        
        //set up attr string
        _attrString = [[NSMutableAttributedString alloc] initWithString:@""];
        
        

    }
    return self;
}



- (void)dealloc
{
    
    _textInput = nil;
    _scrollView = nil;
    _scrollViewBackground = nil;
    _autoCompleteArray = nil;
    _autoCompleteButtonOptions = nil;
 
}

- (void) addCompleters:(NSMutableArray *) completers
{
    for (GTIOAutoCompleter * completer in completers){
        [self.autoCompleteArray addObject:completer];    
    }
}

- (void) showScrollView 
{

    if (!self.isScrollViewShowing){
        self.isScrollViewShowing = YES;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect scrollFrameBox = CGRectMake( 0, self.bounds.size.height-48, self.bounds.size.width, 50);
            [self.scrollView setFrame:scrollFrameBox];
            [self.scrollViewBackground setFrame:scrollFrameBox];
        } completion:^(BOOL finished) {
        }];
    }
    
}

- (void) hideScrollView 
{
    if (self.isScrollViewShowing){
        self.isScrollViewShowing = NO;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGRect scrollFrameBox = CGRectMake( 0, self.bounds.size.height-4, self.bounds.size.width, 50);
            [self.scrollView setFrame:scrollFrameBox];
            [self.scrollViewBackground setFrame:scrollFrameBox];
        } completion:^(BOOL finished) {
            [self.scrollView clearScrollView];
        }];

        
    }

  
}

- (void) showButtonsWithAutoCompleters:(NSArray *) foundAutoCompleters
{
    
    [self.scrollView showButtonsWithAutoCompleters: foundAutoCompleters];
    if ([foundAutoCompleters count]>0)
        [self showScrollView];

}

#pragma mark UITextViewDelegate methods
- (BOOL)textView:(UITextView *)field shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)inputString 
{

    [self hidePlaceholderText];

    //if the user hit 'done':
    if([inputString isEqualToString:@"\n"]) {
        
        //close the keyboard and hide the text input
        [field resignFirstResponder];
        
        [self hideScrollView];
        
        //self.textInput.textColor = [UIColor clearColor];
        
        //TODO:
        //this should prob kick off an event of some kind to alert the view's owner that we're done with the keyboard (and to animate and such)

        return NO;
    }
    
    self.inputText = [field.text stringByReplacingCharactersInRange:range withString:inputString];
    
    [self updateInputDisplayTextInRange:range withString:inputString];

    if (self.inputText.length>0){
        [self setPositionOfLastWordsTypedInText:[self getStringThroughCursorPositionWithRange:range]];
        
        [self highlightHashTag];

        NSArray *foundAutoCompleters = [self searchLastTypedWordsForAutoCompletes];

        if ([foundAutoCompleters count]>0){
            [self showButtonsWithAutoCompleters: foundAutoCompleters];
            if ([foundAutoCompleters count]==1)  {
                NSLog(@"do something exciting");
            }
        }
        else {
            if (![self showAtTagButtons])
                [self hideScrollView];
        }
        
        [self cleanUpAttrString];
    
    }
    else {
        [self displayPlaceholderText];
    }
    
    
    
    return YES;
}

- (NSString *) getStringThroughCursorPositionWithRange:(NSRange) range 
{
    
    
    int cursorPosition = MIN(range.location + range.length +1, self.inputText.length);

    return [self.inputText substringWithRange:NSMakeRange(0,cursorPosition)];    
    
    
}
- (void) setPositionOfLastWordsTypedInText:(NSString *)str 
{

    self.positionOfLastWordTyped = NSMakeRange(0, str.length);
    self.positionOfLastTwoWordsTyped = NSMakeRange(0, str.length);
    
    NSUInteger count = 0, words = 0, length = [str length];
    NSRange range = NSMakeRange(0, length); 
    while(range.location != NSNotFound && words<2 && count<3)
    {
        range = [str rangeOfString: @" " options:NSBackwardsSearch range:range];
        if(range.location != NSNotFound)
        {
            if (range.location<=(length-1) && words == 1){
                self.positionOfLastTwoWordsTyped = NSMakeRange(range.location+1, length-range.location-1);
                words++;
            }

            if (range.location<(length-1) && words == 0){
                self.positionOfLastWordTyped = NSMakeRange(range.location+1, length-range.location-1);
                words++;
            }
            
            range = NSMakeRange(0, range.location-1);
            count++; 
        }
    }
}


- (NSString *) getLastWordTyped
{
    return [[self lastWordTypedInText:self.inputText] lowercaseString];
}

- (NSString *) getLastTwoWordsTyped
{
    return [[self lastTwoWordsTypedInText:self.inputText] lowercaseString];
}


- (NSString *) lastWordTypedInText:(NSString *)str
{
    return [str substringWithRange:self.positionOfLastWordTyped];
}

- (NSString *) lastTwoWordsTypedInText:(NSString *)str
{
    return [str substringWithRange:self.positionOfLastTwoWordsTyped];
}

- (void)updateInputDisplayTextInRange:(NSRange) range withString:(NSString *) string
{   
    
        NSDictionary *inputTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (id)self.ACInputFont, (id)kCTFontAttributeName,
                                       [NSNumber numberWithFloat:0.0], kCTKernAttributeName,                                
                                    self.ACInputColor, (id)kCTForegroundColorAttributeName, nil];


        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string attributes:inputTextAttr];


        [self.attrString replaceCharactersInRange:range withAttributedString:attrStr];
        /* Set the attributes string in the text layer :) */
        self.textView.string = self.attrString;
    
}

- (void)highlightInputTextInRange:(NSRange) range withId:(NSString *) completer_id withType:(NSString *) type
{
    
    NSDictionary *highlightTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)self.ACHighlightColor, (id)kCTForegroundColorAttributeName, 
                                   completer_id, @"completerId",
                                   type, @"completerType",
                                   nil];
    
    
    
    [self.attrString addAttributes:highlightTextAttr range:range];
    /* Set the attributes string in the text layer :) */
    self.textView.string = self.attrString;
    
}



- (void)unHighlightInputTextInRange:(NSRange) range 
{
    
    [self updateInputDisplayTextInRange:range withString:[[self.attrString string] substringWithRange:range]];
    
}

- (void)displayPlaceholderText {

    // NSArray *highlights = [[NSArray alloc] initWithObjects: @"#highlights", @"@simon", nil];
    NSArray *highlights = [[NSArray alloc] init];
    [self displayPlaceholderText:@"How does this Zara top look? @Becky #wedding" withHighlightedStrings:highlights];

    if (self.previewTextView.opacity ==0){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.75];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.previewTextView.opacity = 1;
        
        [UIView commitAnimations];
    }

}
- (void)displayPlaceholderText:(NSString *) text withHighlightedStrings:(NSArray *) highlights
{

        NSDictionary *placeholderTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (id)self.ACPlaceholderFont, (id)kCTFontAttributeName,
                                             [NSNumber numberWithFloat:0.0], kCTKernAttributeName,
                                    self.ACPlaceholderColor, (id)kCTForegroundColorAttributeName, nil];

        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text attributes:placeholderTextAttr];

        NSDictionary *highlightTextAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)self.ACHighlightColor, (id)kCTForegroundColorAttributeName, 
                                   nil];

        for (NSString *highlight in highlights){
            NSRange range = [[attrStr string] rangeOfString:highlight];
            if (range.location != NSNotFound ){
                [attrStr addAttributes:highlightTextAttr range:range];
            }
        }

        self.previewTextView.string = attrStr;

    
}

- (void) hidePlaceholderText 
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.previewTextView.opacity = 0;
    
    [UIView commitAnimations];
}

- (void) highlightHashTag
{

    NSString *lastword = [self.inputText substringWithRange:self.positionOfLastWordTyped];

    if ([[lastword substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"]){
        [self highlightInputTextInRange:self.positionOfLastWordTyped withId:[self getLastWordTyped] withType:@"#" ];    
    }
    
}



- (NSMutableArray *) searchLastTypedWordsForAutoCompletes {
  
    // Put anything that starts with this substring into the autocompleteButtons array
    // The items in this array is what will show up in the scroll view
    
    NSMutableArray *foundAutoCompleters = [[NSMutableArray alloc] init];

    for(GTIOAutoCompleter *option in self.autoCompleteArray) {
        
        if ( [self startedTypingCompleterInLastTwoWords:option] ) {
            [foundAutoCompleters addObject:option];  
            
        }
        else if ([self startedTypingCompleterInLastWord:option] ){
            
            [foundAutoCompleters addObject:option];  
            
        }
        
    }
    return foundAutoCompleters;
}

- (BOOL) startedTypingCompleterInLastTwoWords:(GTIOAutoCompleter *) completer{
    // NSLog(@"lastword %@", [self lastWordTypedInText:self.inputText]);
    if ([[completer.name lowercaseString] rangeOfString:[self getLastTwoWordsTyped]].location == 0 && [self getLastTwoWordsTyped].length>1 ) {
        return true; 
        // NSLog(@"found %@", completer.key);
    }
    else if ([[[self getLastTwoWordsTyped] substringWithRange:NSMakeRange(0,1)] isEqualToString:@"@"] && [self getLastTwoWordsTyped].length>1 ){
        NSRange substringRange = [[completer.name lowercaseString] rangeOfString:[[self getLastTwoWordsTyped] substringWithRange:NSMakeRange(1, [self getLastTwoWordsTyped].length-1)]];
        if (substringRange.location == 0 && [completer.type isEqualToString:@"@"]){
            // NSLog(@"found %@", completer.key);
            return true; 
        }
    }
    return false;
}

- (BOOL) startedTypingCompleterInLastWord:(GTIOAutoCompleter *) completer{
    // NSLog(@"lastword %@", [self lastWordTypedInText:self.inputText]);
    if ([[completer.name lowercaseString] rangeOfString:[self getLastWordTyped]].location == 0 && [self getLastWordTyped].length>1) {
        return true;
    }
    else if ([[[self getLastWordTyped] substringWithRange:NSMakeRange(0,1)] isEqualToString:@"@"] && [self getLastWordTyped].length>1 ){
        NSRange substringRange = [[completer.name lowercaseString] rangeOfString:[[self getLastWordTyped] substringWithRange:NSMakeRange(1, [self getLastWordTyped].length-1)]];
        if (substringRange.location == 0 && [completer.type isEqualToString:@"@"]){
            return true;
        }
    }
    return false;
}

- (void)autoCompleterIdSelected:(NSString*)completer_id {
    
    GTIOAutoCompleter *completer = [self getCompleterWithId:completer_id];

    if ([self startedTypingCompleterInLastWord:completer] | [[self getLastWordTyped] isEqualToString:@"@"] ) {
        [self doAutoCompleteWithCompleter:completer inRange:self.positionOfLastWordTyped];
        [self highlightInputTextInRange:self.positionOfLastWordTyped withId:completer.completer_id withType:completer.type];
    }
    else if ([self startedTypingCompleterInLastTwoWords:completer]){
        [self doAutoCompleteWithCompleter:completer inRange:self.positionOfLastTwoWordsTyped];
        [self highlightInputTextInRange:self.positionOfLastTwoWordsTyped withId:completer.completer_id withType:completer.type];
    }
    [self hideScrollView];
}


- (GTIOAutoCompleter *) getCompleterWithId: (NSString *) completer_id {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"completer_id like %@",
        completer_id];

    NSArray * results = [self.autoCompleteArray filteredArrayUsingPredicate:predicate];

    if ([results count]>0){
        return [results objectAtIndex:0];    
    }
    
    return nil;
}


- (void) doAutoCompleteWithCompleter: (GTIOAutoCompleter *) completer  inRange:(NSRange) range{

    self.inputText = [self.inputText stringByReplacingCharactersInRange:range withString:[completer getCompleterString]];

    [self updateInputDisplayTextInRange:range withString:[completer getCompleterString]];

    range.length = range.length + ([completer getCompleterString].length - range.length);

    [self highlightInputTextInRange:range withId:completer.completer_id withType:completer.type];

    range.location = range.location + range.length ;
    range.length = 0;

    self.inputText = [self.inputText stringByReplacingCharactersInRange:range withString:@" "];

    [self updateInputDisplayTextInRange:range withString:@" "];

    self.textInput.text = self.inputText;

    
}

- (NSArray *) getAtTagCompleters{

   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type like %@",
        @"@"];

    return [self.autoCompleteArray filteredArrayUsingPredicate:predicate];

}

- (BOOL) showAtTagButtons {
    if([[self getLastWordTyped] isEqualToString:@"@"]) {
        NSArray *completers = [self getAtTagCompleters];
        if ([completers count]>0){
            [self showButtonsWithAutoCompleters:[self getAtTagCompleters]];

            return true;
        }
    }
    return false;
}


- (void) cleanUpAttrString {
    
    
    NSDictionary *attributes;
    NSRange effectiveRange = { 0, 0 }; 
    do { 
        NSRange range;
        range = NSMakeRange (NSMaxRange(effectiveRange), [self.attrString length] - NSMaxRange(effectiveRange));
        
        attributes = [self.attrString attributesAtIndex:range.location longestEffectiveRange: &effectiveRange inRange:range ];
        
        if ([attributes objectForKey:@"completerType"] ){
            
            GTIOAutoCompleter * completer = [self getCompleterWithId:[attributes objectForKey:@"completerId"]];

            //if its a hashtag, make sure the hashtag is at the front of the string
            if ([[attributes objectForKey:@"completerType"] isEqualToString:@"#"]){

                NSRange hash = [[[self.attrString string] substringWithRange:effectiveRange] rangeOfString:@"#"];
                if (hash.location !=0) {
                    [self unHighlightInputTextInRange:effectiveRange];
                }
            }
            // if its some other tag, make sure the string still matches
            else if (![[[self.attrString string] substringWithRange:effectiveRange] isEqualToString:[completer getCompleterString]]){
                [self unHighlightInputTextInRange:effectiveRange];
            }

      
        }
       
        
    }
    while (NSMaxRange(effectiveRange) < [self.attrString length]); 


    

}


- (NSString *) getSubmissionText {

    NSString *response = [[NSString alloc] initWithString: @""];
    
   
    

    
        NSDictionary *attributes;
        NSRange effectiveRange = { 0, 0 }; 
        do { 
            NSRange range;
            range = NSMakeRange (NSMaxRange(effectiveRange), [self.attrString length] - NSMaxRange(effectiveRange));
            
            
            attributes = [self.attrString attributesAtIndex:range.location longestEffectiveRange: &effectiveRange inRange:range ];

            
            if ([attributes objectForKey:@"completerType"] ){
                
                response = [response stringByAppendingFormat:@"{%@{%@{%@}}}", [attributes objectForKey:@"completerType"], [attributes objectForKey:@"completerId"], [[self.attrString string] substringWithRange:effectiveRange]];
            }
            else {
                response = [response stringByAppendingString:[[self.attrString string] substringWithRange:effectiveRange]];    
            }
            
        }
        while (NSMaxRange(effectiveRange) < [self.attrString length]); 



    NSLog (@"submission string: %@ ", response);
    
    return response;
}





@end
