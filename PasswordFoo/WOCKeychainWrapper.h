//
//  WOCKeychainWrapper.h
//  PasswordFoo
//
//  Created by Wayne Cochran on 6/16/14.
//  Copyright (c) 2014 Wayne Cochran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOCKeychainWrapper : NSObject

+(BOOL)setPassword:(NSString*)password; // fails if password already set (use update)
+(BOOL)updatePassword:(NSString*)newPassword OldPassword:(NSString*)oldPassword;
+(BOOL)passwordMatches:(NSString*)password;
+(BOOL)deletePassword:(NSString*)password;

@end
