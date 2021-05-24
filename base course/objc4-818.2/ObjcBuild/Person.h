//
//  Person.h
//  ObjcBuild
//
//  Created by miaokii on 2021/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HumanBehavior <NSObject>

@required
- (void)eat;
- (void)sleep;

@optional
- (void)work;

@end

@interface Human : NSObject

@end

@interface Person : Human

@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) int age;

- (void)addFriend:(Person *)friend;
- (void)testMethod;

@end

NS_ASSUME_NONNULL_END
