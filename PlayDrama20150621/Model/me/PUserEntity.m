//
//  PUserEntity.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/14.
//  Copyright (c) 2015年 times. All rights reserved.
//


#define LoginToken          @"LoginToken"
#define LoginUserName       @"LoginUserName"
#define LoginUserId         @"LoginUserId"

#import "PUserEntity.h"
#import "NSString+Extension.h"
#include <sys/sysctl.h>

@implementation PUserEntity

+(PUserEntity *) sharedInstance
{
    static PUserEntity *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}

- (NSString *)currentDeviceType
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.level forKey:@"level"];
    [aCoder encodeObject:self.faceUrl forKey:@"faceUrl"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userName   = [aDecoder decodeObjectForKey:@"userName"];
        self.userId     = [aDecoder decodeObjectForKey:@"userId"];
        self.sex        = [aDecoder decodeObjectForKey:@"sex"];
        self.level      = [aDecoder decodeObjectForKey:@"level"];
        self.faceUrl    = [aDecoder decodeObjectForKey:@"faceUrl"];
        
        self.device_token = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenStorage];
    }
    
    return self;
}

- (void)setDevice_token:(NSString *)device_token
{
    _deviceToken    = device_token;
    [[NSUserDefaults standardUserDefaults] setObject:_deviceToken forKey:kDeviceTokenStorage];
}

//登录成功后，更新当前用户信息（在登录成功的网络回调中使用）
- (void)updateWithLoginDict:(NSDictionary *)loginDic
{
    
}

#pragma mark - synthesize userId
- (void)setUserId:(NSString *)userId
{
    [self rememberUserID:userId];
}

#pragma mark - synthesize userName
- (void)setUserName:(NSString *)userName
{
    [self rememberUserName:userName];
}

#pragma mark - getuserName
- (NSString *)userName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:LoginUserName];
}

#pragma mark - getuserId

- (NSString *)userId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:LoginUserId];
}

- (void)rememberUserName:(NSString *)account
{
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:LoginUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)rememberUserID:(NSString *)userID
{
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:LoginUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setToken:(NSString *)token
{
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:LoginToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



+ (void)deleteToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LoginToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)destroy
{
    self.userId = nil;
    self.userName = nil;
    self.sex = nil;
    self.level = nil;
    self.faceUrl = nil;
    self.token = nil;
    
}


@end
