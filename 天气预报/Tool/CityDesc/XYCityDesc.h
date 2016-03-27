//
//  XYCityDesc.h
//  
//
//  Created by xiayao on 16/3/4.
//
//

#import <Foundation/Foundation.h>

@interface XYCityDesc : NSObject
/**
 *  获取城市描述
 *
 *  @param city     城市名
 *  @param cityDesc 城市描述回调
 *  @param failure  失败的回调
 */
+ (void)getCityDescWithCity:(NSString *)city
                    success:(void (^)(NSString *cityDesc))success
                    failure:(void (^)(NSError *))failure;
@end
