//
//  main.m
//  IMP
//
//  Created by miaokii on 2021/3/15.
//

#import <Foundation/Foundation.h>
#import "IMPTest.h"
#import <objc/runtime.h>
#import "Person.h"
#import <malloc/malloc.h>

// c函数指针来接受方法IMP，默认有前两个隐藏参数id、SEL
void (*function) (id, SEL, NSDictionary*);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        IMPTest * obj = [IMPTest new];
        NSDictionary * params = @{@"funcName": @"funcTestParam:"};
        
        // 将c函数指针指向oc方法的实现地址
        function = (void (*)(id, SEL, NSDictionary *))[obj methodForSelector:@selector(funcTestParam:)];
        // 调用c函数
        function(obj, @selector(funcTestParam:), params);
        // 对象调用方法
        // 以上两个方法调用是等价的，函数实现地址是相同的
        [obj funcTestParam:params];
        
        
        // 声明一个使用block实现的IMP
        IMP impFunc = imp_implementationWithBlock(^(id obj, NSDictionary* param) {
          NSLog(@"IMP block call %@ %@", obj, param);
        });
        // 获取funcTestParam的实现
        Method funcTestParam = class_getInstanceMethod([obj class], @selector(funcTestParam:));
        // 重新设置funcTestParam的实现
        method_setImplementation(funcTestParam, impFunc);
        // 调用，此时方法的实现已经被替换为impFunc
        [obj funcTestParam:params];
        
        
        // --------------- 消息转发流程 ---------------
        Person * per = [Person new];
        // 调用未实现的方法
        [per walk];
        [per run];
        // 动态调用
        [per performSelector:@selector(fly)];
        
        NSObject * object = [[NSObject alloc] init];
        sizeof(object);
        class_getInstanceSize([object class]);
        malloc_size(object)
        
    }
    return 0;
}
