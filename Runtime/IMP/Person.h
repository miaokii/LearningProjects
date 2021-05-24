//
//  Person.h
//  IMP
//
//  Created by miaokii on 2021/4/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject


@property (nonatomic, copy) NSString * name;
//@property (nonatomic, assign) CGFloat * height;

- (void)run;
- (void)walk;

@end

NS_ASSUME_NONNULL_END
