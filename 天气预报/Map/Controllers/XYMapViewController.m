//
//  XYMapViewController.m
//  
//
//  Created by xiayao on 16/3/2.
//
//

#import "XYMapViewController.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "XYMainViewController.h"
#import "XYMyAnnotation.h"
#import "XYAnnotationView.h"
#import "XYGetWeatherData.h"
#import "XYSettingViewController.h"
#import "XYWeatherData.h"
#import "MBProgressHUD+MJ.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

@interface XYMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, XYSettingViewControllerDelegate>
/**
 *  导航条
 */
@property (nonatomic, weak    ) UINavigationBar                *navBar;
/**
 *  当前城市名称
 */
@property (nonatomic, copy    ) NSString                       *locationName;
/**
 *  当前位置空气质量标签
 */
@property (nonatomic, weak    ) UILabel                        *weatherDataLabel;
/**
 *  地图视图
 */
@property (nonatomic, weak    ) MKMapView                      *mapView;
/**
 *  定位管理器
 */
@property (nonatomic, strong  ) CLLocationManager              *locationMgr;
/**
 *  空气质量数据数组
 */
@property (nonatomic, strong  ) NSMutableArray                 *dataArr;
/**
 *  设置控制器
 */
@property (nonatomic, strong  ) XYSettingViewController        *settingVc;
/**
 *  标记数组
 */
@property (nonatomic, strong) NSMutableArray *annoArr;
@end

@implementation XYMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalTransitionStyle   = UIModalTransitionStyleFlipHorizontal;
    
    //设置定位管理器
    _locationMgr                 = [[CLLocationManager alloc] init];
    _locationMgr                 = [[CLLocationManager alloc]init];
    _locationMgr.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    _locationMgr.distanceFilter  = 3000;
    _locationMgr.delegate        = self;
    [_locationMgr startUpdatingLocation];
    [_locationMgr requestAlwaysAuthorization];
    [_locationMgr requestWhenInUseAuthorization];

    //地图点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchWeatherData:)];
    [self.view addGestureRecognizer:tap];
    
    [self setUpViewController];
    [self setUpMapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dataArr = [NSMutableArray array];
    _annoArr = [NSMutableArray array];
    [_locationMgr startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_locationMgr stopUpdatingLocation];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.navigationItem.title = @"空气质量";
        self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_button"] style:UIBarButtonItemStyleDone target:self action:@selector(showSettingVc)];;

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right_button_loc"] style:UIBarButtonItemStylePlain target:self action:@selector(showLocation)];
    }
    return self;
}

#pragma mark 添加子视图和控制器
//地图
- (void)setUpMapView
{
    //设置地图视图
    MKMapView *mapView          = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _mapView                    = mapView;
    _mapView.delegate           = self;
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    _mapView.mapType            = MKMapTypeStandard;
        [self.view addSubview:_mapView];
    
    //设置显示范围
    MKCoordinateSpan span             = MKCoordinateSpanMake(2.2, 2.2);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(31.284137, 121.256455);
    MKCoordinateRegion region         = MKCoordinateRegionMake(coordinate, span);
    [_mapView setRegion:region animated:YES];

}
//控制器
- (void) setUpViewController
{
    _settingVc = [[XYSettingViewController alloc] init];
    _settingVc.delegate = self;
}

//设置导航条
- (void)setUpNavBar
{
    UINavigationBar *navBar                = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    _navBar                                = navBar;
    [self.view addSubview:_navBar];
    //添加标题
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_button_press"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettingVc)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right_button_share_press"] style:UIBarButtonItemStylePlain target:self action:@selector(showLocation)];
    self.navigationItem.title              = @"空气质量";
    [_navBar pushNavigationItem:self.navigationItem animated:YES];
}
//显示设置菜单
- (void)showSettingVc
{
   [self.navigationController presentViewController:_settingVc animated:YES completion:nil];
}

- (void)showLocation
{
    MKCoordinateSpan span = MKCoordinateSpanMake(2.2, 2.2);
    MKCoordinateRegion region = MKCoordinateRegionMake(_mapView.userLocation.coordinate, span);
     [_mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    [_mapView setRegion:region animated:YES];
}

//查询天气数据并跳转视图
- (void)searchWeatherData:(UITapGestureRecognizer *)gest
{
    if ([gest.view isKindOfClass:[MKPinAnnotationView class]]) {
        return;
    }
    gest.numberOfTapsRequired = 1;
    NSUInteger tapCount               = 0;
    //获取tap手势点击的点
    CGPoint touchPoint                = [gest locationOfTouch:tapCount inView:self.mapView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取该点的经纬度和位置
    CLLocationCoordinate2D coordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:self.view];
    CLLocation *currLocation          = [[CLLocation alloc] initWithCoordinate:coordinate altitude:0 horizontalAccuracy:kCLLocationAccuracyThreeKilometers verticalAccuracy:kCLLocationAccuracyThreeKilometers timestamp:[NSDate date]];
        //根据位置获取城市名称
    CLGeocoder *geocoder              = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count > 0) {
                CLPlacemark *placemark    = placemarks[0];
                NSDictionary *addressDict = placemark.addressDictionary;
                NSString *city            = [addressDict objectForKey:(NSString *)kABPersonAddressCityKey];
                city                      = city == nil ? @"" : city;
                NSLog(@"当前城市  %@", city);
                if (city) {
                    [XYGetWeatherData getWeatherDataWithCityName:city success:^(XYWeatherData *weatherData) {
                            //跳转视图，更新数据，添加大头针标记
                            [self popToMainVcWithData:weatherData
                                                 city:city
                                           coordinate:(CLLocationCoordinate2D )coordinate];
                        } failure:^(NSError *error) {
                            NSLog(@"%@", error);
                        }];
                }
            }
        }];
            });
    
    
}
//跳转视图
- (void)popToMainVcWithData:(XYWeatherData *)weatherData
                       city:(NSString *)city
                 coordinate:(CLLocationCoordinate2D )coordinate
{
    //传递空气质量数据
    XYMainViewController *mainVc             = [[XYMainViewController alloc] init];
    [_dataArr addObject:weatherData];
    mainVc.weatherData                       = weatherData;
    mainVc.dataArr                           = _dataArr;
    NSString *cityName                       = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    mainVc.navigationItem.rightBarButtonItem = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        XYMyAnnotation *anno = [[XYMyAnnotation alloc] init];
        anno.title           = cityName;
        [_annoArr addObject:anno];
        [_mapView addAnnotations:_annoArr];
        //跳转视图控制器
        [self.navigationController pushViewController:mainVc animated:YES];
        //TODO: 判断数组是否有相同城市，有就不添加大头针

        

//        [self addAnnotationToMapViewwithCityName:cityName];
    });

}
//添加地图标记
- (void)addAnnotationToMapViewwithCityName:(NSString *)cityName
{
//    NSMutableArray *nameArr = [NSMutableArray array];
//    for (XYWeatherData *weatherData in _dataArr) {
//        [nameArr addObject:weatherData.city];
//    }
//    if ([nameArr indexOfObject:cityName] == NSNotFound) {
        XYMyAnnotation *anno = [[XYMyAnnotation alloc] init];
        anno.title           = cityName;
        
        [_annoArr addObject:anno];
        [_mapView addAnnotations:_annoArr];
//    }
}
//当前城市空气质量横幅
- (void)setUpWeatherDataLabel
{
    UILabel *weatherLabel                       = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 40)];
    weatherLabel.backgroundColor                = [UIColor colorWithWhite:1.0 alpha:0.7];
    weatherLabel.font                           = [UIFont fontWithName:@"HelveticaNeue" size:16];
    weatherLabel.textColor                      = RGB(0, 102, 255);
    weatherLabel.textAlignment                  = NSTextAlignmentCenter;
    _weatherDataLabel.adjustsFontSizeToFitWidth = YES;
    _weatherDataLabel                           = weatherLabel;
    weatherLabel.hidden                         = YES;
    [self.view addSubview:_weatherDataLabel];
}

#pragma mark mapKit代理方法
//设置定位城市和其他城市的标记
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //设置用户地址大头针
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *id = @"annoView";
    XYMyAnnotation *anno          = [[XYMyAnnotation alloc] init];
    annotation                    = anno;
    MKPinAnnotationView *annoView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:id];

    if (!annoView) {
    annoView                      = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:id];
    annoView.animatesDrop         = YES;
    annoView.draggable            = YES;
    annoView.pinColor             = MKPinAnnotationColorPurple;
    annoView.annotation           = anno;
    }
    return annoView;
}

//选中标记后
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //跳转视图控制器
    XYMainViewController *mainVc = [[XYMainViewController alloc] init];
    if ([view.annotation isKindOfClass:[XYMyAnnotation class]]) {
        for (XYWeatherData *weatherData in _dataArr) {
            if ([weatherData.city isEqualToString:view.annotation.title]) {
                mainVc.weatherData = weatherData;
            }
        }
    }
    [self.navigationController pushViewController:mainVc animated:YES];

}
//获取地图位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
//    [MBProgressHUD showMessage:@"定位成功"];
    //根据位置获取城市名称
    CLGeocoder *geocoder      = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
    CLPlacemark *placemark    = placemarks[0];
    NSDictionary *addressDict = placemark.addressDictionary;
    NSString *location        = [addressDict objectForKey:(NSString *)kABPersonAddressCityKey];
    location                  = location == nil ? @"" : location;
    _locationName             = location;
            if (location) {
                static dispatch_once_t onceToken;
                //不能重复执行，每天有限制
                dispatch_once(&onceToken, ^{
                    [XYGetWeatherData getWeatherDataWithCityName:location success:^(XYWeatherData *weatherData) {
                        //刷新视图
                        [self updateViewWithData:weatherData];
                    } failure:^(NSError *error) {
                        NSLog(@"%@", error);
                    }];
                });
            }
            
        dispatch_async(dispatch_get_main_queue(), ^{
            //添加大头针
            NSString *locationName       = [location stringByReplacingOccurrencesOfString:@"市" withString:@""];
            XYMyAnnotation *locationAnno = [[XYMyAnnotation alloc] init];
            locationAnno.title           = locationName;
            locationAnno.coordinate      = userLocation.coordinate;
            
            [_annoArr addObject:locationAnno];
            [_mapView addAnnotation:locationAnno];
            [MBProgressHUD hideHUD];
            });

        }
    }];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [MBProgressHUD showError:@"定位失败"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}
- (void)updateViewWithData:(XYWeatherData *)weatherData
{
    //天气概况横幅
    [self setUpWeatherDataLabel];
    [_dataArr addObject:weatherData];
    NSLog(@"%s", __func__);
    _weatherDataLabel.text = [NSString stringWithFormat:@"PM2.5:%@  PM10:%@  AQI: %@ 空气质量:%@", weatherData.PM25, weatherData.PM10, weatherData.AQI, weatherData.quality];
    //显示动画
    _weatherDataLabel.hidden  = NO;
    CABasicAnimation *show    = [CABasicAnimation animationWithKeyPath:@"opacity"];
    show.fromValue            = @0.0;
    show.toValue              = @1.0;
    show.duration             = 1.5;
    [_weatherDataLabel.layer addAnimation:show forKey:nil];
    _weatherDataLabel.adjustsFontSizeToFitWidth = YES;

    [self.view bringSubviewToFront:_weatherDataLabel];
    self.navigationItem.title = weatherData.city;
    [_navBar pushNavigationItem:self.navigationItem animated:YES];
}

#pragma mark 设置控制器代理方法
- (void)stopShowUserLocation
{
    _mapView.showsUserLocation = NO;
}

- (void)startShowUserLocation
{
    _mapView.showsUserLocation = YES;
}

- (void)showAnnotaion
{
    [_mapView addAnnotations:_annoArr];
}

- (void)removeAnnotaion
{
    [_mapView removeAnnotations:_annoArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_mapView removeFromSuperview];
    [self.view addSubview:_mapView];
}


@end
