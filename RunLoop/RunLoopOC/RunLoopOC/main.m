//
//  main.m
//  RunLoopOC
//
//  Created by miaokii on 2021/5/27.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"application start", nil);
        int value = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        NSLog(@"application end", nil);
        return value;
    }
}

