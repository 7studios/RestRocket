
//
// Copyright 2011 Greg Gentling 7Studios
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//


/*
 * Applications may define schemes that make it possible to open them from your own application
 * using <code>[[UIApplication sharedApplication] openURL:]</code>. There is no way to
 * ask an application which URLs it implements, so Interapp strives to provide a growing
 * set of implementations for known application interfaces.
 
 * <h2>Examples</h2>
 *
 * <h3>Composing a Message in the Twitter App</h3>
 *
 *  // Check whether the Twitter app is installed.
 *  if ([ARCInterapp twitterIsInstalled]) {
 *    // Opens the Twitter app with the composer prepopulated with the following message.
 *    [ARCInterapp twitterWithMessage:@"Playing with the Interapp feature!"];
 *
 *  } else {
 *    // Optionally, we can open the App Store to the twitter page to download the app.
 *    [ARCInterapp twitter];
 *  }

 */



#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ARCMailAppInvocation;



@interface ARCInterapp : NSObject

#pragma mark Safari

+ (BOOL)safariWithURL:(NSURL *)url;

#pragma mark Google Maps

+ (BOOL)googleMapAtLocation:(CLLocationCoordinate2D)location;
+ (BOOL)googleMapAtLocation: (CLLocationCoordinate2D)location
                      title: (NSString *)title;
+ (BOOL)googleMapDirectionsFromLocation: (CLLocationCoordinate2D)fromLocation
                             toLocation: (CLLocationCoordinate2D)toLocation;
+ (BOOL)googleMapWithQuery:(NSString *)query;

#pragma mark Phone

+ (BOOL)phone;
+ (BOOL)phoneWithNumber:(NSString *)phoneNumber;

#pragma mark SMS

+ (BOOL)sms;
+ (BOOL)smsWithNumber:(NSString *)phoneNumber;

#pragma mark Mail

+ (BOOL)mailWithInvocation:(ARCMailAppInvocation *)invocation;

#pragma mark YouTube

+ (BOOL)youTubeWithVideoId:(NSString *)videoId;

#pragma mark App Store

+ (BOOL)appStoreWithAppId:(NSString *)appId;

#pragma mark iBooks

+ (BOOL)iBooksIsInstalled;
+ (BOOL)iBooks;
+ (NSString *)iBooksAppStoreId;

#pragma mark Facebook

+ (BOOL)facebookIsInstalled;
+ (BOOL)facebook;
+ (BOOL)facebookProfileWithId:(NSString *)profileId;
+ (NSString *)facebookAppStoreId;

#pragma mark Twitter

+ (BOOL)twitterIsInstalled;
+ (BOOL)twitter;
+ (BOOL)twitterWithMessage:(NSString *)message;
+ (BOOL)twitterProfileForUsername:(NSString *)username;
+ (NSString *)twitterAppStoreId;


@end


@interface ARCMailAppInvocation : NSObject {
    
@private
  NSString* _recipient;
  NSString* _cc;
  NSString* _bcc;
  NSString* _subject;
  NSString* _body;
}

@property (nonatomic, readwrite, copy) NSString* recipient;
@property (nonatomic, readwrite, copy) NSString* cc;
@property (nonatomic, readwrite, copy) NSString* bcc;
@property (nonatomic, readwrite, copy) NSString* subject;
@property (nonatomic, readwrite, copy) NSString* body;



/**
 * Returns an autoreleased invocation object.
 */
+ (id)invocation;

@end
