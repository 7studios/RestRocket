
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

#import <Foundation/Foundation.h>



/*!
 @abstract Returns TRUE if the URL begins with "bundle://" , "documents://" or "temp://"
 */
BOOL ARCPathIsInternalURL(NSString *URLString);

/*!
 @abstract Returns TRUE if the URL begins with "bundle://"
 */
BOOL ARCPathIsBundleURL(NSString *URLString);

/*!
 @abstract Returns TRUE if the URL begins with "documents://"
 */
BOOL ARCPathIsDocumentsURL(NSString *URLString);

BOOL ARCPathIsFileURL(NSString *URLString);




NSString* ARCPathForFileInResourceBundle(NSString *resourceFilePath, NSString *bundleName);

NSString* ARCPathForBundleResource(NSString *bundleResourceFilePath);


#pragma mark -

NSString* ARCNKPathForFileResource(NSString *bundleFilePath);

/*!
 @abstract Returns the documents path concatenated with the given relative path.
 */
NSString* ARCPathForDocumentsResource(NSString *relativePath);


#pragma mark -

NSURL* ARCPathFileURLForBundleResource(NSString *relativePath);
