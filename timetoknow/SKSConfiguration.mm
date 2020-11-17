//
//  SKSConfiguration.mm
//  SpeechKitSample
//
//  All Nuance Developers configuration parameters can be set here.
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

#import "SKSConfiguration.h"

// All fields are required.
// Your credentials can be found in your Nuance Developers portal, under "Manage My Apps".
NSString* SKSAppKey = @"184e27c2e5c2c133fc1cf11435e970852ff231f7fd463e53ac83b12eeff5f207441ac929dc8a5cd8a64deddc365d61654f925c4cd89a9f841e51b30d46a5148a";
NSString* SKSAppId = @"NMDPTRIAL_test3dizz_gmail_com20160822134512";
NSString* SKSServerHost = @"sslsandbox-nmdp.nuancemobility.net";
NSString* SKSServerPort = @"443";

NSString* SKSLanguage = @"!LANGUAGE!";

NSString* SKSServerUrl = [NSString stringWithFormat:@"nmsps://%@@%@:%@", SKSAppId, SKSServerHost, SKSServerPort];

// Only needed if using NLU/Bolt
NSString* SKSNLUContextTag = @"!NLU_CONTEXT_TAG!";

