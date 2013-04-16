//
//  LoginViewController.h
//  aires
//
//  Created by Gautham on 10/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginSettingsViewController.h"

typedef enum
{
    CELL_USER_FIELD,
    CELL_PWD_FIELD
}CELL_FIELD;

@interface LoginViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
{
    IBOutlet UITableView *loginFieldTable;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *forgotPasswordButton;
    IBOutlet UIButton *settingsButton;
    IBOutlet UIButton *settings2Button;
    
    NSMutableArray *loginCredentials;
    
    UIPopoverController *popover;
    LoginSettingsViewController *mLoginSettingsViewController;
}

-(IBAction)onLogin:(id)sender;
-(IBAction)onForgotPassword:(id)sender;
-(IBAction)onSettings:(id)sender;

@end
