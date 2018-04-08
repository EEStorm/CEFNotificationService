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



@interface CEFService : NSObject 


@property (nonatomic, assign) NSString * EID;

+(NSString *)createEID ;
    
+(void)registerForRemoteNotifications:(UNAuthorizationOptions)entity delegate:(id)delegate EID:(NSString *)EID;

+(void)registerDeviceToken:(NSData *)deviceToken;

@end
