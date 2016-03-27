//
//  XYAnnotationView.m
//  
//
//  Created by xiayao on 16/3/3.
//
//

#import "XYAnnotationView.h"
#import "XYMyAnnotation.h"
@implementation XYAnnotationView
+ (instancetype)annoViewWithMapView:(MKMapView *)mapView
{
    static NSString *id = @"myAnnoView";
    XYAnnotationView *annoView = (XYAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:id];
    if (!annoView) {
        annoView = [[XYAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:id];
    }
    return annoView;
}

- (void)setAnnotation:(XYMyAnnotation *)annotation
{
    [super setAnnotation:annotation];
}
@end
