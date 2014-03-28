//
//  ofxiBeacon.h
//  ofxiBeaconSample
//
//  Created by hiroshi yamato on 3/19/14.
//
//

#import <Foundation/Foundation.h>

@interface ofxiBeacon : NSObject

+ (ofxiBeacon *)sharedInstanceWithUUIDString:(NSString *)uuid;

@property (nonatomic, readonly) NSMutableDictionary *beaconInfo;
@property (nonatomic) BOOL *doDebug;

- (void)recieveBeaconReload;

@end
