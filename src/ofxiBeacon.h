//
//  ofxiBeacon.h
//  ofxiBeaconSample
//
//  Created by hiroshi yamato on 3/19/14.
//
//

#import <Foundation/Foundation.h>
#import "ofMain.h"
#pragma once

@interface ofxiBeaconDelegate : NSObject

+ (ofxiBeaconDelegate *)sharedInstanceWithUUIDString:(NSString *)uuid serviceIndentifier:(NSString *)serviceIndentifier;
@property (nonatomic, readonly) NSMutableDictionary *beaconInfo;
@property (nonatomic) BOOL doDebug;

- (void)recieveBeaconReload;

@end


# pragma mark - C++ class header
class ofxiBeacon
{
    public:
        ofxiBeacon(const std::string &uuid, const std::string &serviceIndentifier);
        ~ofxiBeacon();
    
        void doDebug(bool flag);
    
    protected:
        ofxiBeaconDelegate *iBeacon;
};