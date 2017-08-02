

#import "NSString+Additions.h"
#import "NSDictionary+Additions.h"



@implementation NSString (RARCAdditions)


+ (NSString*)bodyAsString:(NSData*)body {
	return [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
}


+ (NSString*)newEmpty {
    return [[NSString alloc] init];
}

- (BOOL)isBlank {
  return [[self trimmed] isEmpty];
}

- (BOOL)isEmpty {
  return ([self length] == 0);
}

- (NSString *)presence {
  if([self isBlank]) {
    return nil;
  } else {
    return self;
  }
}


- (BOOL)isDigitOnly {
    NSCharacterSet *numbers = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *trimmedPhoneNumber = [self stringByTrimmingCharactersInSet:numbers];
    
    return [trimmedPhoneNumber isEqualToString:self];
}


- (NSRange)stringRange {
  return NSMakeRange(0, [self length]);
}

- (NSString *)trimmed {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)URLEncodedString {
  NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                           (__bridge CFStringRef)self,
                                                                                           NULL,
                                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                           kCFStringEncodingUTF8);
  return result;
}

- (NSString*)URLDecodedString {
  NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                           (__bridge CFStringRef)self,
                                                                                                           CFSTR(""),
                                                                                                           kCFStringEncodingUTF8);
  return result;
}


- (NSString*)AppendQueryParams:(NSString*)requestUrl queryParams:(NSDictionary*)queryParams {
	if ([queryParams count] > 0) {
		return [NSString stringWithFormat:@"%@?%@", requestUrl, [queryParams URLEncodedStringFromDict]];
	} else {
		return requestUrl;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Returns a string that has been escaped for use as a URL parameter.
 */
- (NSString *)stringByAddingPercentEscapesForURLParameter {
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                (__bridge CFStringRef)self,
                                                                NULL,
                                                                (CFStringRef)@";/?:@&=+$,",
                                                                kCFStringEncodingUTF8);
    
    return result;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Parses a URL, adds query parameters to its query, and re-encodes it as a new URL.
 */
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [query keyEnumerator]) {
        NSString* value = [query objectForKey:key];
        value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }
    
    NSString* params = [pairs componentsJoinedByString:@"&"];
    if ([self rangeOfString:@"?"].location == NSNotFound) {
        return [self stringByAppendingFormat:@"?%@", params];
        
    } else {
        return [self stringByAppendingFormat:@"&%@", params];
    }
}


- (NSDictionary *)queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
	NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
	NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
	NSScanner *scanner = [[NSScanner alloc] initWithString:self];
	
	while (![scanner isAtEnd]) {
		NSString *pairString = nil;
		[scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
		[scanner scanCharactersFromSet:delimiterSet intoString:NULL];
		NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
		
		if (kvPair.count == 2) {
			NSString *key	= [[kvPair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:encoding];
			NSString *value = [[kvPair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:encoding];
			[pairs setObject:value forKey:key];
		}
	}
	return [NSDictionary dictionaryWithDictionary:pairs];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSMutableArray* values = [pairs objectForKey:key];
            if (nil == values) {
                values = [NSMutableArray array];
                [pairs setObject:values forKey:key];
            }
            if (kvPair.count == 1) {
                [values addObject:[NSNull null]];
                
            } else if (kvPair.count == 2) {
                NSString* value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                [values addObject:value];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}



@end
