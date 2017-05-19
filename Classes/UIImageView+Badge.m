//
//  UIImageView+Badge.m
//  SmartCity
//
//  Created by hoperun on 16/11/1.
//  Copyright © 2016年 sea. All rights reserved.
//

#import <objc/runtime.h>
#import "UIImageView+Badge.h"
//判断当前对象是否有效
#define isValid(object)     (object && ![object isEqual:[NSNull null]])

NSString const *UIImageView_badgeKey = @"UIImageView_badgeKey";

NSString const *UIImageView_badgeValueKey = @"UIImageView_badgeValueKey";
NSString const *UIImageView_badgeBGColorKey = @"UIImageView_badgeBGColorKey";
NSString const *UIImageView_badgeTextColorKey = @"UIImageView_badgeTextColorKey";
NSString const *UIImageView_badgeFontKey = @"UIImageView_badgeFontKey";
NSString const *UIImageView_badgePaddingKey = @"UIImageView_badgePaddingKey";
NSString const *UIImageView_badgeMinSizeKey = @"UIImageView_badgeMinSizeKey";
NSString const *UIImageView_badgeOriginXKey = @"UIImageView_badgeOriginXKey";
NSString const *UIImageView_badgeOriginYKey = @"UIImageView_badgeOriginYKey";
NSString const *UIImageView_shouldHideBadgeAtZeroKey = @"UIImageView_shouldHideBadgeAtZeroKey";
NSString const *UIImageView_shouldAnimateBadgeKey = @"UIImageView_shouldAnimateBadgeKey";
NSString const *UIImageView_isPlumKey = @"UIImageView_isPlumKey";
@implementation UIImageView (Badge)

- (void)badgeInit
{
    // Default design initialization
    self.badgeBGColor   = [UIColor redColor];
    self.badgeTextColor = [UIColor whiteColor];
    self.badgeFont      = [UIFont systemFontOfSize:12.0];
    self.badgePadding   = 6;
    self.badgeMinSize   = 8;
    self.badgeOriginX   = self.frame.size.width - self.badge.frame.size.width/2;
    self.badgeOriginY   = -4;
    self.shouldHideBadgeAtZero = YES;
    self.shouldAnimateBadge = YES;
    // Avoids badge to be clipped when animating its scale
    self.clipsToBounds = NO;
}

- (void)refreshBadge
{
    // Change new attributes
    self.badge.textColor        = self.badgeTextColor;
    self.badge.backgroundColor  = self.badgeBGColor;
    self.badge.font             = self.badgeFont;
}

- (CGSize) badgeExpectedSize
{
    // When the value changes the badge could need to get bigger
    // Calculate expected size to fit new value
    // Use an intermediate label to get expected size thanks to sizeToFit
    // We don't call sizeToFit on the true label to avoid bad display
    UILabel *frameLabel = [self duplicateLabel:self.badge];
    [frameLabel sizeToFit];
    
    CGSize expectedLabelSize = frameLabel.frame.size;
    return expectedLabelSize;
}

- (void)updateBadgeFrame
{
    
    CGSize expectedLabelSize = [self badgeExpectedSize];
    
    // Make sure that for small value, the badge will be big enough
    CGFloat minHeight = expectedLabelSize.height;
    
    // Using a const we make sure the badge respect the minimum size
    minHeight = (minHeight < self.badgeMinSize) ? self.badgeMinSize : expectedLabelSize.height;
    CGFloat minWidth = expectedLabelSize.width;
    CGFloat padding = self.badgePadding;
    
    // Using const we make sure the badge doesn't get too smal
    minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width;
    self.badge.frame = CGRectMake(self.badgeOriginX, self.badgeOriginY, minWidth + padding, minHeight + padding);
    self.badge.layer.cornerRadius = (minHeight + padding) / 2;
    self.badge.layer.masksToBounds = YES;
}

- (void)updateBadgeValueAnimated:(BOOL)animated
{
    // Bounce animation on badge if value changed and if animation authorized
    if (animated && self.shouldAnimateBadge && ![self.badge.text isEqualToString:self.badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.badge.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    
    // Set the new value
    if (![self.badgeValue isEqualToString:@"0"]) {
        self.badge.text = self.badgeValue;
    }
    
    // Animate the size modification if needed
    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self updateBadgeFrame];
    }];
}

- (UILabel *)duplicateLabel:(UILabel *)labelToCopy
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    
    return duplicateLabel;
}
- (void)removeBadge
{
    [self.badge removeFromSuperview];
    self.badge = nil;
    // Animate badge removal
//    [UIView animateWithDuration:0.2 animations:^{
//        self.badge.transform = CGAffineTransformMakeScale(0, 0);
//    } completion:^(BOOL finished) {
//        [self.badge removeFromSuperview];
//        self.badge = nil;
//    }];
}

#pragma mark - getters/setters
-(UILabel*) badge {
    return objc_getAssociatedObject(self, &UIImageView_badgeKey);
}
-(void)setBadge:(UILabel *)badgeLabel
{
    objc_setAssociatedObject(self, &UIImageView_badgeKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// Badge value to be display
-(NSString *)badgeValue {
    return objc_getAssociatedObject(self, &UIImageView_badgeKey);
}
-(void) setBadgeValue:(NSString *)badgeValue
{
    objc_setAssociatedObject(self, &UIImageView_badgeValueKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // When changing the badge value check if we need to remove the badge
    if (!badgeValue || [badgeValue isEqualToString:@""] || self.shouldHideBadgeAtZero) {
        [self removeBadge];
    }
    else if (!self.badge) {
        
        if ([@"0" isEqualToString:badgeValue]) {
            
            self.badge                      = [[UILabel alloc]init];
            self.badge.layer.cornerRadius   = 4;//圆形
            self.badge.backgroundColor      = [UIColor redColor];
            if (isValid(self.isplum)&&[@"1" isEqualToString:self.isplum]) {
                
                self.badge.frame            = CGRectMake(self.frame.size.width-8,6,8,8);
            }else{
                self.badge.frame            = CGRectMake(self.frame.size.width-4,-2,8,8);
            }
            self.badge.layer.masksToBounds  = YES;
            [self addSubview:self.badge];
        }else{
            // Create a new badge because not existing
            self.badge                      = [[UILabel alloc] initWithFrame:CGRectMake(self.badgeOriginX, self.badgeOriginY, 20, 10)];
            self.badge.textColor            = self.badgeTextColor;
            self.badge.backgroundColor      = self.badgeBGColor;
            self.badge.font                 = self.badgeFont;
            self.badge.textAlignment        = NSTextAlignmentCenter;
            [self badgeInit];
            [self addSubview:self.badge];
            [self updateBadgeValueAnimated:NO];
        }
    } else {
        
        if (![@"0" isEqualToString:badgeValue]) {
            
            [self updateBadgeValueAnimated:YES];
        }
        
    }
}

// Badge background color
-(UIColor *)badgeBGColor {
    return objc_getAssociatedObject(self, &UIImageView_badgeBGColorKey);
}
-(void)setBadgeBGColor:(UIColor *)badgeBGColor
{
    objc_setAssociatedObject(self, &UIImageView_badgeBGColorKey, badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

// Badge text color
-(UIColor *)badgeTextColor {
    return objc_getAssociatedObject(self, &UIImageView_badgeTextColorKey);
}
-(void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    objc_setAssociatedObject(self, &UIImageView_badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

// Badge font
-(UIFont *)badgeFont {
    return objc_getAssociatedObject(self, &UIImageView_badgeFontKey);
}
-(void)setBadgeFont:(UIFont *)badgeFont
{
    objc_setAssociatedObject(self, &UIImageView_badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

// Padding value for the badge
-(CGFloat) badgePadding {
    NSNumber *number = objc_getAssociatedObject(self, &UIImageView_badgePaddingKey);
    return number.floatValue;
}
-(void) setBadgePadding:(CGFloat)badgePadding
{
    NSNumber *number = [NSNumber numberWithDouble:badgePadding];
    objc_setAssociatedObject(self, &UIImageView_badgePaddingKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

// Minimum size badge to small
-(CGFloat) badgeMinSize {
    NSNumber *number = objc_getAssociatedObject(self, &UIImageView_badgeMinSizeKey);
    return number.floatValue;
}
-(void) setBadgeMinSize:(CGFloat)badgeMinSize
{
    NSNumber *number = [NSNumber numberWithDouble:badgeMinSize];
    objc_setAssociatedObject(self, &UIImageView_badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

// Values for offseting the badge over the BarButtonItem you picked
-(CGFloat) badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &UIImageView_badgeOriginXKey);
    return number.floatValue;
}
-(void) setBadgeOriginX:(CGFloat)badgeOriginX
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &UIImageView_badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

-(CGFloat) badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &UIImageView_badgeOriginYKey);
    return number.floatValue;
}
-(void) setBadgeOriginY:(CGFloat)badgeOriginY
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
    objc_setAssociatedObject(self, &UIImageView_badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

-(BOOL) shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &UIImageView_shouldHideBadgeAtZeroKey);
    return number.boolValue;
}
- (void)setShouldHideBadgeAtZero:(BOOL)shouldHideBadgeAtZero
{
    NSNumber *number = [NSNumber numberWithBool:shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &UIImageView_shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Badge has a bounce animation when value changes
-(BOOL) shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &UIImageView_shouldAnimateBadgeKey);
    return number.boolValue;
}
- (void)setShouldAnimateBadge:(BOOL)shouldAnimateBadge
{
    NSNumber *number = [NSNumber numberWithBool:shouldAnimateBadge];
    objc_setAssociatedObject(self, &UIImageView_shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)isplum{
    return objc_getAssociatedObject(self, &UIImageView_isPlumKey);
}
- (void)setIsplum:(NSString *)isplum{
    objc_setAssociatedObject(self, &UIImageView_isPlumKey, isplum, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
