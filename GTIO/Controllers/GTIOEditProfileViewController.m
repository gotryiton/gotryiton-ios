//
//  GTIOEditProfileViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/8/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOEditProfileViewController.h"
#import "GTIOAlmostDoneTableDataItem.h"
#import "GTIOProgressHUD.h"
#import "GTIOUser.h"

@interface GTIOEditProfileViewController ()

@end

@implementation GTIOEditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {    
        [self setHidesBottomBarWhenPushed:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"edit profile" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOUIButton *saveButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeSaveGrayTopMargin tapHandler:^(id sender) {
        [self dismissKeyboard];
        NSMutableArray *missingDataElements = [NSMutableArray array];
        for (GTIOAlmostDoneTableDataItem *dataItem in self.tableData) {
            if ([dataItem required]) {
                if ([[self.saveData valueForKey:[dataItem apiKey]] length] == 0) {
                    [missingDataElements addObject:[dataItem titleText]];
                }
            }
        }
        if ([missingDataElements count] > 0) {
            GTIOAlertView *missingRequiredData = [[GTIOAlertView alloc] initWithTitle:@"incomplete profile!" message:[NSString stringWithFormat:@"Please complete the '%@' section%@.",[missingDataElements componentsJoinedByString:@", "], ([missingDataElements count] > 1) ? @"s" : @""] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [missingRequiredData show];
        } else {
            [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
            NSDictionary *trackingInformation = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 @"edit_profile", @"id",
                                                 @"edit_profile", @"screen",
                                                 nil];
            [[GTIOUser currentUser] updateCurrentUserWithFields:self.saveData withTrackingInformation:trackingInformation andLoginHandler:^(GTIOUser *user, NSError *error) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                if (!error) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [GTIOErrorController handleError:error showRetryInView:self.view forceRetry:NO retryHandler:nil];
                }
            }];
        }
    }];
    [self setRightNavigationButton:saveButton];
    
    GTIOUIButton *cancelButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeCancelGrayTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setLeftNavigationButton:cancelButton];
}

@end
