//
//  main.m
//  ObjcBuild
//
//  Created by miaokii on 2021/3/9.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <objc/runtime.h>

#ifndef MKLog
#define MKLog(FORMAT, ...)\
fprintf(stderr,"%s:%d %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#endif

#import "MKObject.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        printf("hahahha");
        // 动态创建类
        Class TestClass = objc_allocateClassPair([NSObject class], "TestObject", 0);
        bool ivarBool = class_addIvar(TestClass, "testIvar", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        objc_registerClassPair(TestClass);

        bool ivarBool2 = class_addIvar(TestClass, "passWord", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));

        id testObj = [[TestClass alloc] init];
        if (ivarBool) {
            [testObj setValue:@"this is a ivar string" forKey:@"testIvar"];
            MKLog(@"%@", [testObj valueForKey:@"testIvar"]);
        }

        if (ivarBool2) {
            MKLog(@"passWord添加成功");
        }
        
        // 动态添加协议
        Protocol * pro = objc_allocateProtocol("TestProtocol");
        protocol_addMethodDescription(pro, "instanceMethod", "v@:", YES, YES);
        protocol_addMethodDescription(pro, "classMethod", "v@:", YES, NO);
        
        class_addProtocol([Person class], pro);
        objc_registerProtocol(pro);
        
        Person * p = [Person alloc];
        // 打印所有方法
        unsigned int methodCount;
        Method * methods = class_copyMethodList([p  class], &methodCount);
        for (int i = 0; i < methodCount; i++) {
            NSString * methodName = [NSString stringWithFormat:@"%s", sel_getName(method_getName(methods[i]))];
            // 每个方法内部都有两个隐含的参数，self和selector
            unsigned int arguments = method_getNumberOfArguments(methods[i]) - 2;
            MKLog(@"mthod name: %@, method argumentCount: %d", methodName, arguments);
        }
        
        unsigned int protocolCount;
        __unsafe_unretained Protocol ** protocolList = class_copyProtocolList([p class], &protocolCount);
        for (int i = 0; i < protocolCount; i++) {
            MKLog(@"protocol name：%s",protocol_getName(protocolList[i]));
        }
    
        // 查看地址
        Person * pp = [Person alloc];
        Person * p1 = [pp init];
        Person * p2 = [pp init];
        Person * p4 = [Person new];
        
        NSLog(@"%@-%@-%p", pp, pp, &pp);
        NSLog(@"%@-%@-%p", pp, p1, &p1);
        NSLog(@"%@-%@-%p", pp, p2, &p2);
        NSLog(@"%@-%@-%p", pp, p4, &p4);
        
        Method add = class_getInstanceMethod([p1 class], @selector(addFriend:));
        IMP addImp = method_getImplementation(add);
        method_setImplementation(add, addImp);
        
        BOOL rs1 = [[NSObject class] isKindOfClass:[NSObject class]];
        BOOL rs2 = [[NSObject class] isMemberOfClass:[NSObject class]];
        BOOL rs3 = [[Person class] isKindOfClass:[Person class]];
        BOOL rs4 = [[Person class] isMemberOfClass:[Person class]];
    
        NSLog(@"rs1 = %d,rs2 = %d,rs3 = %d,rs4 = %d",rs1,rs2,rs3,rs4);
        
        // 不同对象的同名方法，SEL就是同一个
        // 调用时转换成objc_messageSend函数调用，这个函数有两个隐藏参数
        // 第一个是当前调用对象，第二个参数是当前调用方法的SEL
        // 所以可以区分那个对象调用的SEL方法
        [p testMethod];
        [[MKObject new] testMethod];
        
        id __weak obj = [[Person alloc] init];
        NSLog(@"%@", obj);
        
    }
    return 0;
}

