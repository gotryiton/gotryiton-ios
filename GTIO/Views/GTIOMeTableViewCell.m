//
//  GTIOMeTableViewCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMeTableViewCell.h"

@interface GTIOMeTableViewCell()

@property (nonatomic, strong) UIImageView *heart;

@end

@implementation GTIOMeTableViewCell

@synthesize heart = _heart, hasHeart = _hasHeart;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:16.0]];
        [self.textLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
        _heart = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.heart setImage:[UIImage imageNamed:@"profile.icon.heart.png"]];
        [self.contentView addSubview:self.heart];
        self.hasHeart = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.hasHeart) {
        [self.heart setFrame:(CGRect){ 36, 16, 15, 12 }];
    } else {
        [self.heart setFrame:CGRectZero];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
