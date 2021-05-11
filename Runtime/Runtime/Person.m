//
//  Person.m
//  Runtime
//
//  Created by miaokii on 2021/3/11.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person 
{
    NSString* idCard;
    int cousreCount;
}

+ (Person *)share {
    static Person *shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[Person alloc] init];
    });
    return shareManager;
}

+ (void)run {
    MKLog(@"run", nil);
}

- (void)walk {
    MKLog(@"walk", nil);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"Lucy";
        self.address = @"成都";
        self.age = 12;
        self.gender = 1;
        self.profession = @"teacher";
        cousreCount = 10;
        idCard = @"0x";
    }
    return self;
}

// 当一个对象调用的方法未实现，会调用这个方法处理
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(eat)) {
        class_addMethod([self class], sel, (IMP)eat, @"v@:");
    }
    return [super resolveInstanceMethod: sel];
}

void eat(id self, SEL sel) {
    MKLog(@"%@, %@", self, NSStringFromSelector(sel));
}

@end


@implementation Teacher

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"Lucy";
        self.address = @"成都";
        self.profession = @"teacher";
        self.age = 12;
        self.gender = 1;
    }
    return self;
}

codeRuntime

@end
