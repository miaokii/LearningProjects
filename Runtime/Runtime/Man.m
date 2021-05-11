//
//  Man.m
//  Runtime
//
//  Created by miaokii on 2021/3/12.
//

#import "Man.h"
#import "NSObject+Model.h"

@implementation Pat
- (NSString *)description {
    return [NSString stringWithFormat:@"Pat name: %@, type: %@", _name, self.patTypeName];
}
@end

@implementation Company
- (NSString *)description {
    return [NSString stringWithFormat:@"Company name: %@, cid: %@", _name, self.cid];
}
@end

@implementation Man

- (NSString *)description {
    return [NSString stringWithFormat:@"Man name: %@, age: %d, address: %@, tel: %@, company: %@, friends: %@", self.name, self.age
            , self.address, self.tel, self.company, self.friends];
}

- (NSDictionary *)arrayContainModelClass {
    return @{@"friends": NSStringFromClass([Pat class])};
}

+ (NSDictionary *)initDic {
    return @{@"name": @"张峰",
             @"age": @29,
             @"tel": @"1808482873",
             @"address": @"山东聊城",
             @"company": @{
                     @"name": @"四川五百公司",
                     @"cid": @"sd12235890q3",
             },
             @"friends": @[
                     @{
                         @"name": @"贝贝",
                         @"patTypeName": @"猫"
                     },
                     @{
                         @"name": @"豆豆",
                         @"patTypeName": @"狗"
                     },
                     @{
                         @"name": @"天天",
                         @"patTypeName": @"猪猪"
                     }
             ]
        };
}

@end
