ofxiBeacon
==========

openFrameworks addon for handling iBeacon.


## Initialize

### ofxiBeacon(const std::string &uuid, const std::string &serviceIndentifier, bool debug);

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
    std::string uuid( "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" );
    std::string serviceIndentifier ( "com.example.yourapp" );
    ofxiBeacon(uuid, serviceIndentifier, true);
}
```

## methods

### BeaconInfo updateBeaconInfo();

```
class ofApp : public ofxiOSApp {

    public:
        BeaconInfo beaconInfo;
};
```

```
//--------------------------------------------------------------
void ofApp::update(){
    beaconInfo = iBeacon.updateBeaconInfo();
    string status = beaconInfo.status;
    string uuid = beaconInfo.uuid;
    int major = beaconInfo.major;
    int minor = beaconInfo.minor;
    double accuracy = beaconInfo.accuracy;
    int rssi = beaconInfo.rssi;
}
```
