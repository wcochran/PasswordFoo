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
// The first time an app is run, you may want to 'forceDeletePassword' to make
// sure there is no hangover password in the keychain (from a previous
// installation).
// Also, setting a password will silently fail if a password is already set, so
// you need to track (in some persistent storage) some indicator that a password
// is already set to avoid this situation.
//
// Note that use should not store plain text passwords at all; e.g., use CC_SHA256
// (from ) to hash the plaintext passowrd before storing it.
// (see http://www.raywenderlich.com/6475/basic-security-in-ios-5-tutorial-part-1).
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
