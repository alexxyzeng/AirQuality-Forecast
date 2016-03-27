//
//  XYNavigationController.m
//  
//
//  Created by xiayao on 16/3/6.
//
//

#import "XYNavigationController.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

@interface XYNavigationController ()

@end

@implementation XYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

+ (void)initialize
{
    // 获取当前类下面的UIBarButtonItem
    UIBarButtonItem *item    = [UIBarButtonItem appearanceWhenContainedIn:self, nil];

    UIFont *textFont         = [UIFont fontWithName:@"HelveticaNeue" size:18];
    UIColor *navColor        = RGB(0, 122, 255);
    NSDictionary *attributes = @{NSFontAttributeName:textFont,
                                 NSForegroundColorAttributeName:navColor};
    [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
