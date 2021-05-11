//
//  NSObject+KVO.m
//  Runtime
//
//  Created by miaokii on 2021/3/12.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>

@implementation NSObject (KVO)

char nameKey;
- (void)setObjName:(NSString *)objName {
    objc_setAssociatedObject(self, &nameKey, objName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)objName {
    return objc_getAssociatedObject(self, &nameKey);
}

- (BOOL)hasProperty:(NSString *)propertyName {
    unsigned int ivarCount;
    Ivar * ivars = class_copyIvarList([self class], &ivarCount);
    
    for (int i = 0; i < ivarCount; i++) {
        NSString * ivaName = [NSString stringWithFormat:@"%s", ivar_getName(ivars[i])];
        if ([ivaName isEqual: propertyName]) {
            return YES;
        }
    }
    return NO;
}

@end
