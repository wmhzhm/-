//
//  MHFenZu.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/21.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHFenZu.h"

@implementation MHFenZu
+ (instancetype) fenZuWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (instancetype) initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.title = dict[@"title"];
        self.icon = dict[@"icon"];
    }
    return self;
}
@end
