//
//  RNDeviceInfo.m
//  Learnium
//
//  Created by Rebecca Hughes on 03/08/2015.
//  Copyright © 2015 Learnium Limited. All rights reserved.
//

#import "RNDeviceInfo.h"
#import "DeviceUID.h"
#if !(TARGET_OS_TV)
#import <LocalAuthentication/LocalAuthentication.h>
#endif
#import <mach/mach.h>

@interface RNDeviceInfo()
@property (nonatomic) bool isEmulator;
@end

@import CoreTelephony;

@implementation RNDeviceInfo

@synthesize isEmulator;

RCT_EXPORT_MODULE(RNDeviceInfo)

+ (BOOL)requiresMainQueueSetup
{
   return YES;
}


- (NSString*) deviceId
{
    struct utsname systemInfo;

    uname(&systemInfo);

    NSString* deviceId = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];

    if ([deviceId isEqualToString:@"i386"] || [deviceId isEqualToString:@"x86_64"] ) {
        deviceId = [NSString stringWithFormat:@"%s", getenv("SIMULATOR_MODEL_IDENTIFIER")];
        self.isEmulator = YES;
    } else {
        self.isEmulator = NO;
    }

    return deviceId;
}

- (NSString*) deviceName
{
    static NSDictionary* deviceNamesByCode = nil;

    if (!deviceNamesByCode) {

        deviceNamesByCode = @{@"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPod5,1"   :@"iPod Touch",      // (Fifth Generation)
                              @"iPod7,1"   :@"iPod Touch",      // (Sixth Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone 3G",       // (3G)
                              @"iPhone2,1" :@"iPhone 3GS",      // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad2,2"   :@"iPad 2",          //
                              @"iPad2,3"   :@"iPad 2",          //
                              @"iPad2,4"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPad3,2"   :@"iPad",            // (3rd Generation)
                              @"iPad3,3"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,2" :@"iPhone 4",        // iPhone 4
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad3,5"   :@"iPad",            // (4th Generation)
                              @"iPad3,6"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPad2,6"   :@"iPad Mini",       // (Original)
                              @"iPad2,7"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6s",       //
                              @"iPhone8,2" :@"iPhone 6s Plus",  //
                              @"iPhone8,4" :@"iPhone SE",       //
                              @"iPhone9,1" :@"iPhone 7",        // (model A1660 | CDMA)
                              @"iPhone9,3" :@"iPhone 7",        // (model A1778 | Global)
                              @"iPhone9,2" :@"iPhone 7 Plus",   // (model A1661 | CDMA)
                              @"iPhone9,4" :@"iPhone 7 Plus",   // (model A1784 | Global)
                              @"iPhone10,3":@"iPhone X",        // (model A1865, A1902)
                              @"iPhone10,6":@"iPhone X",        // (model A1901)
                              @"iPhone10,1":@"iPhone 8",        // (model A1863, A1906, A1907)
                              @"iPhone10,4":@"iPhone 8",        // (model A1905)
                              @"iPhone10,2":@"iPhone 8 Plus",   // (model A1864, A1898, A1899)
                              @"iPhone10,5":@"iPhone 8 Plus",   // (model A1897)
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,3"   :@"iPad Air",        // 5th Generation iPad (iPad Air)
                              @"iPad4,4"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,6"   :@"iPad Mini 2",     // (2nd Generation iPad Mini)
                              @"iPad4,7"   :@"iPad Mini 3",     // (3rd Generation iPad Mini)
                              @"iPad4,8"   :@"iPad Mini 3",     // (3rd Generation iPad Mini)
                              @"iPad4,9"   :@"iPad Mini 3",     // (3rd Generation iPad Mini)
                              @"iPad5,1"   :@"iPad Mini 4",     // (4th Generation iPad Mini)
                              @"iPad5,2"   :@"iPad Mini 4",     // (4th Generation iPad Mini)
                              @"iPad5,3"   :@"iPad Air 2",      // 6th Generation iPad (iPad Air 2)
                              @"iPad5,4"   :@"iPad Air 2",      // 6th Generation iPad (iPad Air 2)
                              @"iPad6,3"   :@"iPad Pro 9.7-inch",// iPad Pro 9.7-inch
                              @"iPad6,4"   :@"iPad Pro 9.7-inch",// iPad Pro 9.7-inch
                              @"iPad6,7"   :@"iPad Pro 12.9-inch",// iPad Pro 12.9-inch
                              @"iPad6,8"   :@"iPad Pro 12.9-inch",// iPad Pro 12.9-inch
                              @"iPad7,1"   :@"iPad Pro 12.9-inch",// 2nd Generation iPad Pro 12.5-inch - Wifi
                              @"iPad7,2"   :@"iPad Pro 12.9-inch",// 2nd Generation iPad Pro 12.5-inch - Cellular
                              @"iPad7,3"   :@"iPad Pro 10.5-inch",// iPad Pro 12.5-inch - Wifi
                              @"iPad7,4"   :@"iPad Pro 10.5-inch",// iPad Pro 12.5-inch - Cellular
                              @"AppleTV2,1":@"Apple TV",        // Apple TV (2nd Generation)
                              @"AppleTV3,1":@"Apple TV",        // Apple TV (3rd Generation)
                              @"AppleTV3,2":@"Apple TV",        // Apple TV (3rd Generation - Rev A)
                              @"AppleTV5,3":@"Apple TV",        // Apple TV (4th Generation)
                              @"AppleTV6,2":@"Apple TV 4K",     // Apple TV 4K
                              };
    }

    NSString* deviceName = [deviceNamesByCode objectForKey:self.deviceId];

    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:

        if ([self.deviceId rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([self.deviceId rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([self.deviceId rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else if([self.deviceId rangeOfString:@"AppleTV"].location != NSNotFound){
            deviceName = @"Apple TV";
        }
    }

    return deviceName;
}

- (NSString *) carrier
{
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    return carrier.carrierName;
}

- (NSString*) userAgent
{
#if TARGET_OS_TV
    return @"not available";
#else
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    return [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
#endif
}

- (NSString*) deviceLocale
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    return language;
}

- (NSString*) deviceCountry
{
  NSString *country = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
  return country;
}

- (NSString*) timezone
{
  NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
  return currentTimeZone.name;
}

- (bool) isTablet
{
  return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

- (bool) is24Hour
{
    NSString *format = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    return ([format rangeOfString:@"a"].location == NSNotFound);
}

- (unsigned long long) totalMemory {
  return [NSProcessInfo processInfo].physicalMemory;
}

- (NSDictionary *)constantsToExport
{
    UIDevice *currentDevice = [UIDevice currentDevice];

    NSString *uniqueId = [DeviceUID uid];

    return @{
             @"systemName": currentDevice.systemName,
             @"systemVersion": currentDevice.systemVersion,
             @"apiLevel": @"not available",
             @"model": self.deviceName,
             @"brand": @"Apple",
             @"deviceId": self.deviceId,
             @"deviceName": currentDevice.name,
             @"deviceLocale": self.deviceLocale,
             @"deviceCountry": self.deviceCountry ?: [NSNull null],
             @"uniqueId": uniqueId,
             @"bundleId": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"],
             @"appVersion": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: [NSNull null],
             @"buildNumber": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
             @"systemManufacturer": @"Apple",
             @"carrier": self.carrier ?: [NSNull null],
             @"userAgent": self.userAgent,
             @"timezone": self.timezone,
             @"isEmulator": @(self.isEmulator),
             @"isTablet": @(self.isTablet),
             @"is24Hour": @(self.is24Hour),
             @"totalMemory": @(self.totalMemory)
             };
}

RCT_EXPORT_METHOD(isPinOrFingerprintSet:(RCTResponseSenderBlock)callback)
{
  #if TARGET_OS_TV
    BOOL isPinOrFingerprintSet = false;
  #else
    LAContext *context = [[LAContext alloc] init];
    BOOL isPinOrFingerprintSet = ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil]);
  #endif
    callback(@[[NSNumber numberWithBool:isPinOrFingerprintSet]]);
}

RCT_EXPORT_METHOD(getUsedMemory:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if (kerr != KERN_SUCCESS) {
      reject(@"fetch_error", @"task_info failed", nil);
      return;
    }

    resolve(@((unsigned long)info.resident_size));
}

RCT_EXPORT_METHOD(getCPUUsage:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;

    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        reject(@"fetch_error", @"task_info failed", nil);
        return;
    }

    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;

    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;

    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads

    basic_info = (task_basic_info_t)tinfo;

    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        reject(@"fetch_error", @"task_threads failed", nil);
        return;
    }
    if (thread_count > 0)
        stat_thread += thread_count;

    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;

    for (j = 0; j < (int)thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            reject(@"fetch_error", @"thread_info failed", nil);
            return;
        }

        basic_info_th = (thread_basic_info_t)thinfo;

        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }

    } // for each thread

    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    if (kr =! KERN_SUCCESS) {
        reject(@"fetch_error", @"vm_deallocate failed", nil);
        return;
    }

    resolve(@(tot_cpu));
}


@end
