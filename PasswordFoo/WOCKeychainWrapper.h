//
//  WOCKeychainWrapper.h
//  PasswordFoo
//
//  Created by Wayne Cochran on 6/16/14.
//  Copyright (c) 2014 Wayne Cochran. All rights reserved.
//

//
// This is dumbfoundingly simple wrapper for storing a single password.
// Note that once a password has been stored in the default keychain
// it persists even after the app and its data have been deleted.
//
//


#import <Foundation/Foundation.h>

@interface WOCKeychainWrapper : NSObject

//+(BOOL)hasPassword;
+(BOOL)setPassword:(NSString*)password; // fails if password already set (use update)
+(BOOL)updatePassword:(NSString*)newPassword OldPassword:(NSString*)oldPassword;
+(BOOL)passwordMatches:(NSString*)password;
+(BOOL)deletePassword:(NSString*)password;
+(void)forceDeletePassword;


@end
