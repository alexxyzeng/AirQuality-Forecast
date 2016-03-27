//
//  XYWeatherHeaderView.m
//  
//
//  Created by xiayao on 16/3/3.
//
//


#import "XYWeatherHeaderView.h"
#define Padding           5
#define DateLabelWidth    75
#define PM25LabelWidth    50
#define PM10LabelWidth    50
#define AQILabelWidth     30
#define QualityLabelWidth 70

@implementation XYWeatherHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews
{
    NSInteger margin                        = (self.bounds.size.width - Padding * 4 - DateLabelWidth -
                                              PM25LabelWidth - PM10LabelWidth - AQILabelWidth - QualityLabelWidth) / 4;
    //更新日期
    UILabel *dateLabel                      = [[UILabel alloc] initWithFrame:CGRectMake(Padding * 2, Padding, DateLabelWidth, 20)];
    dateLabel.textColor                     = [UIColor whiteColor];
    dateLabel.textAlignment                 = NSTextAlignmentLeft;
    dateLabel.font                          = [UIFont fontWithName:@"HelveticaNeue" size:16];
    dateLabel.text = @"更新时间";
    dateLabel.adjustsFontSizeToFitWidth     = YES;
    _updateDateLabel                        = dateLabel;
    [self addSubview:_updateDateLabel];
    
    UILabel *pm25Label                      = [[UILabel alloc] initWithFrame:CGRectMake(Padding * 2 + DateLabelWidth + margin, Padding, PM25LabelWidth, 20)];
    pm25Label.textColor                     = [UIColor whiteColor];
    pm25Label.textAlignment                 = NSTextAlignmentCenter;
    pm25Label.font                          = [UIFont fontWithName:@"HelveticaNeue" size:16];
    pm25Label.text = @"PM2.5";
    pm25Label.adjustsFontSizeToFitWidth     = YES;
    _pm25Label = pm25Label;
    [self addSubview:_pm25Label];
    
    
    UILabel *pm10Label                  = [[UILabel alloc] initWithFrame:CGRectMake(Padding * 2 + DateLabelWidth + PM25LabelWidth + margin * 2, Padding, PM10LabelWidth, 20)];
    pm10Label.textColor                 = [UIColor whiteColor];
    pm10Label.textAlignment             = NSTextAlignmentCenter;
    pm10Label.font                      = [UIFont fontWithName:@"HelveticaNeue" size:16];
    pm10Label.text = @"PM10";
    pm10Label.adjustsFontSizeToFitWidth = YES;
    _pm10Label                          = pm10Label;
    [self addSubview:_pm10Label];
    
    
    UILabel *AQILabel                       = [[UILabel alloc] initWithFrame:CGRectMake(Padding * 2 + DateLabelWidth + PM25LabelWidth + PM10LabelWidth + margin * 3, Padding, AQILabelWidth, 20)];
    AQILabel.textColor                      = [UIColor whiteColor];
    AQILabel.textAlignment                  = NSTextAlignmentCenter;
    AQILabel.font                           = [UIFont fontWithName:@"HelveticaNeue" size:16];
    AQILabel.text = @"AQI";
    AQILabel.adjustsFontSizeToFitWidth      = YES;
    _AQILabel                               = AQILabel;
    [self addSubview:_AQILabel];
    
    
    UILabel *qualityLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(Padding * 2+ DateLabelWidth + PM25LabelWidth + PM10LabelWidth + AQILabelWidth + margin * 4, Padding, QualityLabelWidth, 20)];
    qualityLabel.textColor                  = [UIColor whiteColor];
    qualityLabel.textAlignment              = NSTextAlignmentCenter;
    qualityLabel.font                       = [UIFont fontWithName:@"HelveticaNeue" size:16];
    qualityLabel.text = @"空气质量";
    qualityLabel.adjustsFontSizeToFitWidth  = YES;
    _qualityLabel                           = qualityLabel;
    [self addSubview:_qualityLabel];
}
@end

