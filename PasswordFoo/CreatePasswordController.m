//
//  CreatePasswordController.m
//  PasswordFoo
//
//  Created by Wayne Cochran on 6/16/14.
//  Copyright (c) 2014 Wayne Cochran. All rights reserved.
//

#import "CreatePasswordController.h"
#import "AppDelegate.h"
#import "WOCKeychainWrapper.h"

@interface CreatePasswordController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation CreatePasswordController


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
    if (appDelegate.userAuthenticated) {
        self.passwordTextField.enabled = NO;
        self.confirmPasswordTextField.enabled = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password already Created!"
                                                        message:@"You already have a password. You can reset the password elsewhere."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
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


- (IBAction)setPassword:(id)sender {
    NSLog(@"setPassword:");
    NSString *password = self.passwordTextField.text;
    if ([password isEqualToString:self.confirmPasswordTextField.text]) {
        [WOCKeychainWrapper setPassword:password];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.userAuthenticated = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password set"
                                                        message:@"User Authenticated"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = ALERT_SUCCESS_TAG;
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mismatching passwords"
                                                        message:@"Enter passwords again"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = ALERT_FAIL_TAG;
        [alert show];
    }
}

@end
