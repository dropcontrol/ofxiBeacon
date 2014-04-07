//
//  ofxiBeacon.mm
//  ofxiBeaconSample
//
//  Created by hiroshi yamato on 3/19/14.
//
//

#import "ofxiBeacon.h"
#import <CoreLocation/CoreLocation.h>

@interface ofxiBeaconDelegate () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSUUID *proximityUUID;
@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (nonatomic) NSMutableDictionary *beaconInfo;
@property (nonatomic) BOOL beaconReload;
@property (nonatomic, copy) NSString *uuid;

@end

# pragma mark - C++ class implementations
ofxiBeacon::ofxiBeacon(const std::string &uuid, const std::string &serviceIndentifier, bool debug)
{
    iBeacon = [ofxiBeaconDelegate sharedInstanceWithUUIDString:[NSString stringWithUTF8String:uuid.c_str()] serviceIndentifier:[NSString stringWithUTF8String:serviceIndentifier.c_str()]];
    
    if ( debug == true ){
        iBeacon.doDebug = YES;
    }
}

ofxiBeacon::~ofxiBeacon()
{
    // this class is singleton class.
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
            self.beaconReload = NO;
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
    if (![_beaconInfo[@"status"] isEqualToString:status]
        || ( _beaconInfo[@"major"] != [NSNull null] && ![_beaconInfo[@"major"] isEqualToNumber:major])
        || ( _beaconInfo[@"minor"] != [NSNull null] && ![_beaconInfo[@"minor"] isEqualToNumber:minor])
        || _beaconReload == YES ) {
        
        self.beaconInfo[@"kind"] = kind;
        self.beaconInfo[@"status"] = status;
        self.beaconInfo[@"major"] = major == nil ? [NSNull null] : major;
        self.beaconInfo[@"minor"] = minor == nil ? [NSNull null] : minor;
        self.beaconInfo[@"accuracy"] = accuracy == nil ? [NSNull null] : accuracy;
        self.beaconInfo[@"rssi"] = rssi == nil ? [NSNull null] : rssi;
        self.beaconInfo[@"uuid"] = self.uuid;
        
        // maybe, iOS7.1 is not need this compared value
        NSNumber *maxRssiValue = @-20;
        NSComparisonResult result = [rssi compare:maxRssiValue];
        switch (result) {
            case NSOrderedAscending:
                
                if ( ![status isEqualToString:@"unknown"] ){
//                    [self sendBeaconStatus:_beaconInfo];
                }
                
                break;
                
            default:
                break;
        }
        
        if ( _beaconReload == YES) {
            self.beaconReload = NO;
        }
    }
}

- (void)recieveBeaconReload
{
    NSLog(@"__FUNCTION__ : %s", __FUNCTION__);
    NSLog(@"Set beacon reload");
    self.beaconReload = YES;
}


@end
