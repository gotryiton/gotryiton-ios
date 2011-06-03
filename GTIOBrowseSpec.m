//
//  GTIOBrowseSpec.m
//

#import "UISpec.h"
#import "UIExpectation.h"
#import "GTIOCategory.h"

@interface GTIOBrowseSpec : NSObject <UISpec> {}
@end

@implementation GTIOBrowseSpec

- (void)itShouldEscapeTheCategoryAPIEndpoints {
    GTIOCategory* category = [[[GTIOCategory alloc] init] autorelease];
    category.apiEndpoint = @"escape/this/api/endpoint";
    [expectThat(category.escapedAPIEndpoint) should:be(@"escape.this.api.endpoint")];
}

@end

