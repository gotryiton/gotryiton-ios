// http://www.cocoadev.com/index.pl?BaseSixtyFour

@interface NSData (Base64)

+ (id)gtio_dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)gtio_base64Encoding;

@end