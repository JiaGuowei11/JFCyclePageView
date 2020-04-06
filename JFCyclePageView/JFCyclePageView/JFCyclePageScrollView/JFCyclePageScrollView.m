//
//  JFCyclePageScrollView.m
//  JFCyclePageView
//
//  Created by apple on 2020/4/5.
//  Copyright © 2020 贾国伟. All rights reserved.
//

#import "JFCyclePageScrollView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define IMAGEVIEW_X 10
#define SCROLLVIEW_Y 200
#define SCROLLVIEW_HEIGHT 200
#define IMAGE_CORNERRADIUS 200/16
#define TIMEINTERVAL 2
#define NIMATEWITHDURATION 0.2

@interface JFCyclePageScrollView ()<UIScrollViewDelegate>

//图片数组
@property (nonatomic, copy) NSArray *ImgArray;
//定时器
@property (nonatomic, strong) NSTimer *cycleTimer;

@end

@implementation JFCyclePageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.delegate = self;
        
        [self InitUI];
        [self LoadData];
    }
    
    return self;
}

- (void)InitUI
{
    self.ImgArray = @[@"firstImage",@"image",@"image",@"lastImage"];

    self.frame = CGRectMake(0, SCROLLVIEW_Y, SCREEN_WIDTH, SCROLLVIEW_HEIGHT);
    self.contentSize = CGSizeMake(SCREEN_WIDTH * (self.ImgArray.count+2), SCROLLVIEW_HEIGHT);
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);

    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(IMAGEVIEW_X, SCROLLVIEW_Y+(SCROLLVIEW_HEIGHT-50), SCREEN_WIDTH-IMAGEVIEW_X*2, 50)];
    
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.numberOfPages = self.ImgArray.count;
    
}

- (void)LoadData
{
    
    UIImageView * firstImage = [[UIImageView alloc]initWithFrame:CGRectMake(IMAGEVIEW_X, 0, SCREEN_WIDTH-IMAGEVIEW_X*2, SCROLLVIEW_HEIGHT)];
    
    [firstImage setImage:[UIImage imageNamed:@"lastImage"]];
    [self ImageView:firstImage];
    [self addSubview:firstImage];

    for (int n = 0; n < self.ImgArray.count; n++)
    {
        UIImageView * cycleView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * (n+1)+IMAGEVIEW_X, 0, SCREEN_WIDTH-IMAGEVIEW_X*2, SCROLLVIEW_HEIGHT)];
        
        [cycleView setImage:[UIImage imageNamed:self.ImgArray[n]]];
        [self ImageView:cycleView];
        [self addSubview:cycleView];
    }
    
    UIImageView * lastImage = [[UIImageView alloc]initWithFrame:CGRectMake(IMAGEVIEW_X+SCREEN_WIDTH * (self.ImgArray.count+1), 0, SCREEN_WIDTH-IMAGEVIEW_X*2, SCROLLVIEW_HEIGHT)];
    
    [lastImage setImage:[UIImage imageNamed:@"firstImage"]];
    [self ImageView:lastImage];
    [self addSubview:lastImage];

    self.cycleTimer = [NSTimer timerWithTimeInterval:TIMEINTERVAL target:self selector:@selector(cycleTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.cycleTimer forMode:NSDefaultRunLoopMode];
 
}

- (void)ImageView:(UIImageView *)imageView
{
    imageView.layer.cornerRadius = IMAGE_CORNERRADIUS;
    imageView.layer.masksToBounds = YES;
    imageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0f green:arc4random_uniform(255)/255.0f blue:arc4random_uniform(255)/255.0f alpha:1];
    imageView.userInteractionEnabled = YES;
}

//定时器
- (void)cycleTimer:(NSTimer *)timer
{
    CGFloat ViewX;
    ViewX = self.contentOffset.x;

    if (ViewX == [UIScreen mainScreen].bounds.size.width * self.ImgArray.count) {

        [UIView animateWithDuration:NIMATEWITHDURATION animations:^{
            
            self.contentOffset = CGPointMake(ViewX+SCREEN_WIDTH, 0);
            
        }completion:^(BOOL finished) {
            
            self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            self.pageControl.currentPage = (self.contentOffset.x/SCREEN_WIDTH-1);
            
        }];
    }
    else
    {
        [UIView animateWithDuration:NIMATEWITHDURATION animations:^{
            
            self.contentOffset = CGPointMake(ViewX+SCREEN_WIDTH, 0);
            
        }completion:^(BOOL finished) {
            
            self.pageControl.currentPage = (self.contentOffset.x/SCREEN_WIDTH-1);
            
        }];
    }

}

//Scrollview Delegate
//滚动视图即将开始拖动时回调
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.cycleTimer invalidate];
    self.cycleTimer = nil;
}

//视图已经结束滑动时回调
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.cycleTimer = [NSTimer timerWithTimeInterval:TIMEINTERVAL target:self selector:@selector(cycleTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.cycleTimer forMode:NSDefaultRunLoopMode];
}

//视图已经结束减速时回调
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.x == 0) {
        
        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * self.ImgArray.count, 0);
        
    }
    else if (scrollView.contentOffset.x == SCREEN_WIDTH * (self.ImgArray.count+1))
    {
        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        
    }
    
    self.pageControl.currentPage = self.contentOffset.x/SCREEN_WIDTH-1;
}


@end
