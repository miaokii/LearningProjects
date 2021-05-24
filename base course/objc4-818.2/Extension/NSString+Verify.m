//
//  NSString+Verify.m
//  Extension
//
//  Created by miaokii on 2021/4/14.
//

#import "NSString+Verify.h"

@implementation NSString (Verify)

-(bool)isPhoneNum {
    return self.length == 11 && [self hasPrefix:@"1"];
}

@end
