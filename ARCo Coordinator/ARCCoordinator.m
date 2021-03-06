
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

#import "ARCCoordinator.h"



@implementation ARCCoordinator

//@synthesize fixtureSerializationClass = _fixtureSerializationClass;
//@synthesize serializationClass = _serializationClass;

@synthesize connectionClass = _connectionClass;
@synthesize coreData = _coreData;
@synthesize bindings = _bindings;
@synthesize router = _router;
@synthesize baseURL = _baseURL;
@synthesize httpUser = _httpUser;
@synthesize httpPassword = _httpPassword;
@synthesize responseKeyPath = _responseKeyPath;
@synthesize serializer = _serializer;
@synthesize fixtureSerializer = _fixtureSerializer;
@synthesize dateFormatter = _dateFormatter;
@synthesize dateFormat = _dateFormat;
@synthesize batchAllRequests = _batchAllRequests;
@synthesize secureAllConnections = _secureAllConnections;

#pragma mark -
# pragma mark Initializations


+ (ARCCoordinator *) sharedInstance {
    
    static dispatch_once_t predicate;
    static ARCCoordinator *_shared = nil;
    
    dispatch_once(&predicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}


- (id) init{
    
    if(self = [super init]){
        
        _baseURL = @"";
        _coreData = [[CKCoreData alloc] init];
        _router = [[CKRouter alloc] init];
        _bindings = [[CKBindings alloc] init];
        _dateFormatter = [[NSDateFormatter alloc] init];
        _connectionClass = [CKNSURLConnection class];
        _serializationClass = [CKJSONKit class];
        _fixtureSerializationClass = [CKJSONKit class];
    }
    
    return self;
}

- (void) dealloc{
    
    RELEASE_SAFELY(_dateFormat);
    RELEASE_SAFELY(_dateFormatter);
    RELEASE_SAFELY(_coreData);
    RELEASE_SAFELY(_router);
    RELEASE_SAFELY(_baseURL);
    RELEASE_SAFELY(_httpUser);
    RELEASE_SAFELY(_httpPassword);
    RELEASE_SAFELY(_responseKeyPath);
    RELEASE_SAFELY(_bindings);
    
    [super dealloc];
}

- (CKManager *) setBaseURL:(NSString *) url user:(NSString *) user password:(NSString *) password{
    
    self.baseURL = url;
    self.httpUser = user;
    self.httpPassword = password;
    
    return self;
}

- (void) setDateFormat:(NSString *)dateFormat{
    
    [_dateFormatter setDateFormat:dateFormat];
    
    RELEASE_SAFELY(_dateFormat);
    _dateFormat = [dateFormat retain];
}

- (NSManagedObjectContext *) managedObjectContext{
    
    return self.coreData.managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel{
    
    return self.coreData.managedObjectModel;
}

- (id) parse:(id) object{
    
    return [self.serializer deserialize:object];
}

- (id) serialize:(id) object{
    
    return [self.serializer serialize:object];
}

- (id) parseFixture:(NSString *) object{
    
    return [self.fixtureSerializer deserialize:[object dataUsingEncoding:NSUTF8StringEncoding]];
}

- (id) serializer{
    
    if(_serializer == nil && _serializationClass != nil)
        _serializer = [[_serializationClass alloc] init];
    
    return _serializer;
}

- (id) fixtureSerializer{
    
    if(_fixtureSerializer == nil && _fixtureSerializationClass != nil)
        _fixtureSerializer = [[_fixtureSerializationClass alloc] init];
    
    return _fixtureSerializer;
}

- (void) sendRequest:(CKRequest *) request{
        
    if(request.batch && [request.connection respondsToSelector:@selector(sendBatchRequest:)])
        [request.connection performSelector:@selector(sendBatchRequest:) withObject:request];
    
    else if(request.batch && !request.isBatched)
        [self sendBatchRequest:request];
    
    else
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [request.connection send:request];
        });
}

- (void) sendBatchRequest:(CKRequest *) request{
    
    __block NSMutableArray *objects = [[NSMutableArray alloc] init];
    __block int pagesComplete = 0;
    
    for(int page = 1; page <= request.batchMaxPages; page++){
        
        CKRequest *pagedRequest = [CKRequest requestWithMap:request.routerMap];
        pagedRequest.isBatched = YES;
        pagedRequest.parseBlock = request.parseBlock;
        pagedRequest.errorBlock = request.errorBlock;
        pagedRequest.batchCurrentPage = page;
        [pagedRequest addParameters:request.parameters];
        
        NSLog(@"%@", [pagedRequest remoteURL]);
        
        pagedRequest.completionBlock = ^(CKResult *result){
            
            for(NSManagedObject *obj in result.objects){
                
                id managedObject = [[CKManager sharedManager].managedObjectContext objectWithID:[obj objectID]];
                                    
                if(managedObject != nil)
                    [objects addObject:managedObject];
            }
            
            pagesComplete++;
            
            if(pagesComplete == request.batchMaxPages){
                
                result.objects = objects;
                
                if(request.completionBlock != nil)
                    request.completionBlock(result);
                
                [objects release];
            }
        }; 
        
        [pagedRequest send];
    }
}

- (CKResult *) sendSyncronousRequest:(CKRequest *) request{
    
    return [request.connection sendSyncronously:request];
}

+ (NSArray *) seedFiles{
    
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle bundleForClass:[self class]] bundlePath], ckSeedPath] error:nil]; 
}

- (BOOL) loadAllSeedFiles{
    
    return [self loadSeedFilesForGroupName:nil];
}

- (BOOL) loadSeedFilesForGroupName:(NSString *) groupName{
    
    return [self loadSeedFiles:[[self class] seedFiles] groupName:groupName];
}

- (BOOL) loadSeedFiles:(NSArray *) files groupName:(NSString *) groupName{
    
    NSError *error = nil;
    
    for(NSString *file in files){
        
        NSString *content = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@", [[NSBundle bundleForClass:[self class]] bundlePath], ckSeedPath, file] encoding:NSUTF8StringEncoding error:&error];
        
        id value = [self parseFixture:content];
        
        if(value == nil){
            
            error = [NSError errorWithDomain:@"com.corekit" code:1 userInfo:[NSDictionary dictionaryWithObject:content forKey:file]];
            continue;
        }
        
        NSMutableString *class = [NSMutableString stringWithString:[[[file stringByDeletingPathExtension] componentsSeparatedByString:@"_"] objectAtIndex:0]];
        
        if([ckCoreDataClassPrefix length] > 0)
            [class replaceOccurrencesOfString:ckCoreDataClassPrefix withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ckCoreDataClassPrefix length])];
        
        Class modelClass = NSClassFromString(class);
        [modelClass removeAll];
        
        if([value isKindOfClass:[NSDictionary class]]){
            
            [value enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                
                if(groupName == nil || (groupName != nil && [groupName isEqualToString:key]))
                    [modelClass build:obj];
            }];
        }
        else if(groupName == nil)
            [modelClass build:value];
        
    }
    
    [CKRecord save];
    
    return error == nil;
}


@end
