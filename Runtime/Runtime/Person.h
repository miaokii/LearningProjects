//
//  Person.h
//  Runtime
//
//  Created by miaokii on 2021/3/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PersonProtocol <NSObject>

- (void)work;

@end

@interface Person : NSObject<PersonProtocol, NSCoding>
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * profession;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) UInt8 gender;

+ (void)run;
- (void)walk;
- (void)fly;

@end

@interface Teacher : NSObject<NSCoding>

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * profession;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger gender;

@end

NS_ASSUME_NONNULL_END
