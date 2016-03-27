//
//  XYDescView.h
//  
//
//  Created by xiayao on 16/3/6.
//
//

#import <UIKit/UIKit.h>

@interface XYDescView : UITextView
/**
 *  返回属性字符串的文本框
 *
 *  @param frame 文本框的大小
 *  @param text  文本
 *
 *  @return 返回带属性的文本框
 */
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;

/**
 *  返回带属性的文本
 *
 *  @param text 文本
 */
- (NSAttributedString *)textViewWithText:(NSString *)text;
@end
