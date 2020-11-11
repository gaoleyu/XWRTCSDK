//
//  AreaTextField.m
//  TestNewPro
//
//  Created by zhangtao on 2020/2/6.
//  Copyright © 2020 zt.td. All rights reserved.
//

#import "AreaTextField.h"

static NSString *const markSecureText = @"●"; // ● *
static CGFloat  originXY = 13; // 默认x，y坐标间距3.0

@interface AreaTextField () <UITextFieldDelegate>

@property (nonatomic, assign) NSInteger textCount; // 最多输入位数
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *textArray;

@property (nonatomic, copy) void (^editFinish)(NSString *text);
@property(nonatomic, copy)   void(^deleteTxt)(void);
@end

@implementation AreaTextField


//- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count textEntry:(BOOL)isSecureText editDone:(void (^)(NSString *text))done deleteTxt:(nonnull void (^)(void))delTxt
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        self.limitStr = @"0123456789";
//        [self boxInput:count textEntry:isSecureText editDone:done deleteTxt:delTxt];
//    }
//
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.limitStr = @"0123456789";
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.limitStr = @"0123456789";
    }
    return self;
}

#pragma mark - 视图

/// 方块输入框（位数，明文或密文显示）
- (void)boxInput:(NSInteger)count allowThird:(BOOL)thirdInput textEntry:(BOOL)isSecureText editDone:(void (^)(NSString *text))done deleteTxt:(nonnull void (^)(void))delTxt
{
    if (0 < count)
    {
        self.delegate = self;
        self.secureTextEntry = !thirdInput;
        self.showSecure = isSecureText;
        _textCount = count;
        self.editFinish = [done copy];
        self.deleteTxt = [delTxt copy];
        self.tintColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor clearColor];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textAlignment = NSTextAlignmentLeft;
        
        CGFloat heightSelft = CGRectGetHeight(self.bounds);
        
        CGFloat originXItem = _originX? :originXY;
        CGFloat originYItem = 0;//originXY;
        CGFloat sizeItem = (heightSelft - originYItem * 2);
        
        CGFloat sizeWidth = 0.0f;
        if (_areaWidth) {
            sizeWidth = _areaWidth;
        }else{
            sizeWidth = sizeItem;
        }
        
//        CGFloat widthTotal = sizeWidth * _textCount + originXItem * (_textCount - 1);
//        if (widthTotal > CGRectGetWidth(self.bounds))
//        {
//            // 大于自身宽度时
//            sizeWidth = (CGRectGetWidth(self.bounds) - (_textCount * (sizeWidth + 1))) / _textCount;
//            originYItem = (heightSelft - sizeItem) / 2;
//        }
//        else if (widthTotal < CGRectGetWidth(self.bounds))
//        {
//            // 小于自身宽度时
//            originXItem = (CGRectGetWidth(self.bounds) - sizeItem * _textCount) / (_textCount - 1);
//        }
        
        
        self.labelArray = [[NSMutableArray alloc] initWithCapacity:_textCount];
        for (int i = 0; i < _textCount; i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i * (sizeWidth + originXItem)), originYItem, sizeWidth, sizeItem)];
            label.backgroundColor = [UIColor colorWithRed:241 green:243 blue:246 alpha:1];
            label.font = [UIFont boldSystemFontOfSize:20];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            label.layer.masksToBounds = YES;
            label.layer.borderWidth = 0.5;
            [self addSubview:label];
            
            [self.labelArray addObject:label];
        }
        
        self.textBackgroundColor = [UIColor whiteColor];
        self.textCornerRadius = 3.0;
        self.textBorderColor = [UIColor blackColor];
        
        self.textArray = [[NSMutableArray alloc] initWithCapacity:_textCount];
    }
}

- (void)resetLabelBackgroundColor
{
    for (NSInteger i = 0; i < _textCount; i++)
    {
        UILabel *label = self.labelArray[i];
        label.backgroundColor = _textBackgroundColor;
    }
}

- (void)resetLabelCornerRadius
{
    for (NSInteger i = 0; i < _textCount; i++)
    {
        UILabel *label = self.labelArray[i];
        label.layer.cornerRadius = _textCornerRadius;
    }
}

- (void)resetLabelBorderColor
{
    for (NSInteger i = 0; i < _textCount; i++)
    {
        UILabel *label = self.labelArray[i];
        label.layer.borderColor = _textBorderColor.CGColor;
    }
}

- (void)resetLabelTextColor
{
    for (NSInteger i = 0; i < _textCount; i++)
    {
        UILabel *label = self.labelArray[i];
        label.textColor = _color;
    }
}

/*
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}
*/
 
#pragma mark - 信息处理

// 只能输入指定位数字符
- (BOOL)limitTextCharacters:(NSString *)limitCharacter number:(NSInteger)limitNumber string:(NSString *)string
{
    NSInteger length = self.textArray.count;
    // 字数限制
    if (length > limitNumber)
    {
        return NO;
    }
    else
    {
        if (limitCharacter && 0 < limitCharacter.length)
        {
            if ([limitCharacter containsString:string])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    
    return YES;
}

// 显示输入字符
- (void)showLabelText
{
    for (NSInteger i = 0; i < _textCount; i++)
    {
        UILabel *label = self.labelArray[i];
        NSString *text = (i < self.textArray.count ? self.textArray[i] : @"");
        label.text = ((self.showSecure && 0 != text.length) ? markSecureText : text);
    }
    
    if (self.editFinish && self.textArray.count == _textCount)
    {
        NSMutableString *textStr = [[NSMutableString alloc] initWithCapacity:_textCount];
        for (NSString *string in self.textArray)
        {
            [textStr appendString:string];
        }
        self.editFinish(textStr);
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    // 回车时退出，同时判断输入不能为空
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        
        return NO;
    }

    if ([textField isFirstResponder])
    {
        BOOL isResult = [self limitTextCharacters:self.limitStr number:_textCount string:string];

        if ([string isEqualToString:@""])
        {
            // 删除键时，删除信息
            [self.textArray removeLastObject];
            if (self.deleteTxt) {
                self.deleteTxt();
            }
        }
        else
        {
            if ((self.textArray.count < _textCount) && isResult)
            {
                [self.textArray addObject:string];
            }
        }
        [self performSelector:@selector(showLabelText) withObject:nil afterDelay:0.1];
        
        return isResult;
    }
    
    return YES;
}

#pragma mark - setter

- (void)setTextBackgroundColor:(UIColor *)textBackgroundColor
{
    _textBackgroundColor = textBackgroundColor;
    [self resetLabelBackgroundColor];
}

- (void)setTextCornerRadius:(CGFloat)textCornerRadius
{
    _textCornerRadius = textCornerRadius;
    [self resetLabelCornerRadius];
}

- (void)setTextBorderColor:(UIColor *)textBorderColor
{
    _textBorderColor = textBorderColor;
    [self resetLabelBorderColor];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self resetLabelTextColor];
    
}

/// 清空输入
- (void)clearInput
{
    [self.labelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = (UILabel *)obj;
        label.text = nil;
    }];
    [self.textArray removeAllObjects];
}


@end
