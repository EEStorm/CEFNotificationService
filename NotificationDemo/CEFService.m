//
//  CEFService.m
//  NotificationDemo
//
//  Created by zhangDongdong on 2018/4/8.
//  Copyright © 2018年 micorosoft. All rights reserved.
//

#import "CEFService.h"
#import "AppDelegate.h"

@implementation CEFService

+(void)registerForRemoteNotifications:(UNAuthorizationOptions)entity delegate:(id)delegate EID:(NSString *)EID profile:(Profile)profile successCompletion:(Completion)successCompletion failedCompletion:(Completion)failedCompletion{
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    if (version.doubleValue >= 10.0) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = delegate;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"注册成功");
                
                [self registerNotification:EID Profile:profile withTags:Tags customId:CustomId];
                successCompletion();
            }else{
                //用户点击不允许
                NSLog(@"注册失败");
                failedCompletion();
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
    }else if (version.doubleValue >= 8.0){
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:entity categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        //iOS 8.0系统以下
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:entity];
    }
    
    //注册远端消息通知获取device token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}



+(void)registerDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}


+(NSString *)createEIDwithTags:(NSArray *)tags customId:(NSString *)customId{

    CustomId = customId;
    Tags = tags;
    
    static NSString *EID = @"";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://cefsfcluster.chinanorth.cloudapp.chinacloudapi.cn/users"]];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictPramas = @{@"tags":tags,
                                 @"customId":customId
                                 };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        EID = (NSString *)[dict objectForKey:@"customizedUID"];
        
        NSLog(@"%@",dict);
    }];
    [sessionDataTask resume];
    
    return EID;
}

+(void)registerNotification:(NSString *)EID Profile:(Profile)profile withTags:(NSArray*)tags customId:(NSString*)customId{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://cefsfcluster.chinanorth.cloudapp.chinacloudapi.cn/users/%@",EID]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dictPramas = @{@"tags":tags,
                                 @"customId":customId
                                 };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictPramas options:0 error:nil];
    request.HTTPBody = data;

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        
        profile(dict);
    }];
    
    [sessionDataTask resume];
}

+(void)getContent:(UNNotificationContent *)content{
    
}


@end
