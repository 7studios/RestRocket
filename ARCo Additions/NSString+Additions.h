


@interface NSString (RARCAdditions)

+ (NSString*)bodyAsString:(NSData*)body;
+ (NSString*)newEmpty;

- (BOOL)isBlank;
- (BOOL)isEmpty;
- (BOOL)isDigitOnly;

- (NSString *)presence;

- (NSRange)stringRange;
- (NSString *)trimmed;

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;


- (NSString*)AppendQueryParams:(NSString*)requestUrl queryParams:(NSDictionary*)queryParams;
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;
- (NSString *)stringByAddingPercentEscapesForURLParameter;

- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding;
- (NSDictionary *)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

@end
