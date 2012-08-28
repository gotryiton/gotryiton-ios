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

static CGFloat const kGTIOUserBadgeVerticalOffset = 0.0;
static CGFloat const kGTIOUserBadgeHorizontalOffset = 5.0;

@interface GTIOQuickAddTableCell()

@property (nonatomic, strong) GTIOUIButton *checkbox;
@property (nonatomic, strong) UIImageView *badgeImageView;

@end

@implementation GTIOQuickAddTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];

        // Name
        [self.textLabel setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBook size:18.0]];
        [self.textLabel setTextColor:[UIColor gtio_grayTextColor727272]];
        
        // Description
        [self.detailTextLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0]];
        [self.detailTextLabel setTextColor:[UIColor gtio_grayTextColorA7A7A7]];
        
        // Profile Picture
        UIImageView *innerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask-user-72.png"]];
        [innerShadow sizeToFit];
        [self.imageView addSubview:innerShadow];
        [self.imageView setImage:innerShadow.image];
        [self.imageView.layer setCornerRadius:2.0f];
        [self.imageView.layer setMasksToBounds:YES];
        
        // Checkbox
        _checkbox = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeQuickAddCheckbox];
        [_checkbox addTarget:self action:@selector(selectedCheckbox:) forControlEvents:UIControlEventTouchUpInside];
        [self setAccessoryView:_checkbox];
        
        // Badge
        _badgeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_badgeImageView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)prepareForReuse
{
    self.user = nil;
    [self.badgeImageView setFrame:CGRectZero];
}

- (void)setUser:(GTIOUser *)user
{
    _user = user;
    
    [self.textLabel setText:self.user.name];
    [self.detailTextLabel setText:[self.user.userDescription uppercaseString]];
    __block GTIOQuickAddTableCell *blockSelf = self;
    [self.imageView setImageWithURL:self.user.icon success:^(UIImage *image) {
        [blockSelf setNeedsLayout];
    } failure:nil];
    [self.checkbox setSelected:self.user.selected];
    if (self.user.badge) {
        [self.badgeImageView setImageWithURL:[user.badge badgeImageURLForUserList] success:nil failure:nil];
    }
    [self setNeedsLayout];
}

- (void)selectedCheckbox:(id)sender
{
    GTIOUIButton *button = (GTIOUIButton *)sender;
    [button setSelected:!button.selected];
    
    if ([self.delegate respondsToSelector:@selector(checkboxStateChanged:)]) {
        [self.delegate checkboxStateChanged:button.selected];
    }
    
    [self.user setSelected:button.selected];
}	

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView setFrame:(CGRect){ 8, 9, 36, 36 }];
    [self.textLabel setFrame:CGRectOffset(self.textLabel.frame, (self.imageView.image) ? -10.0 : 0.0, 3.0)];
    [self.detailTextLabel setFrame:CGRectOffset(self.detailTextLabel.frame, (self.imageView.image) ? -10.0 : 0.0, 1.0)];
    if (self.user.badge) {
        [self.badgeImageView setFrame:(CGRect){ (self.textLabel.frame.origin.x + [self nameLabelSize].width + kGTIOUserBadgeHorizontalOffset), (self.textLabel.frame.origin.y + kGTIOUserBadgeVerticalOffset), [self.user.badge badgeImageSizeForUserList] }];
    }
}

-(CGSize)nameLabelSize
{
    return [self.user.name sizeWithFont:self.textLabel.font forWidth:400.0f lineBreakMode:UILineBreakModeTailTruncation];
}


@end
