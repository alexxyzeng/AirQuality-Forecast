//
//  XYCityDesc.m
//  
//
//  Created by xiayao on 16/3/4.
//
//

#import "XYCityDesc.h"
#import "XYWeatherData.h"
#import "XYHttpTool.h"
#import "GDataXMLNode.h"

@implementation XYCityDesc
+ (void)getCityDescWithCity:(NSString *)city success:(void (^)(NSString *))success failure:(void (^)(NSError *error))failure
{
    //设置参数
    NSDictionary *param = [NSDictionary dictionaryWithObject:city
                                                      forKey:@"theCityName"];
    NSString *url = @"http://www.webxml.com.cn/WebServices/WeatherWebService.asmx/getWeatherbyCityName";
    //发送请求
    [XYHttpTool GET:url parameters:param success:^(id responseObject) {
        //解析xml数据
        //创建文档
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject options:1 error:nil];
        //获取根元素
        GDataXMLElement *rootElement = doc.rootElement;
        //将根元素中string子元素加入数组
        NSArray *dataArray = [rootElement elementsForName:@"string"];
        //获取子元素的字符串值
        NSString *cityDesc = [[dataArray lastObject] stringValue];
        if (success) {
            success(cityDesc);
        }
    } failure:^(NSError *error) {
        NSLog(@"获取城市描述失败");
    }];
}
@end
