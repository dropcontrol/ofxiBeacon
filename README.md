ofxiBeacon
==========

openFrameworks addon for handling iBeacon.


## Initialize

### sharedInstanceWithUUIDString:serviceIndentifier

```
+ (ofxiBeacon *)sharedInstanceWithUUIDString:(NSString *)uuid serviceIndentifier:(NSString *)serviceIndentifier;
```

```
ofxiBeacon *iBeacon;
//--------------------------------------------------------------
void ofApp::setup(){
    NSString *uuid = @"";
    NSString *serviceIndentifier = @"";
    iBeacon = [ofxiBeacon sharedInstanceWithUUIDString:uuid serviceIndentifier:serviceIndentifier];

}
```

## properties

### beaconInfo

```
@property (nonatomic, readonly) NSMutableDictionary *beaconInfo;
```

```
NSMutableDictionary *beaconInfo;
//--------------------------------------------------------------
void ofApp::update(){
    beaconInfo = iBeacon.beaconInfo;
}
```

### doDebug

```
@property (nonatomic) BOOL doDebug;
```

```
//--------------------------------------------------------------
void ofApp::update(){
    iBeacon.doDebug = YES;
}
```

## methods

### recieveBeaconReload

```
- (void)recieveBeaconReload;
```
