//
//  XYMyAnnotation.h
//  
//
//  Created by xiayao on 16/3/3.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface XYMyAnnotation : NSObject <MKAnnotation>
/**
 *  当前坐标
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/**
 *  标记标题
 */
@property (nonatomic, copy  ) NSString               *title;
/**
 *  标记副标题
 */
@property (nonatomic, copy  ) NSString               *subTitle;
@end
