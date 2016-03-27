//
//  XYWeatherCell.m
//  
//
//  Created by xiayao on 16/3/3.
//
//

#import "XYWeatherCell.h"
#define Padding                   10
#define DateLabelWidth            75
#define PM25LabelWidth            50
#define PM10LabelWidth            50
#define AQILabelWidth             30
#define QualityLabelWidth         70
#define ViewWidth                 [UIApplication sharedApplication].keyWindow.frame.size.width

@implementation XYWeatherCell

- (void)awakeFromNib {
    // Initialization code
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setUpSubviews
{
    NSInteger margin                       = (ViewWidth - Padding * 2 - DateLabelWidth - PM25LabelWidth - PM10LabelWidth - AQILabelWidth - QualityLabelWidth) / 4;
    //日期
    UILabel *dateLabel                     = [[UILabel alloc] initWithFrame:CGRectMake(Padding, 5, DateLabelWidth, 20)];
    dateLabel.textColor                    = [UIColor whiteColor];
    dateLabel.textAlignment                = NSTextAlignmentLeft;
    dateLabel.font                         = [UIFont fontWithName:@"HelveticaNeue" size:14];
    dateLabel.adjustsFontSizeToFitWidth    = YES;
    _updateDateLabel                       = dateLabel;
    [self addSubview:_updateDateLabel];
    //时间
    UILabel *timeLabel                     = [[UILabel alloc] initWithFrame:CGRectMake(Padding, Padding * 2, DateLabelWidth, 20)];
    timeLabel.textColor                    = [UIColor whiteColor];
    timeLabel.textAlignment                = NSTextAlignmentLeft;
    timeLabel.font                         = [UIFont fontWithName:@"HelveticaNeue" size:12];
    timeLabel.adjustsFontSizeToFitWidth    = YES;
    _updateTimeLabel                       = timeLabel;
    [self addSubview:_updateTimeLabel];

    //pm2.5
    UILabel *pm25Label                     = [[UILabel alloc] initWithFrame:CGRectMake(Padding + DateLabelWidth + margin, Padding, PM25LabelWidth, 20)];
    pm25Label.textColor                    = [UIColor whiteColor];
    pm25Label.textAlignment                = NSTextAlignmentCenter;
    pm25Label.font                         = [UIFont fontWithName:@"HelveticaNeue" size:16];
    pm25Label.adjustsFontSizeToFitWidth    = YES;
    _pm25Label                             = pm25Label;
    [self addSubview:_pm25Label];

    //pm10
    UILabel *pm10Label                     = [[UILabel alloc] initWithFrame:CGRectMake(Padding + DateLabelWidth + PM25LabelWidth + margin * 2, Padding, PM10LabelWidth, 20)];
    pm10Label.textColor                    = [UIColor whiteColor];
    pm10Label.textAlignment                = NSTextAlignmentCenter;
    pm10Label.font                         = [UIFont fontWithName:@"HelveticaNeue" size:16];
    pm10Label.adjustsFontSizeToFitWidth    = YES;
    _pm10Label                             = pm10Label;
    [self addSubview:_pm10Label];

    //AQI
    UILabel *AQILabel                      = [[UILabel alloc] initWithFrame:CGRectMake(Padding + DateLabelWidth + PM25LabelWidth + PM10LabelWidth + margin * 3, Padding, AQILabelWidth, 20)];
    AQILabel.textColor                     = [UIColor whiteColor];
    AQILabel.textAlignment                 = NSTextAlignmentCenter;
    AQILabel.font                          = [UIFont fontWithName:@"HelveticaNeue" size:16];
    AQILabel.adjustsFontSizeToFitWidth     = YES;
    _AQILabel                              = AQILabel;
    [self addSubview:_AQILabel];

    //空气质量
    UILabel *qualityLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(Padding + DateLabelWidth + PM25LabelWidth + PM10LabelWidth + AQILabelWidth + margin * 4, Padding , QualityLabelWidth, 20)];
    qualityLabel.textColor                 = [UIColor whiteColor];
    qualityLabel.textAlignment             = NSTextAlignmentCenter;
    qualityLabel.font                      = [UIFont fontWithName:@"HelveticaNeue" size:16];
    qualityLabel.adjustsFontSizeToFitWidth = YES;
    _qualityLabel                          = qualityLabel;
    [self addSubview:_qualityLabel];
}
@end
