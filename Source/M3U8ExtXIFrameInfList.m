//
//  M3U8ExtXIFrameInfList.m
//  ILSLoader
//
//  Created by Jin Sun on 13-4-15.
//  Copyright (c) 2013年 iLegendSoft. All rights reserved.
//

#import "M3U8ExtXIFrameInfList.h"

@interface M3U8ExtXIFrameInfList ()

@property (nonatomic, strong) NSMutableArray *m3u8InfoList;

@end

@implementation M3U8ExtXIFrameInfList

- (id)init {
    self = [super init];
    if (self) {
        self.m3u8InfoList = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Getter && Setter
- (NSUInteger)count {
    return [self.m3u8InfoList count];
}

#pragma mark - Public
- (void)addExtXIFrameInf:(M3U8ExtXIFrameInf *)extIFrameInf {
    [self.m3u8InfoList addObject:extIFrameInf];
}

- (M3U8ExtXIFrameInf *)xIFrameInfAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    return [self.m3u8InfoList objectAtIndex:index];
}

- (M3U8ExtXIFrameInf *)firstXIFrameInf {
    return [self.m3u8InfoList firstObject];
}

- (M3U8ExtXIFrameInf *)lastXIFrameInf {
    return [self.m3u8InfoList lastObject];
}

- (void)sortByBandwidthInOrder:(NSComparisonResult)order {
    
    NSArray *array = [self.m3u8InfoList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger bandwidth1 = ((M3U8ExtXIFrameInf *)obj1).bandwidth;
        NSInteger bandwidth2 = ((M3U8ExtXIFrameInf *)obj2).bandwidth;
        if ( bandwidth1 == bandwidth2 ) {
            return NSOrderedSame;
        } else if (bandwidth1 < bandwidth2) {
            return order;
        } else {
            return order * (-1);
        }
    }];
    
    self.m3u8InfoList = [array mutableCopy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.m3u8InfoList];
}

@end
