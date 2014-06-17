//
//  WOCKeychainWrapper.m
//  PasswordFoo
//
//  Created by Wayne Cochran on 6/16/14.
//  Copyright (c) 2014 Wayne Cochran. All rights reserved.
//
//  https://developer.apple.com/library/mac/documentation/security/Reference/keychainservices/Reference/reference.html
//
//  WWDC Video "Security Framework" has small part on keychain:
//  https://developer.apple.com/videos/wwdc/2012/
//
//  http://www.raywenderlich.com/6475/basic-security-in-ios-5-tutorial-part-1
//  http://useyourloaf.com/blog/2010/04/28/keychain-duplicate-item-when-adding-password.html
//
//
//  We are using keychain item class of kSecClassGenericPassword. The primary key is uniquely
//  identified by the constants kSecAttrAccount and kSecAttrService. See the 'Keychain Services Ease of Use' section in
//  https://developer.apple.com/library/mac/documentation/security/conceptual/keychainServConcepts/02concepts/concepts.html
//
//  kSecAttrAccessGroup is for sharing a keychain item among multiple aplications (we are *not* interested
//  in that here).
//

#import "WOCKeychainWrapper.h"
#import <Security/Security.h>

#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define ACCOUNT @"ImaUser"

@implementation WOCKeychainWrapper

//
// SecItemAdd
//
+(BOOL)setPassword:(NSString*)password {
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *attr = @{(__bridge id) kSecClass: (__bridge id) kSecClassGenericPassword,
                           (__bridge id) kSecAttrAccount : ACCOUNT,
                           (__bridge id) kSecAttrService : APP_NAME,
                           (__bridge id) kSecValueData : passwordData};
    OSStatus err = SecItemAdd((__bridge CFDictionaryRef)attr, NULL);  // NULL => default keychain
    return err == errSecSuccess; // err == errSecDuplicateItem if password already set
}

//
// SecItemUpdate
//
+(BOOL)updatePassword:(NSString*)newPassword OldPassword:(NSString*)oldPassword {
    NSData *oldPasswordData = [oldPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *searchDict = @{(__bridge id) kSecClass: (__bridge id) kSecClassGenericPassword,
                                 (__bridge id) kSecAttrAccount : ACCOUNT,
                                 (__bridge id) kSecAttrService : APP_NAME,
                                 (__bridge id) kSecValueData : oldPasswordData};
    NSData *newPasswordData = [newPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *updateDict = @{(__bridge id) kSecValueData : newPasswordData};
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDict,
                                    (__bridge CFDictionaryRef)updateDict);
    return status == errSecSuccess;
}

//+(BOOL)hasPassword {
//    NSDictionary *query = @{(__bridge id) kSecClass: (__bridge id) kSecClassGenericPassword,
//                            (__bridge id) kSecAttrAccount : ACCOUNT,
//                            (__bridge id) kSecAttrService : APP_NAME};
//    CFTypeRef result = NULL;
//    OSStatus status =  SecItemCopyMatching((__bridge CFDictionaryRef)(query), &result);
//    return status == errSecSuccess && result != NULL;
//}

//
// SecItemCopyMatching
//
+(BOOL)passwordMatches:(NSString*)password {
    NSDictionary *query = @{(__bridge id) kSecClass: (__bridge id) kSecClassGenericPassword,
                            (__bridge id) kSecAttrAccount : ACCOUNT,
                            (__bridge id) kSecAttrService : APP_NAME,
                            (__bridge id) kSecReturnData : (__bridge id) kCFBooleanTrue};
    CFTypeRef resultRef = NULL;
    OSStatus status =  SecItemCopyMatching((__bridge CFDictionaryRef)(query), &resultRef);
    if (status == errSecSuccess && resultRef != NULL) {
        NSData *result = (__bridge_transfer NSData*)resultRef;
        NSString *storedPassword = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        return [storedPassword isEqualToString:password];
    }
    return NO;
}

//
// SecItemDelete()
//
+(BOOL)deletePassword:(NSString*)password {
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *attr = @{(__bridge id) kSecClass: (__bridge id) kSecClassGenericPassword,
                           (__bridge id) kSecAttrAccount : ACCOUNT,
                           (__bridge id) kSecAttrService : APP_NAME,
                           (__bridge id) kSecValueData : passwordData};
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)(attr));
    return status == errSecSuccess;
}

+(void)forceDeletePassword {
    NSDictionary *spec = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword};
    SecItemDelete((__bridge CFDictionaryRef)spec);
}


@end
