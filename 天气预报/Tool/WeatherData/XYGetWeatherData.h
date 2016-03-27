//
//  XYGetWeatherData.h
//  
//
//  Created by xiayao on 16/3/2.
//
//

#import <Foundation/Foundation.h>
@class XYWeatherData;
@interface XYGetWeatherData : NSObject

/**
 *  根据城市名称返回天气数据
 *
 *  @param cityName 城市名称
 *  @param success  请求成功后天气数据回调
 *  @param failure  请求失败回调
 */
+ (void)getWeatherDataWithCityName:(NSString *)city
                           success:(void (^)(XYWeatherData *weatherData))success
                           failure:(void (^)(NSError *error))failure;
@end
