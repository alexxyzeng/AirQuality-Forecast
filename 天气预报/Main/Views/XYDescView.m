//
//  XYDescView.m
//  
//
//  Created by xiayao on 16/3/6.
//
//

#import "XYDescView.h"
#define  KWindowWidth     [UIApplication sharedApplication].keyWindow.frame.size.width
#define  textFont         [UIFont fontWithName:@"HelveticaNeue" size:16]
#define  textColor        [UIColor whiteColor]
@implementation XYDescView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor                = [UIColor clearColor];
        self.contentInset                   = UIEdgeInsetsMake(10, 10, 0, 10);
        self.scrollEnabled                  = YES;
        self.textAlignment                  = NSTextAlignmentLeft;
        self.alwaysBounceVertical           = YES;
        self.directionalLockEnabled         = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.editable                       = NO;
        self.contentSize                    = CGSizeMake(KWindowWidth, self.contentSize.height);
        
        //设置行距、字体和颜色
        NSMutableParagraphStyle *paraStyle =[[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing              = 5;
        NSDictionary *attributes           = @{NSFontAttributeName:textFont,
                                     NSParagraphStyleAttributeName:paraStyle,
                                     NSForegroundColorAttributeName:textColor};
        self.attributedText                = [[NSAttributedString alloc] initWithString:text
                                                                             attributes:attributes];
    }
    return self;
}

- (NSAttributedString *)textViewWithText:(NSString *)text
{
    NSMutableParagraphStyle *paraStyle =[[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing              = 5;
    NSDictionary *attributes           = @{NSFontAttributeName:textFont,
                                           NSParagraphStyleAttributeName:paraStyle,
                                           NSForegroundColorAttributeName:textColor};
    self.attributedText                = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:attributes];
    return self.attributedText;
}
@end
