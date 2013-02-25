//
//  ZDLoadingView.h
//  ZDo
//
//  Created by John_Ma on 13-2-25.
//  Copyright (c) 2013年 john song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDLoadingView : UIView{
    CGAffineTransform trans;
    CGFloat angle;
    NSTimer *timer;
}
@property (nonatomic, strong)UILabel *loadingView;
-(void)startAnimate;
-(void)start;
-(void)hide;
@end
