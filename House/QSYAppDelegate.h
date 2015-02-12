//
//  QSYAppDelegate.h
//  House
//
//  Created by ysmeng on 15/1/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainObjectContext;

///保存上下文信息
- (void)saveContextWithWait:(BOOL)isWait;
- (NSURL *)applicationDocumentsDirectory;

@end
