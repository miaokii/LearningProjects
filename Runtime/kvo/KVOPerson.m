//
//  KVOPerson.m
//  kvo
//
//  Created by miaokii on 2021/4/15.
//

#import "KVOPerson.h"
#import <objc/runtime.h>

@implementation KVOPerson

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.friends = [NSMutableArray array];
    }
    return self;
}

//- (void)setAge:(NSInteger)age {
//    if (_age != age) {
//        [self willChangeValueForKey:@"age"];
//        _age = age;
//        [self didChangeValueForKey:@"age"];
//    }
//}

//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//    if ([key isEqual:@"age"]) {
//        return  false;
//    }
//    return [super automaticallyNotifiesObserversForKey:key];
//}

- (void)objectInfo {
    NSLog(@"object address: %p\n", self);
    
    IMP nameIMP =   class_getMethodImplementation(object_getClass(self), @selector(setName:));
    IMP ageIMP =    class_getMethodImplementation(object_getClass(self), @selector(setAge:));
    IMP friendIMP = class_getMethodImplementation(object_getClass(self), @selector(setFriends:));
    
    NSLog(@"object setName IMP: %p\n", nameIMP);
    NSLog(@"object setAge IMP: %p\n", ageIMP);
    NSLog(@"object setFriends IMP: %p\n", friendIMP);
    
    Class objectClass = [self class];
    Class objectRuntimeClass = object_getClass(self);
    Class superClass = [super class];
    Class objectRuntimeSuperClass = class_getSuperclass(objectRuntimeClass);
    
    NSLog(@"objectClass: %@\n", objectClass);
    NSLog(@"objectRuntimeClass: %@\n", objectRuntimeClass);
    NSLog(@"superClass: %@\n", superClass);
    NSLog(@"objectRuntimeSuperClass: %@\n", objectRuntimeSuperClass);
    
    /*
    NSLog(@"method list:\n");
    unsigned int methodCount;
    Method* methodList = class_copyMethodList(objectRuntimeClass, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methodList[i];
        NSLog(@"method name: %@\n", NSStringFromSelector(method_getName(method)));
    }
     */
}

@end
