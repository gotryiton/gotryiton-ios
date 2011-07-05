//
//  GTIOFeaturedViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 6/14/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOFeaturedViewController.h"
#import "GTIOBrowseListTTModel.h"
#import "GTIOListSection.h"
#import "GTIOProfile.h"
#import "GTIOHeaderView.h"

@interface GTIOFeaturedStylistBadge : UIControl {
    GTIOProfile* _stylist;
    TTImageView* _profileImageView;
    UIImageView* _profileOverlayView;
    UILabel* _nameView;
    UIImageView* _connectionIconView;
}

@property (nonatomic, retain) GTIOProfile* profile;

@end

@implementation GTIOFeaturedStylistBadge

@synthesize profile = _profile;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _profileImageView = [[TTImageView alloc] initWithFrame:CGRectZero];
        _profileImageView.defaultImage = [UIImage imageNamed:@"empty-profile-pic.png"];
        [self addSubview:_profileImageView];
        
        _profileOverlayView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-overlay-110.png"]];
        _profileOverlayView.backgroundColor = [UIColor clearColor];
        [self addSubview:_profileOverlayView];
        
        _nameView = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameView.font = kGTIOFetteFontOfSize(16);
        _nameView.textColor = kGTIOColorBrightPink;
        _nameView.textAlignment = UITextAlignmentCenter;
        _nameView.lineBreakMode = UILineBreakModeMiddleTruncation;
        _nameView.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameView];
        
        _connectionIconView = [[UIImageView alloc] initWithImage:nil];
        [self addSubview:_connectionIconView];
        
        _profileImageView.userInteractionEnabled = NO;
        _profileImageView.exclusiveTouch = NO;
        _profileOverlayView.exclusiveTouch = NO;
        _connectionIconView.exclusiveTouch = NO;
        [self addTarget:nil action:@selector(badgeTouched:) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc {
    [_profileImageView release];
    [_profileOverlayView release];
    [_nameView release];
    [_connectionIconView release];
    [_profile release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _profileImageView.frame = CGRectMake(20,10,55,55);
    _profileOverlayView.frame = CGRectInset(_profileImageView.frame, -4, -4);
    _nameView.frame = CGRectMake(0, 80, self.bounds.size.width, 15);
}

- (void)setProfile:(GTIOProfile*)profile {
    [profile retain];
    [_profile release];
    _profile = profile;
    _profileImageView.urlPath = profile.profileIconURL;
    _nameView.text = [profile.displayName uppercaseString];
    _connectionIconView.image = [profile.stylistRelationship imageForFeaturedConnection];
    _connectionIconView.frame = CGRectMake(57,47,18,18);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, 95, 95)];
}

@end

@interface GTIOFeaturedSectionView : UIView {
    GTIOListSection* _section;
    NSArray* _stylistViews;
    UIView* _titleView;
    UILabel* _titleLabel;
    UIImageView* _backgroundImageView;
    UIImageView* _bottomImageView;
}
@property (nonatomic, retain) GTIOListSection* section;

@end

@implementation GTIOFeaturedSectionView

@synthesize section = _section;

- (id)initWithFrame:(CGRect)rect {
    if ((self = [super initWithFrame:rect])) {
        _titleView = [[UIView alloc] initWithFrame:CGRectZero];
        _titleView.backgroundColor = RGBCOLOR(227,227,227);
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 2;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = RGBCOLOR(128,128,128);
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleView addSubview:_titleLabel];
        [self addSubview:_titleView];
        
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow-wallpaper.png"]];
        [self addSubview:_backgroundImageView];
        _bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow-wallpaper-bottom.png"]];
        [self addSubview:_bottomImageView];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)dealloc {
    [_section release];
    [_stylistViews release];
    [_titleView release];
    [_titleLabel release];
    [_backgroundImageView release];
    [_bottomImageView release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // layout titleView
    _titleView.frame = CGRectMake(0,0,320,40);
    _titleLabel.frame = CGRectMake(40,0,240,40);
    
    // layout badges.
    int row = 0;
    int column = 0;
    for (UIView* view in _stylistViews) {
        int y = 11 + (105*row) + CGRectGetMaxY(_titleView.frame);
        int x = 17 + (95*column);
        view.frame = CGRectOffset(view.bounds, x, y);
        column++;
        if (column > 2) {
            column = 0;
            row++;
        }
    }
    
    _backgroundImageView.frame = CGRectOffset(_backgroundImageView.bounds, 0, _titleView.bounds.size.height);
    _bottomImageView.frame = CGRectOffset(_bottomImageView.bounds, 0, self.bounds.size.height - _bottomImageView.bounds.size.height);
}

- (void)sizeToFit {
    int rows = ceil([_section.stylists count] / 3.0f);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 320, 40+11+(rows*95)+20);
}

- (void)setSection:(GTIOListSection*)section {
    [section retain];
    [_section release];
    _section = section;
    
    for (UIView* view in _stylistViews) {
        [view removeFromSuperview];
    }
    [_stylistViews release];
    
    NSMutableArray* views = [NSMutableArray array];
    for (GTIOProfile* profile in section.stylists) {
        GTIOFeaturedStylistBadge* badge = [[[GTIOFeaturedStylistBadge alloc] initWithFrame:CGRectZero] autorelease];
        badge.profile = profile;
        [self addSubview:badge];
        [views addObject:badge];
    }
    _titleLabel.text = section.title;
    _stylistViews = [views copy];
}


@end

@implementation GTIOFeaturedScrollView

@synthesize sections = _sections;

- (void)dealloc {
    [_sections release];
    [_sectionViews release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // layout sections
    float y = 0;
    for (UIView* section in _sectionViews) {
        [section sizeToFit];
        float height = section.bounds.size.height;
        section.frame = CGRectMake(0,y,320,height);
        y += height;
    }
    
    self.contentSize = CGSizeMake(320,y);
}

- (void)setSections:(NSArray*)sections {
    [sections retain];
    [_sections release];
    _sections = sections;
    
    for (GTIOFeaturedSectionView* sectionView in _sectionViews) {
        [sectionView removeFromSuperview];
    }
    [_sectionViews release];
    
    NSMutableArray* views = [NSMutableArray array];
    for (GTIOListSection* section in _sections) {
        GTIOFeaturedSectionView* view = [[[GTIOFeaturedSectionView alloc] initWithFrame:CGRectZero] autorelease];
        view.section = section;
        [self addSubview:view];
        [views addObject:view];
    }
    
    _sectionViews = [views copy];
}

@end

@implementation GTIOFeaturedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)loadView {
    [super loadView];
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"FEATURED"];
    _scrollView = [[GTIOFeaturedScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    UIBarButtonItem* myStylistsButton = [[[GTIOBarButtonItem alloc] initWithTitle:@"my stylists"
                                                                     target:self
                                                                     action:@selector(stylistsButtonWasPressed:)] autorelease];
    self.navigationItem.rightBarButtonItem = myStylistsButton;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [_scrollView release];
}

- (void)stylistsButtonWasPressed:(id)sender {
    if ([GTIOUser currentUser].loggedIn) {
       TTOpenURL(@"gtio://stylists");
    } else {
        TTOpenURL(@"gtio://login");
    }
}

- (void)createModel {
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/featured-stylists") delegate:nil];
    objectLoader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    objectLoader.method = RKRequestMethodPOST;
    GTIOBrowseListTTModel* model = [GTIOBrowseListTTModel modelWithObjectLoader:objectLoader];
    self.model = model;
}

- (void)didLoadModel:(BOOL)firstTime {
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)self.model;
    NSArray* sections = model.list.sections;
    
    _scrollView.sections = sections;
    [_scrollView setNeedsLayout];
    
}

- (void)badgeTouched:(GTIOFeaturedStylistBadge*)badge {
    NSString* url = [NSString stringWithFormat:@"gtio://profile/%@", badge.profile.uid];;
    TTOpenURL(url);
}

@end
