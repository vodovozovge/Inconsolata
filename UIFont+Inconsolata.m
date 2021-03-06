//
// UIFont+Inconsolata.m
//
//

#import <CoreText/CoreText.h>
#import "UIFont+Inconsolata.h"

@interface KOSFontLoader : NSObject

+ (void)loadFontWithName:(NSString *)fontName;

@end

@implementation KOSFontLoader

+(void) loadFontWithName:(NSString *)fontName {
    NSURL *bundleURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Inconsolata" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    NSURL *fontURL = [bundle URLForResource:fontName withExtension:@"ttf"];
    NSData *fontData = [NSData dataWithContentsOfURL:fontURL];

    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);

    if (font) {
        CFErrorRef error = NULL;
        if (CTFontManagerRegisterGraphicsFont(font, &error) == NO) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:(__bridge NSString *)errorDescription userInfo:@{ NSUnderlyingErrorKey: (__bridge NSError *)error }];
        }

        CFRelease(font);
    }

    CFRelease(provider);
}

@end

@implementation UIFont (Inconsolata)

+ (instancetype)inconsolataLoadAndReturnFont:(NSString *)fontName size:(CGFloat)fontSize onceToken:(dispatch_once_t *)onceToken fontFileName:(NSString *)fontFileName {
    dispatch_once(onceToken, ^{
        [KOSFontLoader loadFontWithName:fontFileName];  
    });

    return [self fontWithName:fontName size:fontSize];
}


+ (instancetype)inconsolataFontOfSize:(CGFloat)fontSize {
    static dispatch_once_t onceToken;
    return [self inconsolataLoadAndReturnFont:@"Inconsolata-Regular" size:fontSize onceToken:&onceToken fontFileName:@"Inconsolata-Regular"];
}

+ (instancetype)inconsolataBoldFontOfSize:(CGFloat)fontSize {
    static dispatch_once_t onceToken;
   return [self inconsolataLoadAndReturnFont:@"Inconsolata-Bold" size:fontSize onceToken:&onceToken fontFileName:@"Inconsolata-Bold"];
}

@end

