//
//  CEFService.h
//  NotificationDemo
//
//  Created by zhangDongdong on 2018/4/8.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@protocol CEFPushDelegate <NSObject>

- (void)cefpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler;

- (void)cefpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler ;

@end

@interface CEFService : NSObject 


@property (nonatomic, assign) NSString * EID;

+(void)registerForRemoteNotifications:(UNAuthorizationOptions)entity delegate:(id)delegate;

+(void)registerDeviceToken:(NSData *)deviceToken;

@end
