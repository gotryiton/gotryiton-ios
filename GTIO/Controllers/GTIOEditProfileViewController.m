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
    GTIOButton *saveButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeSaveGrayTopMargin tapHandler:^(id sender) {
        NSMutableArray *missingDataElements = [NSMutableArray array];
        for (GTIOAlmostDoneTableDataItem *dataItem in self.tableData) {
            if ([dataItem required]) {
                if ([[self.saveData valueForKey:[dataItem apiKey]] length] == 0) {
                    [missingDataElements addObject:[dataItem titleText]];
                }
            }
        }
        if ([missingDataElements count] > 0) {
            UIAlertView *missingRequiredData = [[UIAlertView alloc] initWithTitle:@"Incomplete Profile!" message:[NSString stringWithFormat:@"Please complete the '%@' section%@.",[missingDataElements componentsJoinedByString:@", "], ([missingDataElements count] > 1) ? @"s" : @""] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
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
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"We were not able to save your profile." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
    }];
    
    GTIOButton *cancelButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeCancelGrayTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self = [super initWithTitle:@"edit profile" italic:YES leftNavBarButton:cancelButton rightNavBarButton:saveButton];
    if (self) {    
        NSMutableArray *selectableYears = [NSMutableArray array];
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        for (int i = 0; i < 100; i++) {
            [selectableYears addObject:[dateFormatter stringFromDate:currentDate]];
            currentDate = [currentDate dateByAddingTimeInterval:-(60 * 60 * 24 * 365.25)];
        }
        
        NSArray *selectableGenders = [NSArray arrayWithObjects:@"female", @"male", nil];
        
        GTIOUser *currentUser = [GTIOUser currentUser];
        self.profilePicture = [currentUser icon];
        
        self.tableData = [NSArray arrayWithObjects:
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"email" andTitleText:@"email" andPlaceHolderText:@"user@domain.com" andAccessoryText:[currentUser email] andPickerItems:nil isRequired:YES usesPicker:NO isMultiline:NO],
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"name" andTitleText:@"name" andPlaceHolderText:@"Jane Doe" andAccessoryText:[currentUser name] andPickerItems:nil isRequired:YES usesPicker:NO isMultiline:NO],
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"city" andTitleText:@"city" andPlaceHolderText:@"New York" andAccessoryText:[currentUser city] andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:NO],
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"state" andTitleText:@"state or country" andPlaceHolderText:@"NY" andAccessoryText:[currentUser state] andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:NO],
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"gender" andTitleText:@"gender" andPlaceHolderText:@"select" andAccessoryText:[currentUser gender] andPickerItems:selectableGenders isRequired:YES usesPicker:YES isMultiline:NO],
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"born_in" andTitleText:@"year born" andPlaceHolderText:@"select year" andAccessoryText:[NSString stringWithFormat:@"%i",[[currentUser birthYear] intValue]] andPickerItems:selectableYears isRequired:NO usesPicker:YES isMultiline:NO],
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"url" andTitleText:@"website" andPlaceHolderText:@"http://myblog.tumblr.com" andAccessoryText:[currentUser url] andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:NO],
                      [[GTIOAlmostDoneTableDataItem alloc] initWithApiKey:@"about" andTitleText:@"about me" andPlaceHolderText:@"...tell us about your personal style!" andAccessoryText:[currentUser aboutMe] andPickerItems:nil isRequired:NO usesPicker:NO isMultiline:YES],
                      nil];
        
        // prepopulate save data with values from current user
        self.saveData = [NSMutableDictionary dictionary];
        for (GTIOAlmostDoneTableDataItem *dataItem in self.tableData) {
            [self.saveData setValue:[dataItem accessoryText] forKey:[dataItem apiKey]];
        }
        
        self.textFields = [NSMutableArray array];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

@end
