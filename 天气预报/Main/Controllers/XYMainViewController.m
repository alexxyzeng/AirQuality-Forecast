//
//  ViewController.m
//  天气预报
//
//  Created by xiayao on 16/3/2.
//  Copyright (c) 2016年 xiayao. All rights reserved.
//

#import "XYMainViewController.h"
#import "XYMapViewController.h"
#import "XYWeatherCell.h"
#import "XYWeatherHeaderView.h"
#import "XYGetWeatherData.h"
#import "XYWeatherDataTool.h"
#import "XYWeatherData.h"
#import "XYCityDesc.h"
#import "MBProgressHUD+MJ.h"
#import "XYDescView.h"

#define  KWindowWidth [UIApplication sharedApplication].keyWindow.frame.size.width
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

@interface XYMainViewController () <UITableViewDelegate, UITableViewDataSource>
/**
 *  当前城市所有天气数据数组
 */
@property (nonatomic, strong) NSMutableArray                 *currCityWeatherArr;
/**
 *  城市描述
 */
@property (nonatomic, weak  ) XYDescView                     *cityDescView;
/**
 *  历史天气数据列表标题
 */
@property (nonatomic, weak) UILabel *weatherListLabel;
/**
 *  历史天气数据列表视图
 */
@property (nonatomic, weak  ) UITableView                    *weatherTableView;

@end

@implementation XYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.view.backgroundColor = RGB(135, 206, 241);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _currCityWeatherArr = [NSMutableArray arrayWithArray:[XYWeatherDataTool weatherDataWithCityName:_weatherData.city]];
    [_currCityWeatherArr insertObject:_weatherData atIndex:0];
    
    [self setUpNavBar];
    [self setUpDescView];
    [self setUpWeatherTableView];
    [self setUpweatherListLabel];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view removeFromSuperview];
}
#pragma mark 子视图设置
//设置导航条
- (void)setUpNavBar
{
    UIBarButtonItem *back                  = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                                     imageNamed:@"navigationbar_back_dark"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(popToRootVc)];
    UIBarButtonItem *save                  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWeatherData)];
    self.navigationItem.leftBarButtonItem  = back;
    self.navigationItem.rightBarButtonItem = save;
    self.navigationItem.title              = @"空气质量详情";
}
//设置城市描述
- (void)setUpDescView
{
    [self.view addSubview:_cityDescView];
    //获取对应的数据模型
    self.navigationItem.title = _weatherData.city;
    //在这里请求获取城市描述数据，加载到视图中，并保存到数据模型中
    NSLog(@"city = %@", _weatherData.city);
    //先从数据库中查找
    NSArray *dataArr = [XYWeatherDataTool weatherDataWithCityName:_weatherData.city];
    for (XYWeatherData *data in dataArr) {
        if (data.cityDesc) {
            _weatherData.cityDesc = data.cityDesc;
            XYDescView *descView  = [[XYDescView alloc] initWithFrame:CGRectMake(0, 70, KWindowWidth, CGRectGetMidY(self.view.bounds) - 100) text:_weatherData.cityDesc];
            _cityDescView         = descView;
            [self.view addSubview:_cityDescView];
        } else {
            [XYCityDesc getCityDescWithCity:_weatherData.city success:^(NSString *cityDesc) {
                _cityDescView.attributedText = [_cityDescView textViewWithText:cityDesc];
            } failure:^(NSError *error) {
                _cityDescView.text = @"获取相应城市描述失败";
            }];
        }
    }

}

- (void)popToRootVc
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//保存天气数据
- (void)saveWeatherData
{
    [MBProgressHUD showMessage:@"正在保存"];
    [XYWeatherDataTool saveWeatherDataWithData:[_dataArr lastObject]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        //禁用按钮
        self.navigationItem.rightBarButtonItem = nil;
    });
}
//列表标题
- (void)setUpweatherListLabel
{
    UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake((KWindowWidth - 300) / 2, CGRectGetMidY(self.view.bounds) - 5, 300, 50)];
    label.textColor     = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font          = [UIFont fontWithName:@"HelveticaNeue" size:20];
    label.text          = @"空气质量历史记录";
    _weatherListLabel = label;
    [self.view addSubview:_weatherListLabel];
}

//设置空气质量表视图
- (void)setUpWeatherTableView
{
    UITableView *weatherTableView        = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(self.view.bounds) - 20, KWindowWidth, CGRectGetMidY(self.view.bounds)) style:UITableViewStyleGrouped];
    weatherTableView.contentSize         = CGSizeMake(self.view.bounds.size.width, CGRectGetMidY(self.view.bounds));
    weatherTableView.backgroundColor     = [UIColor clearColor];
    weatherTableView.sectionFooterHeight = 1.0;
    weatherTableView.separatorStyle      = UITableViewCellSeparatorStyleSingleLine;
    _weatherTableView                    = weatherTableView;
    _weatherTableView.delegate           = self;
    _weatherTableView.dataSource         = self;
    
    [self.view addSubview:_weatherTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 表视图代理和数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currCityWeatherArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id = @"weatherId";
    XYWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[XYWeatherCell alloc] initWithFrame:CGRectMake(0, 0, KWindowWidth, 40)];
        //获取数据
        XYWeatherData *weatherData = _currCityWeatherArr[indexPath.row];
        //赋值
        NSArray *timeArr           = [weatherData.time componentsSeparatedByString:@" "];
        cell.updateDateLabel.text  = timeArr[0];
        cell.updateTimeLabel.text  = timeArr[1];
        cell.pm25Label.text        = weatherData.PM25;
        cell.pm10Label.text        = weatherData.PM10;
        cell.AQILabel.text         = weatherData.AQI;
        cell.qualityLabel.text     = weatherData.quality;
        
        if (indexPath.row == 0) {
            cell.updateDateLabel.textColor = RGB(0, 102, 255);
            cell.updateTimeLabel.textColor = RGB(0, 102, 255);
            cell.pm25Label.textColor       = RGB(0, 102, 255);
            cell.pm10Label.textColor       = RGB(0, 102, 255);
            cell.AQILabel.textColor        = RGB(0, 102, 255);
            cell.qualityLabel.textColor    = RGB(0, 102, 255);
        } else {
            cell.updateDateLabel.textColor = [UIColor whiteColor];
            cell.updateTimeLabel.textColor = [UIColor whiteColor];
            cell.pm25Label.textColor       = [UIColor whiteColor];
            cell.pm10Label.textColor       = [UIColor whiteColor];
            cell.AQILabel.textColor        = [UIColor whiteColor];
            cell.qualityLabel.textColor    = [UIColor whiteColor];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    XYWeatherHeaderView *headerView = [[XYWeatherHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWindowWidth, 40)];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
@end
