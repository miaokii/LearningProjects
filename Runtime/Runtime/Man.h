//
//  Man.h
//  Runtime
//
//  Created by miaokii on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Pat : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *patTypeName;

@end

@interface Company : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cid;

@end

@interface Man : NSObject

@property (nonatomic, assign) int age;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, strong) NSArray<Pat *> *friends;
@property (nonatomic, strong) Company *company;

+(NSDictionary *)initDic;

@end


NS_ASSUME_NONNULL_END
