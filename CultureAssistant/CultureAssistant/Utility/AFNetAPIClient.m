//
//  AFNetAPIClient.m
//  AgedCulture
//


#import "AFNetAPIClient.h"

@implementation AFNetAPIClient

+ (instancetype)sharedClient
{
    static AFNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/plain",@"application/octet-stream", nil];
        [_sharedClient.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [_sharedClient.requestSerializer setValue:[DeviceHelper sharedInstance].deviceID forHTTPHeaderField:@"deviceId"];
        [_sharedClient.requestSerializer setValue:@"" forHTTPHeaderField:@"X-KEY"];
        [_sharedClient.requestSerializer setValue:[UIDevice currentDevice].localizedModel forHTTPHeaderField:@"X-TYPE"];
        [_sharedClient.requestSerializer setValue:@"ios" forHTTPHeaderField:@"X-SYSTEM"];
        [_sharedClient.requestSerializer setValue:@"" forHTTPHeaderField:@"X-INFO"];
        
        [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _sharedClient.requestSerializer.timeoutInterval = 10.f;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [_sharedClient.requestSerializer setValue:[[DeviceHelper sharedInstance] getLogParams] forHTTPHeaderField:@"logParams"];
        
    });
    
    return _sharedClient;
}


+ (NSURLSessionDataTask *)GET:(NSString *)Function
                   parameters:(id)parameters
                      success:(void (^)(id JSON, NSError *error))success
                      failure:(void (^)(id JSON, NSError *error))failure
{
    AFNetAPIClient * manager = [self sharedClient];
    
    if ([DeviceHelper sharedInstance].tokenCode){
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"tokenCode=%@",[DeviceHelper sharedInstance].tokenCode] forHTTPHeaderField:@"cookie"];
    }
    
    //    NSLog(@"123 ===\n%@",[manager.requestSerializer HTTPRequestHeaders]);
    
    NSURLSessionDataTask * task = [manager GET:[AFNetAPIBaseURLString stringByAppendingString:Function] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress){
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject){
        
        if (success) {
            
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            aString = [aString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\\\""];
            aString = [aString stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
            aString=[aString stringByReplacingOccurrencesOfString:@"&#183;" withString:@"."];
            
            NSLog(@"\n\n%@ \n\n%@\n\n",[NSString stringWithFormat:@"%@",task.response.URL],aString);
            
            
            DataModel * model = [[DataModel alloc] initWithString:aString error:nil];
            if ([model.code intValue] == 200) {
                success(aString,nil);
                NSString * url = [NSString stringWithFormat:@"%@",task.response.URL];
                NSString* fileName = [self recombinateString:url];
                [self writeDiskWithData:[aString dataUsingEncoding:NSUTF8StringEncoding] Path:fileName];
            }
            else
            {
                NSString * url = [NSString stringWithFormat:@"%@",task.response.URL];
                NSString* fileName = [self recombinateString:url];
                NSString * diskaString = [self readFromDiskWithPath:fileName];
                if (diskaString) {
                    success(diskaString,nil);
                }
                else
                {
                    failure(model.msg,nil);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"get failure error %@",error);
        if (failure) {
            NSString * url = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"NSErrorFailingURLKey"]];
            NSString* fileName = [self recombinateString:url];
            NSString * aString = [self readFromDiskWithPath:fileName];
            if (aString) {
                success(aString,nil);
            }
            else
            {
                failure(@"请求失败",nil);
            }
        }
    }];
    return task;
}

+ (NSURLSessionDataTask *)POST:(NSString *)Function
                    parameters:(id)parameters 
                       success:(void (^)(id JSON, NSError *error))success
                       failure:(void (^)(id JSON, NSError *error))failure
{
    AFNetAPIClient * manager = [self sharedClient];
    
    if ([DeviceHelper sharedInstance].tokenCode){
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"tokenCode=%@",[DeviceHelper sharedInstance].tokenCode] forHTTPHeaderField:@"cookie"];
    }
    return [manager POST:[AFNetAPIBaseURLString stringByAppendingString:Function] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        if (success) {
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            aString = [aString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            aString = [aString stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
            aString = [aString stringByReplacingOccurrencesOfString:@"&#183;" withString:@"."];
            aString = [aString stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
            aString = [aString stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
            
            NSLog(@"\n\n%@ \n\n%@\n\n",[NSString stringWithFormat:@"%@",task.response.URL],aString);
            DataModel * model = [[DataModel alloc] initWithString:aString error:nil];
            if ([model.code intValue] == 200) {
                success(aString,nil);
            }
            else
            {
                /*
                 {"result":"{\"redirect\":\"http://192.168.102.200:8090/api/login/toLogin\"}","code":"000001","success":true,"msg":"未登录"}
                 */
                if ([model.code isEqualToString:@"000001"] || [model.code isEqualToString:@"000005"]) {
                    [[UserInfoManager sharedInstance] deleteUserInfo];
                }
                if (failure)
                {
                    aString = [NSString stringWithFormat:@"{\"result\":%@,\"code\":%@,\"msg\":\"%@\"}",model.result,model.code,model.msg];
                    //                    failure(aString,nil);
                    failure(model,nil);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"AFNetAPIClient post error %@",error.debugDescription);

        failure(@"请求失败",nil);
    }];
}

+ (NSURLSessionDataTask *)PostMediaData:(NSString *)Function
                             parameters:(NSDictionary *) parameters
                              mediaData:(NSArray *)mediaDatas
                                success:(void (^)(id JSON, NSError *error))success
                                failure:(void (^)(id JSON, NSError *error))failure  //上传多媒体
{
    NSLog(@"=============%@/n%@",Function,parameters);
    
    AFNetAPIClient * manager = [self sharedClient];
    
    if ([DeviceHelper sharedInstance].tokenCode){
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"tokenCode=%@",[DeviceHelper sharedInstance].tokenCode] forHTTPHeaderField:@"cookie"];
    }
    return   [manager POST:[AFNetAPIBaseURLString stringByAppendingString:Function] parameters:parameters constructingBodyWithBlock:^(id  _Nonnull formData) {
        
        if (mediaDatas.count >= 2 )
        {
            NSString *firstObj = [mediaDatas objectAtIndex:0];
            NSObject* dataObj = [mediaDatas objectAtIndex:1];
            if ([firstObj isEqualToString:ImageFile])
            {
                NSData *imagedata=[self resetSizeOfImageData:(UIImage *)dataObj maxSize:800];
                [formData appendPartWithFileData:imagedata name:@"file" fileName:@"image1.png" mimeType:@"image/jpeg"];
            }
            else if ([firstObj isEqualToString:MP4File])
            {
                [formData appendPartWithFileData:(NSData *)dataObj name:@"file" fileName:@"video1.mp4" mimeType:@"video/quicktime"];
            }
            else if ([firstObj isEqualToString:MP3File])
            {
                [formData appendPartWithFileData:(NSData *)dataObj name:@"file" fileName:@"audio1.mp3" mimeType:@"audio/mpeg3"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask *task, id JSON) {
        
        NSLog(@"PostMediaData... success");
        
        NSString *aString = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
        aString = [aString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\\\""];
        aString=[aString stringByReplacingOccurrencesOfString:@"&#183;" withString:@"."];
        
        NSLog(@"PostMediaData  \n\n%@\n\n",aString);
        
        DataModel * model = [[DataModel alloc] initWithString:aString error:nil];
        if ([model.code intValue] == 200) {
            success(aString,nil);
        }
        else
        {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            [MBProgressHUD MBProgressHUDWithView:window Str:model.msg];
            if (failure)
            {
                failure(aString,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"PostImage... failure");
        if (failure) {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            [MBProgressHUD MBProgressHUDWithView:window Str:error.description];
            failure(@"请求失败",nil);
        }
    }];
}

#pragma mark-
+ (NSString *)recombinateString:(NSString *)originalStr{
    NSString* modifyStr = @"";
    NSArray* array = [originalStr componentsSeparatedByString:@"&"];
    
    for (NSInteger i = 0; i < array.count; i++){
        NSString *string = array[i];
        NSRange range1 = [string rangeOfString:@"sign"];
        NSRange range2 = [string rangeOfString:@"tokenCode"];
        if (range1.location == NSNotFound && range2.location == NSNotFound) {
            if (i == 0) {
                modifyStr = string;
            }else{
                modifyStr = [modifyStr stringByAppendingString:[NSString stringWithFormat:@"&%@",string]];
            }
        }
    }
    return modifyStr;
}

+(void)writeDiskWithData:(NSData *)data Path:(NSString*)path
{
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    NSString *fullNamespace = @"AFNetApiClient";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *_diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
    
    if (![_fileManager fileExistsAtPath:_diskCachePath]) {
        [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    [_fileManager createFileAtPath:[_diskCachePath stringByAppendingPathComponent:[path stringByReplacingOccurrencesOfString:@"/" withString:@"."]] contents:data attributes:nil];
    
}

+(NSString *)readFromDiskWithPath:(NSString*)path
{
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    NSString *fullNamespace = @"AFNetApiClient";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *_diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
    
    NSString * filePath = [_diskCachePath stringByAppendingPathComponent:[path stringByReplacingOccurrencesOfString:@"/" withString:@"."]];
    
    if ([_fileManager fileExistsAtPath:filePath]) {
        NSString * str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        return str;
    }
    return nil;
}
#pragma mark- 图片有关
//先调整分辨率在计算压缩比例
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}
//2.保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image)
    {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

@end
