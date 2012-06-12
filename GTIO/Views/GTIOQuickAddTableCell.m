//
//  GTIOQuickAddTableCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOQuickAddTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@interface GTIOQuickAddTableCell()

@property (nonatomic, strong) GTIOButton *checkbox;
@property (nonatomic, strong) UIImageView *badge;

@end

@implementation GTIOQuickAddTableCell

@synthesize user = _user, delegate = _delegate, checkbox = _checkbox, badge = _badge;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Name
        [self.textLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:18.0]];
        [self.textLabel setTextColor:[UIColor gtio_reallyDarkGrayTextColor]];
        
        // Location
        [self.detailTextLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaLight size:10.0]];
        [self.detailTextLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
        
        // Profile Picture
        UIImageView *innerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask-user-72.png"]];
        [innerShadow sizeToFit];
        [self.imageView addSubview:innerShadow];
        [self.imageView setImage:innerShadow.image];
        [self.imageView.layer setCornerRadius:2.0f];
        [self.imageView.layer setMasksToBounds:YES];
        
        // Checkbox
        _checkbox = [GTIOButton buttonWithGTIOType:GTIOButtonTypeQuickAddCheckbox];
        [_checkbox addTarget:self action:@selector(selectedCheckbox:) forControlEvents:UIControlEventTouchUpInside];
        [self setAccessoryView:_checkbox];
        
        // Badge
        _badge = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_badge];
    }
    return self;
}

- (void)prepareForReuse
{
    self.user = nil;
}

- (void)setUser:(GTIOUser *)user
{
    _user = user;
    
    [self.textLabel setText:self.user.name];
    [self.detailTextLabel setText:self.user.location];
    __block GTIOQuickAddTableCell *blockSelf = self;
    [self.imageView setImageWithURL:self.user.icon success:^(UIImage *image) {
        [blockSelf setNeedsLayout];
    } failure:nil];
    [self.checkbox setSelected:self.user.selected];
    if (self.user.badge) {
        [self.badge setImageWithURL:user.badge.path];
    }
    [self setNeedsLayout];
}

- (void)selectedCheckbox:(id)sender
{
    GTIOButton *button = (GTIOButton *)sender;
    [button setSelected:!button.selected];
    
    if ([self.delegate respondsToSelector:@selector(checkboxStateChanged:)]) {
        [self.delegate checkboxStateChanged:button];
    }
    
    [self.user setSelected:button.selected];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView setFrame:(CGRect){ 8, 9, 36, 36 }];
    [self.textLabel setFrame:CGRectOffset(self.textLabel.frame, (self.imageView.image) ? -30.0 : 0.0, 0.0)];
    [self.detailTextLabel setFrame:CGRectOffset(self.detailTextLabel.frame, (self.imageView.image) ? -30.0 : 0.0, -2.0)];
    if (self.user.badge) {
        [self.badge setFrame:(CGRect){ self.textLabel.frame.origin.x + self.textLabel.bounds.size.width + 2.0, self.textLabel.frame.origin.y + 2.0, 15, 15 }];
    }
}

@end