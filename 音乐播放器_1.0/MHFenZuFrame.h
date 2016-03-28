//
//  MHFenZuFrame.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/16.
//  Copyright © 2016年 wmh—future. All rights reserved.
//
#define FenZuIconWidth 30
#define Padding 10
#define MHFenZuFont [UIFont systemFontOfSize:18]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MHFenZu;
@interface MHFenZuFrame : NSObject
@property (assign ,nonatomic,readonly) CGRect iconF;
@property (assign ,nonatomic,readonly) CGRect titleF;
@property (assign ,nonatomic,readonly) CGFloat cellHeight;
@property (strong ,nonatomic) MHFenZu *fenZu;

@end
