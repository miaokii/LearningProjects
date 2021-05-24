//
//  MKObject.m
//  ObjcBuild
//
//  Created by miaokii on 2021/3/18.
//

#import "MKObject.h"

@implementation MKObject

- (void)testMethod {
    NSLog(@"testMethod %p", @selector(testMethod));
    
    [super class];
}

+ (void)initialize
{
    if (self == [super class]) {
        
    }
}

@end
