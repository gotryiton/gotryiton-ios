//
//  GTIOPlaceholderTextField.h
//  GTIO
//
//  Created by Jeremy Ellison on 9/1/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOPlaceholderTextField : UITextField {
    UILabel* _customPlaceholderLabel;
}

@property (nonatomic, copy) NSString* customPlaceholder;
@property (nonatomic, readonly) UILabel* customPlaceholderLabel;

@end

@interface GTIOPlaceholderTextView : UITextView {
    UILabel* _customPlaceholderLabel;
}
@property (nonatomic, copy) NSString* customPlaceholder;
@property (nonatomic, readonly) UILabel* customPlaceholderLabel;

@end