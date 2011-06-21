//
//  GTIOSectionedDataSource.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/7/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOSectionedDataSource.h"
#import "GTIOTableImageControlItem.h"
#import "GTIOTableImageControlCell.h"

@interface GTIOPersonalStylistsItemCell : TTTableViewCell {
    NSMutableArray* _thumbnailImageViews;
    UILabel* _personalStylistLabel;
    UILabel* _aditionalTextLabel;
}
@end

@implementation GTIOPersonalStylistsItemCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return 85;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _personalStylistLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _personalStylistLabel.text = @"personal stylists";
        _personalStylistLabel.textColor = RGBCOLOR(128,128,128);
        _personalStylistLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:_personalStylistLabel];
        
        _aditionalTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _aditionalTextLabel.textColor = RGBCOLOR(128,128,128);
        _aditionalTextLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_aditionalTextLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)dealloc {
    [_thumbnailImageViews release];
    [_personalStylistLabel release];
    [_aditionalTextLabel release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _personalStylistLabel.frame = CGRectMake(10,10,200,20);
    
    float xOffset = 10;
    float yPos = 40;
    
    for (TTImageView* imgView in _thumbnailImageViews) {
        imgView.frame = CGRectMake(xOffset, yPos, 35, 35);
        xOffset += 45;
    }
    _aditionalTextLabel.frame = CGRectMake(xOffset, yPos, 300-xOffset, 30);
    
}

- (void)setObject:(id)obj {
    [super setObject:obj];
    GTIOPersonalStylistsItem* item = (GTIOPersonalStylistsItem*)obj;
    
    _aditionalTextLabel.text = item.stylistsQuickLook.text;
    
    for (TTImageView* imgView in _thumbnailImageViews) {
        [imgView removeFromSuperview];
    }
    [_thumbnailImageViews release];
    _thumbnailImageViews = [NSMutableArray new];
    for (NSString* thumbURL in item.stylistsQuickLook.thumbs) {
        TTImageView* imgView = [[[TTImageView alloc] initWithFrame:CGRectZero] autorelease];
        imgView.urlPath = thumbURL;
        
        imgView.layer.borderWidth = 1;
        imgView.layer.cornerRadius = 1;
        imgView.layer.borderColor = RGBCOLOR(217,217,217).CGColor;
        
        [self.contentView addSubview:imgView];
        [_thumbnailImageViews addObject:imgView];
    }
}

@end

@implementation GTIOSectionedDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[GTIOPersonalStylistsItem class]]) {
        return [GTIOPersonalStylistsItemCell class];
    } else if ([object isKindOfClass:[GTIOTableImageControlItem class]]) {
		return [GTIOTableImageControlCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

@end

@implementation GTIOPersonalStylistsItem

@synthesize stylistsQuickLook = _stylistsQuickLook;

- (void)dealloc {
    [_stylistsQuickLook release];
    [super dealloc];
}

@end