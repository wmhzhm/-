//
//  MHListModel.m
//  API测试
//
//  Created by wmh—future on 16/4/17.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHSearchListModel.h"

@implementation MHSearchListModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
