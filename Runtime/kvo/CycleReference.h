//
//  CycleReference.h
//  kvo
//
//  Created by Miaokii on 2021/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Son;
@interface Father: NSObject
@property (nonatomic, strong) Son * son;
@end

@interface Son: NSObject
@property (nonatomic, strong) Father * father;
@end

NS_ASSUME_NONNULL_END
