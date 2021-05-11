//
//  NSObject+Model.m
//  Runtime
//
//  Created by miaokii on 2021/3/12.
//

#import "NSObject+Model.h"
#import <objc/runtime.h>

@implementation NSObject (Model)

+ (void)resolveDict:(NSDictionary *)dict {
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString * type;
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
            type = @"NSString";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
            type = @"NSArray";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            type = @"int";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
            type = @"NSDictionary";
        }
        
        // 属性字符串
        NSString * property;
        if ([type containsString:@"NS"]) {
            property = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",type, key];
        } else {
            property = [NSString stringWithFormat:@"@property (nonatomic, assign) %@ %@;",type, key];
        }
        MKLog(@"%@", property);
    }];
}

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    id objc = [[self alloc] init];
    unsigned int count;
    Ivar * ivars = class_copyIvarList(self, &count);
    for (int i = 0; i < count; i ++) {
        Ivar var = ivars[i];
        NSString * varName = [NSString stringWithFormat:@"%s", ivar_getName(var)];
        NSString * key = [varName substringFromIndex:1];
        
        id value = dict[key];
        
        // 二级判断
        if ([value isKindOfClass:[NSDictionary class]]) {
            // 字典转模型
            // 获取模型的类对象，递归
            
            // 获取成员属性类型
            NSString * type = [NSString stringWithFormat:@"%s", ivar_getTypeEncoding(var)];
            
            // 生成的是这种@"@\"User\""
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            
            // 不包括角标
            type = [type substringToIndex:range.location];
            
            Class modelClass = NSClassFromString(type);
            if (modelClass) {
                value = [modelClass modelWithDict:value];
            }
        }
        
        // 判断是否为数组
        else if ([value isKindOfClass:[NSArray class]]) {
            // 判断对应类型是否实现字典数组转模型数组的协议
            if ([objc respondsToSelector:@selector(arrayContainModelClass)]) {
                // 获取数组中字典对应的模型
                NSString * type = [objc arrayContainModelClass][key];
                if (type) {
                    // 生成模型
                    Class classModel = NSClassFromString(type);
                    NSMutableArray * arrTypes = [NSMutableArray array];
                    for (NSDictionary * dic in value) {
                        id model = [classModel modelWithDict:dic];
                        [arrTypes addObject:model];
                    }
                    value = arrTypes;
                }
            }
        }
        
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}

@end
