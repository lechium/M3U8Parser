//
//  NSURL+m3u8.m
//  M3U8Kit
//
//  Created by Frank on 16/06/2017.
//

#import "NSURL+m3u8.h"
#import "M3U8PlaylistModel.h"

@implementation NSURL (m3u8)

- (NSURL *)m3u_properM3UURL {
    NSString *base = [[self baseURL] absoluteString]; //ie https://website.net/Company/185/711/2083252803943/1665503927621
    return [NSURL URLWithString:[base stringByAppendingFormat:@"/%@", [self relativePath]]];
    //[NSURL URLWithString:[base stringByAppendingPathComponent:[self relativePath]]]; //relativePath ie: layer_3_x15ae724f9359493b9699514a833cd94b/30310_02__055017_2083254851776_mp4_video_640x360_311000_primary_audio_eng_1_x15ae724f9359493b9699514a833cd94b_3.m3u8
}

- (NSURL *)m3u_realBaseURL {
    NSURL *baseURL = self.baseURL;
    if (!baseURL) {
        NSString *string = [self.absoluteString stringByReplacingOccurrencesOfString:self.lastPathComponent withString:@""];
        
        baseURL = [NSURL URLWithString:string];
    }
    
    return baseURL;
}

- (void)m3u_loadAsyncCompletion:(void (^)(M3U8PlaylistModel *model, NSError *error))completion {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        NSError *err = nil;
        NSString *str = [[NSString alloc] initWithContentsOfURL:self
                                                       encoding:NSUTF8StringEncoding error:&err];
        
        if (err) {
            completion(nil, err);
            return;
        }
        
        M3U8PlaylistModel *listModel = [[M3U8PlaylistModel alloc] initWithString:str
                                                                     originalURL:self baseURL:self.m3u_realBaseURL error:&err];
        if (err) {
            completion(nil, err);
            return;
        }
        
        completion(listModel, nil);
    });
}

@end
