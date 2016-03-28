//
//  MHFenZuCell.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/16.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHFenZuCell.h"
#import "MHFenZu.h"
#import "MHFenZuFrame.h"

@interface MHFenZuCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;//图标
@property (weak, nonatomic) IBOutlet UILabel *titleView;//标题

@end
@implementation MHFenZuCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString * ID = @"fenZu";
    MHFenZuCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MHFenZuCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //设置点击后变透明灰色
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:188/255  green:32/255 blue:3/255 alpha:0.11];
        //设置cell背景透明
         cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //图标
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView  = iconView;
        //标题
#warning Label未做细化处理
        UILabel *titleView = [[UILabel alloc] init];
        [self.contentView addSubview:titleView];
        titleView.textColor = [UIColor whiteColor];
        titleView.font = MHFenZuFont;
        self.titleView = titleView;
    }
    return self;
}

- (void)setFenZuFrame:(MHFenZuFrame *)fenZuFrame
{
    _fenZuFrame = fenZuFrame;
    MHFenZu *fenZu = fenZuFrame.fenZu;
    //图标
    self.iconView.image = [UIImage imageNamed:fenZu.icon];
    self.iconView.frame = fenZuFrame.iconF;
    //标题
    self.titleView.text = fenZu.title;
    self.titleView.frame = fenZuFrame.titleF;
}
@end
