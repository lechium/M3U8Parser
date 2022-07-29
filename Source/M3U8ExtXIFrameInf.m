//
//  M3U8ExtXIFrameInf.m
//  ILSLoader
//
//  Created by Jin Sun on 13-4-15.
//  Copyright (c) 2013年 iLegendSoft. All rights reserved.
//

#import "M3U8ExtXIFrameInf.h"
#import "M3U8TagsAndAttributes.h"

@interface M3U8ExtXIFrameInf()
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic) MediaResoulution resolution;
@end

@implementation M3U8ExtXIFrameInf

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.dictionary = dictionary;
        self.resolution = MediaResoulutionZero;
    }
    return self;
}

- (NSURL *)baseURL {
    return self.dictionary[M3U8_BASE_URL];
}

- (NSURL *)URL {
    return self.dictionary[M3U8_URL];
}

- (NSURL *)m3u8URL {
    if (self.URI.scheme) {
        return self.URI;
    }
    
    return [NSURL URLWithString:self.URI.absoluteString relativeToURL:[self baseURL]];
}

- (NSInteger)averageBandwidth {
    return [self.dictionary[M3U8_EXT_X_STREAM_INF_AVERAGE_BANDWIDTH] integerValue];
}

- (NSInteger)bandwidth {
    return [self.dictionary[M3U8_EXT_X_I_FRAME_STREAM_INF_BANDWIDTH] integerValue];
}

- (NSInteger)programId {
    return [self.dictionary[M3U8_EXT_X_I_FRAME_STREAM_INF_PROGRAM_ID] integerValue];
}

- (NSArray *)codecs {
    NSString *codecsString = self.dictionary[M3U8_EXT_X_I_FRAME_STREAM_INF_CODECS];
    return [codecsString componentsSeparatedByString:@","];
}

- (MediaResoulution)resolution {
    NSString *rStr = self.dictionary[M3U8_EXT_X_I_FRAME_STREAM_INF_RESOLUTION];
    MediaResoulution resolution = MediaResolutionFromString(rStr);
    return resolution;
}

- (NSString *)video {
    return self.dictionary[M3U8_EXT_X_I_FRAME_STREAM_INF_VIDEO];
}

- (NSURL *)URI {
    return [NSURL URLWithString:self.dictionary[M3U8_EXT_X_I_FRAME_STREAM_INF_URI]];
}

- (NSString *)description {
    return [NSString stringWithString:self.dictionary.description];
}

/*
 #EXT-X-STREAM-INF:AUDIO="600k",BANDWIDTH=1049794,AVERAGE-BANDWIDTH=1000000,PROGRAM-ID=1,CODECS="avc1.42c01e,mp4a.40.2",RESOLUTION=640x360,SUBTITLES="subs"
 main_media_0.m3u8
 */
- (NSString *)m3u8PlainString {
    NSMutableString *str = [NSMutableString string];
    [str appendString:M3U8_EXT_X_I_FRAME_STREAM_INF];
    [str appendString:[NSString stringWithFormat:@"BANDWIDTH=%ld", (long)self.bandwidth]];
    if (self.averageBandwidth > 0) {
        [str appendString:[NSString stringWithFormat:@",AVERAGE-BANDWIDTH=%ld", (long)self.averageBandwidth]];
    }
    NSString *codecsString = self.dictionary[M3U8_EXT_X_I_FRAME_STREAM_INF_CODECS];
    [str appendString:[NSString stringWithFormat:@",CODECS=\"%@\"", codecsString]];
    NSString *rStr = self.dictionary[M3U8_EXT_X_I_FRAME_STREAM_INF_RESOLUTION];
    if (rStr.length > 0) {
        [str appendString:[NSString stringWithFormat:@",RESOLUTION=%@", rStr]];
    }
    [str appendString:[NSString stringWithFormat:@",URI=\"%@\"", self.URI.absoluteString]];
    return str;
}

@end





