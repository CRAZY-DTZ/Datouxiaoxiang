//
//  DtzAlertView.m
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/30.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "DtzAlertView.h"
#import "DtzAttachment.h"

#define winSize [[UIScreen mainScreen]bounds]

@implementation DtzAlertView

- (void)createBtns {
    UIButton * wechatBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 1, winSize.size.width - 10, 50)];
    wechatBtn.tag = 1;
    [wechatBtn setTitleColor:[UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1] forState:UIControlStateNormal];
    [wechatBtn setTitle:@"获取微信头像" forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
    [wechatBtn setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [wechatBtn setBackgroundImage:[UIImage imageNamed:@"highlighted"] forState:UIControlStateHighlighted];
    
    UIButton * othersBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 52, winSize.size.width - 10, 50)];
    othersBtn.tag = 2;
    [othersBtn setTitle:@"其他" forState:UIControlStateNormal];
    [othersBtn setTitleColor:[UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1] forState:UIControlStateNormal];
    [othersBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
    [othersBtn setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [othersBtn setBackgroundImage:[UIImage imageNamed:@"highlighted"] forState:UIControlStateHighlighted];
    
    UIButton * thirdBtn = [[UIButton alloc]initWithFrame:CGRectMake(5,1 + 51 * 2, winSize.size.width - 10, 50)];
    thirdBtn.tag = 3;
    [thirdBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [thirdBtn setTitleColor:[UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1] forState:UIControlStateNormal];
    [thirdBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
    [thirdBtn setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [thirdBtn setBackgroundImage:[UIImage imageNamed:@"highlighted"] forState:UIControlStateHighlighted];
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 1 + 51 * 3 + 4, winSize.size.width - 10, 50)];
    cancelBtn.tag = 0;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"highlighted"] forState:UIControlStateHighlighted];
    
    self.backgroundColor = [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:0.7];
    [self addSubview:wechatBtn];
    [self addSubview:othersBtn];
    [self addSubview:thirdBtn];
    [self addSubview:cancelBtn];
}

- (void)clickBtns:(id)sender {
    //点击了图片.
    UIButton * sendBtn = (UIButton *)sender;
    [self.delegate clickButtonWithTag:sendBtn.tag];
}



@end
