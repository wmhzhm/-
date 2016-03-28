//
//  MHFenZuFrame.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/16.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHFenZuFrame.h"
#import "MHFenZu.h"
@implementation MHFenZuFrame

//计算文字尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setFenZu:(MHFenZu *)fenZu
{
    _fenZu = fenZu;
    //开头图片
    CGFloat iconX = Padding;
    CGFloat iconY = Padding;
    CGFloat iconW = FenZuIconWidth;
    CGFloat iconH = iconW;
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    //分组名
    CGSize titleSize = [self sizeWithText:fenZu.title font:MHFenZuFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat titleX = CGRectGetMaxX(_iconF) + Padding;
    CGFloat titleY = CGRectGetMinY(_iconF) + (( iconH - titleSize.height ) *0.5 );
    _titleF = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    //行高
    _cellHeight = CGRectGetMaxY(_iconF) + Padding;
}
@end
