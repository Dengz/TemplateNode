//
//  TemplateLayoutNode.m
//  Template
//
//  Created by DengLiujun on 2017/11/20.
//  Copyright © 2017年 liujun.me. All rights reserved.
//

#import "TemplateNode.h"
#import <UIKit/UIKit.h>
#import "UIView+TemplateNode.h"
#import "TemplateNode+Parse.h"

#define YG_PROPERTY(type, lowercased_name, capitalized_name)    \
- (type)lowercased_name                                         \
{                                                               \
return YGNodeStyleGet##capitalized_name(self.node);           \
}                                                               \
\
- (void)set##capitalized_name:(type)lowercased_name             \
{                                                               \
YGNodeStyleSet##capitalized_name(self.node, lowercased_name); \
}

#define YG_VALUE_PROPERTY(lowercased_name, capitalized_name)                       \
- (YGValue)lowercased_name                                                         \
{                                                                                  \
return YGNodeStyleGet##capitalized_name(self.node);                              \
}                                                                                  \
\
- (void)set##capitalized_name:(YGValue)lowercased_name                             \
{                                                                                  \
    switch (lowercased_name.unit) {                                                  \
        case YGUnitPoint:                                                              \
            YGNodeStyleSet##capitalized_name(self.node, lowercased_name.value);          \
            break;                                                                       \
        case YGUnitPercent:                                                            \
            YGNodeStyleSet##capitalized_name##Percent(self.node, lowercased_name.value); \
            break;                                                                       \
        default:                                                                       \
            NSAssert(NO, @"Not implemented");                                            \
    }                                                                                \
}   \
\
- (void)set##capitalized_name##String:(NSString *)lowercased_name        \
{                                                                      \
    YGValue value = [TemplateNode YGValueFromString:lowercased_name];   \
    [self set##capitalized_name:value];\
}

#define YG_EDGE_PROPERTY_GETTER(type, lowercased_name, capitalized_name, property, edge) \
- (type)lowercased_name                                                                  \
{                                                                                        \
return YGNodeStyleGet##property(self.node, edge);                                      \
}

#define YG_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge) \
- (void)set##capitalized_name:(CGFloat)lowercased_name                             \
{                                                                                  \
YGNodeStyleSet##property(self.node, edge, lowercased_name);                      \
}

#define YG_EDGE_PROPERTY(lowercased_name, capitalized_name, property, edge)         \
YG_EDGE_PROPERTY_GETTER(CGFloat, lowercased_name, capitalized_name, property, edge) \
YG_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)

#define YG_VALUE_EDGE_PROPERTY_SETTER(objc_lowercased_name, objc_capitalized_name, c_name, edge) \
- (void)set##objc_capitalized_name:(YGValue)objc_lowercased_name                                 \
{                                                                                                \
    switch (objc_lowercased_name.unit) {                                                           \
        case YGUnitPoint:                                                                            \
            YGNodeStyleSet##c_name(self.node, edge, objc_lowercased_name.value);                       \
            break;                                                                                     \
        case YGUnitPercent:                                                                          \
            YGNodeStyleSet##c_name##Percent(self.node, edge, objc_lowercased_name.value);              \
            break;                                                                                     \
        default:                                                                                     \
            NSAssert(NO, @"Not implemented");                                                          \
    }                                                                                              \
}\
- (void)set##objc_capitalized_name##String:(NSString *)str \
{\
    YGValue value = [TemplateNode YGValueFromString:str];   \
    [self set##objc_capitalized_name:value];\
}

#define YG_VALUE_EDGE_PROPERTY(lowercased_name, capitalized_name, property, edge)   \
YG_EDGE_PROPERTY_GETTER(YGValue, lowercased_name, capitalized_name, property, edge) \
YG_VALUE_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)

#define YG_VALUE_EDGES_PROPERTIES(lowercased_name, capitalized_name)                                                  \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Left, capitalized_name##Left, capitalized_name, YGEdgeLeft)                   \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Top, capitalized_name##Top, capitalized_name, YGEdgeTop)                      \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Right, capitalized_name##Right, capitalized_name, YGEdgeRight)                \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Bottom, capitalized_name##Bottom, capitalized_name, YGEdgeBottom)             \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Start, capitalized_name##Start, capitalized_name, YGEdgeStart)                \
YG_VALUE_EDGE_PROPERTY(lowercased_name##End, capitalized_name##End, capitalized_name, YGEdgeEnd)                      \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Horizontal, capitalized_name##Horizontal, capitalized_name, YGEdgeHorizontal) \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Vertical, capitalized_name##Vertical, capitalized_name, YGEdgeVertical)       \
YG_VALUE_EDGE_PROPERTY(lowercased_name, capitalized_name, capitalized_name, YGEdgeAll)

YGValue YGPointValue(CGFloat value)
{
    return (YGValue) { .value = value, .unit = YGUnitPoint };
}

YGValue YGPercentValue(CGFloat value)
{
    return (YGValue) { .value = value, .unit = YGUnitPercent };
}

static YGConfigRef globalConfig;

@interface TemplateNode()
{
    NSMutableSet *_childrenSet;
}

@property (nonatomic, assign, readonly) YGNodeRef node;

@end

@implementation TemplateNode

@synthesize isEnabled=_isEnabled;
@synthesize isIncludedInLayout=_isIncludedInLayout;
@synthesize node=_node;

+ (void)initialize
{
    globalConfig = YGConfigNew();
    YGConfigSetExperimentalFeatureEnabled(globalConfig, YGExperimentalFeatureWebFlexBasis, true);
    YGConfigSetPointScaleFactor(globalConfig, [UIScreen mainScreen].scale);
}

- (instancetype)init {
    if (self = [super init]) {
        _node = YGNodeNewWithConfig(globalConfig);
        _isEnabled = YES;
        _isIncludedInLayout = YES;
        YGNodeSetContext(_node, (__bridge void *) self);
        YGNodeSetMeasureFunc(_node, YGMeasureView);
        _childrenSet = [NSMutableSet new];
    }
    return self;
}

- (instancetype)initWithView:(UIView*)view
{
    if (self = [self init]) {
        self.view = view;
        [view attachTemplateNode:self];
    }
    
    return self;
}

- (instancetype)initWithCALayer:(CALayer *)layer Layout:(NSDictionary *)styles Attributes:(NSDictionary *)attributes
{
    if (self = [self init]) {
        self.layer = layer;
        
        [self applyCALayerAttributes:attributes];
        [self applyLayoutConfig:styles];
    }
    
    return self;
}

- (instancetype)initWithView:(UIView *)view Layout:(NSDictionary *)styles Attributes:(NSDictionary *)attributes
{
    if (self = [self initWithView:view]) {
        [self applyUIViewConfig:attributes];
        [self applyLayoutConfig:styles];
    }
    
    return self;
}

- (void)dealloc
{
    YGNodeFree(self.node);
}

- (BOOL)isDirty
{
    return YGNodeIsDirty(self.node);
}

- (void)markDirty
{
    if (self.isDirty || !self.isLeaf) {
        return;
    }
    
    // Yoga is not happy if we try to mark a node as "dirty" before we have set
    // the measure function. Since we already know that this is a leaf,
    // this *should* be fine. Forgive me Hack Gods.
    const YGNodeRef node = self.node;
    if (YGNodeGetMeasureFunc(node) == NULL) {
        YGNodeSetMeasureFunc(node, YGMeasureView);
    }
    
    YGNodeMarkDirty(node);
}

- (NSUInteger)numberOfChildren
{
    return YGNodeGetChildCount(self.node);
}

- (BOOL)isLeaf
{
    return self.numberOfChildren == 0;
}

#pragma mark - Style

- (YGPositionType)position
{
    return YGNodeStyleGetPositionType(self.node);
}

- (void)setPosition:(YGPositionType)position
{
    YGNodeStyleSetPositionType(self.node, position);
}

YG_PROPERTY(YGDirection, direction, Direction)
YG_PROPERTY(YGFlexDirection, flexDirection, FlexDirection)
YG_PROPERTY(YGJustify, justifyContent, JustifyContent)
YG_PROPERTY(YGAlign, alignContent, AlignContent)
YG_PROPERTY(YGAlign, alignItems, AlignItems)
YG_PROPERTY(YGAlign, alignSelf, AlignSelf)
YG_PROPERTY(YGWrap, flexWrap, FlexWrap)
YG_PROPERTY(YGOverflow, overflow, Overflow)
YG_PROPERTY(YGDisplay, display, Display)

YG_PROPERTY(CGFloat, flexGrow, FlexGrow)
YG_PROPERTY(CGFloat, flexShrink, FlexShrink)
YG_VALUE_PROPERTY(flexBasis, FlexBasis)

YG_VALUE_EDGE_PROPERTY(left, Left, Position, YGEdgeLeft)
YG_VALUE_EDGE_PROPERTY(top, Top, Position, YGEdgeTop)
YG_VALUE_EDGE_PROPERTY(right, Right, Position, YGEdgeRight)
YG_VALUE_EDGE_PROPERTY(bottom, Bottom, Position, YGEdgeBottom)
YG_VALUE_EDGE_PROPERTY(start, Start, Position, YGEdgeStart)
YG_VALUE_EDGE_PROPERTY(end, End, Position, YGEdgeEnd)
YG_VALUE_EDGES_PROPERTIES(margin, Margin)
YG_VALUE_EDGES_PROPERTIES(padding, Padding)

YG_EDGE_PROPERTY(borderLeftWidth, BorderLeftWidth, Border, YGEdgeLeft)
YG_EDGE_PROPERTY(borderTopWidth, BorderTopWidth, Border, YGEdgeTop)
YG_EDGE_PROPERTY(borderRightWidth, BorderRightWidth, Border, YGEdgeRight)
YG_EDGE_PROPERTY(borderBottomWidth, BorderBottomWidth, Border, YGEdgeBottom)
YG_EDGE_PROPERTY(borderStartWidth, BorderStartWidth, Border, YGEdgeStart)
YG_EDGE_PROPERTY(borderEndWidth, BorderEndWidth, Border, YGEdgeEnd)
YG_EDGE_PROPERTY(borderWidth, BorderWidth, Border, YGEdgeAll)

YG_VALUE_PROPERTY(width, Width)
YG_VALUE_PROPERTY(height, Height)
YG_VALUE_PROPERTY(minWidth, MinWidth)
YG_VALUE_PROPERTY(minHeight, MinHeight)
YG_VALUE_PROPERTY(maxWidth, MaxWidth)
YG_VALUE_PROPERTY(maxHeight, MaxHeight)
YG_PROPERTY(CGFloat, aspectRatio, AspectRatio)

#pragma mark - Layout and Sizing

- (YGDirection)resolvedDirection
{
    return YGNodeLayoutGetDirection(self.node);
}

- (void)applyLayout
{
    CGSize constrainedSize;
    if (self.view) {
        constrainedSize = self.view.bounds.size;
    }else{
        constrainedSize = CGSizeMake(YGUndefined, YGUndefined);
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [weakSelf calculateLayoutWithSize:constrainedSize];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf applyLayoutPreservingOrigin:NO originOffset:CGPointZero];
        });
    });
}

- (void)applyLayoutWithSize:(CGSize)size
{
    [self applyLayoutWithSize:size ParentView:nil];
}

- (void)applyLayoutWithSize:(CGSize)size ParentView:(UIView *)view
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [weakSelf calculateLayoutWithSize:size];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf applyLayoutPreservingOrigin:NO originOffset:CGPointZero];
            if (view) {
                [view addSubview:strongSelf.view];
            }
        });
    });
}

- (void)applyLayoutPreservingOrigin:(BOOL)preserveOrigin
{
    __weak typeof(self) weakSelf = self;
    CGSize size = self.view.bounds.size;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [weakSelf calculateLayoutWithSize:size];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf applyLayoutPreservingOrigin:preserveOrigin originOffset:CGPointZero];
        });
    });
}

- (void)applyLayoutPreservingOrigin:(BOOL)preserveOrigin originOffset:(CGPoint)offset {
    
    NSAssert([NSThread isMainThread], @"Yoga apply must be done on main thread.");
    
    const UIView *view = self.view;
    
    if (!self.isIncludedInLayout) {
        return;
    }
    
    YGNodeRef node = self.node;
    const CGPoint topLeft = {
        YGNodeLayoutGetLeft(node),
        YGNodeLayoutGetTop(node),
    };
    
    const CGPoint bottomRight = {
        topLeft.x + YGNodeLayoutGetWidth(node),
        topLeft.y + YGNodeLayoutGetHeight(node),
    };
    
    const CGPoint origin = preserveOrigin ? view.frame.origin : offset;
    CGRect frame = (CGRect) {
        .origin = {
            .x = YGRoundPixelValue(topLeft.x + origin.x),
            .y = YGRoundPixelValue(topLeft.y + origin.y),
        },
        .size = {
            .width = YGRoundPixelValue(bottomRight.x) - YGRoundPixelValue(topLeft.x),
            .height = YGRoundPixelValue(bottomRight.y) - YGRoundPixelValue(topLeft.y),
        },
    };
    if (self.view) {
        view.frame = frame;
    }else if(self.layer){
        self.layer.frame = frame;
    }
    
    const CGPoint currentOffset = self.view ? CGPointZero : (CGPoint){
        .x = YGRoundPixelValue(topLeft.x + origin.x),
        .y = YGRoundPixelValue(topLeft.y + origin.y),
    };
    
    if (!self.isLeaf) {
        for (NSUInteger i=0; i<self.numberOfChildren; i++) {
            YGNodeRef subNode = YGNodeGetChild(node, (int)i);
            TemplateNode *subTemplateNode = (__bridge TemplateNode *)YGNodeGetContext(subNode);
            [subTemplateNode applyLayoutPreservingOrigin:NO originOffset:currentOffset];
        }
    }
}


- (CGSize)intrinsicSize
{
    const CGSize constrainedSize = {
        .width = YGUndefined,
        .height = YGUndefined,
    };
    return [self calculateLayoutWithSize:constrainedSize];
}

- (CGSize)calculateLayoutWithSize:(CGSize)size
{
    const YGNodeRef node = self.node;
    YGNodeCalculateLayout(
                          node,
                          size.width,
                          size.height,
                          YGNodeStyleGetDirection(node));
    
    return (CGSize) {
        .width = YGNodeLayoutGetWidth(node),
        .height = YGNodeLayoutGetHeight(node),
    };
}


- (void)addSubNode:(TemplateNode *)subNode {
    //check storage
    if ([_childrenSet containsObject:subNode]) {
        return;
    }
    [_childrenSet addObject:subNode];
    
    //Only leaf node should have measure function
    YGNodeSetMeasureFunc(_node, NULL);
    
    // add subnode
    NSUInteger index = self.numberOfChildren;
    YGNodeInsertChild(self.node, subNode.node, (int)index);
    
    // add subview if needed
    if (subNode.view || subNode.layer) {
        id parent = YGGetClosestParentView(_node);
        if ([parent isKindOfClass:[UIView class]]) {
            UIView *parentView = parent;
            if (subNode.view) {
                [parentView addSubview:subNode.view];
            }else if(subNode.layer){
                [parentView.layer addSublayer:subNode.layer];
            }
        }else if ([parent isKindOfClass:[CALayer class]]){
            CALayer *parentLayer = parent;
            if (subNode.view) {
                [parentLayer addSublayer:subNode.view.layer];
            }else if(subNode.layer){
                [parentLayer addSublayer:subNode.layer];
            }
        }
    }
}

#pragma mark - Private

static id YGGetClosestParentView( YGNodeRef node )
{
    YGNodeRef currentNode = node;
    
    while (currentNode != nil) {
        if (YGNodeGetContext(currentNode)) {
            TemplateNode *templateNode = (__bridge TemplateNode *)YGNodeGetContext(currentNode);
            if (templateNode.view) {
                return templateNode.view;
            }
            if (templateNode.layer) {
                return templateNode.layer;
            }
        }
        
        currentNode = YGNodeGetParent(currentNode);
    }
    
    return nil;
}


static YGSize YGMeasureView(
                            YGNodeRef node,
                            float width,
                            YGMeasureMode widthMode,
                            float height,
                            YGMeasureMode heightMode)
{
    const CGFloat constrainedWidth = (widthMode == YGMeasureModeUndefined) ? CGFLOAT_MAX : width;
    const CGFloat constrainedHeight = (heightMode == YGMeasureModeUndefined) ? CGFLOAT_MAX: height;
    
    TemplateNode *templateNode = (__bridge TemplateNode *)YGNodeGetContext(node);
    UIView *view = templateNode.view;
    
    CGSize sizeThatFits = (CGSize){
        .width = constrainedWidth,
        .height = constrainedHeight,
    };
    
    if ([[NSThread currentThread] isMainThread]) {
        if (templateNode.view) {
            sizeThatFits = [view sizeThatFits:(CGSize) {
                .width = constrainedWidth,
                .height = constrainedHeight,
            }];
        }
    }else{
        if ([templateNode.view isKindOfClass:[UILabel class]]) {
            
            NSString *content = [view valueForKey:@"text"];
            UIFont *font = [view valueForKey:@"font"];
            
            NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
            sizeThatFits = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:font}
                                                 context:context].size;
        }else if([templateNode.layer isKindOfClass:[CATextLayer class]]){
            
            CATextLayer *layer = (CATextLayer *)templateNode.layer;
            NSString *content = layer.string;
            
            UIFont *font = (UIFont *)layer.font;//[UIFont fontWithName:layer.font size:layer.fontSize];
            
            NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
            sizeThatFits = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:font}
                                                 context:context].size;
        }
    }
    
    return (YGSize) {
        .width = YGSanitizeMeasurement(constrainedWidth, sizeThatFits.width, widthMode),
        .height = YGSanitizeMeasurement(constrainedHeight, sizeThatFits.height, heightMode),
    };
}

static CGFloat YGSanitizeMeasurement(
                                     CGFloat constrainedSize,
                                     CGFloat measuredSize,
                                     YGMeasureMode measureMode)
{
    CGFloat result;
    if (measureMode == YGMeasureModeExactly) {
        result = constrainedSize;
    } else if (measureMode == YGMeasureModeAtMost) {
        result = MIN(constrainedSize, measuredSize);
    } else {
        result = measuredSize;
    }
    
    return result;
}

static CGFloat YGRoundPixelValue(CGFloat value)
{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        scale = [UIScreen mainScreen].scale;
    });
    
    return roundf(value * scale) / scale;
}

@end
