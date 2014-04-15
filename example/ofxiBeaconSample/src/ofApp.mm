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
    ofSetColor(0, 0, 0);
    ofDrawBitmapString(uuid, 10, 80);
    ofDrawBitmapString("kind: ", 10, 100);
    ofDrawBitmapString(kind, 90, 100);
    ofDrawBitmapString("status: ", 10, 120);
    ofDrawBitmapString(status, 90, 120);
    ofDrawBitmapString("major: ", 10, 140);
    ofDrawBitmapString(ofToString(majorNumber), 90, 140);
    ofDrawBitmapString("minor: ", 10, 160);
    ofDrawBitmapString(ofToString(minorNumber), 90, 160);
    ofDrawBitmapString("accuracy: ", 10, 180);
    ofDrawBitmapString(ofToString(accuracyValue, 15), 90, 180);
    ofDrawBitmapString("rssi: ", 10, 200);
    ofDrawBitmapString(ofToString(rssiValue), 90, 200);

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
