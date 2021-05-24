//
//  Person.m
//  ObjcBuild
//
//  Created by miaokii on 2021/3/9.
//

#import "Person.h"

@implementation Human

+ (void)load {
    NSLog(@"%@", self);
}

+ (void)initialize
{
    if (self == [super class]) {
        
    }
}

@end






@interface Person ()
@property (nonatomic, strong) NSMutableArray <Person *> * friends;
@end

@implementation Person

+ (void)initialize {
    
}

+ (void)load {
    NSLog(@"%@", self);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.friends = [NSMutableArray array];
        
        
        NSLog(@"[self class] = %@",[self class]);
        NSLog(@"[super class] = %@",[super class]);
        NSLog(@"[self superclass] = %@",[self superclass]);
        NSLog(@"[super superclass] = %@",[super superclass]);
        
        
    }
    return self;
}

+ (id)init {
    return [[self alloc] init];
}

- (void)addFriend:(Person *)friend {
    [self.friends addObject:friend];
}

- (void)testMethod {
    NSLog(@"testMethod %p", @selector(testMethod));
}

@end
