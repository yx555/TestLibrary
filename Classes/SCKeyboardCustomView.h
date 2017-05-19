//
//  SCKeyboardCustomView.h
//  SmartCity
//
//  Created by xyf on 16/9/21.
//  Copyright © 2016年 sea. All rights reserved.
//

#import <UIKit/UIKit.h>
//键盘协议
@protocol keyBoardDelegate <NSObject>

- (void)numberKeyboard:(NSString *)numStr;

@end
@interface SCKeyboardCustomView : UIView

@property (nonatomic,assign) id <keyBoardDelegate> delegate;

@property (nonatomic, strong) UITextField *idNumTextField;
@end
