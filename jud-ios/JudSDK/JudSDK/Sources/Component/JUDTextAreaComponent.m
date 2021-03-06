/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDTextAreaComponent.h"
#import "JUDUtility.h"
#import "JUDConvert.h"
#import "JUDComponent_internal.h"
#import "JUDView.h"
#import "JUDAssert.h"
#import "JUDSDKInstance.h"
#import "JUDComponent+PseudoClassManagement.h"

typedef UITextView JUDTextAreaView;

@interface JUDTextAreaComponent()
@property (nonatomic, strong) JUDTextAreaView *textView;
@property (nonatomic, strong) UILabel *placeholder;

//attribute
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) NSString *placeholderString;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic) BOOL autofocus;
@property (nonatomic) BOOL disabled;
@property (nonatomic, strong)NSString *textValue;
@property(nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic) NSUInteger rows;
//style

@property (nonatomic) JUDPixelType fontSize;
@property (nonatomic) JUDTextStyle fontStyle;
@property (nonatomic) CGFloat fontWeight;
@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) NSTextAlignment textAlign;

//event
@property (nonatomic) BOOL inputEvent;
@property (nonatomic) BOOL focusEvent;
@property (nonatomic) BOOL blurEvent;
@property (nonatomic) BOOL changeEvent;
@property (nonatomic) BOOL returnEvent;
@property (nonatomic) BOOL clickEvent;
@property (nonatomic, strong) NSString *changeEventString;
@property (nonatomic, assign) CGSize keyboardSize;

@end

@implementation JUDTextAreaComponent {
    UIEdgeInsets _border;
    UIEdgeInsets _padding;
    NSTextStorage* _textStorage;
}

JUD_EXPORT_METHOD(@selector(focus))
JUD_EXPORT_METHOD(@selector(blur))
JUD_EXPORT_METHOD(@selector(setSelectionRange:selectionEnd:))
JUD_EXPORT_METHOD(@selector(getSelectionRange:))

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance];
    if (self) {
        _inputEvent = NO;
        _focusEvent = NO;
        _blurEvent = NO;
        _changeEvent = NO;
        _clickEvent = NO;
        _returnEvent = NO;
        _padding = UIEdgeInsetsZero;
        _border = UIEdgeInsetsZero;
        
        if (attributes[@"autofocus"]) {
            _autofocus = [attributes[@"autofocus"] boolValue];
        }
        if (attributes[@"rows"]) {
            _rows = [attributes[@"rows"] integerValue];
        } else {
            _rows = 2;
        }
        if (attributes[@"disabled"]) {
            _disabled = [attributes[@"disabled"] boolValue];
        }
        if (attributes[@"placeholder"]) {
            NSString *placeHolder = [JUDConvert NSString:attributes[@"placeholder"]];
            if (placeHolder) {
                _placeholderString = placeHolder;
            }
        }
        if (attributes[@"returnKeyType"]) {
            _returnKeyType = [JUDConvert UIReturnKeyType:attributes[@"returnKeyType"]];
        }
        if (!_placeholderString) {
            _placeholderString = @"";
        }
        if (styles[@"placeholderColor"]) {
            _placeholderColor = [JUDConvert UIColor:styles[@"placeholderColor"]];
        }else {
            _placeholderColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1.0];
        }
        if (attributes[@"value"]) {
            NSString * value = [JUDConvert NSString:attributes[@"value"]];
            if (value) {
                _textValue = value;
                if([value length] > 0) {
                    _placeHolderLabel.text = @"";
                }
            }
        }
        if (styles[@"color"]) {
            _color = [JUDConvert UIColor:styles[@"color"]];
        }
        if (styles[@"fontSize"]) {
            _fontSize = [JUDConvert JUDPixelType:styles[@"fontSize"] scaleFactor:self.judInstance.pixelScaleFactor];
        }
        if (styles[@"fontWeight"]) {
            _fontWeight = [JUDConvert JUDTextWeight:styles[@"fontWeight"]];
        }
        if (styles[@"fontStyle"]) {
            _fontStyle = [JUDConvert JUDTextStyle:styles[@"fontStyle"]];
        }
        if (styles[@"fontFamily"]) {
            _fontFamily = styles[@"fontFamily"];
        }
        if (styles[@"textAlign"]) {
            _textAlign = [JUDConvert NSTextAlignment:styles[@"textAlign"]] ;
        }
    }
    
    return self;
}

- (void)viewWillLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillUnload
{
    _textView = nil;
}
- (UIView *)loadView
{
    return [[JUDTextAreaView alloc] init];
}
- (void)viewDidLoad
{
    _textView = (JUDTextAreaView*)self.view;
    [self setEnabled];
    [self setAutofocus];
    if (_placeholderString) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.numberOfLines = 0;
        [_textView addSubview:_placeHolderLabel];
    }
    [self setPlaceholderAttributedString];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeKeyboard)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    toolbar.items = [NSArray arrayWithObjects:space, barButton, nil];
    
    _textView.inputAccessoryView = toolbar;
    
    if (_textValue && [_textValue length]>0) {
        _textView.text = _textValue;
        _placeHolderLabel.text = @"";
    }else {
        _textView.text = @"";
    }
    _textView.delegate = self;
    
    if (_color) {
        [_textView setTextColor:_color];
    }
    [_textView setTextAlignment:_textAlign];
    [self setTextFont];
    _padding = UIEdgeInsetsZero;
    _border = UIEdgeInsetsZero;
    [self updatePattern];
    [_textView setReturnKeyType:_returnKeyType];
    
    [_textView setNeedsDisplay];
    [_textView setClipsToBounds:YES];
    [self handlePseudoClass];
}

- (void)focus
{
    if (self.textView) {
        [self.textView becomeFirstResponder];
    }
}

- (void)blur
{
    if (self.textView) {
        [self.textView resignFirstResponder];
    }
}

-(void)setSelectionRange:(NSInteger)selectionStart selectionEnd:(NSInteger)selectionEnd
{
    if(selectionStart>self.textView.text.length || selectionEnd>self.textView.text.length) {
        return;
    }
    [self.textView becomeFirstResponder];
    UITextPosition *startPos =  [self.textView positionFromPosition:self.textView.beginningOfDocument offset:selectionStart];
    UITextPosition *endPos = [self.textView positionFromPosition:self.textView.beginningOfDocument offset:selectionEnd];
    UITextRange *textRange = [self.textView textRangeFromPosition:startPos
                                                        toPosition:endPos];
    self.textView.selectedTextRange = textRange;
}

-(void)getSelectionRange:(JUDCallback)callback
{
    NSInteger selectionStart = [self.textView offsetFromPosition:self.textView.beginningOfDocument toPosition:self.textView.selectedTextRange.start];
    NSInteger selectionEnd = [self.textView offsetFromPosition:self.textView.beginningOfDocument toPosition:self.textView.selectedTextRange.end];
    NSDictionary *res = @{@"selectionStart":@(selectionStart),@"selectionEnd":@(selectionEnd)};
    callback(res);
}

#pragma mark - add-remove Event
- (void)addEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"input"]) {
        _inputEvent = YES;
    }
    if ([eventName isEqualToString:@"focus"]) {
        _focusEvent = YES;
    }
    if ([eventName isEqualToString:@"blur"]) {
        _blurEvent = YES;
    }
    if ([eventName isEqualToString:@"change"]) {
        _changeEvent = YES;
    }
    if ([eventName isEqualToString:@"click"]) {
        _clickEvent = YES;
    }
    if ([eventName isEqualToString:@"return"]) {
        _returnEvent = YES;
    }
}

-(void)removeEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"input"]) {
        _inputEvent = NO;
    }
    if ([eventName isEqualToString:@"focus"]) {
        _focusEvent = NO;
    }
    if ([eventName isEqualToString:@"blur"]) {
        _blurEvent = NO;
    }
    if ([eventName isEqualToString:@"change"]) {
        _changeEvent = NO;
    }
    if ([eventName isEqualToString:@"click"]) {
        _clickEvent = NO;
    }
    if ([eventName isEqualToString:@"return"]) {
        _returnEvent = NO;
    }
}

#pragma mark - upate attributes
- (void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"autofocus"]) {
        _autofocus = [attributes[@"autofocus"] boolValue];
        [self setAutofocus];
    }
    if (attributes[@"disabled"]) {
        _disabled = [attributes[@"disabled"] boolValue];
        [self setEnabled];
    }
    if (attributes[@"placeholder"]) {
        _placeholderString = attributes[@"placeholder"];
        [self setPlaceholderAttributedString];
    }
    if (attributes[@"value"]) {
        NSString * value = [JUDConvert NSString:attributes[@"value"]];
        if (value) {
            _textValue = value;
            _textView.text = _textValue;
            if([value length] > 0) {
                _placeHolderLabel.text = @"";
            }
        }
    }
    if (attributes[@"returnKeyType"]) {
        _returnKeyType = [JUDConvert UIReturnKeyType:attributes[@"returnKeyType"]];
        [_textView setReturnKeyType:_returnKeyType];
    }
}

#pragma mark - upate styles
- (void)updateStyles:(NSDictionary *)styles
{
    if (styles[@"color"]) {
        _color = [JUDConvert UIColor:styles[@"color"]];
        [_textView setTextColor:_color];
    }
    if (styles[@"fontSize"]) {
        _fontSize = [JUDConvert JUDPixelType:styles[@"fontSize"] scaleFactor:self.judInstance.pixelScaleFactor];
    }
    if (styles[@"fontWeight"]) {
        _fontWeight = [JUDConvert JUDTextWeight:styles[@"fontWeight"]];
    }
    if (styles[@"fontStyle"]) {
        _fontStyle = [JUDConvert JUDTextStyle:styles[@"fontStyle"]];
    }
    if (styles[@"fontFamily"]) {
        _fontFamily = styles[@"fontFamily"];
    }
    
    [self setTextFont];
    
    if (styles[@"textAlign"]) {
        _textAlign = [JUDConvert NSTextAlignment:styles[@"textAlign"]] ;
        [_textView setTextAlignment:_textAlign];
    }
    if (styles[@"placeholderColor"]) {
        _placeholderColor = [JUDConvert UIColor:styles[@"placeholderColor"]];
    }else {
        _placeholderColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1.0];
    }
    [self setPlaceholderAttributedString];
    [self updatePattern];
}

#pragma mark update touch styles
- (void)handlePseudoClass
{
    NSMutableDictionary *styles = [NSMutableDictionary new];
    NSMutableDictionary *recordStyles = [NSMutableDictionary new];
    if(_disabled){
        recordStyles = [self getPseudoClassStylesByKeys:@[@"disabled"]];
        [styles addEntriesFromDictionary:recordStyles];
    }else {
        recordStyles = [NSMutableDictionary new];
        recordStyles = [self getPseudoClassStylesByKeys:@[@"enabled"]];
        [styles addEntriesFromDictionary:recordStyles];
    }
    if ([_textView isFirstResponder]){
        recordStyles = [NSMutableDictionary new];
        recordStyles = [self getPseudoClassStylesByKeys:@[@"focus"]];
        [styles addEntriesFromDictionary:recordStyles];
    }
    NSString *disabledStr = @"enabled";
    if (_disabled){
        disabledStr = @"disabled";
    }
    if ([_textView isFirstResponder]) {
        NSString *focusStr = @"focus";
        recordStyles = [NSMutableDictionary new];
        recordStyles = [self getPseudoClassStylesByKeys:@[focusStr,disabledStr]];
        [styles addEntriesFromDictionary:recordStyles];
    }
    [self updatePseudoClassStyles:styles];
}

#pragma mark measure frame
- (CGSize (^)(CGSize))measureBlock
{
    __weak typeof(self) weakSelf = self;
    return ^CGSize (CGSize constrainedSize) {
        
        CGSize computedSize = [[[NSString alloc] init]sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]}];
        computedSize.height = computedSize.height * _rows;
        //TODO:more elegant way to use max and min constrained size
        if (!isnan(weakSelf.cssNode->style.minDimensions[CSS_WIDTH])) {
            computedSize.width = MAX(computedSize.width, weakSelf.cssNode->style.minDimensions[CSS_WIDTH]);
        }
        
        if (!isnan(weakSelf.cssNode->style.maxDimensions[CSS_WIDTH])) {
            computedSize.width = MIN(computedSize.width, weakSelf.cssNode->style.maxDimensions[CSS_WIDTH]);
        }
        
        if (!isnan(weakSelf.cssNode->style.minDimensions[CSS_HEIGHT])) {
            computedSize.height = MAX(computedSize.height, weakSelf.cssNode->style.minDimensions[CSS_HEIGHT]);
        }
        
        if (!isnan(weakSelf.cssNode->style.maxDimensions[CSS_HEIGHT])) {
            computedSize.height = MIN(computedSize.height, weakSelf.cssNode->style.maxDimensions[CSS_HEIGHT]);
        }
        
        return (CGSize) {
            JUDCeilPixelValue(computedSize.width),
            JUDCeilPixelValue(computedSize.height)
        };
    };
}

#pragma mark textview Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _changeEventString = [textView text];
    if (_focusEvent) {
        [self fireEvent:@"focus" params:nil];
    }
    if (_clickEvent) {
        [self fireEvent:@"click" params:nil];
    }
    [textView becomeFirstResponder];
    [self handlePseudoClass];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text && [textView.text length] > 0) {
        _placeHolderLabel.text = @"";
    }else{
        [self setPlaceholderAttributedString];
    }
    if (_inputEvent) {
        [self fireEvent:@"input" params:@{@"value":[textView text]} domChanges:@{@"attrs":@{@"value":[textView text]}}];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (![textView.text length]) {
        [self setPlaceholderAttributedString];
    }
    if (_changeEvent) {
        if (![[textView text] isEqualToString:_changeEventString]) {
            [self fireEvent:@"change" params:@{@"value":[textView text]} domChanges:@{@"attrs":@{@"value":[textView text]}}];
        }
    }
    if (_blurEvent) {
        [self fireEvent:@"blur" params:nil];
    }
    if(self.pseudoClassStyles && [self.pseudoClassStyles count]>0){
        [self recoveryPseudoStyles:self.styles];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (_returnEvent) {
            NSString *typeStr = [JUDUtility returnKeyType:_returnKeyType];
            [self fireEvent:@"return" params:@{@"value":[textView text],@"returnKeyType":typeStr} domChanges:@{@"attrs":@{@"value":[textView text]}}];
        }
    }
    return YES;
}

#pragma mark - private method
- (void)setPlaceholderAttributedString
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_placeholderString];
    UIFont *font = [JUDUtility fontWithSize:_fontSize textWeight:_fontWeight textStyle:_fontStyle fontFamily:_fontFamily scaleFactor:self.judInstance.pixelScaleFactor];
    if (_placeholderColor) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:_placeholderColor range:NSMakeRange(0, _placeholderString.length)];
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _placeholderString.length)];
    }
    _placeHolderLabel.backgroundColor = [UIColor clearColor];
    CGRect expectedLabelSize = [attributedString boundingRectWithSize:(CGSize){self.view.frame.size.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    _placeHolderLabel.clipsToBounds = NO;
    CGRect newFrame = _placeHolderLabel.frame;
    newFrame.size.height = ceil(expectedLabelSize.size.height);
    newFrame.size.width = _textView.frame.size.width;
    newFrame.origin.x = 4; // the cursor origin.x
    newFrame.origin.y = 7; // the cursor origin.y
    _placeHolderLabel.frame = newFrame;
    _placeHolderLabel.attributedText = attributedString;
}

- (void)updatePattern
{
    UIEdgeInsets padding = UIEdgeInsetsMake(self.cssNode->style.padding[CSS_TOP], self.cssNode->style.padding[CSS_LEFT], self.cssNode->style.padding[CSS_BOTTOM], self.cssNode->style.padding[CSS_RIGHT]);
    if (!UIEdgeInsetsEqualToEdgeInsets(padding, _padding)) {
        [self setPadding:padding];
    }
    
    UIEdgeInsets border = UIEdgeInsetsMake(self.cssNode->style.border[CSS_TOP], self.cssNode->style.border[CSS_LEFT], self.cssNode->style.border[CSS_BOTTOM], self.cssNode->style.border[CSS_RIGHT]);
    if (!UIEdgeInsetsEqualToEdgeInsets(border, _border)) {
        [self setBorder:border];
    }
}

- (void)setPadding:(UIEdgeInsets)padding
{
    _padding = padding;
    [self _updateTextContentInset];
}

- (void)setBorder:(UIEdgeInsets)border
{
    _border = border;
    [self _updateTextContentInset];
}

- (void)_updateTextContentInset
{
    [_textView setTextContainerInset:UIEdgeInsetsMake(_padding.top + _border.top,
                                                      _padding.left + _border.left,
                                                      _padding.bottom + _border.bottom,
                                                      _border.right + _border.right)];
}

- (void)setAutofocus
{
    if (_autofocus) {
        [_textView becomeFirstResponder];
    } else {
        [_textView resignFirstResponder];
    }
}

- (void)setTextFont
{
    UIFont *font = [JUDUtility fontWithSize:_fontSize textWeight:_fontWeight textStyle:_fontStyle fontFamily:_fontFamily scaleFactor:self.judInstance.pixelScaleFactor];
    [_textView setFont:font];
}

- (void)setEnabled
{
    _textView.editable = !(_disabled);
    _textView.selectable = !(_disabled);
}

#pragma mark keyboard
- (void)keyboardWasShown:(NSNotification*)notification
{
    if(![_textView isFirstResponder]) {
        return;
    }
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    if(begin.size.height <= 44) {
        return;
    }
    _keyboardSize = end.size;
    UIView * rootView = self.judInstance.rootView;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect keyboardRect = (CGRect){
        .origin.x = 0,
        .origin.y = CGRectGetMaxY(screenRect) - _keyboardSize.height - 54,
        .size = _keyboardSize
    };
    CGRect textAreaFrame = [_textView.superview convertRect:_textView.frame toView:rootView];
    if (keyboardRect.origin.y - textAreaFrame.size.height <= textAreaFrame.origin.y) {
        [self setViewMovedUp:YES];
        self.judInstance.isRootViewFrozen = YES;
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    if (![_textView isFirstResponder]) {
        return;
    }
    UIView * rootView = self.judInstance.rootView;
    if (!CGRectEqualToRect(self.judInstance.frame, rootView.frame)) {
        [self setViewMovedUp:NO];
        self.judInstance.isRootViewFrozen = NO;
    }
}

- (void)closeKeyboard
{
    [_textView resignFirstResponder];
}

#pragma mark method
- (void)setViewMovedUp:(BOOL)movedUp
{
    UIView *rootView = self.judInstance.rootView;
    CGRect rect = self.judInstance.frame;
    CGRect rootViewFrame = rootView.frame;
    CGRect textAreaFrame = [_textView.superview convertRect:_textView.frame toView:rootView];
    if (movedUp) {
        CGFloat offset = textAreaFrame.origin.y-(rootViewFrame.size.height-_keyboardSize.height-textAreaFrame.size.height);
        if (offset > 0) {
            rect = (CGRect){
                .origin.x = 0.f,
                .origin.y = -offset,
                .size = rootViewFrame.size
            };
        }
    }
    self.judInstance.rootView.frame = rect;
}

#pragma mark -reset color
- (void)resetStyles:(NSArray *)styles
{
    if ([styles containsObject:@"color"]) {
        _color = [UIColor blackColor];
        [_textView setTextColor:[UIColor blackColor]];
    }
    if ([styles containsObject:@"fontSize"]) {
        _fontSize = JUD_TEXT_FONT_SIZE;
        [self setTextFont];
    }
}

@end
