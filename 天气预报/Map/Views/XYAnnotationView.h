//
//  XYAnnotationView.h
//  
//
//  Created by xiayao on 16/3/3.
//
//

#import <MapKit/MapKit.h>

@interface XYAnnotationView : MKAnnotationView
/**
 *  返回自定义的大头针视图
 *
 *  @param mapView 所在地图视图
 *
 *  @return 自定义大头针
 */
+ (instancetype)annoViewWithMapView:(MKMapView *)mapView;
@end
