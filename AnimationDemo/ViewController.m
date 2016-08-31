//
//  ViewController.m
//  AnimationDemo
//
//  Created by xietao on 16/7/5.
//  Copyright © 2016年 xietao3. All rights reserved.
//

#import "ViewController.h"
#import "AnimationView.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet AnimationView *animationView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAnimationView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initAnimationView {
    // 模仿一次改动2
}

@end
