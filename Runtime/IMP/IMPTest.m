//
//  IMPTest.m
//  IMP
//
//  Created by miaokii on 2021/3/16.
//

#import "IMPTest.h"

@implementation IMPTest
- (void)funcTest {
    NSLog(@"%@", @"run funcTest");
}
- (void)funcTestParam:(NSDictionary *)dict {
    NSLog(@"%@ %@", self, dict);
}
@end
