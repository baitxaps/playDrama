//
//  NSError+NSError.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "NSError+NSError.h"


@implementation NSError (NSError)

+ (NSError *)networkError
{
    NSError *error = [NSError errorWithDomain:PLAY_BASE_URL_STR
                                         code:ErrorTypeNetworkError
                                     userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"GOUC_NetworkErr", nil)}];
    return error;
}

+ (NSError *)failedConfigReopenError
{
    NSError *error = [NSError errorWithDomain:PLAY_BASE_URL_STR
                                         code:ErrorTypeFailedConfigReopenError
                                     userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"GOUC_FialedConfigReopenApp", nil)}];
    return error;
}

+ (NSError *)unknowError
{
    NSError *error = [NSError errorWithDomain:PLAY_BASE_URL_STR
                                         code:ErrorTypeUnknowError
                                     userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"GOUC_UnknowErr", nil)}];
    return error;
}

+ (NSError *)errorWithMsg:(NSString *)msgString code:(int)code
{
    if (code == ErrorTypeVerifyFailed)
    {
        msgString = NSLocalizedString(@"GO_Register_VerCodeErr",nil);
    }
    else if(code == ErrorTypeAlreadyRegistered)
    {
        //110001
        msgString = NSLocalizedString(@"GO_Register_AlreadyReg", nil);
    }
    else if(code == ErrorTypeErrorUsernameOrPassword)
    {
        //100001
        msgString = NSLocalizedString(@"GO_Login_Error_User_Or_Password", nil);
    }
    else if(code == ErrorTypeErrorHavenotRegistered)
    {
        //110002
        msgString = NSLocalizedString(@"GOUC_NetworkHaveNotRegistered", nil);
    }
    else if(code == ErrorTypeErrorUsernameNotExist)
    {
        //100002
        msgString = NSLocalizedString(@"GO_Login_Error_Username", nil);
    }
    else if(code == ErrorTypeErrorZoneErr)
    {
        //40000
        msgString = NSLocalizedString(@"GOUC_Login_Err_Zone", nil);
    }
    else if(code == ErrorTypeErrorVersionErr)
    {
        //40001
        msgString = NSLocalizedString(@"GOUC_Login_Err_Version", nil);
    }
    else if(code == ErrorTypeErrorEventsCycleTime){
        //100400
        msgString = NSLocalizedString(@"GOUC_Activity_Err_EventsCycleTime", nil);
    }
    else if(code == ErrorTypeErrorAcitvityAbnormal){
        //100401
        msgString = NSLocalizedString(@"GOUC_Activity_Err_AcitvityAbnormal", nil);
    }
    else if(code == ErrorTypeErrorActivityOutdated){
        //100402
        msgString = NSLocalizedString(@"GOUC_Activity_Err_ActivityOutdated", nil);
    }
    else if(code == ErrorTypeErrorActivityMustBeCar){
        //100403
        msgString = NSLocalizedString(@"GOUC_Activity_Err_ActivityMustBeCar", nil);
    }    else if(code == ErrorTypeErrorGroupMembersOnly){
        //100404
        msgString = NSLocalizedString(@"GOUC_Activity_Err_GroupMembersOnly", nil);
    }
    else if(code == ErrorTypeErrorGroupAuthority){
        //100405
        msgString = NSLocalizedString(@"GOUC_Activity_Err_GroupAuthority", nil);
    }
    else if(code == ErrorTypeErrorOperatorNotLeader){
        //100407
        msgString = NSLocalizedString(@"GOUC_Activity_Err_OperatorNotLeader", nil);
    }
    else if(code == ErrorTypeErrorActivityIdNotAllow){
        //100407
        msgString = NSLocalizedString(@"GOUC_Activity_Err_ActivityIdNotAllow", nil);
    }
    else if(code == ErrorTypeErrorActivityTypeNotAllow){
        //100408
        msgString = NSLocalizedString(@"GOUC_Activity_Err_ActivityTypeNotAllow", nil);
    }
    else if(code == ErrorTypeErrorActivityRangeNotAllow){
        //100409
        msgString = NSLocalizedString(@"GOUC_Activity_Err_ActivityRangeNotAllow", nil);
    }
    else if(code == ErrorTypeErrorActivityIfNotCar){
        //100410
        msgString = NSLocalizedString(@"GOUC_Activity_Err_ActivityIfNotCar", nil);
    }
    else if(code == ErrorTypeErrorActivityHasApply){
        //100411
        msgString = NSLocalizedString(@"GOUC_Activity_Err_ActivityHasApply", nil);
    }
    else if(code == ErrorTypeErrorActivityHasCancel){
        //100412
        msgString = NSLocalizedString(@"GOUC_Activity_Err_ActivityHasCancel", nil);
        
    }else if (code == ErrorTypeErrorActivityNoCarNo){
        //100413
        msgString = NSLocalizedString(@"GOUC_Activity_Err_ActivityNoCarNo", nil);
        
    }else if (code == ErrorTypeErrorActivityDelete){
        //100414
        msgString = NSLocalizedString(@"GOUC_Activity_Err_ActivityDelete", nil);
    }else if(code == ErrorTypeErrorStaryThanEndTime){
        //10002
        msgString = NSLocalizedString(@"GOUC_Activity_Err_StaryThanEndTime", nil);
    }
    else
    {
        if (!msgString || [msgString isKindOfClass:[NSNull class]])
        {
            return [self networkError];
        }
    }
    
    NSError *error = [NSError errorWithDomain:PLAY_BASE_URL_STR
                                         code:code
                                     userInfo:@{NSLocalizedDescriptionKey:msgString}];
    return error;
}
@end
