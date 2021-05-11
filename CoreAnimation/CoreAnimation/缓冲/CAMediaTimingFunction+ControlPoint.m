//
//  CAMediaTimingFunction+ControlPoint.m
//  CoreAnimation
//
//  Created by miaokii on 2021/2/22.
//

#import "CAMediaTimingFunction+ControlPoint.h"

@implementation CAMediaTimingFunction (ControlPoint)

- (CGPoint)getControlPoint1 {
    float controlPoint1[2];
    [self getControlPointAtIndex:1 values: controlPoint1];
    return CGPointMake(controlPoint1[0], controlPoint1[1]);
}

- (CGPoint)getControlPoint2 {
    float controlPoint2[2];
    [self getControlPointAtIndex:2 values:controlPoint2];
    return CGPointMake(controlPoint2[0], controlPoint2[1]);
}

@end
