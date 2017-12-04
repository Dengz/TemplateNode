//
//  TemplateNode+Parse.m
//  Template
//
//  Created by DengLiujun on 2017/11/23.
//  Copyright © 2017年 liujun.me. All rights reserved.
//

#import "TemplateNode+Parse.h"
#import "UIColor+Hex.h"
#import <objc/runtime.h>

@implementation TemplateNode (Parse)

+ (YGAlign)YGAlignFromString:(NSString *)value
{
    const char* str = [value UTF8String];
    if (strcmp(str, "auto") == 0) {
        return YGAlignAuto;
    }
    if (strcmp(str, "flex-start") == 0) {
        return YGAlignFlexStart;
    }
    if (strcmp(str, "center") == 0) {
        return YGAlignCenter;
    }
    if (strcmp(str, "flex-end") == 0) {
        return YGAlignFlexEnd;
    }
    if (strcmp(str, "stretch") == 0) {
        return YGAlignStretch;
    }
    if (strcmp(str, "baseline") == 0) {
        return YGAlignBaseline;
    }
    if (strcmp(str, "space-between") == 0) {
        return YGAlignSpaceBetween;
    }
    if (strcmp(str, "space-around") == 0) {
        return YGAlignSpaceAround;
    }
    
    return YGAlignAuto;
}

+ (YGDimension)YGDimensionFromString:(NSString *)value
{
    
    const char* str = [value UTF8String];
    if (strcmp(str, "width") == 0) {
        return YGDimensionWidth;
    }
    if (strcmp(str, "height") == 0) {
        return YGDimensionHeight;
    }
    
    return YGDimensionWidth;
}

+ (YGDirection)YGDirectionFromString:(NSString *)value
{
    const char* str = [value UTF8String];
    if (strcmp(str, "inherit") == 0) {
        return YGDirectionInherit;
    }
    if (strcmp(str, "ltr") == 0) {
        return YGDirectionLTR;
    }
    if (strcmp(str, "rtl") == 0) {
        return YGDirectionRTL;
    }
    
    return YGDirectionInherit;
}

+ (YGDisplay)YGDisplayFromString:(NSString *)value
{
    const char* str = [value UTF8String];
    if (strcmp(str, "flex") == 0) {
        return YGDisplayFlex;
    }
    if (strcmp(str, "none") == 0) {
        return YGDisplayNone;
    }
    
    return YGDisplayFlex;
}

+ (YGEdge)YGEdgeFromString:(NSString *)value
{
    const char* str = [value UTF8String];
    if (strcmp(str, "left") == 0) {
        return YGEdgeLeft;
    }
    if (strcmp(str, "top") == 0) {
        return YGEdgeTop;
    }
    if (strcmp(str, "right") == 0) {
        return YGEdgeRight;
    }
    if (strcmp(str, "bottom") == 0) {
        return YGEdgeBottom;
    }
    if (strcmp(str, "start") == 0) {
        return YGEdgeStart;
    }
    if (strcmp(str, "end") == 0) {
        return YGEdgeEnd;
    }
    if (strcmp(str, "horizontal") == 0) {
        return YGEdgeHorizontal;
    }
    if (strcmp(str, "vertical") == 0) {
        return YGEdgeVertical;
    }
    if (strcmp(str, "all") == 0) {
        return YGEdgeAll;
    }
    
    return YGEdgeAll;
}

+ (YGFlexDirection)YGFlexDirectionFromString:(NSString *)value
{
    const char* str = [value UTF8String];
    if (strcmp(str, "column") == 0) {
        return YGFlexDirectionColumn;
    }
    if (strcmp(str, "column-reverse") == 0) {
        return YGFlexDirectionColumnReverse;
    }
    if (strcmp(str, "row") == 0) {
        return YGFlexDirectionRow;
    }
    if (strcmp(str, "row-reverse") == 0) {
        return YGFlexDirectionRowReverse;
    }
    
    return YGFlexDirectionColumn;
}

+ (YGJustify)YGJustifyFromString:(NSString *)value
{
    const char* str = [value UTF8String];
    if (strcmp(str, "flex-start") == 0) {
        return YGJustifyFlexStart;
    }
    if (strcmp(str, "center") == 0) {
        return YGJustifyCenter;
    }
    if (strcmp(str, "flex-end") == 0) {
        return YGJustifyFlexEnd;
    }
    if (strcmp(str, "space-between") == 0) {
        return YGJustifySpaceBetween;
    }
    if (strcmp(str, "space-around") == 0) {
        return YGJustifySpaceAround;
    }
    
    return YGJustifyFlexStart;
}

+ (YGMeasureMode)YGMeasureModeFromString:(NSString *)value
{
    const char* str = [value UTF8String];
    if (strcmp(str, "undefined") == 0) {
        return YGMeasureModeUndefined;
    }
    if (strcmp(str, "exactly") == 0) {
        return YGMeasureModeExactly;
    }
    if (strcmp(str, "at-most") == 0) {
        return YGMeasureModeAtMost;
    }
    
    return YGMeasureModeUndefined;
}

+ (YGNodeType)YGNodeTypeFromString:(NSString *)value
{
    const char* str = [value UTF8String];
    if (strcmp(str, "default") == 0) {
        return YGNodeTypeDefault;
    }
    if (strcmp(str, "text") == 0) {
        return YGNodeTypeText;
    }
    
    return YGNodeTypeDefault;
}

+ (YGOverflow)YGOverflowFromString:(NSString *)value
{
    const char* str = [value UTF8String];
    if (strcmp(str, "visible") == 0) {
        return YGOverflowVisible;
    }
    if (strcmp(str, "hidden") == 0) {
        return YGOverflowHidden;
    }
    if (strcmp(str, "scroll") == 0) {
        return YGOverflowScroll;
    }
    
    return YGOverflowVisible;
}

+ (YGPositionType)YGPositionTypeFromString:(NSString *)value
{
    const char* str = [value UTF8String];
    if (strcmp(str, "relative") == 0) {
        return YGPositionTypeRelative;
    }
    if (strcmp(str, "absolute") == 0) {
        return YGPositionTypeAbsolute;
    }
    
    return YGPositionTypeRelative;
}

+ (YGValue)YGValueFromString:(NSString *)value
{
    if ([value isKindOfClass:[NSString class]] && [value hasSuffix:@"%"]) {
        NSString *valueStr = [value substringToIndex:value.length - 1];
        return YGPercentValue([valueStr floatValue]);
    }
    
    return YGPointValue([value floatValue]);
}

+ (YGWrap)YGWrapFromString:(NSString *)value
{
    const char* str = [value UTF8String];
    if (strcmp(str, "no-wrap") == 0) {
        return YGWrapNoWrap;
    }
    if (strcmp(str, "wrap") == 0) {
        return YGWrapWrap;
    }
    if (strcmp(str, "wrap-reverse") == 0) {
        return YGWrapWrapReverse;
    }
    
    return YGWrapNoWrap;
}


+ (UIColor *)parseColor:(NSString *)str
{
    if ([str rangeOfString:@","].length == 0) {
        return [UIColor colorWithHexString:str alpha:1];
    }
    NSArray *list = [str componentsSeparatedByString:@","];
    CGFloat alpha = [[list objectAtIndex:1] floatValue];
    return [UIColor colorWithHexString:list[0] alpha:alpha];
}

+ (UIFont *)parseFont:(id)input
{
    if ([input isKindOfClass:[NSNumber class]]) {
        return [UIFont systemFontOfSize:[input floatValue]];
    }
    NSString *str = (NSString *)input;
    NSArray *list = [str componentsSeparatedByString:@","];
    NSString *fontName = list.count > 1 ? list[0] : @"HelveticaNeue";
    CGFloat size = [list[list.count > 1 ? 1 : 0] floatValue];
    if ([fontName isEqualToString:@"bold"]) {
        return [UIFont boldSystemFontOfSize:size];
    }
    return [UIFont fontWithName:fontName size:size];
}

+ (CGPoint)parsePoint:(NSString *)str
{
    if (str.length > 0) {
        NSArray *array = [str componentsSeparatedByString:@","];
        if (array.count == 2) {
            CGPointMake([array.firstObject doubleValue], [array.lastObject doubleValue]);
        }
    }
    return CGPointZero;
}

+ (CGSize)parseSize:(NSString *)str
{
    if (str.length > 0) {
        NSArray *array = [str componentsSeparatedByString:@","];
        if (array.count == 2) {
            CGSizeMake([array.firstObject doubleValue], [array.lastObject doubleValue]);
        }
    }
    return CGSizeZero;
}

+ (UIImage *)parseImage:(NSString *)str
{
    return [UIImage imageNamed:str];
}

- (void)applyLayoutConfig:(NSDictionary *)layout
{
    static NSMutableSet *propertySet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertySet = [NSMutableSet new];
        
        unsigned int count;
        objc_property_t* props = class_copyPropertyList([TemplateNode class], &count);
        for (int i = 0; i < count; i++) {
            objc_property_t property = props[i];
            const char * name = property_getName(property);
            NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            const char * type = property_getAttributes(property);
            
            NSString * typeString = [NSString stringWithUTF8String:type];
            NSArray * attributes = [typeString componentsSeparatedByString:@","];
            NSString * typeAttribute = [attributes objectAtIndex:0];
            NSString * propertyType = [typeAttribute substringFromIndex:1];
            if ([propertyType rangeOfString:@"YGValue"].location != NSNotFound) {
                [propertySet addObject:propertyName];
            }
        }
        free(props);
    });
    for (NSString *layoutKey in layout.allKeys) {
        id value = [layout objectForKey:layoutKey];
        if ([propertySet containsObject:layoutKey]) {
            [self setValue:value forKey:[NSString stringWithFormat:@"%@String", layoutKey]];
        }else if ([layoutKey hasPrefix:@"align"]) {
            [self setValue:@([TemplateNode YGAlignFromString:value]) forKey:layoutKey];
        }else if ([layoutKey isEqualToString:@"direction"]) {
            [self setValue:@([TemplateNode YGDirectionFromString:value]) forKey:layoutKey];
        }else if ([layoutKey isEqualToString:@"flexDirection"]) {
            [self setValue:@([TemplateNode YGFlexDirectionFromString:value]) forKey:layoutKey];
        }else if ([layoutKey isEqualToString:@"justifyContent"]) {
            [self setValue:@([TemplateNode YGJustifyFromString:value]) forKey:layoutKey];
        }else if ([layoutKey isEqualToString:@"position"]) {
            [self setValue:@([TemplateNode YGPositionTypeFromString:value]) forKey:layoutKey];
        }else if ([layoutKey isEqualToString:@"flexWrap"]) {
            [self setValue:@([TemplateNode YGWrapFromString:value]) forKey:layoutKey];
        }else if ([layoutKey isEqualToString:@"overflow"]) {
            [self setValue:@([TemplateNode YGOverflowFromString:value]) forKey:layoutKey];
        }else if ([layoutKey isEqualToString:@"display"]) {
            [self setValue:@([TemplateNode YGDisplayFromString:value]) forKey:layoutKey];
        }else {
            [self setValue:value forKey:layoutKey];
        }
    }
}

- (void)applyUIViewConfig:(id)config
{
    if ([config isKindOfClass:[NSArray class]]) {
        [self applyUIViewAttributeList:config];
    }else if ([config isKindOfClass:[NSDictionary class]]) {
        [self applyUIViewAttributes:config];
    }
}

- (void)applyUIViewAttributes:(NSDictionary *)attributes
{
    UIView *view = self.view;
    if (!view) {
        return;
    }
    
    for (NSString *key in attributes.allKeys) {
        if ([key isEqualToString:@"font"]) {
            [view setValue:[TemplateNode parseFont:attributes[key]] forKey:key];
        }else if ([key rangeOfString:@"Color"].length > 0){
            [view setValue:[TemplateNode parseColor:attributes[key]] forKey:key];
        }else if ([key isEqualToString:@"image"]){
            [(UIImageView *)view setImage:[TemplateNode parseImage:attributes[key]]];
        }else if ([key isEqualToString:@"image_url"]){
            //            [(UIImageView *)self pin_setImageFromURL:[NSURL URLWithString:attributes[key]]];
        }else if([key isEqualToString:@"id"]){
            [view setValue:[attributes valueForKey:@"id"] forKey:@"template_element_id"];
        }else if([key isEqualToString:@"layer"]){
            NSDictionary *layerConfig = [attributes valueForKey:@"layer"];
            for (NSString *key in layerConfig.allKeys) {
                if ([key isEqualToString:@"borderColor"]) {
                    view.layer.borderColor = [[TemplateNode parseColor:[layerConfig valueForKey:key]] CGColor];
                }else if ([key rangeOfString:@"shadowOffset"].length > 0){
                    view.layer.shadowOffset = [TemplateNode parseSize:[layerConfig valueForKey:key]];
                }else{
                    [view.layer setValue:[layerConfig valueForKey:key] forKey:key];
                }
            }
        }else{
            [view setValue:[attributes valueForKey:key] forKey:key];
        }
    }
}

- (void)applyUIViewAttributeList:(NSArray *)attributeList
{
    if (!self.view) {
        return;
    }
    for (NSDictionary *attributes in attributeList) {
        [self applyUIViewAttributes:attributes];
    }
}

- (void)applyCALayerAttributes:(NSDictionary *)attributes
{
    for (NSString *key in attributes.allKeys) {
        if ([key hasSuffix:@"Color"]) {
            [self.layer setValue:(id)[[TemplateNode parseColor:[attributes valueForKey:key]] CGColor] forKey:key];
        }else if ([key rangeOfString:@"shadowOffset"].length > 0){
            self.layer.shadowOffset = [TemplateNode parseSize:[attributes valueForKey:key]];
        }else{
            [self.layer setValue:[attributes valueForKey:key] forKey:key];
        }
    }
}


+ (TemplateNode *)templateNodeWithConfig:(NSDictionary *)config
{
    return [TemplateNode templateNodeWithConfig:config ParentNode:nil];
}

+ (TemplateNode *)templateNodeWithConfig:(NSDictionary *)config ParentNode:(TemplateNode *)parentNode
{
    UIView *nodeView = nil;
    CALayer *nodeLayer = nil;
    if ([config valueForKey:@"class"]) {
        Class clazz = NSClassFromString([config valueForKey:@"class"]);
        if ([clazz isSubclassOfClass:[UIView class]]) {
            nodeView = [clazz new];
        }else if([clazz isSubclassOfClass:[CALayer class]]){
            nodeLayer = [clazz new];
            nodeLayer.contentsScale = [UIScreen mainScreen].scale;
        }
    }
    
    TemplateNode *node = nil;
    
    if (nodeView) {
        node = [[TemplateNode alloc] initWithView:nodeView
                                           Layout:[config valueForKey:@"style"]
                                       Attributes:[config valueForKey:@"attributes"]];
    }else{
        node = [[TemplateNode alloc] initWithCALayer:nodeLayer
                                              Layout:[config valueForKey:@"style"]
                                          Attributes:[config valueForKey:@"attributes"]];
    }
    
    if (parentNode) {
        [parentNode addSubNode:node];
    }
    
    NSArray *children = [config valueForKey:@"children"];
    for (NSDictionary *subConfig in children) {
        [TemplateNode templateNodeWithConfig:subConfig ParentNode:node];
    }
    
    return node;
}

@end
