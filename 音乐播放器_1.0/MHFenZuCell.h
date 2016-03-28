//
//  MHFenZuCell.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/16.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHFenZuFrame;
@interface MHFenZuCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableview;
@property (strong ,nonatomic) MHFenZuFrame *fenZuFrame;
@end
