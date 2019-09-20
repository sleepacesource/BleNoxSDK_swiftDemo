//
//  CustomStyleButton.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/15.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "CustomStyleButton.h"

@implementation CustomStyleButton


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setTitleColor:[UIColor colorWithRed:38/255.0 green:52/255.0 blue:68/255.0 alpha:1.0] forState:UIControlStateNormal];
    
}

-(void)setSelected:(BOOL)selected
{
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:42/255.0 green:151/255.0 blue:254/255.0 alpha:1.0];
        [self setTitleColor:self.selectedColor forState:UIControlStateNormal];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:self.normalColor forState:UIControlStateNormal];
    }
}

@end
