//
//  NSObject+Log.h
//  Runtime
//
//  Created by miaokii on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Log)

+ (instancetype)modelWithDict:(NSDictionary *)dict;
+ (void)resolveDict:(NSDictionary *)dict;
- (NSDictionary *)arrayContainModelClass;

@end

NS_ASSUME_NONNULL_END
