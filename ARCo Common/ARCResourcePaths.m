
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


#import "ARCResourcePaths.h"


BOOL ARCPathIsInternalURL(NSString *aURLString) {
	return ARCPathIsBundleURL(aURLString) || ARCPathIsDocumentsURL(aURLString) || ARCPathIsFileURL(aURLString);
}

BOOL ARCPathIsBundleURL(NSString *aURLString) {
	return [aURLString hasPrefix:@"bundle://"];
}

BOOL ARCPathIsDocumentsURL(NSString *aURLString) {
	return [aURLString hasPrefix:@"documents://"];
}

BOOL ARCPathIsFileURL(NSString *aURLString) {
	return [aURLString hasPrefix:@"file://"];
}

#pragma mark -



NSString* ARCPathForBundleResource(NSString *bundleResourceFilePath) {
	NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
	if (ARCPathIsBundleURL(bundleResourceFilePath) == TRUE) {
		NSString *filePath	= [bundleResourceFilePath substringFromIndex:9];
		return [mainBundlePath stringByAppendingPathComponent:filePath];
	}
	return nil;
}


NSString* ARCPathForFileResource(NSString *bundleFilePath) {
	if (ARCPathIsFileURL(bundleFilePath) == TRUE) {
		NSString *localFilePath	= [bundleFilePath substringFromIndex:7];
		NSString *mainBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:localFilePath];
		return mainBundlePath;
	}
	return nil;
}

NSString* ARCPathForDocumentsResource(NSString *filePath) {
	static NSString *documentsPath = nil;
	if (!documentsPath) {
		NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentsPath = [dirs objectAtIndex:0];
	}
	if (ARCPathIsDocumentsURL(filePath) == TRUE) {
		NSString *localFilePath	= [filePath substringFromIndex:12];
		return [documentsPath stringByAppendingPathComponent:localFilePath];
	}
	return nil;
}

#pragma mark -

NSString* ARCPathForFileInResourceBundle(NSString *resourceFilePath, NSString *bundleName) {
	NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
	return [[mainBundlePath stringByAppendingPathComponent:bundleName] stringByAppendingPathComponent:resourceFilePath];
}

NSURL* ARCKPathFileURLForBundleResource(NSString *relativeFilePath) {
	NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
	NSString *fullResourcePath = [mainBundlePath stringByAppendingPathComponent:relativeFilePath];
	return [NSURL fileURLWithPath:fullResourcePath];
}


