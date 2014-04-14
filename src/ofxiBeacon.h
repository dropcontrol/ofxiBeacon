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
@property (nonatomic) BOOL didStartMonitoringForRegion;

@end


# pragma mark - C++ class header

struct BeaconInfo {
    string kind;
    string status;
    string uuid;
    int major;
    int minor;
    double accuracy;
    int rssi;
};

class ofxiBeacon
{
    public:
        ofxiBeacon();
        ofxiBeacon(const string &uuid, const string &serviceIndentifier, bool debug);
        ~ofxiBeacon();
    
        BeaconInfo updateBeaconInfo();
        bool didStartMonitoringForRegion();
    
    protected:
        ofxiBeaconDelegate *iBeacon;
};

