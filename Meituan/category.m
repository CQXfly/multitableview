//
//  category.m
//  Meituan
//
//  Created by 崇庆旭 on 15/7/20.
//  Copyright (c) 2015年 崇庆旭. All rights reserved.
//

#import "category.h"

@implementation category

+ (instancetype)catrgoryWithDictionary:(NSDictionary *)dict
{
    category *cat = [[category alloc] init];
    [cat setValuesForKeysWithDictionary:dict];
    return cat;
}

@end
