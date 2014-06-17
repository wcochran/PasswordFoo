//
//  ResetPasswordController.m
//  PasswordFoo
//
//  Created by Wayne Cochran on 6/17/14.
//  Copyright (c) 2014 Wayne Cochran. All rights reserved.
//

#import "ResetPasswordController.h"
#import "AppDelegate.h"
#import "WOCKeychainWrapper.h"

@interface ResetPasswordController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *freshPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmFreshPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *setPasswordButton;

-(IBAction)setNewPassword:(id)sender;

@end

@implementation ResetPasswordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        self.oldPasswordTextField.enabled = NO;
        self.freshPasswordTextField.enabled = NO;
        self.confirmFreshPasswordTextField.enabled = NO;
        self.setPasswordButton.enabled = NO;
    } else {
        [self.oldPasswordTextField becomeFirstResponder];
    }
}

#define ALERT_SUCCESS_TAG 1
#define ALERT_FAIL_TAG 2

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == ALERT_SUCCESS_TAG) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)setNewPassword:(id)sender {
    NSString *oldPassword = self.oldPasswordTextField.text;
    if ([WOCKeychainWrapper passwordMatches:oldPassword]) {
        NSString *newPassword = self.freshPasswordTextField.text;
        if ([newPassword isEqualToString:self.confirmFreshPasswordTextField.text]) {
            if ([WOCKeychainWrapper updatePassword:newPassword OldPassword:oldPassword]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password reset"
                                                                message:@"User now has new password!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                alert.tag = ALERT_SUCCESS_TAG;
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New password fail!"
                                                                message:@"New password NOT created... hmmm..."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                alert.tag = ALERT_FAIL_TAG;
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mismatching new passwords"
                                                            message:@"Enter new password and confirm again"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            alert.tag = ALERT_FAIL_TAG;
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Password!"
                                                        message:@"Need to know password to change it!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = ALERT_FAIL_TAG;
        [alert show];
    }
}

@end
