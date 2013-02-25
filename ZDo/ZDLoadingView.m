//
//  ZDLoadingView.m
//  ZDo
//
//  Created by John_Ma on 13-2-25.
//  Copyright (c) 2013年 john song. All rights reserved.
//

#import "ZDLoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
@implementation ZDLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFrame:CGRectMake(0, 0, 25, 25)];
        self.loadingView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        self.loadingView.font = [self.loadingView.font fontWithSize:25.0f];
        [self.loadingView setTextAlignment:NSTextAlignmentCenter];
        [self.loadingView setText:@"Z"];
        [self.loadingView setTextColor:[UIColor blackColor]];
        [self.loadingView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.loadingView];
        angle = 0.25;
        
        
    }
    return self;
}

-(void)start{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startAnimate) userInfo:nil repeats:YES];
    
}

-(void)startAnimate{
//    self.loadingView.transform = trans;
    trans = CGAffineTransformMakeRotation(angle*M_PI);
    UIWindow *mainWindow = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        self.center = mainWindow.center;
    [mainWindow addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.loadingView.transform = trans;
    }completion:^(BOOL finished) {
        angle+=0.25;
    }];

}

-(void)hide{
    [self removeFromSuperview];
    [timer invalidate];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
