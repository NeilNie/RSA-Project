//
//  NSBubbleData.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "NSBubbleData.h"

@implementation NSBubbleData

#pragma mark - Text bubble

const UIEdgeInsets textInsetsMine = {7, 13, 13, 23};
const UIEdgeInsets textInsetsSomeone = {7, 13, 13, 12};

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type{
    return [[NSBubbleData alloc] initWithText:text date:date type:type];
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type{
    
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    CGSize maximumLabelSize = CGSizeMake(220, 9999);
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    NSDictionary *attr = @{NSFontAttributeName: font};
    CGRect labelBounds = [(text ? text : @"") boundingRectWithSize:maximumLabelSize
                                                           options:options
                                                        attributes:attr
                                                           context:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelBounds.size.width, labelBounds.size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    if (type == BubbleTypeMine) {
        label.textColor = [UIColor whiteColor];
    }
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:label date:date type:type insets:insets];
}

#pragma mark - Image bubble

const UIEdgeInsets imageInsetsMine = {2, 0, 8, 13};
const UIEdgeInsets imageInsetsSomeone = {3, 7, 6, 4}; //top, left, bottom, right

+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type{
    return [[NSBubbleData alloc] initWithImage:image date:date type:type];
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type{
    
    CGSize size = image.size;
    if (size.width > 220){
        
        size.height /= (size.width / 220);
        size.width = 220;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;

    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type insets:insets];       
}

#pragma mark - Custom view bubble

+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets{
    
    return [[NSBubbleData alloc] initWithView:view date:date type:type insets:insets];
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets{
    
    self = [super init];
    if (self){
        _view = view;
        _date = date;
        _type = type;
        _insets = insets;
    }
    return self;
}

@end
