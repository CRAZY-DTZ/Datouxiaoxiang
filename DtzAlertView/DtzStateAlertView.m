//
//  DtzStateAlertView.m
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/30.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "DtzStateAlertView.h"
#import "DtzAttachment.h"

#define winSize [[UIScreen mainScreen]bounds]

@implementation DtzStateAlertView

//- (void)createBtns {
//    for (int i = 0; i < self.statuslist.count; i ++) {
//        NSDictionary * dic = [self.statuslist objectAtIndex:i];
//        NSString * name = dic[@"name"];
//        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(5, 1 + i * 51 , winSize.size.width - 10, 50)];
//        UIImage * image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:name];
//        [btn setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"highlighted"] forState:UIControlStateHighlighted];
//        btn.tag = i + 1;
//        [btn addTarget:self action:@selector(clickStateBtns:) forControlEvents:UIControlEventTouchUpInside];
//        DtzAttachment * attachment = [[DtzAttachment alloc]init];
//        if (name) {
//            NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@",name]];
//            [attributed insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:0];
//            //设置距离.
//            [attributed addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:4] range:NSMakeRange(1,name.length + 2)];
////            if (image) {
//                attachment.image = image;
//                [btn setAttributedTitle:attributed forState:UIControlStateNormal];
//                
////            }else {
////                self.isCompeleted = NO;
////            }
//        }
//        [self addSubview:btn];
//    }
//    self.isCompeleted = YES;
//}

- (void)createBtns {
    for (int i = 0; i < self.statuslist.count; i ++) {
        NSDictionary * dic = [self.statuslist objectAtIndex:i];
        NSString * name = dic[@"name"];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(5, 1 + i * 51 , winSize.size.width - 10, 50)];
        NSString * iconUrl = [dic objectForKey:@"link"];
        iconUrl = [iconUrl stringByAppendingString:@"?imageView2/1/w/20/h/20/q/75/format/png"];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]];
        UIImage * image = [UIImage imageWithData:data];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        [btn setTitle:[NSString stringWithFormat:@"  %@",name] forState:UIControlStateNormal];
        [btn setTitle:[NSString stringWithFormat:@"  %@",name] forState:UIControlStateHighlighted];
        [btn setTitleColor:RGB(74, 74, 74) forState:UIControlStateHighlighted];
        [btn setTitleColor:RGB(74, 74, 74) forState:UIControlStateNormal];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(clickStateBtns:) forControlEvents:UIControlEventTouchUpInside];
        CGSize titleSize = btn.titleLabel.bounds.size;
        CGSize imageSize = btn.imageView.bounds.size;
        [btn setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"highlighted"] forState:UIControlStateHighlighted];
        [self addSubview:btn];
    }
    self.isCompeleted = YES;
}

- (void)clickStateBtns:(id)sender {
    UIButton * btn = (UIButton *)sender;
    [self.delegate clickStateBtnsWithTag:btn.tag];
}

@end
