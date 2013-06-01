//
//  VersionNetRespondBean.h
//  airizu
//
//  Created by 唐志华 on 13-2-17.
//
//

#import <Foundation/Foundation.h>

@interface VersionNetRespondBean : NSObject {
  
}

@property (nonatomic, readonly) NSString *latestVersion;
@property (nonatomic, readonly) NSString *fileSize;
@property (nonatomic, readonly) NSString *updateContent;
@property (nonatomic, readonly) NSString *downloadAddress;

+(id)versionNetRespondBeanWithNewVersion:(NSString *)latestVersion
                             andFileSize:(NSString *)fileSize
                        andUpdateContent:(NSString *)updateContent
                      andDownloadAddress:(NSString *)downloadAddress;
@end