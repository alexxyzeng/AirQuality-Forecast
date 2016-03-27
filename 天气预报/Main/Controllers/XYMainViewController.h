//
//  ViewController.h
//  天气预报
//
//  Created by xiayao on 16/3/2.
//  Copyright (c) 2016年 xiayao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYWeatherData;
@interface XYMainViewController : UIViewController
/**
 *  保存的天气数据数组
 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/**
 *  当前的天气数据
 */
@property (nonatomic, strong) XYWeatherData *weatherData;
@end

