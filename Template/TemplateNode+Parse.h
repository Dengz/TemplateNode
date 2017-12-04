//
//  TemplateNode+Parse.h
//  Template
//
//  Created by DengLiujun on 2017/11/23.
//  Copyright © 2017年 liujun.me. All rights reserved.
//

#import "TemplateNode.h"
#include "YGEnums.h"
#import <UIKit/UIKit.h>

@interface TemplateNode (Parse)

#pragma mark Parser for Yoga
+ (YGAlign)YGAlignFromString:(NSString *)value;

+ (YGDimension)YGDimensionFromString:(NSString *)value;

+ (YGDirection)YGDirectionFromString:(NSString *)value;

+ (YGDisplay)YGDisplayFromString:(NSString *)value;

+ (YGEdge)YGEdgeFromString:(NSString *)value;

+ (YGFlexDirection)YGFlexDirectionFromString:(NSString *)value;

+ (YGJustify)YGJustifyFromString:(NSString *)value;

+ (YGMeasureMode)YGMeasureModeFromString:(NSString *)value;

+ (YGNodeType)YGNodeTypeFromString:(NSString *)value;

+ (YGOverflow)YGOverflowFromString:(NSString *)value;

+ (YGPositionType)YGPositionTypeFromString:(NSString *)value;

+ (YGValue)YGValueFromString:(NSString *)value;

+ (YGWrap)YGWrapFromString:(NSString *)value;

#pragma mark Parser for UIView
+ (CGSize)parseSize:(NSString *)str;

+ (UIColor *)parseColor:(NSString *)str;

+ (UIFont *)parseFont:(id)str;

+ (UIImage *)parseImage:(NSString *)str;


#pragma mark Config
- (void)applyLayoutConfig:(NSDictionary *)layout;

- (void)applyUIViewConfig:(id)config;
- (void)applyCALayerAttributes:(NSDictionary *)attributes;

+ (TemplateNode *)templateNodeWithConfig:(NSDictionary *)config;

@end
