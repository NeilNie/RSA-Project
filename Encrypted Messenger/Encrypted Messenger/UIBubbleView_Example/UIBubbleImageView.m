//
//  UIBubbleImageView.m
//  UIBubbleView_Example
//
//  Created by Yongyang Nie on 10/11/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "UIBubbleImageView.h"

@implementation UIBubbleImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithImage:(UIImage *)image{
    
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.imageView];
        self.frame = CGRectMake(0, 1, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(screenBounds.size.width,                                              //width
                                      screenBounds.size.width / image.size.width * image.size.height,       //height
                                      screenBounds.size.width / 2 - self.imageView.frame.size.width / 2,    //center.x
                                      screenBounds.size.height / 2 + self.imageView.frame.size.height / 2); //center.y
}

-(void)showImageView{
    
    self.backgroundColor = [UIColor blackColor];
    
    UIButton *back = [[UIButton alloc] init];
    back.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 36, [UIScreen mainScreen].bounds.size.height - 28, 28, 20);
    back.titleLabel.textColor = [UIColor whiteColor];
    back.titleLabel.text = @"Back";
    back.backgroundColor = [UIColor clearColor];
}

-(void)longPressGesture:(UILongPressGestureRecognizer *)longPress{
    
}

@end
