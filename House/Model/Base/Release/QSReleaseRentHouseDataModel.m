//
//  QSReleaseRentHouseDataModel.m
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSReleaseRentHouseDataModel.h"

@implementation QSReleaseRentHouseDataModel

- (NSArray *)getCurrentPickedImages
{
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.imagesList count]; i++) {
        
        QSReleaseRentHousePhotoDataModel *tempModel = self.imagesList[i];
        [tempArray addObject:tempModel.image];
        
    }
    
    return [NSArray arrayWithArray:tempArray];
    
}

#pragma mark - 生成发布出租物业的参数
- (NSDictionary *)createReleaseSaleHouseParams
{
    
    return nil;
    
}

@end

@implementation QSReleaseRentHousePhotoDataModel



@end