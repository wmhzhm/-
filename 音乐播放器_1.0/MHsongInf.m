//
//  MHsongInf.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/4/19.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHsongInf.h"

@implementation MHsongInf
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"copyType"]) {
        self.myTypeCopy = value;
    }
}
- (instancetype)initWithDict:(NSDictionary *)songInf
{
        self = [super init];
        if (self) {
            [self setValuesForKeysWithDictionary:songInf];
        }
        return self;
}
@end
