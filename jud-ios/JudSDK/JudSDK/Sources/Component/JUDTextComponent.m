/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDTextComponent.h"
#import "JUDSDKInstance_private.h"
#import "JUDComponent_internal.h"
#import "JUDLayer.h"
#import "JUDUtility.h"
#import "JUDConvert.h"
#import "JUDRuleManager.h"
#import "JUDDefine.h"
#import <pthread/pthread.h>

@interface JUDText : UIView

@property (nonatomic, strong) NSTextStorage *textStorage;

@end

@implementation JUDText

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.isAccessibilityElement = YES;
        self.accessibilityTraits |= UIAccessibilityTraitStaticText;
        
        self.opaque = NO;
        self.contentMode = UIViewContentModeRedraw;
        self.textStorage = [NSTextStorage new];
    }
    return self;
}

+ (Class)layerClass
{
    return [JUDLayer class];
}

- (UIImage *)drawTextWithBounds:(CGRect)bounds padding:(UIEdgeInsets)padding
{
    if (bounds.size.width <=0 || bounds.size.height <= 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, self.layer.opaque, JUDScreenScale());
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([self.jud_component _needsDrawBorder]) {
        [self.jud_component _drawBorderWithContext:context size:bounds.size];
    } else {
        JUDPerformBlockOnMainThread(^{
            [self.jud_component _resetNativeBorderRadius];
        });
    }
    NSLayoutManager *layoutManager = _textStorage.layoutManagers.firstObject;
    NSTextContainer *textContainer = layoutManager.textContainers.firstObject;
    
    CGRect textFrame = UIEdgeInsetsInsetRect(bounds, padding);
    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
    
    [layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:textFrame.origin];
    [layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:textFrame.origin];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setTextStorage:(NSTextStorage *)textStorage
{
    if (_textStorage != textStorage) {
        _textStorage = textStorage;
        [self.jud_component setNeedsDisplay];
    }
}

- (NSString *)description
{
    NSString *superDescription = super.description;
    NSRange semicolonRange = [superDescription rangeOfString:@";"];
    NSString *replacement = [NSString stringWithFormat:@"; text: %@; frame:%f,%f,%f,%f", _textStorage.string, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height];
    return [superDescription stringByReplacingCharactersInRange:semicolonRange withString:replacement];
}

- (NSString *)accessibilityValue
{
    return _textStorage.string;
}

@end

@implementation JUDTextComponent
{
    UIEdgeInsets _border;
    UIEdgeInsets _padding;
    NSTextStorage *_textStorage;
    CGFloat _textStorageWidth;
    
    NSString *_text;
    UIColor *_color;
    NSString *_fontFamily;
    CGFloat _fontSize;
    CGFloat _fontWeight;
    JUDTextStyle _fontStyle;
    NSUInteger _lines;
    NSTextAlignment _textAlign;
    JUDTextDecoration _textDecoration;
    NSString *_textOverflow;
    CGFloat _lineHeight;
    
   
    pthread_mutex_t _textStorageMutex;
    pthread_mutexattr_t _textStorageMutexAttr;
}

static BOOL _isUsingTextStorageLock = NO;
+ (void)useTextStorageLock:(BOOL)isUsingTextStorageLock
{
    _isUsingTextStorageLock = isUsingTextStorageLock;
}

- (instancetype)initWithRef:(NSString *)ref
                       type:(NSString *)type
                     styles:(NSDictionary *)styles
                 attributes:(NSDictionary *)attributes
                     events:(NSArray *)events
               judInstance:(JUDSDKInstance *)judInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance];
    if (self) {
        if (_isUsingTextStorageLock) {
            pthread_mutexattr_init(&_textStorageMutexAttr);
            pthread_mutexattr_settype(&_textStorageMutexAttr, PTHREAD_MUTEX_RECURSIVE);
            pthread_mutex_init(&_textStorageMutex, &_textStorageMutexAttr);
        }
        
        [self fillCSSStyles:styles];
        [self fillAttributes:attributes];
    }
    
    return self;
}

- (void)dealloc
{
    if (_isUsingTextStorageLock) {
        pthread_mutex_destroy(&_textStorageMutex);
        pthread_mutexattr_destroy(&_textStorageMutexAttr);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#define JUD_STYLE_FILL_TEXT(key, prop, type, needLayout)\
do {\
    id value = styles[@#key];\
    if (value) {\
        _##prop = [JUDConvert type:value];\
        [self setNeedsRepaint];\
        if (needLayout) {\
            [self setNeedsLayout];\
        }\
    }\
} while(0);

#define JUD_STYLE_FILL_TEXT_PIXEL(key, prop, needLayout)\
do {\
    id value = styles[@#key];\
    if (value) {\
        _##prop = [JUDConvert JUDPixelType:value scaleFactor:self.judInstance.pixelScaleFactor];\
        [self setNeedsRepaint];\
    if (needLayout) {\
        [self setNeedsLayout];\
    }\
}\
} while(0);

- (void)fillCSSStyles:(NSDictionary *)styles
{
    JUD_STYLE_FILL_TEXT(color, color, UIColor, NO)
    JUD_STYLE_FILL_TEXT(fontFamily, fontFamily, NSString, YES)
    JUD_STYLE_FILL_TEXT_PIXEL(fontSize, fontSize, YES)
    JUD_STYLE_FILL_TEXT(fontWeight, fontWeight, JUDTextWeight, YES)
    JUD_STYLE_FILL_TEXT(fontStyle, fontStyle, JUDTextStyle, YES)
    JUD_STYLE_FILL_TEXT(lines, lines, NSUInteger, YES)
    JUD_STYLE_FILL_TEXT(textAlign, textAlign, NSTextAlignment, NO)
    JUD_STYLE_FILL_TEXT(textDecoration, textDecoration, JUDTextDecoration, YES)
    JUD_STYLE_FILL_TEXT(textOverflow, textOverflow, NSString, NO)
    JUD_STYLE_FILL_TEXT_PIXEL(lineHeight, lineHeight, YES)
    
    UIEdgeInsets padding = {
        JUDFloorPixelValue(self.cssNode->style.padding[CSS_TOP] + self.cssNode->style.border[CSS_TOP]),
        JUDFloorPixelValue(self.cssNode->style.padding[CSS_LEFT] + self.cssNode->style.border[CSS_LEFT]),
        JUDFloorPixelValue(self.cssNode->style.padding[CSS_BOTTOM] + self.cssNode->style.border[CSS_BOTTOM]),
        JUDFloorPixelValue(self.cssNode->style.padding[CSS_RIGHT] + self.cssNode->style.border[CSS_RIGHT])
    };
    
    if (!UIEdgeInsetsEqualToEdgeInsets(padding, _padding)) {
        _padding = padding;
        [self setNeedsRepaint];
    }
}

- (void)fillAttributes:(NSDictionary *)attributes
{
    id text = attributes[@"value"];
    if (text) {
        _text = [JUDConvert NSString:text];
        [self setNeedsRepaint];
        [self setNeedsLayout];
    }
}

- (void)setNeedsRepaint
{
    if (_isUsingTextStorageLock) {
        pthread_mutex_lock(&_textStorageMutex);
    }
    _textStorage = nil;
    if (_isUsingTextStorageLock) {
        pthread_mutex_unlock(&_textStorageMutex);
    }
}

#pragma mark - Subclass

- (void)setNeedsLayout
{
    [super setNeedsLayout];
}

- (void)viewDidLoad
{
    if (_isUsingTextStorageLock) {
        pthread_mutex_lock(&_textStorageMutex);
    }
    ((JUDText *)self.view).textStorage = _textStorage;
    if (_isUsingTextStorageLock) {
        pthread_mutex_unlock(&_textStorageMutex);
    }
    [self setNeedsDisplay];
}

- (UIView *)loadView
{
    return [[JUDText alloc] init];
}

- (JUDDisplayBlock)displayBlock
{
    JUDText *textView = ((JUDText *)self.view);
    return ^UIImage *(CGRect bounds, BOOL(^isCancelled)(void)) {
        if (isCancelled()) {
            return nil;
        }
        if (_isUsingTextStorageLock) {
            pthread_mutex_lock(&_textStorageMutex);
        }
        
        UIImage *image = [textView drawTextWithBounds:bounds padding:_padding];
        
        if (_isUsingTextStorageLock) {
            pthread_mutex_unlock(&_textStorageMutex);
        }
        
        return image;
    };
}

- (CGSize (^)(CGSize))measureBlock
{
    __weak typeof(self) weakSelf = self;
    return ^CGSize (CGSize constrainedSize) {
        NSTextStorage *textStorage = [weakSelf textStorageWithWidth:constrainedSize.width];
        
        NSLayoutManager *layoutManager = textStorage.layoutManagers.firstObject;
        NSTextContainer *textContainer = layoutManager.textContainers.firstObject;
        CGSize computedSize = [layoutManager usedRectForTextContainer:textContainer].size;
        
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
        if ([JUDUtility isBlankString:textStorage.string]) {
            //  if the text value is empty or nil, then set the height is 0.
            computedSize.height = 0;
        }
        
        return (CGSize) {
            JUDCeilPixelValue(computedSize.width),
            JUDCeilPixelValue(computedSize.height)
        };
    };
}

#pragma mark Text Building
- (NSString *)text
{
    return _text;
}

- (void)repaintText:(NSNotification *)notification
{
    if (![_fontFamily isEqualToString:notification.userInfo[@"fontFamily"]]) {
        return;
    }
    [self setNeedsRepaint];
    JUDPerformBlockOnComponentThread(^{
        [self.judInstance.componentManager startComponentTasks];
        JUDPerformBlockOnMainThread(^{
            [self setNeedsLayout];
            [self setNeedsDisplay];
        });
    });
}

- (NSAttributedString *)buildAttributeString
{
    NSString *string = [self text] ?: @"";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // set textColor
    if(_color) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:_color range:NSMakeRange(0, string.length)];
    }
    
    if (_fontFamily) {
        NSString * keyPath = [NSString stringWithFormat:@"%@.tempSrc", _fontFamily];
        NSString * fontSrc = [[[JUDRuleManager sharedInstance] getRule:@"fontFace"] valueForKeyPath:keyPath];
        keyPath = [NSString stringWithFormat:@"%@.localSrc", _fontFamily];
        NSString * fontLocalSrc = [[[JUDRuleManager sharedInstance] getRule:@"fontFace"] valueForKeyPath:keyPath];
        //custom localSrc is cached
        if (!fontLocalSrc && fontSrc) {
            // if use custom font, when the custom font download finish, refresh text.
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repaintText:) name:JUD_ICONFONT_DOWNLOAD_NOTIFICATION object:nil];
        }
    }
    
    // set font
    UIFont *font = [JUDUtility fontWithSize:_fontSize textWeight:_fontWeight textStyle:_fontStyle fontFamily:_fontFamily scaleFactor:self.judInstance.pixelScaleFactor];
    if (font) {
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    }
    
    if(_textDecoration == JUDTextDecorationUnderline){
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
    } else if(_textDecoration == JUDTextDecorationLineThrough){
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];

    if (_textAlign) {
        paragraphStyle.alignment = _textAlign;
    }
    
    if (_lineHeight) {
        paragraphStyle.maximumLineHeight = _lineHeight;
        paragraphStyle.minimumLineHeight = _lineHeight;
    }
    
    if (_lineHeight || _textAlign) {
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:(NSRange){0, attributedString.length}];
    }
    if ([self adjustLineHeight]) {
        if (_lineHeight > font.lineHeight) {
            [attributedString addAttribute:NSBaselineOffsetAttributeName
                                     value:@((_lineHeight - font.lineHeight)/ 2)
                                     range:(NSRange){0, attributedString.length}];
        }
    }

    return attributedString;
}

- (BOOL)adjustLineHeight
{
    return YES;
}

- (NSTextStorage *)textStorageWithWidth:(CGFloat)width
{
    if (_textStorage && width == _textStorageWidth) {
        return _textStorage;
    }
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    // build AttributeString
    NSAttributedString *attributedString = [self buildAttributeString];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
    [textStorage addLayoutManager:layoutManager];
    
    NSTextContainer *textContainer = [NSTextContainer new];
    textContainer.lineFragmentPadding = 0.0;
    
    textContainer.lineBreakMode = NSLineBreakByClipping;
    if (_textOverflow && [_textOverflow length] > 0) {
        if ([_textOverflow isEqualToString:@"ellipsis"])
            textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    textContainer.maximumNumberOfLines = _lines > 0 ? _lines : 0;
    textContainer.size = (CGSize){isnan(width) ? CGFLOAT_MAX : width, CGFLOAT_MAX};

    [layoutManager addTextContainer:textContainer];
    [layoutManager ensureLayoutForTextContainer:textContainer];
    
    _textStorageWidth = width;
    
    if (_isUsingTextStorageLock) {
        pthread_mutex_lock(&_textStorageMutex);
    }
    _textStorage = textStorage;
    if (_isUsingTextStorageLock) {
        pthread_mutex_unlock(&_textStorageMutex);
    }
    
    return textStorage;
}

- (void)syncTextStorageForView
{
    CGFloat width = self.calculatedFrame.size.width - (_padding.left + _padding.right);
    NSTextStorage *textStorage = [self textStorageWithWidth:width];
    
    [self.judInstance.componentManager  _addUITask:^{
        if ([self isViewLoaded]) {
            if (_isUsingTextStorageLock) {
                pthread_mutex_lock(&_textStorageMutex);
            }
            ((JUDText *)self.view).textStorage = textStorage;
            if (_isUsingTextStorageLock) {
                pthread_mutex_unlock(&_textStorageMutex);
            }
            [self readyToRender]; // notify super component
            [self setNeedsDisplay];
        }
    }];
}

- (void)_frameDidCalculated:(BOOL)isChanged
{
    [super _frameDidCalculated:isChanged];
    [self syncTextStorageForView];
}

- (void)_updateStylesOnComponentThread:(NSDictionary *)styles resetStyles:(NSMutableArray *)resetStyles isUpdateStyles:(BOOL)isUpdateStyles
{
    [super _updateStylesOnComponentThread:styles resetStyles:(NSMutableArray *)resetStyles isUpdateStyles:isUpdateStyles];
    
    [self fillCSSStyles:styles];
    
    [self syncTextStorageForView];
}

- (void)_updateAttributesOnComponentThread:(NSDictionary *)attributes
{
    [super _updateAttributesOnComponentThread:attributes];
    
    [self fillAttributes:attributes];
    
    [self syncTextStorageForView];
}

#ifdef UITEST
- (NSString *)description
{
    return super.description;
}
#endif
 
- (void)_resetCSSNodeStyles:(NSArray *)styles
{
    [super _resetCSSNodeStyles:styles];
    if ([styles containsObject:@"color"]) {
        _color = [UIColor blackColor];
        [self setNeedsRepaint];
    }
    if ([styles containsObject:@"fontSize"]) {
        _fontSize = JUD_TEXT_FONT_SIZE;
        [self setNeedsRepaint];
        [self setNeedsLayout];
    }
}

@end

