//
//  Person.m
//  IMP
//
//  Created by miaokii on 2021/4/16.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Man.h"
@implementation Person

// 消息转发流程
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (!strcmp("fly", sel_getName(sel))) {
        // 添加方法实现
        class_addMethod([self class], sel, (IMP)canNotFly, "v@:");
        return true;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

// 消息备用接收者
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(walk) && [Man instancesRespondToSelector:aSelector]) {
        return [[Man alloc] init];
    }
    return [super forwardingTargetForSelector: aSelector];
}

// 当备用消息接收者为nil时，生成方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(run)) {
        // 为转发的方法手动生成签名
        // 签名类型就是用来描述这个方法的返回值、参数的
        // 方法签名默认隐藏两个参数
        // self代表方法调用者
        // _cmd代表这个方法的sel
        // v@:表示：v代表放回值void、@代表self，:代表_cmd
        return [NSMethodSignature signatureWithObjCTypes: "v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

// 当动态方法解析和备用接收者都没有处理这个消息时，执行完整消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = [anInvocation selector];
    if ([Man instancesRespondToSelector: selector]) {
        // 转发到Man对象实现
        [anInvocation invokeWithTarget:[Man new]];
    }
}

void canNotFly(id self, SEL sel) {
    NSLog(@"%@ can not %@", self, NSStringFromSelector(sel));
}


@end
