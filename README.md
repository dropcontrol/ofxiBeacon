ofxiBeacon
==========

openFrameworks addon for handling iBeacon.


## Initialize

### ofxiBeacon(const std::string &uuid, const std::string &serviceIndentifier, bool debug);

```
void ofApp::setup(){
    std::string uuid( "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" );
    std::string serviceIndentifier ( "com.example.yourapp" );
    ofxiBeacon(uuid, serviceIndentifier, true);
}
```

## methods
