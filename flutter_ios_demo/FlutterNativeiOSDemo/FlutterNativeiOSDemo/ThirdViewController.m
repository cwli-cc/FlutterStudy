//
//  ThirdViewController.m
//  FlutterNativeiOSDemo
//
//  Created by lichengwu on 2019/5/9.
//  Copyright © 2019 cwli. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blueColor];
    
    self.navigationItem.title = @"第三page";
    
    NSString *text = [self.parames objectForKey:@"title"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 300, 100)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:25];
    label.text = text;
    [self.view addSubview:label];
}

- (void)dealloc {
    NSLog(@"%@   释放了",NSStringFromClass([self class]));
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
