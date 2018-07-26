//
//  RequestHelper.h
//  AgedCulture
//


#import <Foundation/Foundation.h>

@interface RequestHelper : NSObject

+ (instancetype)sharedInstance;

- (NSDictionary *)prepareRequestparameter:(NSDictionary *)dic;
@end
