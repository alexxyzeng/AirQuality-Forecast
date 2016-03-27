//
//  XYWeatherDataTool.h
//  
//
//  Created by xiayao on 16/3/2.
//
//

#import <Foundation/Foundation.h>
@class XYWeatherData;

@interface XYWeatherDataTool : NSObject
/**
 *  保存天气数据
 *
 *  @param weatherData 要保存的天气数据模型
 */
+ (void)saveWeatherDataWithData:(XYWeatherData *)weatherData;
/**
 *  根据城市名称获取本地天气数据
 *
 *  @param city 城市名称
 *
 *  @return 返回天气数据数组
 */
+ (NSArray *)weatherDataWithCityName:(NSString *)city;
/**
 *  获取所有天气数据
 *
 *  @return 返回数据库中所有天气数据
 */
+ (NSArray *)allWeatherData;
@end
