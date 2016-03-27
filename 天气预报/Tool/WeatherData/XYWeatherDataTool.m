//
//  XYWeatherDataTool.m
//  
//
//  Created by xiayao on 16/3/2.
//
//

#import "XYWeatherDataTool.h"
#import "FMDB.h"
#import "XYWeatherData.h"

@implementation XYWeatherDataTool
static FMDatabase *_db;

+ (void)initialize
{
    //创建文件路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath  = [cachePath stringByAppendingPathComponent:@"weather.sqlite"];
    _db = [FMDatabase databaseWithPath:filePath];
    if ([_db open]) {
        NSLog(@"打开成功");
    }
    NSLog(@"%@", filePath);
    //创建表
    BOOL flag = [_db executeUpdate:@"create table if not exists t_weather (id integer primary key autoincrement,city text,time text,AQI text,quality text,PM25 text,PM10 text,desc text);"];
    if (flag) {
        NSLog(@"创建成功");
    } else {
        NSLog(@"创建失败");
    }
}

+ (void)saveWeatherDataWithData:(XYWeatherData *)weatherData
{
    NSString *city    = weatherData.city;
    NSString *time    = weatherData.time;
    NSString *AQI     = weatherData.AQI;
    NSString *quality = weatherData.quality;
    NSString *PM25    = weatherData.PM25;
    NSString *PM10    = weatherData.PM10;
    NSString *desc    = weatherData.cityDesc;
    
    BOOL flag         = [_db executeUpdate:@"insert into t_weather (city,time,AQI,quality,PM25,PM10,desc) values(?,?,?,?,?,?,?)",city,time,AQI,quality,PM25,PM10,desc];
        if (flag) {
            NSLog(@"插入成功");
        } else {
            NSLog(@"插入失败");
        }
}

+ (NSArray *)weatherDataWithCityName:(NSString *)city
{
    NSLog(@"%s", __func__);
    NSString *sql = [NSString stringWithFormat:@"select * from t_weather where city = '%@' order by id desc",city];
    //查询数据
    FMResultSet *set        = [_db executeQuery:sql];
    NSMutableArray *dataArr = [NSMutableArray array];
    while ([set next]) {
        XYWeatherData *weatherData = [[XYWeatherData alloc] init];
        [dataArr addObject:weatherData];
    }
    return dataArr;
}


+ (NSArray *)allWeatherData
{
    NSMutableArray *dataArr = [NSMutableArray array];

    NSString *sql           = [NSString stringWithFormat:@"select * from t_weather order by id desc"];
    FMResultSet *set        = [_db executeQuery:sql];
    
    while ([set next]) {
        XYWeatherData *weatherData = [[XYWeatherData alloc] init];
        weatherData.city           = [set stringForColumn:@"city"];;
//        weatherData.cityDesc = [set stringForColumn:@"desc"];
//        weatherData.time = [set stringForColumn:@"time"];
//        weatherData.AQI = [set stringForColumn:@"AQI"];
//        weatherData.quality = [set stringForColumn:@"quality"];
//        weatherData.PM25 = [set stringForColumn:@"PM25"];
//        weatherData.PM10 = [set stringForColumn:@"PM10"];
        [dataArr addObject:weatherData];
    }
    return dataArr;
}
@end
