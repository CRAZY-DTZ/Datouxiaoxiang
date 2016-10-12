//
//  DtzAttachment.m
//  Blinc
//
//  Created by wuhaibin on 16/9/27.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "DtzAttachment.h"

@implementation DtzAttachment

//重载此方法 使得图片的大小和行高是一样的。
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake(0, 0, lineFrag.size.height, lineFrag.size.height);
}


@end
