//
//  KVOPerson.h
//  kvo
//
//  Created by miaokii on 2021/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVOPerson : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSMutableArray<KVOPerson *>* friends;

- (void)objectInfo;

@end

NS_ASSUME_NONNULL_END
