//
//  XYSettingViewController.m
//  
//
//  Created by xiayao on 16/3/4.
//
//

#import "XYSettingViewController.h"
#import "XYWeatherDataTool.h"
#import "XYWeatherData.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

@interface XYSettingViewController () <UITableViewDelegate, UITableViewDataSource>
/**
 *  天气城市列表数组
 */
@property (nonatomic, strong ) NSMutableArray     *cityArr;
/**
 *  设置列表
 */
@property (nonatomic,weak    ) UITableView        *settingTableView;
/**
 *  导航条
 */
@property (nonatomic, weak   ) UINavigationBar    *navBar;

@end

@implementation XYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    //加载子视图
    [self setUpNavBar];
    [self setUpSettingTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initCityArr];
    NSIndexSet *indesSet = [NSIndexSet indexSetWithIndex:0];
    [_settingTableView reloadSections:indesSet withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark 加载子视图和数据方法
- (void)initCityArr
{
    //获取保存的所有值
    NSArray *dataArr = [XYWeatherDataTool allWeatherData];
    NSMutableArray *cityArr = [NSMutableArray array];
    if (cityArr) {
        for (XYWeatherData *data in dataArr) {
            NSString *cityName = data.city;
            [cityArr addObject:cityName];
        }
        //去除重复的城市名
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *cityName in cityArr) {
            [dict setValue:cityName forKey:cityName];
        }
        _cityArr = [NSMutableArray arrayWithArray:dict.allValues];
    }
}
//设置导航条
- (void)setUpNavBar
{
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    navBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    navBar.tintColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    navBar.translucent = YES;
    //设置按钮和标题
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backToMapVc)];
    back.tintColor = RGB(0, 122, 255);
    self.navigationItem.rightBarButtonItem = back;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    titleLabel.text = @"设置";
    [self.navigationItem setTitleView:titleLabel];
    [navBar pushNavigationItem:self.navigationItem animated:YES];

    _navBar = navBar;
    [self.view addSubview:_navBar];
}

- (void)setUpSettingTableView
{
    UITableView *settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStyleGrouped];
    settingTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    settingTableView.backgroundColor = RGB(135, 206, 241);
    settingTableView.sectionFooterHeight = 1.0;
    _settingTableView = settingTableView;
    _settingTableView.dataSource = self;
    _settingTableView.delegate = self;
    [self.view addSubview:_settingTableView];

}
//回到地图控制器
- (void)backToMapVc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 设置列表数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _cityArr.count;;
            break;
        case 1:
            return 3;
        default:
            break;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSArray *textArr = @[@"显示当前位置", @"推送通知", @"清除地图标记"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font      = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.selectionStyle      = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor     = [UIColor clearColor];

        if (indexPath.section == 0) {
            cell.textLabel.text = _cityArr[indexPath.row];
        }
        if (indexPath.section == 1) {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString *setting = textArr[indexPath.row];
            cell.textLabel.text = setting;
            switch (indexPath.row) {
                case 0:
                {
                    cell.accessoryView    = [[UIView alloc] init];
                    UISwitch *locSwitch   = [[UISwitch alloc] init];
                    locSwitch.onTintColor = RGB(0, 122, 241);
                    locSwitch.on          = YES;
                    if ([locSwitch isOn]) {
//                        [self.delegate stopShowUserLocation];
                    } else {
//                        [self.delegate startShowUserLocation];
                    }
                    cell.accessoryView = locSwitch;
                }
                    break;
                case 1:
                {
                    cell.accessoryView    = [[UIView alloc] init];
                    UISwitch *locSwitch   = [[UISwitch alloc] init];
                    locSwitch.onTintColor = RGB(0, 122, 241);
                    locSwitch.on          = YES;
                    if ([locSwitch isOn]) {
                        //注册通知
                        [self registerLocalNotication];
                    } else {
                        [self removeLocalNotication];
                    }
                    cell.accessoryView = locSwitch;
                }
                case 2:
                {
                    cell.accessoryView    = [[UIView alloc] init];
                    UISwitch *locSwitch   = [[UISwitch alloc] init];
                    locSwitch.onTintColor = RGB(0, 122, 241);
                    locSwitch.on          = NO;
                    if ([locSwitch isOn]) {
                        //注册通知
                        [self.delegate removeAnnotaion];
                    } else {
                        [self.delegate showAnnotaion];
                    }
                    cell.accessoryView = locSwitch;
                }
                default:
                    break;
            }
            
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width, 40)];
    headerLabel.textColor                 = RGB(0, 102, 255);
    headerLabel.font                      = [UIFont fontWithName:@"HelveticaNeue" size:18];

    headerLabel.adjustsFontSizeToFitWidth = YES;
    headerLabel.textAlignment             = NSTextAlignmentLeft;
    headerLabel.text                      = nil;
    if (section == 0) {
        headerLabel.text = @"   城市列表";
    }
    if (section == 1) {
        headerLabel.text = @"   其他设置";
    }
    
    return headerLabel;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 2://移除标记
                [self.delegate removeAnnotaion];
                break;
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

#pragma mark 注册和接触通知
- (void)registerLocalNotication
{
    // 创建一个本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置10秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:10];
    if (notification != nil) {
        // 设置推送信息
        notification.fireDate                   = pushDate;
        notification.timeZone                   = [NSTimeZone defaultTimeZone];
        notification.alertBody                  = @"天气通知";
        notification.applicationIconBadgeNumber = 1;
        NSDictionary *info                      = [NSDictionary dictionaryWithObject:@"airquality"
                                                                              forKey:@"key"];
        notification.userInfo                   = info;
        //添加推送到UIApplication
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType type          = UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                     categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            // 通知重复提示的单位，可以是天、周、月
            notification.repeatInterval          = NSCalendarUnitDay;
    }
    }
}

- (void)removeLocalNotication {
    // 获得 UIApplication
    UIApplication *app  = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArray = [app scheduledLocalNotifications];
    for (UILocalNotification * loc in localArray) {
        if ([[loc.userInfo objectForKey:@"key"] isEqualToString:@"airquality"]) {
            //取消 本地推送
            [[UIApplication sharedApplication] cancelLocalNotification:loc];
        }
    }
}
@end

