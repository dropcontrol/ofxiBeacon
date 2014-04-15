//
//  ofxiBeacon.mm
//  ofxiBeaconSample
//
//  Created by hiroshi yamato on 3/19/14.
//  Copyright (c) 2014 Hiroshi Yamato
//  This software is released under the MIT License, see LICENSE.md

#import "ofxiBeacon.h"
#import <CoreLocation/CoreLocation.h>

@interface ofxiBeaconDelegate () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSUUID *proximityUUID;
@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (nonatomic) NSMutableDictionary *beaconInfo;
@property (nonatomic, copy) NSString *uuid;

@end

# pragma mark - C++ class implementations

ofxiBeacon::ofxiBeacon(){};

ofxiBeacon::ofxiBeacon(const string &uuid, const string &serviceIndentifier, bool debug)
{
    iBeacon = [ofxiBeaconDelegate sharedInstanceWithUUIDString:[NSString stringWithUTF8String:uuid.c_str()] serviceIndentifier:[NSString stringWithUTF8String:serviceIndentifier.c_str()]];

    if ( debug == true ){
        iBeacon.doDebug = YES;
    }
}

ofxiBeacon::~ofxiBeacon()
{
    // this class is singleton class as obj-c class.
}

BeaconInfo ofxiBeacon::updateBeaconInfo()
{
    string kind = iBeacon.beaconInfo[@"kind"] != NULL ? string((char *)[iBeacon.beaconInfo[@"kind"] UTF8String]) : "";
    string status = iBeacon.beaconInfo[@"status"] != NULL ? string((char *)[iBeacon.beaconInfo[@"status"] UTF8String]) : "";
    string uuid = iBeacon.beaconInfo[@"uuid"] != NULL ? string((char *)[iBeacon.beaconInfo[@"uuid"] UTF8String]) : "";
    int major = iBeacon.beaconInfo[@"major"] != [NSNull null] ? [iBeacon.beaconInfo[@"major"] intValue] : 0;
    int minor = iBeacon.beaconInfo[@"minor"] != [NSNull null] ? [iBeacon.beaconInfo[@"minor"] intValue] : 0;
    double accuracy = iBeacon.beaconInfo[@"accuracy"] != [NSNull null] ? [iBeacon.beaconInfo[@"accuracy"] doubleValue] : 0;
    int rssi = iBeacon.beaconInfo[@"rssi"] != [NSNull null] ? [iBeacon.beaconInfo[@"rssi"] intValue] : 0;

    BeaconInfo currentBeaconInfo = {
        kind,
        status,
        uuid,
        major,
        minor,
        accuracy,
        rssi,
    };

    return currentBeaconInfo;
}

# pragma mark - obj-c class implementations
@implementation ofxiBeaconDelegate

+ (ofxiBeaconDelegate *)sharedInstanceWithUUIDString:(NSString *)uuid serviceIndentifier:(NSString *)serviceIndentifier
{
    static ofxiBeaconDelegate *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initForiBeacon:uuid serviceIndentifier:(NSString *)serviceIndentifier];
    });

    return _sharedInstance;
}

- (id)initForiBeacon:(NSString *)uuid serviceIndentifier:(NSString *)serviceIndentifier
{
    self = [super init];
    if (self) {
        //init
        if ([CLLocationManager isRangingAvailable]) {
            self.locationManager = [[CLLocationManager alloc] init];;
            self.locationManager.delegate = self;

            self.proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
            self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:_proximityUUID identifier:serviceIndentifier];

            [_locationManager startMonitoringForRegion:_beaconRegion];

            self.beaconInfo = [[NSMutableDictionary alloc] init];
            self.doDebug = NO;
            self.uuid = uuid;

            NSLog(@"Done init");
        }
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    // starting to monitor iBeacon.
    [self makeBeaconStatus:@"monitor" status:@"start" major:nil minor:nil accuracy:nil rssi:nil];
    [_locationManager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            // region is INSIDE.
            [self makeBeaconStatus:@"region" status:@"inside" major:nil minor:nil accuracy:nil rssi:nil];
            if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
                [_locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
            }
            break;
        case CLRegionStateOutside:
            // region is OUTSIDES.
            [self makeBeaconStatus:@"region" status:@"outside" major:nil minor:nil accuracy:nil rssi:nil];
            break;
        case CLRegionStateUnknown:
            // region is UNKNOWN.
            [self makeBeaconStatus:@"region" status:@"unknown" major:nil minor:nil accuracy:nil rssi:nil];
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    //  region is ENTERED.
    [self makeBeaconStatus:@"region" status:@"enter" major:nil minor:nil accuracy:nil rssi:nil];

    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable])
    {
        [_locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    // region is EXIT.
    [self makeBeaconStatus:@"region" status:@"exit" major:nil minor:nil accuracy:nil rssi:nil];

    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [_locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    // region is FAIL
    [self makeBeaconStatus:@"monitor" status:@"fail" major:nil minor:nil accuracy:nil rssi:nil];

    NSString *errorStr = [error localizedDescription];
    NSLog(@"Monitoring did fail:%@", errorStr);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        CLBeacon *nearestBeacon = beacons.firstObject;

        NSString *range;

        switch (nearestBeacon.proximity) {
            case CLProximityImmediate:
                range = @"immediate";
                break;
            case CLProximityNear:
                range = @"near";
                break;
            case CLProximityFar:
                range = @"far";
                break;
            case CLProximityUnknown:
                range = @"unknown";
                break;
            default:
                break;
        }

        [self makeBeaconStatus:@"range" status:range major:nearestBeacon.major minor:nearestBeacon.minor accuracy:[NSNumber numberWithDouble:nearestBeacon.accuracy] rssi:[NSNumber numberWithLong:nearestBeacon.rssi]];

        if ( _doDebug == YES ) {
            NSString *message = [NSString stringWithFormat:@"status:%@, major:%@, minor:%@, accuracy:%f, rssi:%ld",  range, nearestBeacon.major, nearestBeacon.minor, nearestBeacon.accuracy, (long)nearestBeacon.rssi];
            [self sendLocalNotificationForMessage:message];
        }
    }
}

# pragma mark - notify method
- (void)sendLocalNotificationForMessage:(NSString *)message
{
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.alertBody = message;
    localNotification.fireDate = [NSDate date];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)makeBeaconStatus:(NSString *)kind status:(NSString *)status major:(NSNumber *)major minor:(NSNumber *)minor accuracy:(NSNumber *)accuracy rssi:(NSNumber *)rssi
{
    self.beaconInfo[@"kind"] = kind;
    self.beaconInfo[@"status"] = status;
    self.beaconInfo[@"uuid"] = self.uuid;
    self.beaconInfo[@"major"] = major == nil ? [NSNull null] : major;
    self.beaconInfo[@"minor"] = minor == nil ? [NSNull null] : minor;
    self.beaconInfo[@"accuracy"] = accuracy == nil ? [NSNull null] : accuracy;
    self.beaconInfo[@"rssi"] = rssi == nil ? [NSNull null] : rssi;

}


@end
