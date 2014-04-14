ofxiBeacon
==========

openFrameworks addon for handling iBeacon.


## Initialize

### ofxiBeacon(const string &uuid, const string &serviceIndentifier, bool debug);

#### .h
```
class ofApp : public ofxiOSApp {

    public:
        ofxiBeacon iBeacon;
};
```


#### .mm
```
void ofApp::setup(){
    string uuid( "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" );
    string serviceIndentifier ( "com.example.yourapp" );
    ofxiBeadon();
    ofxiBeacon(uuid, serviceIndentifier, true);
}
```
if debug is true, sending beacon info to LocalNotification.

## methods

### BeaconInfo updateBeaconInfo();

#### .h
```
class ofApp : public ofxiOSApp {

    public:
        BeaconInfo beaconInfo;
};
```

#### .mm
```
//--------------------------------------------------------------
void ofApp::update(){
    beaconInfo = iBeacon.updateBeaconInfo();
    string kind = beaconInfo.status;
    string status = beaconInfo.status;
    string uuid = beaconInfo.uuid;
    int major = beaconInfo.major;
    int minor = beaconInfo.minor;
    double accuracy = beaconInfo.accuracy;
    int rssi = beaconInfo.rssi;
}
```
