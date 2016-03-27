//
//  XYWeatherHeaderView.h
//  
//
//  Created by xiayao on 16/3/3.
//
//

#import <UIKit/UIKit.h>

@interface XYWeatherHeaderView : UIView
/**
 *  更新日期标签
 */
@property (nonatomic, weak) UILabel *updateDateLabel;
/**
 *  PM2.5标签
 */
@property (nonatomic, weak) UILabel *pm25Label;
/**
 *  PM10标签
 */
@property (nonatomic, weak) UILabel *pm10Label;
/**
 *  AQI标签
 */
@property (nonatomic, weak) UILabel *AQILabel;
/**
 *  空气质量标签
 */
@property (nonatomic, weak) UILabel *qualityLabel;
@end
