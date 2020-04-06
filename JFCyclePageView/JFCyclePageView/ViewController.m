//
//  ViewController.m
//  JFCyclePageView
//
//  Created by apple on 2020/4/5.
//  Copyright © 2020 贾国伟. All rights reserved.
//

#import "ViewController.h"
#import "JFCyclePageScrollView.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView * CyclePageView;
@property (nonatomic, strong) UIPageControl * pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    JFCyclePageScrollView * cyclepageView = [[JFCyclePageScrollView alloc]init];

    //添加ScrollView
    [self.view addSubview:cyclepageView];
    //添加PageControl
    [self.view addSubview:cyclepageView.pageControl];

}


@end
