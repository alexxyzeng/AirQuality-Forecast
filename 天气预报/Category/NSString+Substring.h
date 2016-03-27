//
//  NSString+Substring.h
//  
//
//  Created by xiayao on 16/2/12.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Substring)
/**
 *  是否包含字符串
 *
 *  @param substring 包含的字符串（判读）
 *
 *  @return 返回是否包含
 */
- (BOOL)contains:(NSString *)substring;
@end
