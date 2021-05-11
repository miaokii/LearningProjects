//
//  main.m
//  Runtime
//
//  Created by miaokii on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "Person.h"
#import "Cat.h"
#import "NSObject+KVO.h"
#import "NSObject+Model.h"
#import "Man.h"

void runtimeFuncs() {
    Person * per = [Person new];

}

// MARK: - runtime常用方法
void runtimeNormalFunc() {
    Person * per = [Person new];
    
    // 1、获取类 Person
    Class personClass = object_getClass([Person class]);
    
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
    Method addMethod = NULL;
    class_addMethod(personClass, @selector(main), method_getImplementation(addMethod), method_getTypeEncoding(addMethod));
     
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
        NSLog(@"method name: %s", sel_getName(method_getName(methodList[i])));
    }
    
    // 8、获取一个类的属性列表
    unsigned int count = 0;
    objc_property_t * properties = class_copyPropertyList([Person class], &count);
    for (int i = 0; i < count; i++) {
        NSLog(@"property name: %s", property_getName(properties[i]));
        NSLog(@"property attribute：%s", property_getAttributes(properties[i]));
    }
    
    // 10、获取成员变量列表
    unsigned int ivarCount;
    Ivar * ivarList = class_copyIvarList([per class], &ivarCount);
    
    for (int i = 0; i < ivarCount; i++) {
        // 11、获取成员变量的名字
        NSLog(@"ivar name：%s",ivar_getName(ivarList[i]));
        // 12、获取成员变量的类型
        NSLog(@"ivar type：%s", ivar_getTypeEncoding(ivarList[i]));
    }
    
    // 13、获取类的协议列表
    unsigned int protocolCount;
    __unsafe_unretained Protocol ** protocolList = class_copyProtocolList(personClass, &protocolCount);
    for (int i = 0; i < protocolCount; i++) {
        NSLog(@"protocol name：%s",protocol_getName(protocolList[i]));
    }
    // 14、set关联类型
    NSString * key = @"ks";
    objc_setAssociatedObject(per, &key, @"name", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 15、读取关联类型值
    objc_getAssociatedObject(per, &key);
    
    // 替换实现
    Method walkMethod = class_getInstanceMethod([per class], @selector(walk));
    IMP walkIMP = imp_implementationWithBlock(^(id obj, NSDictionary* param) {
      NSLog(@"new walk", nil);
    });
    method_setImplementation(walkMethod, walkIMP);
    [per walk];
    
    [per fly];
}

void personNewMethod() {
    
}

// MARK: - 消息发送和转发
void messageSend_messageForward() {
    // cat对象
    Cat * cat = [Cat new];
    
    // 如果没有在Cat类中实现run方法，会抛出
    // unrecognized selector sent to instance异常
    // 编译结果：objc_msgSend(cat, @selector(run))
    [cat fly];
    [cat run];
    [cat miao];
}

// MARK: - 动态添加一个类
void dynamicAddAClass() {
    // 创建一个类
    // param1: 父类
    // param2: 类名
    // param3: 分配个类和元类对象为不的索引ivars的字节数，通常为0
    Class clazz = objc_allocateClassPair([Person class], "Student", 0);
    
    // 添加成员属性_stuID
    // param1: 添加对象
    // param2: 属性命
    // param3: 属性内存大小
    // param4: 属性内存对齐偏移方式 https://www.zhihu.com/question/36590790
    // param5: 属性类型的c字符串 @encode()
    class_addIvar(clazz, "_stuID", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    // 添加成员属性_class
    class_addIvar(clazz, "_class", sizeof(NSUInteger), log2(sizeof(NSUInteger)), @encode(NSUInteger));
    
    // 注册类
    objc_registerClassPair(clazz);
    
    // 创建类的实例
    id stu = [[clazz alloc] init];
    
    // 设置成员属性
    [stu setValue:@"lucy" forKey:@"name"];
    [stu setValue:@"201202211" forKey:@"stuID"];
    object_setIvar(stu, class_getInstanceVariable(clazz, "_class"), @2020);
    
    NSLog(@"new class object: %@", stu);
    // 获取所有成员属性
    unsigned int ivarCount;
    Ivar * ivars = class_copyIvarList(clazz, &ivarCount);
    
    for (int i = 0; i < ivarCount; i++) {
        NSLog(@"ivar name：%s",ivar_getName(ivars[i]));
    }
    
    NSLog(@"stuID: %@, class: %@", [stu valueForKey:@"stuID"], object_getIvar(stu, class_getInstanceVariable(clazz, "_class")));
    
    // 当类或者其子类的实例还存在，就不能调用obj_disposeClassPair方法
    stu = nil;
    
    // 销毁类
    objc_disposeClassPair(clazz);
}

// MARK: - 获取类的所有属性，成员变量和方法
void allPerson() {
    Person * p = [[Person alloc] init];
    p.name = @"Lucy";
    p.age = 12;
    p.address = @"上海";
    p.profession = @"程序媛";
    [p setValue:@"513021188322348211" forKey:@"idCard"];
    
    // 打印所有成员变量
    unsigned int ivarCount;
    Ivar * ivars = class_copyIvarList([p class], &ivarCount);
    for (int i = 0; i < ivarCount; i ++) {
        Ivar var = ivars[i];
        NSString * ivarName = [NSString stringWithFormat:@"%s", ivar_getName(var)];
        id value = [p valueForKey:ivarName];
        if (value) {
            NSLog(@"var name: %@ value: %@", ivarName, value);
        } else {
            NSLog(@"var name: %@ value: nil", ivarName);
        }
    }
    
    // 打印所有成员属性
    unsigned int properCount;
    objc_property_t * properties = class_copyPropertyList([p class], &properCount);
    for (int i = 0; i < properCount; i++) {
        NSString * propertyName = [NSString stringWithFormat:@"%s", property_getName(properties[i])];
        id value = [p valueForKey:propertyName];
        
        if (value) {
            NSLog(@"property name: %@ value: %@", propertyName, value);
        } else {
            NSLog(@"property name: %@ value: nil", propertyName);
        }
    }
    
    // 打印所有方法
    unsigned int methodCount;
    Method * methods = class_copyMethodList([p  class], &methodCount);
    for (int i = 0; i < methodCount; i++) {
        NSString * methodName = [NSString stringWithFormat:@"%s", sel_getName(method_getName(methods[i]))];
        // 每个方法内部都有两个隐含的参数，self和selector
        unsigned int arguments = method_getNumberOfArguments(methods[i]) - 2;
        NSLog(@"mthod name: %@, method argumentCount: %d", methodName, arguments);
    }
    
    // 动态更改成员变量
    NSLog(@"更改name前: %@", p.name);
    Ivar ivarName = class_getInstanceVariable([p class], "_name");
    object_setIvar(p, ivarName, @"汤唯");
    NSLog(@"更改name后: %@", p.name);
    
    // 动态添加方法查看Person.m
    [p performSelector:@selector(fly)];

}

// MARK: - 交换方法实现
void swazzingMethod() {
    
    Method runMethod = class_getInstanceMethod([Tiger class], @selector(run));
    Method miaoMethod = class_getInstanceMethod([Tiger class], @selector(miao));
    method_exchangeImplementations(runMethod, miaoMethod);
    
    Tiger * tiger = [[Tiger alloc] init];
    [tiger run];
    [tiger miao];
}

// MARK: - KVO防止崩溃、类别添加属性
void avoidKVOCrash() {
    Person * p = [[Person alloc] init];
    if ([p hasProperty:@"_name"]) {
        [p setValue:@"kangkai" forKey:@"_name"];
    }
    if ([p hasProperty:@"tel"]) {
        [p setValue:@"110" forKey:@"tel"];
    }
    
    // 类别属性
    p.objName = @"Category name";
    NSLog(@"%@", p.objName);
}

// MARK: - encodeDecode
void encodeDecode() {
    Teacher * p = [[Teacher alloc] init];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:p];
    
    Teacher * p1 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@", p1);
}

// MARK: - 字典转换模型
void dictToModel() {
    NSDictionary * dic = [Man initDic];
    Man * zf = [Man modelWithDict:dic];
    NSLog(@"%@", zf);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        runtimeNormalFunc();
        printf("\n--------------------\n");
        messageSend_messageForward();
        printf("\n--------------------\n");
        dynamicAddAClass();
        printf("\n--------------------\n");
        allPerson();
        printf("\n--------------------\n");
        swazzingMethod();
        printf("\n--------------------\n");
        avoidKVOCrash();
        printf("\n--------------------\n");
        encodeDecode();
        printf("\n--------------------\n");
        dictToModel();
    }
    return 0;
}


