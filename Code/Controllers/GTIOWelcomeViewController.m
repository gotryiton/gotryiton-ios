//
//  GTIOWelcomeViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOWelcomeViewController.h"
#import "GTIOBrowseListTTModel.h"
#import "GTIOOutfit.h"
#import "GTIOOutfitViewController.h"

@implementation GTIOWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:@"GTIOWelcomeViewController" bundle:nibBundleOrNil]) {
        
    }
    
    return self;
}

- (IBAction)loginButtonWasPressed {
    TTOpenURL(@"gtio://login");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"self.view: %@", self.view.subviews);
    UIImage* image = [[UIImage imageNamed:@"welcome-button.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:12];
    [_welcomeButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)createModel {
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(@"/welcome-outfits") delegate:nil];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = [GTIOUser paramsByAddingCurrentUserIdentifier:[NSDictionary dictionary]];
    GTIOBrowseListTTModel* model = [GTIOBrowseListTTModel modelWithObjectLoader:objectLoader];
    self.model = model;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)modelDidStartLoad:(id<TTModel>)model {
    [_spinner startAnimating];
}

- (void)modelDidFinishLoad:(id<TTModel>)aModel {
    [_spinner stopAnimating];
    GTIOBrowseListTTModel* model = (GTIOBrowseListTTModel*)aModel;
    GTIOBrowseList* list = model.list;
    srand(time(NULL));
    for (int i = 0; i < [list.outfits count]; i++) {
        GTIOOutfit* outfit = [list.outfits objectAtIndex:i];
        TTImageView* imageView = [[[TTImageView alloc] initWithFrame:CGRectMake(0,0,71,90)] autorelease];
        imageView.urlPath = outfit.iphoneThumbnailUrl;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"welcome-thumb-overlay.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(outfitButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        
        int row = floor(i/5);
        int column = i%5;
//        NSLog(@"(%d,%d)", row, column);
        int x = 61 * column;
        int y = 80*row;
        CGRect frame = CGRectMake(x,y,71,90);
        
        imageView.frame = CGRectInset(frame,10,10);
        button.frame = frame;
        [_outfitImagesView addSubview:imageView];
        [_outfitImagesView addSubview:button];
        
        imageView.alpha = 0;
        button.alpha = 0;
        float delay = (rand() / (float)((unsigned)RAND_MAX + 1))*2;
        NSLog(@"Delay: %f", delay);
        [self performSelector:@selector(fadeIn:) withObject:[NSArray arrayWithObjects:imageView, button, nil] afterDelay:delay];
    }
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error {
    NSLog(@"Error: %@", error);
    [_spinner stopAnimating];
}

- (void)modelDidCancelLoad:(id<TTModel>)model {
    [_spinner stopAnimating];
}

- (void)fadeIn:(NSArray*)items {
    [UIView beginAnimations:nil context:nil];
    for (UIView* view in items) {
        view.alpha = 1;
    }
    [UIView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)outfitButtonTouched:(id)sender {
    int index = [(UIView*)sender tag];
    NSLog(@"index: %d", index);
    
//    GTIOOutfitViewController* viewController = [[GTIOOutfitViewController alloc] initWithModel:self.model outfitIndex:index];
//    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];

    // Matt V. For some reason wants this to pop back to the home controller.
    // This provides a very strange UX that i believe will confuse users more than be useful.
    GTIOOutfitViewController* viewController = [[GTIOOutfitViewController alloc] initWithModel:self.model outfitIndex:index];
    [self dismissModalViewControllerAnimated:YES];
    UIViewController* home = [[TTNavigator navigator] viewControllerForURL:@"gtio://home"];
    [home.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

@end
