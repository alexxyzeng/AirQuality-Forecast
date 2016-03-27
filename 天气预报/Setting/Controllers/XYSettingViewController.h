//
//  XYSettingViewController.h
//  
//
//  Created by xiayao on 16/3/4.
//
//

#import <UIKit/UIKit.h>

@protocol XYSettingViewControllerDelegate<NSObject>
/**
 *  停止显示用户位置
 */
- (void)stopShowUserLocation;
/**
 *  开始显示用户位置
 */
- (void)startShowUserLocation;
/**
 *  显示地图标记
 */
- (void)showAnnotaion;
/**
 *  移除所有的地图标记
 */
- (void)removeAnnotaion;
@end

@interface XYSettingViewController : UIViewController
/**
 *  设置代理
 */
@property (nonatomic, weak) id<XYSettingViewControllerDelegate>delegate;
@end
