//
//  Cat.m
//  Runtime
//
//  Created by miaokii on 2021/3/12.
//

#import "Cat.h"
#import <objc/runtime.h>

@implementation Cat
/*
 [car run]方法会被编译成
 objc_msgSend(cat, @selector(run));
 
 objc_msgSend的执行流程如下：
 
    1、通过isa指针查找对象所属的类
    2、查找类的cache列表，如果没有则下一步
    3、查找类的方法列表
    4、如果找到了与方法选择器名称相同的方法，跳转至实现代码
    5、找不到，沿着继承体系一直向上查找
    6、找到了与方法选择名称相同的方法，就跳转至实现代码
    7、找不到，执行消息转发
 
 如果执行的方法在继承体系中都没有查找到话，会执行消息转发流程
 消息转发流程如下：
    1、动态方法解析：通过+resolveInstanceMethod:方法询问接收者所属的类，能不能动态添加其他方法来处理这个未知消息，如果能，消息转发结束
    2、备用接收者：当动态方法解析不能处理时，通过-forwardingTargetForSelector：方法询问接收者有没有其他对象能处理这条消息，如果有，将该消息转发给能处理的其他对象，消息转发结束
    3、消息签名：当备用接收者也不能处理这条消息时，需要返回一个消息签名给后一步消息转发，如果返回nil，消息转发结束
    4、完整的消息转发：如果备用接收者也不能处理这条消息，就将消息的所有相关信息都封装到NSInvocation对象，再问一次接收者，是否能处理，如果不能处理，崩溃
 */

// 在main中调用了run实例方法，但是.m中没有实现该方法，走消息转发流程
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // run方法未实现
    if (sel == @selector(run)) {
        // 返回默认处理，会执行请求备用消息接收者方法
        // -forwardingTargetForSelector:
        return [super resolveInstanceMethod:sel];
    }
    // fly方法未实现，动态添加方法来处理
    else if (sel == @selector(fly)) {
        // 添加方法实现
        // oc实例方法
        IMP instanceMethodfly =
        method_getImplementation(class_getInstanceMethod([self class], @selector(catNotFly)));
        // c方法
        IMP c_method_notFlay = (IMP)catNotFly;
        
        // param1: 添加方法的类
        // param2: 添加实现的方法选择器
        // param3: 实现方法地址
        // param4: 实现方法的返回值和参数
        class_addMethod([self class], sel, c_method_notFlay, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

// 当resolveInstanceMethod返回false时，请求备用消息接收者
- (id)forwardingTargetForSelector:(SEL)aSelector {
    // 将Tiger对象返回给备用接收者
    if (aSelector == @selector(run) && [Tiger instancesRespondToSelector:aSelector]) {
        return [Tiger new];
    }
    return [super forwardingTargetForSelector: aSelector];
}

// 当备用消息接收者为nil时，生成方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(miao)) {
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
    if ([Tiger instancesRespondToSelector: selector]) {
        // 转发到Tiger对象实现
        [anInvocation invokeWithTarget:[Tiger new]];
    }
}

- (void)catNotFly {
    NSLog(@"%s can not fly", class_getName([self class]));
}

void catNotFly() {
    printf("Cat can not fly\n");
}
@end


@implementation Tiger

- (void)run {
    printf("%s run\n", class_getName([self class]));
}

- (void)miao {
    printf("%s miao\n", class_getName([self class]));
}

@end
