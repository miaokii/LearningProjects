//
//  CAMediaTimingFunction+ControlPoint.h
//  CoreAnimation
//
//  Created by miaokii on 2021/2/22.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAMediaTimingFunction (ControlPoint)

- (CGPoint)getControlPoint1;
- (CGPoint)getControlPoint2;

@end

NS_ASSUME_NONNULL_END
