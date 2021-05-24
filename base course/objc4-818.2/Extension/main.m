//
//  main.m
//  Extension
//
//  Created by miaokii on 2021/4/14.
//

#import <Foundation/Foundation.h>
#import "NSString+Log.h"
#import "NSString+Verify.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString * phone = @"12222222222";
        NSLog(@"%d", [phone isPhoneNum]);
    }
    return 0;
}
