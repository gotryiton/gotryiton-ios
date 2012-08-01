//
//  GTIOInviteFriendsTableCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOInviteFriendsTableCell.h"
#import "TTTAttributedLabel.h"

@interface GTIOInviteFriendsTableCell()

@property (nonatomic, strong) TTTAttributedLabel *nameLabel;

@end

@implementation GTIOInviteFriendsTableCell

@synthesize nameLabel = _nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[TTTAttributedLabel alloc] initWithFrame:(CGRect){ 10, 13, self.contentView.bounds.size.width - 20, 20 }];
        _nameLabel.textColor = [UIColor gtio_grayTextColor8F8F8F];
        _nameLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:14.0];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)setFirstName:(NSString *)firstName lastName:(NSString *)lastName
{
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, (lastName.length > 0) ? lastName : @""];
    
    [self.nameLabel setText:fullName afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        if (lastName.length > 0) {
            NSRange boldRange = [fullName rangeOfString:firstName];
            UIFont *boldFont = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBold size:14.0];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldFont.fontName, boldFont.pointSize, NULL);
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                CFRelease(font);
            }
        }
        return mutableAttributedString;
    }];
}

@end
