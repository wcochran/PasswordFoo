//
//  DeletePasswordController.m
//  PasswordFoo
//
//  Created by Wayne Cochran on 6/16/14.
//  Copyright (c) 2014 Wayne Cochran. All rights reserved.
//

#import "DeletePasswordController.h"
#import "AppDelegate.h"
#import "WOCKeychainWrapper.h"

@interface DeletePasswordController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation DeletePasswordController


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
                                                        message:@"No password to delete!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        self.passwordTextField.enabled = NO;
    } else {
        [self.passwordTextField becomeFirstResponder];
    }
}

#define ALERT_SUCCESS_TAG 1
#define ALERT_FAIL_TAG 2

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == ALERT_SUCCESS_TAG) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)deletePassword:(id)sender {
    NSLog(@"deletePassword:");
    NSString *password = self.passwordTextField.text;
    if ([WOCKeychainWrapper passwordMatches:password]) {
        BOOL success = [WOCKeychainWrapper deletePassword:password];
        if (success) {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.userAuthenticated = NO;
        }
        self.passwordTextField.enabled = NO;
        NSString *msg = success ? @"Password successfully deleted!" : @"Password not deleted... hmmm...";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Password"
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = ALERT_SUCCESS_TAG ;
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Password!"
                                                        message:@"Need to know password to delete it!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = ALERT_FAIL_TAG;
        [alert show];
    }
    
    
}

@end
