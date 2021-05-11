//
//  Test.m
//  Runtime
//
//  Created by miaokii on 2021/4/16.
//

#import "Test.h"
#import "Person.h"
#import <objc/runtime.h>

@interface Test ()

@property (nonatomic, strong) Person * person;

@end

@implementation Test

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.person = [[Person alloc] init];
    }
    return self;
}

- (void)normalRuntime {
    Person * per = [Person new];
    
    // 1、获取类 Person
    Class personClass = object_getClass([Person class]);
    // 父类类型
    class_getSuperclass(object_getClass([Person class]));
    
    // 2、SEL是selector在Objc中的表示
    SEL oriSel = @selector(main);
    
    // 3、获取类方法
    Method classMethod = class_getClassMethod(personClass, @selector(run));
    
    // 4、获取实例方法
    Method instanceMethod = class_getInstanceMethod([per class], @selector(walk));
    
    // 5、添加方法
    // param1：添加方法的类
    // param2：要添加方法的的选择器
    // param3：要添加方法的实现指针，这个方法至少有两个隐藏函数self和_cmd
    // param4：描述方法的参数
    Method addMethod = class_getInstanceMethod(object_getClass([self class]), @selector(personNewMethod));
    class_addMethod(personClass, @selector(personNewMethod), method_getImplementation(addMethod), method_getTypeEncoding(addMethod));
     
    // 6、替换原来方法类
    // param1：修改的对象
    // param2：修改对象的方法
    // param3：新方法的实现指针
    // param4：新方法的参数
    class_replaceMethod(personClass, oriSel, method_getImplementation(addMethod), method_getTypeEncoding(addMethod));
    
    // 交换前执行
    [Person run];
    [per walk];
    
    // 7、交换两个参数
    method_exchangeImplementations(classMethod, instanceMethod);
    
    // 交换后执行
    [Person run];
    [per walk];
    
    // 8、获取类的方法列表
    unsigned int classMethodCount = 0;
    Method * methodList = class_copyMethodList([Person class], &classMethodCount);
    for (int i = 0; i < classMethodCount; i++) {
        MKLog(@"method name: %s", sel_getName(method_getName(methodList[i])));
    }
    
    // 8、获取一个类的属性列表
    unsigned int count = 0;
    objc_property_t * properties = class_copyPropertyList([Person class], &count);
    for (int i = 0; i < count; i++) {
        MKLog(@"property name: %s", property_getName(properties[i]));
        MKLog(@"property attribute：%s", property_getAttributes(properties[i]));
    }
    
    // 10、获取成员变量列表
    unsigned int ivarCount;
    Ivar * ivarList = class_copyIvarList([per class], &ivarCount);
    
    for (int i = 0; i < ivarCount; i++) {
        // 11、获取成员变量的名字
        MKLog(@"ivar name：%s",ivar_getName(ivarList[i]));
        // 12、获取成员变量的类型
        MKLog(@"ivar type：%s", ivar_getTypeEncoding(ivarList[i]));
    }
    
    // 13、获取类的协议列表
    unsigned int protocolCount;
    __unsafe_unretained Protocol ** protocolList = class_copyProtocolList(personClass, &protocolCount);
    for (int i = 0; i < protocolCount; i++) {
        MKLog(@"protocol name：%s",protocol_getName(protocolList[i]));
    }
    // 14、set关联类型
    NSString * key = @"ks";
    objc_setAssociatedObject(per, &key, @"name", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 15、读取关联类型值
   objc_getAssociatedObject(per, &key);
    
    Method walkMethod = class_getInstanceMethod([per class], @selector(walk));
    IMP walkIMP = imp_implementationWithBlock(^(id obj, NSDictionary* param) {
      NSLog(@"new walk", nil);
    });
    method_setImplementation(walkMethod, walkIMP);
}

- (void)personNewMethod {
    NSLog(@"self: %@", self);
}

@end
