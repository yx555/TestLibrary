//
//  SCKeyboardCustomView.m
//  SmartCity
//
//  Created by xyf on 16/9/21.
//  Copyright © 2016年 sea. All rights reserved.
//

#import "SCKeyboardCustomView.h"
#import "SCColorFromHex.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width


#define btnHeigth  48
@implementation SCKeyboardCustomView
{
    NSArray *showNumArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if(self){
        //create ui
        self.backgroundColor = [UIColor clearColor];
        showNumArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",
                                                       @"4",@"5",@"6",
                                                       @"7",@"8",@"9",
                                                       @"X",@"0",@"",nil];
        [self createKeyboardNumber];
        
    }
    return self;
}

- (void)createKeyboardNumber
{
    
    //4行3列
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 3; j++) {
           
            UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            numBtn.backgroundColor = [UIColor clearColor];
            if(ScreenWidth > 320){
                
                numBtn.frame = CGRectMake((ScreenWidth-114)/3.0*j, btnHeigth*i, (ScreenWidth-114)/3.0, btnHeigth);
                numBtn.layer.borderWidth = 0.25;
                
            }else{
                
                numBtn.frame = CGRectMake(ScreenWidth/4.0*j, btnHeigth*i, ScreenWidth/4.0, btnHeigth);
                numBtn.layer.borderWidth = 0.25;
            }
            numBtn.tag = i*3+j;
            
            numBtn.layer.borderColor = [SCColorFromHex colorWithHexString:@"d9d9d9"].CGColor;
            
            [numBtn setTitle: [showNumArray objectAtIndex:i*3+j] forState:UIControlStateNormal];
            numBtn.titleLabel.font = [UIFont systemFontOfSize:24];
            [numBtn setTitleColor:[SCColorFromHex colorWithHexString:@"333333"] forState:UIControlStateNormal];
            
            if (i*3+j<9 || i*3+j ==10 ) {
               
                [numBtn setBackgroundImage:[self imageWithColor:[SCColorFromHex colorWithHexString:@"fcfcfc"]] forState:UIControlStateNormal];
                [numBtn setBackgroundImage:[self imageWithColor:[SCColorFromHex colorWithHexString:@"ededed"]] forState:UIControlStateHighlighted];
            }else if(i*3+j == 9){
                //X
                [numBtn setBackgroundImage:[self imageWithColor:[SCColorFromHex colorWithHexString:@"ededed"]] forState:UIControlStateNormal];
                [numBtn setBackgroundImage:[self imageWithColor:[SCColorFromHex colorWithHexString:@"dedede"]] forState:UIControlStateHighlighted];
            }else{
                //隐藏键盘图片
                [numBtn setImage:[UIImage imageNamed:@"hiddenBtnImage"] forState:UIControlStateNormal];
                [numBtn setBackgroundImage:[self imageWithColor:[SCColorFromHex colorWithHexString:@"ededed"]] forState:UIControlStateNormal];
                [numBtn setBackgroundImage:[self imageWithColor:[SCColorFromHex colorWithHexString:@"dedede"]] forState:UIControlStateHighlighted];
            }
            
            if(i*3+j == 11){
                //隐藏键盘
                [numBtn addTarget:self action:@selector(tapBtnToHiddenKeyboard) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [numBtn addTarget:self action:@selector(tapNumber:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [self addSubview:numBtn];

        }
    }

    //删除按钮
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (ScreenWidth >320) {
        delBtn.frame = CGRectMake(ScreenWidth-114, 0, 114, btnHeigth*2);
    }else{
        delBtn.frame = CGRectMake(ScreenWidth/4.0*3, 0, ScreenWidth/4.0, btnHeigth*2);
    }
    
    delBtn.tag = 12;
    
    delBtn.layer.borderWidth = 0.25;
    delBtn.layer.borderColor = [SCColorFromHex colorWithHexString:@"d9d9d9"].CGColor;
    
    [delBtn setImage:[UIImage imageNamed:@"delBtnImage"] forState:UIControlStateNormal];
    [delBtn setBackgroundImage:[self imageWithColor:[SCColorFromHex colorWithHexString:@"ededed"]] forState:UIControlStateNormal];
    [delBtn setBackgroundImage:[self imageWithColor:[SCColorFromHex colorWithHexString:@"dedede"]] forState:UIControlStateHighlighted];
    
    [delBtn addTarget:self action:@selector(tapNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
    
    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (ScreenWidth >320) {
        
        sureBtn.frame = CGRectMake(ScreenWidth-114, btnHeigth*2, 114, btnHeigth*2);
    }else{
        sureBtn.frame = CGRectMake(ScreenWidth/4.0*3, btnHeigth*2, ScreenWidth/4.0, btnHeigth*2);
    }
    
    sureBtn.tag = 13;
    
    sureBtn.layer.borderWidth = 0.25;
    sureBtn.layer.borderColor = [SCColorFromHex colorWithHexString:@"d9d9d9"].CGColor;
    
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[SCColorFromHex colorWithHexString:@"cceaff"] forState:UIControlStateNormal];
    
    [sureBtn setBackgroundImage:[self imageWithColor:[SCColorFromHex colorWithHexString:@"0c92f2"]] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[self imageWithColor:[SCColorFromHex colorWithHexString:@"0b89e3"]] forState:UIControlStateHighlighted];
    sureBtn.highlighted = YES;
    sureBtn.userInteractionEnabled = NO;
    [sureBtn addTarget:self action:@selector(makeSureAboutIdnumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
}
//前三行数据的点击事件
- (void)tapNumber:(UIButton *)btn
{
    
    NSString *numStr;
    if (btn.tag < 9) {
        
       numStr = [[NSString alloc]initWithFormat:@"%ld",(long)btn.tag+1];
        
    }else if (btn.tag == 9){
        
        numStr = @"X";
    }else if(btn.tag == 10){
        
        numStr = @"0";
    }else{
        
        numStr = @"";
    }
    
    //代理的响应事件(用于登录界面)
    if (_delegate && [_delegate respondsToSelector:@selector(numberKeyboard:)]) {
        
        [_delegate numberKeyboard:numStr];
    }
    
    if ([@"" isEqualToString:numStr]) {
        
        [self deleteStringWithCursor];
    }
    
    [self appendStringWithCursor:numStr];
    
    
}

//添加字符(根据光标的位置)
-(void)appendStringWithCursor:(NSString *)str
{
    // 1.获取光标所在位置
    UITextRange *selectedRange = [_idNumTextField selectedTextRange];
    NSInteger offset = [_idNumTextField offsetFromPosition:_idNumTextField.beginningOfDocument toPosition:selectedRange.end];
    
    // 2.在光标当前位置后一个插入数字
    NSMutableString *contentString =  [[NSMutableString alloc] initWithString:_idNumTextField.text];
    [contentString insertString:str atIndex:offset];
    
    // 3.添加字符后，移动光标到新的位置
    _idNumTextField.text = contentString;
    UITextPosition *newPos = [_idNumTextField positionFromPosition:_idNumTextField.beginningOfDocument offset:offset + 1];
    _idNumTextField.selectedTextRange = [_idNumTextField textRangeFromPosition:newPos toPosition:newPos];
    
    UIButton *sureBtn = (UIButton *)[self viewWithTag:13];
    if (contentString.length > 0) {
        if (!sureBtn.isUserInteractionEnabled) {
            sureBtn.highlighted = NO;
            sureBtn.userInteractionEnabled = YES;
        }
        
    }else{
        if (sureBtn.isUserInteractionEnabled) {
            sureBtn.highlighted = YES;
            sureBtn.userInteractionEnabled = NO;
        } 
        
    }
    
}

//删除字符(根据光标的位置)
- (void)deleteStringWithCursor
{
    NSMutableString *textStr = [_idNumTextField.text mutableCopy];
    if ([textStr length] != 0) {
        // 1.获取光标所在位置
        UITextRange *selectedRange = [_idNumTextField selectedTextRange];
        NSInteger offset = [_idNumTextField offsetFromPosition:_idNumTextField.beginningOfDocument toPosition:selectedRange.end];
        // 2.光标是否置于编辑框开始
        if (offset != 0) {
            NSRange backward = NSMakeRange(offset - 1, 1);
            [textStr deleteCharactersInRange:backward];
            _idNumTextField.text = textStr;
            // 3.删除字符后，移动光标到新的位置
            UITextPosition *newPos = [_idNumTextField positionFromPosition:_idNumTextField.beginningOfDocument offset:offset - 2];
            _idNumTextField.selectedTextRange = [_idNumTextField textRangeFromPosition:newPos toPosition:newPos];
        }
    }
}


//隐藏键盘的按钮的点击事件
- (void)tapBtnToHiddenKeyboard
{
    [_idNumTextField resignFirstResponder];
}

//确定按钮
- (void)makeSureAboutIdnumber:(UIButton *)btn
{

    [_idNumTextField resignFirstResponder];

}

//将颜色转换为图片，显示点击按钮时的颜色改变
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
