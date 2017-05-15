//
//  UIBubbleImageView.h
//  UIBubbleView_Example
//
//  Created by Yongyang Nie on 10/11/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBubbleImageView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) id delegate;

@end

@protocol UIBubbleImageViewDelegate <NSObject>

@end
