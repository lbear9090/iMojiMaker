//
//  AnimatedImage.m
//  iMojiMaker
//
//  Created by Lucky on 4/25/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

#import "AnimatedImage.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#ifndef BYTE_SIZE
    #define BYTE_SIZE 8
#endif

#define MEGABYTE (1024 * 1024)

const NSTimeInterval kAnimatedImageDelayTimeIntervalMinimum = 0.001;

typedef NS_ENUM(NSUInteger, AnimatedImageDataSizeCategory)
{
    AnimatedImageDataSizeCategoryAll            = 10,
    AnimatedImageDataSizeCategoryDefault        = 75,
    AnimatedImageDataSizeCategoryOnDemand       = 250,
    AnimatedImageDataSizeCategoryUnsupported
};

typedef NS_ENUM(NSUInteger, AnimatedImageFrameCacheSize)
{
    AnimatedImageFrameCacheSizeNoLimit                  = 0,
    AnimatedImageFrameCacheSizeLowMemory                = 1,
    AnimatedImageFrameCacheSizeGrowAfterMemoryWarning   = 2,
    AnimatedImageFrameCacheSizeDefault                  = 5
};

@interface AnimatedImage ()

@property (nonatomic, assign, readonly) NSUInteger frameCacheSizeOptimal;
@property (nonatomic, assign, readonly, getter=isPredrawingEnabled) BOOL predrawingEnabled;
@property (nonatomic, assign) NSUInteger frameCacheSizeMaxInternal;
@property (nonatomic, assign) NSUInteger requestedFrameIndex;
@property (nonatomic, assign, readonly) NSUInteger posterImageFrameIndex;
@property (nonatomic, strong, readonly) NSMutableDictionary *cachedFramesForIndexes;
@property (nonatomic, strong, readonly) NSMutableIndexSet *cachedFrameIndexes;
@property (nonatomic, strong, readonly) NSMutableIndexSet *requestedFrameIndexes;
@property (nonatomic, strong, readonly) NSIndexSet *allFramesIndexSet;
@property (nonatomic, assign) NSUInteger memoryWarningCount;
@property (nonatomic, strong, readonly) dispatch_queue_t serialQueue;
@property (nonatomic, strong, readonly) __attribute__((NSObject)) CGImageSourceRef imageSource;
@property (nonatomic, strong, readonly) AnimatedImage *weakProxy;

@end

static NSHashTable *allAnimatedImagesWeak;

@implementation AnimatedImage

- (NSUInteger)frameCacheSizeCurrent
{
    NSUInteger frameCacheSizeCurrent = self.frameCacheSizeOptimal;
    
    if (self.frameCacheSizeMax > AnimatedImageFrameCacheSizeNoLimit)
    {
        frameCacheSizeCurrent = MIN(frameCacheSizeCurrent, self.frameCacheSizeMax);
    }
    
    if (self.frameCacheSizeMaxInternal > AnimatedImageFrameCacheSizeNoLimit)
    {
        frameCacheSizeCurrent = MIN(frameCacheSizeCurrent, self.frameCacheSizeMaxInternal);
    }
    
    return frameCacheSizeCurrent;
}

- (void)setFrameCacheSizeMax:(NSUInteger)frameCacheSizeMax
{
    if (_frameCacheSizeMax != frameCacheSizeMax)
    {
        BOOL willFrameCacheSizeShrink = (frameCacheSizeMax < self.frameCacheSizeCurrent);
        
        _frameCacheSizeMax = frameCacheSizeMax;
        
        if (willFrameCacheSizeShrink)
        {
            [self purgeFrameCacheIfNeeded];
        }
    }
}

- (void)setFrameCacheSizeMaxInternal:(NSUInteger)frameCacheSizeMaxInternal
{
    if (_frameCacheSizeMaxInternal != frameCacheSizeMaxInternal)
    {
        BOOL willFrameCacheSizeShrink = (frameCacheSizeMaxInternal < self.frameCacheSizeCurrent);
        
        _frameCacheSizeMaxInternal = frameCacheSizeMaxInternal;
        
        if (willFrameCacheSizeShrink)
        {
            [self purgeFrameCacheIfNeeded];
        }
    }
}

+ (void)initialize
{
    if (self == [AnimatedImage class])
    {
        allAnimatedImagesWeak = [NSHashTable weakObjectsHashTable];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(NSNotification *note)
        {
            NSAssert([NSThread isMainThread], @"Received memory warning on non-main thread");
            NSArray *images = nil;
            
            @synchronized(allAnimatedImagesWeak)
            {
                images = [[allAnimatedImagesWeak allObjects] copy];
            }

            [images makeObjectsPerformSelector:@selector(didReceiveMemoryWarning:) withObject:note];
        }];
    }
}

- (instancetype)init
{
    return [self initWithAnimatedGIFData:nil];
}

- (instancetype)initWithAnimatedGIFData:(NSData *)data
{
    return [self initWithAnimatedGIFData:data optimalFrameCacheSize:0 predrawingEnabled:YES];
}

- (instancetype)initWithAnimatedGIFData:(NSData *)data optimalFrameCacheSize:(NSUInteger)optimalFrameCacheSize predrawingEnabled:(BOOL)isPredrawingEnabled
{
    BOOL hasData = ([data length] > 0);
    if (!hasData) return nil;
    
    self = [super init];
    if (self)
    {
        _data = data;
        _predrawingEnabled = isPredrawingEnabled;
        
        _cachedFramesForIndexes = [[NSMutableDictionary alloc] init];
        _cachedFrameIndexes = [[NSMutableIndexSet alloc] init];
        _requestedFrameIndexes = [[NSMutableIndexSet alloc] init];
        
        _imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data,
                                                   (__bridge CFDictionaryRef)@{(NSString *)kCGImageSourceShouldCache: @NO});

        if (!_imageSource) return nil;
        
        CFStringRef imageSourceContainerType = CGImageSourceGetType(_imageSource);
        BOOL isGIFData = UTTypeConformsTo(imageSourceContainerType, kUTTypeGIF);
        if (!isGIFData) return nil;
        
        NSDictionary *imageProperties = (__bridge_transfer NSDictionary *)CGImageSourceCopyProperties(_imageSource, NULL);
        _loopCount = [[[imageProperties objectForKey:(id)kCGImagePropertyGIFDictionary] objectForKey:(id)kCGImagePropertyGIFLoopCount] unsignedIntegerValue];
        
        size_t imageCount = CGImageSourceGetCount(_imageSource);
        NSUInteger skippedFrameCount = 0;
        NSMutableDictionary *delayTimesForIndexesMutable = [NSMutableDictionary dictionaryWithCapacity:imageCount];
        
        for (size_t i = 0; i < imageCount; i++)
        {
            @autoreleasepool
            {
                CGImageRef frameImageRef = CGImageSourceCreateImageAtIndex(_imageSource, i, NULL);
                
                if (frameImageRef)
                {
                    UIImage *frameImage = [UIImage imageWithCGImage:frameImageRef];
                    
                    if (frameImage)
                    {
                        if (!self.posterImage)
                        {
                            _posterImage = frameImage;
                            _size = _posterImage.size;
                            _posterImageFrameIndex = i;
                            [self.cachedFramesForIndexes setObject:self.posterImage forKey:@(self.posterImageFrameIndex)];
                            [self.cachedFrameIndexes addIndex:self.posterImageFrameIndex];
                        }
                        
                        NSDictionary *frameProperties = (__bridge_transfer NSDictionary *)CGImageSourceCopyPropertiesAtIndex(_imageSource, i, NULL);
                        NSDictionary *framePropertiesGIF = [frameProperties objectForKey:(id)kCGImagePropertyGIFDictionary];
                        NSNumber *delayTime = [framePropertiesGIF objectForKey:(id)kCGImagePropertyGIFUnclampedDelayTime];
                        
                        if (!delayTime)
                        {
                            delayTime = [framePropertiesGIF objectForKey:(id)kCGImagePropertyGIFDelayTime];
                        }

                        const NSTimeInterval kDelayTimeIntervalDefault = 0.1;
                        
                        if (!delayTime)
                        {
                            if (i == 0)
                            {
                                delayTime = @(kDelayTimeIntervalDefault);
                            }
                            else
                            {
                                delayTime = delayTimesForIndexesMutable[@(i - 1)];
                            }
                        }

                        if ([delayTime floatValue] < ((float)kAnimatedImageDelayTimeIntervalMinimum - FLT_EPSILON))
                        {
                            delayTime = @(kDelayTimeIntervalDefault);
                        }
                        
                        delayTimesForIndexesMutable[@(i)] = delayTime;
                    }
                    else
                    {
                        skippedFrameCount++;
                    }
                    
                    CFRelease(frameImageRef);
                }
                else
                {
                    skippedFrameCount++;
                }
            }
        }
        
        _delayTimesForIndexes = [delayTimesForIndexesMutable copy];
        _frameCount = imageCount;
        
        if (self.frameCount == 0) return nil;
        
        if (optimalFrameCacheSize == 0)
        {
            CGFloat animatedImageDataSize = CGImageGetBytesPerRow(self.posterImage.CGImage) * self.size.height * (self.frameCount - skippedFrameCount) / MEGABYTE;
            
            if (animatedImageDataSize <= AnimatedImageDataSizeCategoryAll)
            {
                _frameCacheSizeOptimal = self.frameCount;
            }
            else if (animatedImageDataSize <= AnimatedImageDataSizeCategoryDefault)
            {
                _frameCacheSizeOptimal = AnimatedImageFrameCacheSizeDefault;
            }
            else
            {
                _frameCacheSizeOptimal = AnimatedImageFrameCacheSizeLowMemory;
            }
        }
        else
        {
            _frameCacheSizeOptimal = optimalFrameCacheSize;
        }

        _frameCacheSizeOptimal = MIN(_frameCacheSizeOptimal, self.frameCount);
        _allFramesIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, self.frameCount)];
        _weakProxy = (id)[WeakProxy weakProxyForObject:self];
        
        @synchronized(allAnimatedImagesWeak)
        {
            [allAnimatedImagesWeak addObject:self];
        }
    }
    
    return self;
}

+ (instancetype)animatedImageWithGIFData:(NSData *)data
{
    return [[AnimatedImage alloc] initWithAnimatedGIFData:data];
}

- (void)dealloc
{
    if (_weakProxy)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:_weakProxy];
    }
    
    if (_imageSource)
    {
        CFRelease(_imageSource);
    }
}

- (UIImage *)imageLazilyCachedAtIndex:(NSUInteger)index
{
    if (index >= self.frameCount) return nil;
    
    self.requestedFrameIndex = index;

    if ([self.cachedFrameIndexes count] < self.frameCount)
    {
        NSMutableIndexSet *frameIndexesToAddToCacheMutable = [self frameIndexesToCache];
        [frameIndexesToAddToCacheMutable removeIndexes:self.cachedFrameIndexes];
        [frameIndexesToAddToCacheMutable removeIndexes:self.requestedFrameIndexes];
        [frameIndexesToAddToCacheMutable removeIndex:self.posterImageFrameIndex];
        NSIndexSet *frameIndexesToAddToCache = [frameIndexesToAddToCacheMutable copy];
        
        if ([frameIndexesToAddToCache count] > 0)
        {
            [self addFrameIndexesToCache:frameIndexesToAddToCache];
        }
    }
    
    UIImage *image = self.cachedFramesForIndexes[@(index)];
    [self purgeFrameCacheIfNeeded];
    
    return image;
}

- (void)addFrameIndexesToCache:(NSIndexSet *)frameIndexesToAddToCache
{
    NSRange firstRange = NSMakeRange(self.requestedFrameIndex, self.frameCount - self.requestedFrameIndex);
    NSRange secondRange = NSMakeRange(0, self.requestedFrameIndex);
    [self.requestedFrameIndexes addIndexes:frameIndexesToAddToCache];
    
    if (!self.serialQueue)
    {
        _serialQueue = dispatch_queue_create("com.flipboard.framecachingqueue", DISPATCH_QUEUE_SERIAL);
    }
    
    AnimatedImage * __weak weakSelf = self;
    dispatch_async(self.serialQueue, ^
    {
        void (^frameRangeBlock)(NSRange, BOOL *) = ^(NSRange range, BOOL *stop)
        {
            for (NSUInteger i = range.location; i < NSMaxRange(range); i++)
            {
                UIImage *image = [weakSelf imageAtIndex:i];
                
                if (image && weakSelf)
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                        weakSelf.cachedFramesForIndexes[@(i)] = image;
                        [weakSelf.cachedFrameIndexes addIndex:i];
                        [weakSelf.requestedFrameIndexes removeIndex:i];
                    });
                }
            }
        };
        
        [frameIndexesToAddToCache enumerateRangesInRange:firstRange options:0 usingBlock:frameRangeBlock];
        [frameIndexesToAddToCache enumerateRangesInRange:secondRange options:0 usingBlock:frameRangeBlock];
    });
}

+ (CGSize)sizeForImage:(id)image
{
    CGSize imageSize = CGSizeZero;
    
    if (!image) return imageSize;
    
    if ([image isKindOfClass:[UIImage class]])
    {
        UIImage *uiImage = (UIImage *)image;
        imageSize = uiImage.size;
    }
    else if ([image isKindOfClass:[AnimatedImage class]])
    {
        AnimatedImage *animatedImage = (AnimatedImage *)image;
        imageSize = animatedImage.size;
    }
    
    return imageSize;
}

- (UIImage *)imageAtIndex:(NSUInteger)index
{
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_imageSource, index, NULL);
    
    if (!imageRef) return nil;
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    
    if (self.isPredrawingEnabled)
    {
        image = [[self class] predrawnImageFromImage:image];
    }
    
    return image;
}

- (NSMutableIndexSet *)frameIndexesToCache
{
    NSMutableIndexSet *indexesToCache = nil;

    if (self.frameCacheSizeCurrent == self.frameCount)
    {
        indexesToCache = [self.allFramesIndexSet mutableCopy];
    }
    else
    {
        indexesToCache = [[NSMutableIndexSet alloc] init];
        NSUInteger firstLength = MIN(self.frameCacheSizeCurrent, self.frameCount - self.requestedFrameIndex);
        NSRange firstRange = NSMakeRange(self.requestedFrameIndex, firstLength);
        [indexesToCache addIndexesInRange:firstRange];
        NSUInteger secondLength = self.frameCacheSizeCurrent - firstLength;
        
        if (secondLength > 0)
        {
            NSRange secondRange = NSMakeRange(0, secondLength);
            [indexesToCache addIndexesInRange:secondRange];
        }
        
        [indexesToCache addIndex:self.posterImageFrameIndex];
    }
    
    return indexesToCache;
}

- (void)purgeFrameCacheIfNeeded
{
    if ([self.cachedFrameIndexes count] > self.frameCacheSizeCurrent)
    {
        NSMutableIndexSet *indexesToPurge = [self.cachedFrameIndexes mutableCopy];
        [indexesToPurge removeIndexes:[self frameIndexesToCache]];
        [indexesToPurge enumerateRangesUsingBlock:^(NSRange range, BOOL *stop)
        {
            for (NSUInteger i = range.location; i < NSMaxRange(range); i++)
            {
                [self.cachedFrameIndexes removeIndex:i];
                [self.cachedFramesForIndexes removeObjectForKey:@(i)];
            }
        }];
    }
}

- (void)growFrameCacheSizeAfterMemoryWarning:(NSNumber *)frameCacheSize
{
    self.frameCacheSizeMaxInternal = [frameCacheSize unsignedIntegerValue];
    const NSTimeInterval kResetDelay = 3.0;
    [self.weakProxy performSelector:@selector(resetFrameCacheSizeMaxInternal) withObject:nil afterDelay:kResetDelay];
}

- (void)resetFrameCacheSizeMaxInternal
{
    self.frameCacheSizeMaxInternal = AnimatedImageFrameCacheSizeNoLimit;
}

- (void)didReceiveMemoryWarning:(NSNotification *)notification
{
    self.memoryWarningCount++;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self.weakProxy selector:@selector(growFrameCacheSizeAfterMemoryWarning:) object:@(AnimatedImageFrameCacheSizeGrowAfterMemoryWarning)];
    [NSObject cancelPreviousPerformRequestsWithTarget:self.weakProxy selector:@selector(resetFrameCacheSizeMaxInternal) object:nil];
    
    self.frameCacheSizeMaxInternal = AnimatedImageFrameCacheSizeLowMemory;
    const NSUInteger kGrowAttemptsMax = 2;
    const NSTimeInterval kGrowDelay = 2.0;
    
    if ((self.memoryWarningCount - 1) <= kGrowAttemptsMax)
    {
        [self.weakProxy performSelector:@selector(growFrameCacheSizeAfterMemoryWarning:) withObject:@(AnimatedImageFrameCacheSizeGrowAfterMemoryWarning) afterDelay:kGrowDelay];
    }
}

+ (UIImage *)predrawnImageFromImage:(UIImage *)imageToPredraw
{
    CGColorSpaceRef colorSpaceDeviceRGBRef = CGColorSpaceCreateDeviceRGB();

    if (!colorSpaceDeviceRGBRef) return imageToPredraw;
    
    size_t numberOfComponents = CGColorSpaceGetNumberOfComponents(colorSpaceDeviceRGBRef) + 1;
    void *data = NULL;
    size_t width = imageToPredraw.size.width;
    size_t height = imageToPredraw.size.height;
    size_t bitsPerComponent = CHAR_BIT;
    
    size_t bitsPerPixel = (bitsPerComponent * numberOfComponents);
    size_t bytesPerPixel = (bitsPerPixel / BYTE_SIZE);
    size_t bytesPerRow = (bytesPerPixel * width);
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageToPredraw.CGImage);
    
    if (alphaInfo == kCGImageAlphaNone || alphaInfo == kCGImageAlphaOnly)
    {
        alphaInfo = kCGImageAlphaNoneSkipFirst;
    }
    else if (alphaInfo == kCGImageAlphaFirst)
    {
        alphaInfo = kCGImageAlphaPremultipliedFirst;
    }
    else if (alphaInfo == kCGImageAlphaLast)
    {
        alphaInfo = kCGImageAlphaPremultipliedLast;
    }
    
    bitmapInfo |= alphaInfo;
    CGContextRef bitmapContextRef = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpaceDeviceRGBRef, bitmapInfo);
    CGColorSpaceRelease(colorSpaceDeviceRGBRef);

    if (!bitmapContextRef) return imageToPredraw;
    
    CGContextDrawImage(bitmapContextRef, CGRectMake(0.0, 0.0, imageToPredraw.size.width, imageToPredraw.size.height), imageToPredraw.CGImage);
    CGImageRef predrawnImageRef = CGBitmapContextCreateImage(bitmapContextRef);
    UIImage *predrawnImage = [UIImage imageWithCGImage:predrawnImageRef scale:imageToPredraw.scale orientation:imageToPredraw.imageOrientation];
    CGImageRelease(predrawnImageRef);
    CGContextRelease(bitmapContextRef);
    
    if (!predrawnImage)
    {
        return imageToPredraw;
    }
    
    return predrawnImage;
}


#pragma mark - Description

- (NSString *)description
{
    NSString *description = [super description];
    description = [description stringByAppendingFormat:@" size=%@", NSStringFromCGSize(self.size)];
    description = [description stringByAppendingFormat:@" frameCount=%lu", (unsigned long)self.frameCount];
    
    return description;
}


@end

@interface WeakProxy ()
@property (nonatomic, weak) id target;
@end

@implementation WeakProxy

+ (instancetype)weakProxyForObject:(id)targetObject
{
    WeakProxy *weakProxy = [WeakProxy alloc];
    weakProxy.target = targetObject;
    return weakProxy;
}

- (id)forwardingTargetForSelector:(SEL)selector
{
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

@end
