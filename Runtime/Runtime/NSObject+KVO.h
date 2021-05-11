//
//  NSObject+KVO.h
//  Runtime
//
//  Created by miaokii on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVO)

@property (nonatomic, copy) NSString * objName;

- (BOOL)hasProperty:(NSString *)propertyName;

@end

NS_ASSUME_NONNULL_END
