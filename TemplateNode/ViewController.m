//
//  ViewController.m
//  TemplateNode
//
//  Created by DengLiujun on 2017/11/17.
//  Copyright © 2017年 liujun.me. All rights reserved.
//

#import "ViewController.h"
#import "TemplateNode.h"
#import "TemplateNode+Parse.h"
#import "UIView+TemplateNode.h"

@interface ViewController ()
{
    TemplateNode *_node;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _node = [TemplateNode templateNodeWithConfig:@{
                                                                @"class": @"UIView",
                                                                @"style": @{
                                                                        @"alignItems": @"center",
                                                                        @"justifyContent": @"center"
                                                                        },
                                                                @"attributes": @{
                                                                        @"backgroundColor": @"123123"
                                                                        },
                                                                @"children": @[
                                                                        @{
                                                                            @"class": @"UILabel",
                                                                            @"attributes": @{
                                                                                    @"text": @"Hello Template",
                                                                                    @"textColor": @"ffffff"
                                                                                    }
                                                                            },
                                                                        @{
                                                                            @"class": @"CALayer",
                                                                            @"style": @{
                                                                                    @"marginTop": @(10),
                                                                                    @"marginLeft": @(15),
                                                                                    @"marginRight": @(15),
                                                                                    @"height": @(0.333),
                                                                                    },
                                                                            @"attributes": @{
                                                                                    @"backgroundColor": @"ffffff"
                                                                                    }
                                                                            },
                                                                        @{
                                                                            @"style": @{
                                                                                    @"height": @(100),
                                                                                    @"alignItems": @"center",
                                                                                    @"justifyContent": @"center"
                                                                                    },
                                                                            @"children": @[
                                                                                    @{
                                                                                        @"class": @"UILabel",
                                                                                        @"attributes": @{
                                                                                                @"text": @"Welcome onboard",
                                                                                                @"textColor": @"ffffff"
                                                                                                }
                                                                                        }
                                                                                    ]
                                                                            }
                                                                        ]
                                                                }];
    
    [_node applyLayoutWithSize:self.view.bounds.size ParentView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
