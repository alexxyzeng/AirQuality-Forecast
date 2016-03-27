//
//  XYGetWeatherData.m
//  
//
//  Created by xiayao on 16/3/2.
//
//

#import "XYGetWeatherData.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "XYWeatherData.h"
#import "MJExtension.h"
#import "NSString+Substring.h"
#import "XYCityDesc.h"

@implementation XYGetWeatherData

+ (void)getWeatherDataWithCityName:(NSString *)city success:(void (^)(XYWeatherData *))success failure:(void (^)(NSError *))failure
{
    //获取城市名称
    NSString *cityName  = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    //    NSLog(@"%@",cityName);
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:@"JH467a1bc34f33091621747f26e14fecce"];
    NSString *path      = @"http://web.juhe.cn:8080/environment/air/pm";
    NSString *api_id    = @"33";
    NSString *method    = @"GET";
    NSDictionary *param = @{@"city":cityName};
    JHAPISDK *juheapi   = [JHAPISDK shareJHAPISDK];
    
    [juheapi executeWorkWithAPI:path
                          APIID:api_id
                     Parameters:param
                         Method:method
                        Success:^(id responseObject) {
        //解析数据
        NSArray *dataArr    = [responseObject objectForKey:@"result"];
        //字典转模型
        XYWeatherData *data = [XYWeatherData objectWithKeyValues:dataArr[0]];
        data.PM25           = [dataArr[0] objectForKey:@"PM2.5"];
        //设置请求数据时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        data.time = [dateFormatter stringFromDate:[NSDate date]];
        NSLog(@"保存时间为：%@", data.time);

        if (success) {
            success(data);
        }
    } Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
