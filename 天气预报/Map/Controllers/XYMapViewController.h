//
//  XYMapViewController.h
//  
//
//  Created by xiayao on 16/3/2.
//
//

#import <UIKit/UIKit.h>
@protocol XYMapViewControllerDelegate <NSObject>

- (void)updateWeatherDataWithCityName:(NSString *)city;

@end

@interface XYMapViewController : UIViewController

//@property (nonatomic, strong) id <XYMapViewControllerDelegate> delegate;

@end
