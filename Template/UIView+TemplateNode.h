//
//  UIView+TemplateNode.h
//  Template
//
//  Created by DengLiujun on 2017/11/20.
//  Copyright © 2017年 liujun.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^YGLayoutConfigurationBlock)(TemplateNode *);

@interface UIView (TemplateNode)

/**
 The TemplateLayoutNode that is attached to this view.
 */
@property (nonatomic, readonly, strong) TemplateNode *templateNode;

/**
 Attach a TemplateLayoutNode to this view.
 */
- (void)attachTemplateNode:(TemplateNode *)node;

/**
 Remove the attaching TemplateLayoutNode of this view.
 Param recursive: If recursive is true, then remove all the subviews' attaching TemplateLayoutNode recursively
 */
- (void)removeTemplateNode:(BOOL)recursive;

/**
 Layout subviews as root node.
 */
- (void)yogaLayoutSubview;


/**
 Reset the layout info in the attaching TemplateLayoutNode
 */
- (void)resetYogaLayout;

@end

NS_ASSUME_NONNULL_END
