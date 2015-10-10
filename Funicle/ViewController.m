//
//  ViewController.m
//  Funicle
//
//  Created by Sebastian Dobrincu on 10/10/15.
//  Copyright © 2015 Sebastian Dobrincu. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

const int padding = 20; // Padding between dots
const int radius = padding*3; // Touch radius

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
    [self.view addGestureRecognizer:panRecognizer];
    hue = 0.0;
    ascending=true;
    dotColor = [UIColor whiteColor];
    
    /*                   Initialize dots                      */
    NSMutableArray *mDots = [NSMutableArray array];
    for(int x=0; x<self.view.frame.size.width; x+=padding)
        for(int y=0; y<self.view.frame.size.height; y+=padding){
            CALayer *dot = [CALayer layer];
            dot.frame = CGRectMake(x, y, 2, 2);
            dot.cornerRadius = 1;
            dot.backgroundColor = [UIColor whiteColor].CGColor;
            [self.view.layer addSublayer:dot];
            [mDots addObject:dot];
        }
    dots = [mDots copy];
}

- (void)detectPan:(UIPanGestureRecognizer *)panGestureRecognizer{

    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    
    for (CALayer *eachDot in dots)
        if ([self isDotInRadius:eachDot location:touchLocation]) {
            
            // Handle colors
            if(ascending==false) hue-=0.0007;
            else if(ascending) hue+=0.0007;
            if(hue>=1.0){hue=0.99; ascending=false;}
            else if(hue<=0.0){hue=0.01; ascending=true;}
            
            eachDot.backgroundColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0].CGColor;
            [UIView animateWithDuration:0.2 animations:^{
                eachDot.affineTransform = CGAffineTransformMakeScale(4.5, 4.5);
            }];
        }else{
            if(eachDot.backgroundColor != dotColor.CGColor){
                eachDot.backgroundColor = dotColor.CGColor;
                [UIView animateWithDuration:0.2 animations:^{
                    eachDot.affineTransform = CGAffineTransformMakeScale(1, 1);
                }];
            }
        }
}

-(BOOL)isDotInRadius:(CALayer *)dot location:(CGPoint)point{
    
    CGRect radFrame = dot.frame;
    radFrame.size.width+=radius;
    radFrame.size.height+=radius;
    radFrame.origin.x-=radius/2;
    radFrame.origin.y-=radius/2;
    
    if (CGRectContainsPoint(radFrame, point))
        return YES;
    
    return NO;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.2 animations:^{
       
        self.view.backgroundColor = self.view.backgroundColor==[UIColor blackColor] ? [UIColor whiteColor] : [UIColor blackColor];
        for (CALayer *eachDot in dots)
            if(eachDot.backgroundColor==[UIColor whiteColor].CGColor)
                eachDot.backgroundColor = [UIColor blackColor].CGColor;
            else if(eachDot.backgroundColor==[UIColor blackColor].CGColor)
                eachDot.backgroundColor = [UIColor whiteColor].CGColor;
    }];
    dotColor = dotColor==[UIColor whiteColor] ? [UIColor blackColor] : [UIColor whiteColor];
}

@end
