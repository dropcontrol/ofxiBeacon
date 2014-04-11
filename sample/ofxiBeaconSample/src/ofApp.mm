#include "ofApp.h"

string status;
string uuid;
int majorNumber;
int minorNumber;
double accuracyValue;
int rssiValue;

//--------------------------------------------------------------
void ofApp::setup(){
    string uuid( "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx" );
    string serviceIndentifier ( "com.example.ofxiBeaconSample" );
    iBeacon = ofxiBeacon();
    iBeacon = ofxiBeacon(uuid, serviceIndentifier, true);

}

//--------------------------------------------------------------
void ofApp::update(){
    beaconInfo = iBeacon.updateBeaconInfo();
    status = beaconInfo.status;
    uuid = beaconInfo.uuid;
    majorNumber = beaconInfo.major;
    minorNumber = beaconInfo.minor;
    accuracyValue = beaconInfo.accuracy;
    rssiValue = beaconInfo.rssi;

}

//--------------------------------------------------------------
void ofApp::draw(){

    ofDrawBitmapString(status, 10, 100);
    ofDrawBitmapString(uuid, 10, 120);
    ofDrawBitmapString(ofToString(majorNumber), 10, 140);
    ofDrawBitmapString(ofToString(minorNumber), 10, 160);
    ofDrawBitmapString(ofToString(accuracyValue), 10, 180);
    ofDrawBitmapString(ofToString(rssiValue), 10, 200);

}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
