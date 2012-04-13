ANDROID_SDK=/Developer/Android
AIR_SDK=/Developer/Android/4.1.0_AIR25

$AIR_SDK/bin/amxmlc -debug=true -library-path+=../libs/SynapseLibrary.swc SynapseAIRClient.mxml

$AIR_SDK/bin/adt -package -target apk-debug -connect 192.168.0.2 -storetype pkcs12 -keystore ../cert/cert.p12 -storepass resource SynapseAIRClient SynapseAIRClient-app.xml SynapseAIRClient.swf

$ANDROID_SDK/tools/adb -e install -r SynapseAIRClient.apk