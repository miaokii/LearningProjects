//
//  prefixHeader.h
//  Runtime
//
//  Created by miaokii on 2021/3/12.
//

#ifndef prefixHeader_h
#define prefixHeader_h

#ifndef MKLog
#define MKLog(FORMAT, ...)\
fprintf(stderr,"%s%d：%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#endif

#define codeRuntime \
- (void)encodeWithCoder:(nonnull NSCoder *)coder { \
    unsigned int count; \
    Ivar * ivars = class_copyIvarList([self class], &count); \
    for (int i = 0; i < count; i++) { \
        NSString * ivarName = [NSString stringWithFormat:@"%s", ivar_getName(ivars[i])]; \
        id value = [self valueForKey:ivarName]; \
        [coder encodeObject:value forKey:ivarName]; \
    } \
    free(ivars); \
} \
 \
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder { \
    if (self == [super init]) { \
        unsigned int count; \
        Ivar * ivars = class_copyIvarList([self class], &count); \
        for (int i = 0; i < count; i++) { \
            NSString * ivarName = [NSString stringWithFormat:@"%s", ivar_getName(ivars[i])]; \
            id value = [coder decodeObjectForKey:ivarName]; \
            object_setIvar(self, ivars[i], value); \
        } \
        free(ivars); \
    } \
    return self; \
} \

#endif /* prefixHeader_h */
