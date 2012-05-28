/*
 
 Copyright (c) 2012 Artem Umanets. The MIT License 
 
 Permission is hereby granted, free of charge, to any person obtaining a copy 
 of this software and associated documentation files (the "Software"), to deal 
 in the Software without restriction, including without limitation the rights 
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
 of the Software, and to permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all 
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE 
 OR OTHER DEALINGS IN THE SOFTWARE.
 
 More info: http://www.opensource.org/licenses/MIT
 
 */

#import "Utils.h"

@implementation Utils

+(NSDate*)addToDate:(NSDate *)date days:(int)days months:(int)months years:(int)years{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = months;
    components.day = days;
    components.year = years;

    NSDate *nextMonth = [gregorian dateByAddingComponents:components toDate:date options:0];
    [components release];
    
    NSDateComponents *nextMonthComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:nextMonth];
    NSDateComponents *todayDayComponents = [gregorian components:NSDayCalendarUnit fromDate:date];
    
    nextMonthComponents.day = todayDayComponents.day;
    NSDate *udatedDate = [gregorian dateFromComponents:nextMonthComponents];
    [gregorian release];
    return udatedDate;
}

+(NSDate*)addToDate:(NSDate *)date seconds:(int)seconds minutes:(int)minutes hours:(int)hours{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.second = seconds;
    components.minute = minutes;
    components.hour = hours;
    NSDate *updatedDate = [gregorian dateByAddingComponents:components toDate:date options:0];
    [components release];
    
    [gregorian release];
    return updatedDate;
}

+(NSString*)dateFormatWithRemainingDays:(NSDate *)dateFrom dateTo:(NSDate *)dateTo{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMMM YYYY"];
    NSString *dateString = [dateFormat stringFromDate:dateTo];
    [dateFormat release];
    
    return [NSString stringWithFormat:@"%@ %@", dateString, [Utils daysRemain:dateFrom dateTo:dateTo]];
}

+(NSString*)daysRemain:(NSDate *)dateFrom dateTo:(NSDate *)dateTo{
    NSInteger days = [Utils daysRemainValue:dateFrom dateTo:dateTo];
    
    NSString *daysString;
    
    if(days <= 0){
        daysString = NSLocalizedString(@"(for 0 days)", nil);
    }else if(days == 1){
        daysString = [NSString stringWithFormat:NSLocalizedString(@"(for 1 day)",nil)];
    }else{
        daysString = [NSString stringWithFormat:NSLocalizedString(@"(for %d days)", nil), days];
    }
    return daysString;
}

+(NSInteger)daysRemainValue:(NSDate *)dateFrom dateTo:(NSDate *)dateTo{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMMM YYYY"];
    [dateFormat release];
    
    
    
    NSDateComponents *componentsToSubtract = [[[NSDateComponents alloc] init] autorelease];
    [componentsToSubtract setDay:-1];
    
    NSDate *today = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:dateFrom options:0];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:today
                                                          toDate:dateTo
                                                         options:NSWrapCalendarComponents];
    NSInteger days = [components day];
    [gregorianCalendar release];
    return days;
}

+(NSString*)dateFormatSimple:(NSDate*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMMM YYYY"];
    NSString *dateString = [dateFormat stringFromDate:date];
    [dateFormat release];
    
    return dateString;
}

+(UIImage*)imageByScalingAndCroppingForSize:(UIImage*)sourceImage toTargetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;  
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        DebugLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+(void)registerNotificationForDate:(NSDate *)date withId:(NSNumber*)notifId descripion:(NSString*)description{
    
    // calculate date
    DebugLog(@"Current date %@", date);
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-1]; // subtract entire month

    NSDate *updatedDate = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
    DebugLog(@"Updated Date %@", updatedDate);

    NSDateComponents *updatedDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:updatedDate];
    [updatedDateComponents setHour:NOTIFICATION_HOUR];
    [updatedDateComponents setMinute:0];
    [updatedDateComponents setSecond:0];
    /*
    [updatedDateComponents setSecond:0];
    [updatedDateComponents setMinute:5];
    [updatedDateComponents setHour:20];
    [updatedDateComponents setMonth:5];
    [updatedDateComponents setDay:1];
    [updatedDateComponents setYear:2012];*/
    
    NSDate *finalDate = [gregorian dateFromComponents: updatedDateComponents];
    [gregorian release];
    [offsetComponents release];
    
    DebugLog(@"Final Date %@", finalDate);
    if([finalDate compare:[NSDate date]] == NSOrderedAscending){
        DebugLog(@"Notification not registered, date is lower then now.");
        return;
    }
    
    // create notification    
    UILocalNotification *local = [[UILocalNotification alloc]init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:notifId forKey:@"ID"];
    local.userInfo = dict;
    
    local.fireDate = finalDate;
    local.alertBody = description;
    local.alertAction = NSLocalizedString(@"View", nil);
    local.soundName = UILocalNotificationDefaultSoundName;
    local.timeZone = [NSTimeZone defaultTimeZone];
    //local.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    DebugLog(@"Notification info: %@", local);
    [local release];
}

+(void)unregisterNotificationWithId:(NSNumber*)notifId{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        NSNumber *nId = [notification.userInfo valueForKey:@"ID"];
        if([notifId isEqualToNumber:nId]){
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            DebugLog(@"Found notification with id %@ and unregisterd", notifId);
        }       
    }
}

/*+(BOOL)isIOS5{
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    DebugLog(@"Version %@",versionCompatibility);
    if ( 5 == [[versionCompatibility objectAtIndex:0] intValue] ) { /// iOS5 is installed
        return YES;
    } else { /// iOS4 is installed
        return NO;    
    }
}*/

@end
