//
//  XYWeatherData.h
//  
//
//  Created by xiayao on 16/3/2.
//
//

#import <Foundation/Foundation.h>

@interface XYWeatherData : NSObject
/**
 *  天气城市名称
 */
@property (nonatomic,copy ) NSString           *city;
/**
 *  城市描述
 */
@property (nonatomic, copy) NSString           *cityDesc;
/**
 *  天气查询时间
 */
@property (nonatomic, copy) NSString           *time;
/**
 *  空气质量指数
 */
@property (nonatomic, copy) NSString           *AQI;
/**
 *  空气质量
 */
@property (nonatomic, copy) NSString           *quality;
/**
 *  PM2.5
 */
@property (nonatomic, copy) NSString           *PM25;
/**
 *  PM10
 */
@property (nonatomic, copy) NSString           *PM10;

@end
