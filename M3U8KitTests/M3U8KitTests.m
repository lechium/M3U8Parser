//
//  M3U8KitTests.m
//  M3U8KitTests
//
//  Created by Frank on 2018/7/2.
//  Copyright © 2018 Allen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSURL+m3u8.h"
#import "M3U8PlaylistModel.h"
#import "StringExample.h"

@interface M3U8KitTests : XCTestCase

@property (nonatomic) StringExample *example;

@end

@implementation M3U8KitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _example = [[StringExample alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadURLAsynchronously {
    XCTestExpectation *expectation = [self expectationWithDescription:@"load URL failed!"];
    NSURL *url = [NSURL URLWithString:@"https://hls.ted.com/talks/2639.m3u8"];
    [url m3u_loadAsyncCompletion:^(M3U8PlaylistModel *model, NSError *error) {
                                          if (error) {
                                              return;
                                          }
                                          [expectation fulfill];
                                      }];
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

- (void)testMasterM3U {
    NSURL *baseURL = [NSURL URLWithString:@"https://hls.ted.com"];
    NSError *error = nil;
    M3U8PlaylistModel *playList = [[M3U8PlaylistModel alloc]
                                   initWithString:_example.m3u8Master
                                   baseURL:baseURL
                                   error:&error];
    NSLog(@"%@", playList);
    NSArray *codecs = [playList.masterPlaylist.xStreamList xStreamInfAtIndex:0].codecs;
    NSLog(@"codecs %@", codecs);
    
    XCTAssert([codecs[0] isEqualToString:@"avc1.42c01e"]);
    XCTAssert([codecs[1] isEqualToString:@"mp4a.40.2"]);
    XCTAssertNil(error);
}

- (void)testPlaylistM3U {
    NSURL *baseURL = [NSURL URLWithString:@"https://example.m3u8kit/9764a7a5vodtransgzp1252524126/953e2ef85285890782612785655/drm/"];
    NSError *error = nil;
    M3U8PlaylistModel *playList = [[M3U8PlaylistModel alloc]
                                   initWithString:_example.m3u8Playlist
                                   baseURL:baseURL
                                   error:&error];
    NSLog(@"%@", playList);
    XCTAssertNil(error);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
