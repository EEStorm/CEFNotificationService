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



typedef void(^Completion)(void);
typedef void(^Profile)(NSDictionary*);

static NSArray *Tags;
static NSString *CustomId;

@interface CEFService : NSObject 

@property(copy,nonatomic)Completion successCompletion;
@property(copy,nonatomic)Completion failedCompletion;
@property(copy,nonatomic)Profile profile;

@property (nonatomic, assign) NSString * EID;

+(NSString *)createEIDwithTags:(NSArray*)tags customId:(NSString*)customId ;
    
+(void)registerForRemoteNotifications:(UNAuthorizationOptions)entity delegate:(id)delegate EID:(NSString *)EID profile:(Profile)profile successCompletion:(Completion)successCompletion failedCompletion:(Completion)failedCompletion;

+(void)registerDeviceToken:(NSData *)deviceToken;

+(void)getContent:(UNNotificationContent*)content;

@end
