//
//  EnterPasswordController.m
//  PasswordFoo
//
//  Created by Wayne Cochran on 6/16/14.
//  Copyright (c) 2014 Wayne Cochran. All rights reserved.
//

#import "EnterPasswordController.h"
#import "AppDelegate.h"
#import "WOCKeychainWrapper.h"

@interface EnterPasswordController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation EnterPasswordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (!appDelegate.userAuthenticated) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No password created?"
                                                        message:@"Create a password first"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        self.passwordTextField.enabled = NO;
        self.doneButton.enabled = NO;
    } else {
        [self.passwordTextField becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define ALERT_SUCCESS_TAG 1
#define ALERT_FAIL_TAG 2

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == ALERT_SUCCESS_TAG) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)enterPassword:(id)sender {
    NSString *password = self.passwordTextField.text;
    if ([WOCKeychainWrapper passwordMatches:password]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                        message:@"That is the correct password indeed!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = ALERT_SUCCESS_TAG;
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Password!"
                                                        message:@"That is NOT the correct password!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = ALERT_FAIL_TAG;
        [alert show];
    }
}

@end
