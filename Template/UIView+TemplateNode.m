//
//  UIView+TemplateNode.m
//  Template
//
//  Created by DengLiujun on 2017/11/20.
//  Copyright © 2017年 liujun.me. All rights reserved.
//

#import "UIView+TemplateNode.h"
#import <objc/runtime.h>
#import "TemplateNode+Parse.h"

static const void *kYGYogaAssociatedKey = &kYGYogaAssociatedKey;

@implementation UIView (TemplateNode)

- (TemplateNode *)templateNode
{
    id node = objc_getAssociatedObject(self, kYGYogaAssociatedKey);
    if (![node isKindOfClass:[TemplateNode class]]) {
        return nil;
    }
    return node;
}

- (void)attachTemplateNode:(TemplateNode *)node
{
     objc_setAssociatedObject(self, kYGYogaAssociatedKey, node, OBJC_ASSOCIATION_ASSIGN);
}

- (void)removeTemplateNode:(BOOL)recursive
{
    objc_setAssociatedObject(self, kYGYogaAssociatedKey, nil, OBJC_ASSOCIATION_ASSIGN);
    if (recursive) {
        for (UIView *subview in self.subviews) {
            [subview removeTemplateNode:recursive];
        }
    }
}

- (void)yogaLayoutSubview
{
    const TemplateNode *node = self.templateNode;
    [node applyLayoutPreservingOrigin:NO];
}

- (void)resetYogaLayout
{
    const TemplateNode *node = self.templateNode;
    [node markDirty];
}

@end
