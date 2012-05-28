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
#import <Foundation/Foundation.h>
#import "Mactos.h"
#import "Constants.h"

@interface Utils : NSObject

// calcualte new NSDate based on @date by adding days/months/years
+(NSDate*)addToDate:(NSDate*)date days:(int)days months:(int)months years:(int)years;

// calcualte new NSDate based on @date by adding seconds/minutes/hours
+(NSDate*)addToDate:(NSDate *)date seconds:(int)seconds minutes:(int)minutes hours:(int)hours;

// format string in format d motnh year (number of days remianed)
+(NSString*)dateFormatWithRemainingDays:(NSDate*)dateFrom dateTo:(NSDate*)dateTo;

// format string in format d motnh yea
+(NSString*)dateFormatSimple:(NSDate*)date;

// calculate number of days remain and format in format (in "numDays" days)
+(NSString*)daysRemain:(NSDate *)dateFrom dateTo:(NSDate *)dateTo;

// calculate the number of days remain and returns it's value
+(NSInteger)daysRemainValue:(NSDate *)dateFrom dateTo:(NSDate *)dateTo;

// rescale image to targetSize
+(UIImage*)imageByScalingAndCroppingForSize:(UIImage*)sourceImage toTargetSize:(CGSize)targetSize;

// perform schedule of notification, notification ID is used to lately unregister notification
// descirption argument is the text displayed on notification
+(void)registerNotificationForDate:(NSDate *)date withId:(NSNumber*)notifId descripion:(NSString*)description;

// unregister notification with specific id
+(void)unregisterNotificationWithId:(NSNumber*)notifId;

// indcation if current client iOS version is 5, otherwise it's 4
//+(BOOL)isIOS5;

@end
