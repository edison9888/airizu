//
//  RoomDetailParseNetRespondStringToDomainBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RoomDetailParseNetRespondStringToDomainBean.h"

#import "RoomDetailDatabaseFieldsConstant.h"
#import "RoomDetailNetRespondBean.h"

#import "JSONKit.h"
#import "NSString+Expand.h"
#import "NSDictionary+SafeValue.h"

#import "ToolsFunctionForThisProgect.h"

static const NSString *const TAG = @"<RoomDetailParseNetRespondStringToDomainBean>";

@implementation RoomDetailParseNetRespondStringToDomainBean
- (id) init {
	
	if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
	}
	
	return self;
}

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
	[super dealloc];
}

#pragma mark 实现 IParseNetRespondStringToDomainBean 接口
- (id) parseNetRespondStringToDomainBean:(in NSString *) netRespondString {
  do {
    if ([NSString isEmpty:netRespondString]) {
      PRPLog(@"%@-> 入参 netRespondString 为空 !", TAG);
      break;
    }
    
    const char *jsonStringForUTF8 = [netRespondString UTF8String];
		NSError *error = [[NSError alloc] init];
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *jsonRootNSDictionary
    = [jsonDecoder objectWithUTF8String:(const unsigned char *)jsonStringForUTF8
                                 length:(unsigned int)strlen(jsonStringForUTF8)];
    [jsonDecoder release], jsonDecoder = nil;
		[error release], error = nil;
    
    if (![jsonRootNSDictionary isKindOfClass:[NSDictionary class]]) {
      PRPLog(@"%@-> json 解析失败!", TAG);
      break;
    }
    
    // 关键数据字段检测
    BOOL isLostImportantData = NO;
    NSString *defaultValueForString = @"";
    NSNumber *defaultValueForNumber = [NSNumber numberWithBool:NO];
    
    // 房间编号
    NSNumber *number = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_number];
    if (number == nil) {
      isLostImportantData = YES;
      PRPLog(@"%@-> 关键字段丢失 : number", TAG);
      break;
    }
    
    // 用户编号
    NSNumber *userId = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_userId withDefaultValue:defaultValueForNumber];
    // 建筑面积
    NSNumber *size = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_size withDefaultValue:defaultValueForNumber];
    
    // 房间默认图片
    NSString *image = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_image withDefaultValue:defaultValueForString];
    // 每晚价钱
    NSNumber *price = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_price withDefaultValue:defaultValueForNumber];
    // 房间标题
    NSString *title = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_title withDefaultValue:defaultValueForString];
    // 房间地址
    NSString *address = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_address withDefaultValue:defaultValueForString];
    // 百度经度
    NSNumber *len = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_len withDefaultValue:defaultValueForNumber];
    // 百度纬度
    NSNumber *lat = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_lat withDefaultValue:defaultValueForNumber];
    
    // 曾被预定
    NSNumber *scheduled = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_scheduled withDefaultValue:defaultValueForNumber];
    // 卧室数
    NSString *bedRoom = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_bedRoom withDefaultValue:defaultValueForString];
    // 交易规则
    NSString *ruleContent = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_ruleContent withDefaultValue:defaultValueForString];
    ruleContent = [ToolsFunctionForThisProgect transformHtmlStringToTextString:ruleContent];
    // 清洁服务类型
    NSString *clean = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_clean withDefaultValue:defaultValueForString];
    // 房间概括
    NSString *description = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_roomDescription withDefaultValue:defaultValueForString];
    description = [ToolsFunctionForThisProgect transformHtmlStringToTextString:description];
    // 可入住人数
    NSNumber *accommodates = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_accommodates withDefaultValue:defaultValueForNumber];
    // 使用规则
    NSString *roomRule = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_roomRule withDefaultValue:defaultValueForString];
    roomRule = [ToolsFunctionForThisProgect transformHtmlStringToTextString:roomRule];
    // 卫浴类型
    NSString *restRoom = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_restRoom withDefaultValue:defaultValueForString];
    // 是否提供发票1为是,2为否
    NSString *ticketsString = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_tickets withDefaultValue:defaultValueForString];
    BOOL tickets = NO;
    if ([ticketsString isEqualToString:@"1"]) {
      tickets = YES;
    }
    // 退订条款
    NSString *cancellation = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_cancellation withDefaultValue:defaultValueForString];
    // 最少天数
    NSNumber *minNights = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_minNights withDefaultValue:defaultValueForNumber];
    // 租住方式
    NSString *privacy = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_privacy withDefaultValue:defaultValueForString];
    // 退房时间
    NSString *checkOutTime = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_checkOutTime withDefaultValue:defaultValueForString];
    // 最多天数
    NSNumber *maxNights = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_maxNights withDefaultValue:defaultValueForNumber];
    // 床数
    NSNumber *beds = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_beds withDefaultValue:defaultValueForNumber];
    // 房屋类型
    NSString *propertyType = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_propertyType withDefaultValue:defaultValueForString];
    // 床型
    NSString *bedType = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_bedType withDefaultValue:defaultValueForString];
    // 卫生间数
    NSString *bathRoomNum = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_bathRoomNum withDefaultValue:defaultValueForString];
    
    
    // 租客点评总分
    NSNumber *review = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_review withDefaultValue:defaultValueForNumber];
    // 租客点评总条数
    NSNumber *reviewCount = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_reviewCount withDefaultValue:defaultValueForNumber];
    // 租客点评列表，这里只显示1条记录
    NSString *reviewContent = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_reviewContent withDefaultValue:defaultValueForString];
    
    // 是否是100%验证房间，如果不是不显示
    BOOL isVerify = [[jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_isVerify withDefaultValue:defaultValueForNumber] boolValue];
    // 验100%字符串
    NSString *verifyDescription = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_verifyDescription withDefaultValue:defaultValueForString];
    // 是否是特价房间，如果不是不显示
    BOOL isSpecial = NO;
    NSString *specialDescription = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_specialDescription withDefaultValue:defaultValueForString];
    if (![NSString isEmpty:specialDescription]) {
      isSpecial = YES;
    }
    // 是否是速订房间，如果不是不显示，如果既不是100%、特价、速订，删除房间特色栏目
    BOOL isSpeed = [[jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_isSpeed withDefaultValue:defaultValueForNumber] boolValue];
    // 速订字符串
    NSString *speedDescription = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_speedDescription withDefaultValue:defaultValueForString];
    // 是否是精品房间
    BOOL isBoutique = [[jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_roomType withDefaultValue:defaultValueForNumber] boolValue];
    // 精品房介绍
    NSString *boutiqueDescription = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_boutiqueDescription withDefaultValue:defaultValueForString];
    
    // 介绍字符串
    NSString *introduction = [jsonRootNSDictionary safeStringObjectForKey:k_RoomDetail_RespondKey_introduction withDefaultValue:defaultValueForString];
    
    // 大图地址列表
    NSMutableArray *imageMList = [NSMutableArray array];
    NSArray *jsonArrayForImageMList = [jsonRootNSDictionary safeArrayObjectForKey:k_RoomDetail_RespondKey_imageM];
    [imageMList addObjectsFromArray:jsonArrayForImageMList];
    // 缩略图地址列表
    NSMutableArray *imageSList = [NSMutableArray array];
    NSArray *jsonArrayForImageSList = [jsonRootNSDictionary safeArrayObjectForKey:k_RoomDetail_RespondKey_imageS];
    [imageSList addObjectsFromArray:jsonArrayForImageSList];
    // 配套设施列表
    NSMutableArray *equipmentList = [NSMutableArray array];
    NSArray *jsonArrayForEquipmentList = [jsonRootNSDictionary safeArrayObjectForKey:k_RoomDetail_RespondKey_equipmentList];
    [equipmentList addObjectsFromArray:jsonArrayForEquipmentList];
    
    // 房间套数
    NSNumber *roomNumber = [jsonRootNSDictionary safeNumberObjectForKey:k_RoomDetail_RespondKey_roomNumber withDefaultValue:defaultValueForNumber];
    
    return [RoomDetailNetRespondBean roomDetailNetRespondBeanWithNumber:number
                                                                 userId:userId
                                                                   size:size
                                                                  image:image
                                                                  price:price
                                                                  title:title
                                                                address:address
                                                                    len:len
                                                                    lat:lat
                                                              scheduled:scheduled
                                                                bedRoom:bedRoom
                                                            ruleContent:ruleContent
                                                                  clean:clean
                                                            description:description
                                                           accommodates:accommodates
                                                               roomRule:roomRule
                                                               restRoom:restRoom
                                                                tickets:tickets
                                                           cancellation:cancellation
                                                              minNights:minNights
                                                                privacy:privacy
                                                           checkOutTime:checkOutTime
                                                              maxNights:maxNights
                                                                   beds:beds
                                                           propertyType:propertyType
                                                                bedType:bedType
                                                            bathRoomNum:bathRoomNum
                                                                 review:review
                                                            reviewCount:reviewCount
                                                          reviewContent:reviewContent
            
            
                                                               isVerify:isVerify
                                                      verifyDescription:verifyDescription
                                                              isSpecial:isSpecial
                                                     specialDescription:specialDescription
                                                                isSpeed:isSpeed
                                                       speedDescription:speedDescription
                                                             isBoutique:isBoutique
                                                    boutiqueDescription:boutiqueDescription
            
                                                           introduction:introduction
            
                                                                 imageM:imageMList
                                                                 imageS:imageSList
                                                          equipmentList:equipmentList
                                                             roomNumber:roomNumber];
    
  } while (NO);
  
  return nil;
}

@end