//
//  AnimationView.m
//  AnimationDemo
//
//  Created by xietao on 16/7/6.
//  Copyright © 2016年 xietao3. All rights reserved.
//

#import "AnimationView.h"

@interface AnimationView ()
@property (nonatomic, strong) UIView *touchPointView;
@property (nonatomic, strong) CAShapeLayer *bezierLayer;
@property (nonatomic, assign) CGPoint beganTouchPoint;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initial];
    [self setFrame:frame];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initial];
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)initial {
    self.backgroundColor = [UIColor lightGrayColor];
    _touchPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _touchPointView.backgroundColor = [UIColor whiteColor];
    _touchPointView.alpha = 0.5;
    _touchPointView.hidden = YES;
    _touchPointView.layer.cornerRadius = _touchPointView.frame.size.height/2;
    _touchPointView.layer.masksToBounds = YES;
    [self addSubview:_touchPointView];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink.paused = YES;
    _isAnimating = NO;
}



#pragma mark - TouchMethod
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];
        _beganTouchPoint = point;
        _touchPointView.hidden = NO;
        // 开始逐帧渲染动画
        [self startDisplayLink];
        [_touchPointView setCenter:point];
    }

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];
        [_touchPointView setCenter:point];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    _touchPointView.hidden = YES;
    [self resetBezierLineAnimation];


}

- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    _touchPointView.hidden = YES;
    [self resetBezierLineAnimation];
}

#pragma mark - BezierPath
- (void)drawBezierLineWithPoint:(CGPoint)point {
    
    if (_bezierLayer) {
        _bezierLayer.path = [self getBezierPathWithPoint:point].CGPath;
        return;
    }
    _bezierLayer = [CAShapeLayer layer];
    _bezierLayer.strokeColor = [UIColor redColor].CGColor;
    _bezierLayer.fillColor = [UIColor redColor].CGColor;
    _bezierLayer.lineWidth = 2;
    _bezierLayer.lineJoin = kCALineJoinRound;
    _bezierLayer.lineCap = kCALineCapRound;
    _bezierLayer.path = [self getBezierPathWithPoint:point].CGPath;
    
    //add it to our view
    [self.layer addSublayer:_bezierLayer];
}

- (UIBezierPath *)getBezierPathWithPoint:(CGPoint)point {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat virY = _beganTouchPoint.y + (point.y-_beganTouchPoint.y)/2.0;
    [path moveToPoint:CGPointMake(0, _beganTouchPoint.y)];
    [path addCurveToPoint:CGPointMake(self.frame.size.width, _beganTouchPoint.y) controlPoint1:CGPointMake(point.x, virY) controlPoint2:CGPointMake(point.x, virY)];
    [path closePath];
    
    return path;
}

- (void)resetBezierLineAnimation {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [_touchPointView setCenter:_beganTouchPoint];
    } completion:^(BOOL finished) {
        // 停止逐帧渲染动画
        [self stopDisplayLink];
        self.userInteractionEnabled = YES;
    }];
}


#pragma mark - CADisplayLink
- (void)startDisplayLink {
    self.displayLink.paused = NO;
}

- (void)stopDisplayLink {
    self.displayLink.paused = YES;
}

- (void)displayLinkTick {
    if (_touchPointView.layer.presentationLayer) {
        CALayer *layer = (CALayer *)[_touchPointView.layer presentationLayer];
        [self drawBezierLineWithPoint:layer.position];
    } else {
        [self drawBezierLineWithPoint:_touchPointView.center];
    }
}




@end
