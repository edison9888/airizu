//
//  RoomDetailNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import "RoomDetailNetRespondBean.h"
#import "RoomDetailDatabaseFieldsConstant.h"

static const NSString *const TAG = @"<RoomDetailNetRespondBean>";

@implementation RoomDetailNetRespondBean

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  NSAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
  [_number release];
  [_userId release];
  [_size release];
  [_image release];
  [_price release];
  [_title release];
  [_address release];
  [_len release];
  [_lat release];
  [_scheduled release];
  [_bedRoom release];
  [_ruleContent release];
  [_clean release];
  [_roomDescription release];
  [_accommodates release];
  [_roomRule release];
  [_restRoom release];
  //[_tickets release];
  [_cancellation release];
  [_minNights release];
  [_privacy release];
  [_checkOutTime release];
  [_maxNights release];
  [_beds release];
  [_propertyType release];
  [_bedType release];
  [_bathRoomNum release];
  [_review release];
  [_reviewCount release];
  [_reviewContent release];
  
  
  
  //[_isVerify release];
  [_verifyDescription release];
  //[_specials release];
  [_specialDescription release];
  //[_speed release];
  [_speedDescription release];
  
  
  
  [_introduction release];
  
  [_imageM release];
  [_imageS release];
  [_equipmentList release];
  
  [_roomNumber release];
	
	[super dealloc];
}

- (id) initWithNumber:(NSNumber *)number
               userId:(NSNumber *)userId
                 size:(NSNumber *)size
                image:(NSString *)image
                price:(NSNumber *)price
                title:(NSString *)title
              address:(NSString *)address
                  len:(NSNumber *)len
                  lat:(NSNumber *)lat
            scheduled:(NSNumber *)scheduled
              bedRoom:(NSString *)bedRoom
          ruleContent:(NSString *)ruleContent
                clean:(NSString *)clean
          description:(NSString *)description
         accommodates:(NSNumber *)accommodates
             roomRule:(NSString *)roomRule
             restRoom:(NSString *)restRoom
              tickets:(BOOL)tickets
         cancellation:(NSString *)cancellation
            minNights:(NSNumber *)minNights
              privacy:(NSString *)privacy
         checkOutTime:(NSString *)checkOutTime
            maxNights:(NSNumber *)maxNights
                 beds:(NSNumber *)beds
         propertyType:(NSString *)propertyType
              bedType:(NSString *)bedType
          bathRoomNum:(NSString *)bathRoomNum
               review:(NSNumber *)review
          reviewCount:(NSNumber *)reviewCount
        reviewContent:(NSString *)reviewContent


             isVerify:(BOOL)isVerify
    verifyDescription:(NSString *)verifyDescription
            isSpecial:(BOOL)isSpecial
   specialDescription:(NSString *)specialDescription
              isSpeed:(BOOL)isSpeed
     speedDescription:(NSString *)speedDescription
           isBoutique:(BOOL)isBoutique
  boutiqueDescription:(NSString *)boutiqueDescription

         introduction:(NSString *)introduction

               imageM:(NSArray *)imageM
               imageS:(NSArray *)imageS
        equipmentList:(NSArray *)equipmentList

           roomNumber:(NSNumber *)roomNumber
{
  
  if ((self = [super init])) {
    
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    _number = [number copy];
    _userId = [userId copy];
    _size = [size copy];
    _image = [image copy];
    _price = [price copy];
    _title = [title copy];
    _address = [address copy];
    _len = [len copy];
    _lat = [lat copy];
    _scheduled = [scheduled copy];
    _bedRoom = [bedRoom copy];
    _ruleContent = [ruleContent copy];
    _clean = [clean copy];
    _roomDescription = [description copy];
    _accommodates = [accommodates copy];
    _roomRule = [roomRule copy];
    _restRoom = [restRoom copy];
    _tickets = tickets;
    _cancellation = [cancellation copy];
    _minNights = [minNights copy];
    _privacy = [privacy copy];
    _checkOutTime = [checkOutTime copy];
    _maxNights = [maxNights copy];
    _beds = [beds copy];
    _propertyType = [propertyType copy];
    _bedType = [bedType copy];
    _bathRoomNum = [bathRoomNum copy];
    _review = [review copy];
    _reviewCount = [reviewCount copy];
    _reviewContent = [reviewContent copy];
    
    
    _isVerify = isVerify;
    _verifyDescription = [verifyDescription copy];
    _isSpecial = isSpecial;
    _specialDescription = [specialDescription copy];
    _isSpeed = isSpeed;
    _speedDescription = [speedDescription copy];
    _isBoutique = isBoutique;
    _boutiqueDescription = [boutiqueDescription copy];
    
    _introduction = [introduction copy];
    
    // array
    _imageM = [imageM copy];
    _imageS = [imageS copy];
    _equipmentList = [equipmentList copy];
    
    //
    _roomNumber = [roomNumber copy];
  }
  
  return self;
}

#pragma mark -
#pragma mark 方便构造

+(id)roomDetailNetRespondBeanWithNumber:(NSNumber *)number
                                 userId:(NSNumber *)userId
                                   size:(NSNumber *)size
                                  image:(NSString *)image
                                  price:(NSNumber *)price
                                  title:(NSString *)title
                                address:(NSString *)address
                                    len:(NSNumber *)len
                                    lat:(NSNumber *)lat
                              scheduled:(NSNumber *)scheduled
                                bedRoom:(NSString *)bedRoom
                            ruleContent:(NSString *)ruleContent
                                  clean:(NSString *)clean
                            description:(NSString *)description
                           accommodates:(NSNumber *)accommodates
                               roomRule:(NSString *)roomRule
                               restRoom:(NSString *)restRoom
                                tickets:(BOOL)tickets
                           cancellation:(NSString *)cancellation
                              minNights:(NSNumber *)minNights
                                privacy:(NSString *)privacy
                           checkOutTime:(NSString *)checkOutTime
                              maxNights:(NSNumber *)maxNights
                                   beds:(NSNumber *)beds
                           propertyType:(NSString *)propertyType
                                bedType:(NSString *)bedType
                            bathRoomNum:(NSString *)bathRoomNum
                                 review:(NSNumber *)review
                            reviewCount:(NSNumber *)reviewCount
                          reviewContent:(NSString *)reviewContent

                               isVerify:(BOOL)isVerify
                      verifyDescription:(NSString *)verifyDescription
                              isSpecial:(BOOL)isSpecial
                     specialDescription:(NSString *)specialDescription
                                isSpeed:(BOOL)isSpeed
                       speedDescription:(NSString *)speedDescription
                             isBoutique:(BOOL)isBoutique
                    boutiqueDescription:(NSString *)boutiqueDescription


                           introduction:(NSString *)introduction

                                 imageM:(NSArray *)imageM
                                 imageS:(NSArray *)imageS
                          equipmentList:(NSArray *)equipmentList
                             roomNumber:(NSNumber *)roomNumber {
  
  return [[[RoomDetailNetRespondBean alloc] initWithNumber:number
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
           
                                                    imageM:imageM
                                                    imageS:imageS
                                             equipmentList:equipmentList
                                                roomNumber:roomNumber] autorelease];
  
}

- (NSString *)description {
	return descriptionForDebug(self);
}

-(BOOL)isHaveRoomFeatures {
  do {
    if (_isVerify) {
      break;
    }
    if (_isSpecial) {
      break;
    }
    if (_isSpeed) {
      break;
    }
    if (_isBoutique) {
      break;
    }
    return NO;
  } while (NO);
  
  return YES;
}

#pragma mark -
#pragma mark 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  // 房间编号
  [aCoder encodeObject:_number                forKey:k_RoomDetail_RespondKey_number];
  // 用户编号
  [aCoder encodeObject:_userId                forKey:k_RoomDetail_RespondKey_userId];
  // 建筑面积
  [aCoder encodeObject:_size                  forKey:k_RoomDetail_RespondKey_size];
  // 房间默认图片
  [aCoder encodeObject:_image                 forKey:k_RoomDetail_RespondKey_image];
  // 每晚价钱
  [aCoder encodeObject:_price                 forKey:k_RoomDetail_RespondKey_price];
  // 房间标题
  [aCoder encodeObject:_title                 forKey:k_RoomDetail_RespondKey_title];
  // 房间地址
  [aCoder encodeObject:_address               forKey:k_RoomDetail_RespondKey_address];
  // 百度经度
  [aCoder encodeObject:_len                   forKey:k_RoomDetail_RespondKey_len];
  // 百度纬度
  [aCoder encodeObject:_lat                   forKey:k_RoomDetail_RespondKey_lat];
  // 曾被预定
  [aCoder encodeObject:_scheduled             forKey:k_RoomDetail_RespondKey_scheduled];
  // 卧室数
  [aCoder encodeObject:_bedRoom               forKey:k_RoomDetail_RespondKey_bedRoom];
  // 交易规则
  [aCoder encodeObject:_ruleContent           forKey:k_RoomDetail_RespondKey_ruleContent];
  // 清洁服务类型
  [aCoder encodeObject:_clean                 forKey:k_RoomDetail_RespondKey_clean];
  // 房间概括
  [aCoder encodeObject:_roomDescription       forKey:k_RoomDetail_RespondKey_roomDescription];
  // 可入住人数
  [aCoder encodeObject:_accommodates          forKey:k_RoomDetail_RespondKey_accommodates];
  // 使用规则
  [aCoder encodeObject:_roomRule              forKey:k_RoomDetail_RespondKey_roomRule];
  // 卫浴类型
  [aCoder encodeObject:_restRoom              forKey:k_RoomDetail_RespondKey_restRoom];
  // 是否提供发票1为是,2为否
  [aCoder encodeBool:_tickets                 forKey:k_RoomDetail_RespondKey_tickets];
  // 退订条款
  [aCoder encodeObject:_cancellation          forKey:k_RoomDetail_RespondKey_cancellation];
  // 最少天数
  [aCoder encodeObject:_minNights             forKey:k_RoomDetail_RespondKey_minNights];
  // 租住方式
  [aCoder encodeObject:_privacy               forKey:k_RoomDetail_RespondKey_privacy];
  // 退房时间
  [aCoder encodeObject:_checkOutTime          forKey:k_RoomDetail_RespondKey_checkOutTime];
  // 最多天数
  [aCoder encodeObject:_maxNights             forKey:k_RoomDetail_RespondKey_maxNights];
  // 床数
  [aCoder encodeObject:_beds                  forKey:k_RoomDetail_RespondKey_beds];
  // 房屋类型
  [aCoder encodeObject:_propertyType          forKey:k_RoomDetail_RespondKey_propertyType];
  // 床型
  [aCoder encodeObject:_bedType               forKey:k_RoomDetail_RespondKey_bedType];
  // 卫生间数
  [aCoder encodeObject:_bathRoomNum           forKey:k_RoomDetail_RespondKey_bathRoomNum];
  
  // 租客点评总分
  [aCoder encodeObject:_review                forKey:k_RoomDetail_RespondKey_review];
  // 租客点评总条数
  [aCoder encodeObject:_reviewCount           forKey:k_RoomDetail_RespondKey_reviewCount];
  // 租客点评列表，这里只显示1条记录
  [aCoder encodeObject:_reviewContent         forKey:k_RoomDetail_RespondKey_reviewContent];
  
  // 是否是 "100%验证房"
  [aCoder encodeBool:_isVerify                forKey:k_RoomDetail_RespondKey_isVerify];
  [aCoder encodeObject:_verifyDescription     forKey:k_RoomDetail_RespondKey_verifyDescription];
  // 是否是 "特价房"
  [aCoder encodeBool:_isSpecial               forKey:k_RoomDetail_RespondKey_isSpecial];
  [aCoder encodeObject:_specialDescription    forKey:k_RoomDetail_RespondKey_specialDescription];
  // 是否是 "速定房"
  [aCoder encodeBool:_isSpeed                 forKey:k_RoomDetail_RespondKey_isSpeed];
  [aCoder encodeObject:_speedDescription      forKey:k_RoomDetail_RespondKey_speedDescription];
  // 是否是 "精品房"
  [aCoder encodeBool:_isBoutique              forKey:k_RoomDetail_RespondKey_isBoutique];
  [aCoder encodeObject:_boutiqueDescription   forKey:k_RoomDetail_RespondKey_boutiqueDescription];
  
  // 介绍字符串
  [aCoder encodeObject:_introduction          forKey:k_RoomDetail_RespondKey_introduction];
  // 大图地址列表
  [aCoder encodeObject:_imageM                forKey:k_RoomDetail_RespondKey_imageM];
  // 缩略图地址列表
  [aCoder encodeObject:_imageS                forKey:k_RoomDetail_RespondKey_imageS];
  // 配套设施列表
  [aCoder encodeObject:_equipmentList         forKey:k_RoomDetail_RespondKey_equipmentList];
  // 房间套数
  [aCoder encodeObject:_roomNumber            forKey:k_RoomDetail_RespondKey_roomNumber];
  
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    // 如果有不需要序列化的属性存在时, 可以在这里先进行初始化
    
    // 房间编号
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_number ]) {
      _number  = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_number ] copy];
    }
    // 用户编号
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_userId]) {
      _userId = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_userId] copy];
    }
    // 建筑面积
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_size]) {
      _size = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_size] copy];
    }
    // 房间默认图片
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_image]) {
      _image = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_image] copy];
    }
    // 每晚价钱
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_price]) {
      _price = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_price] copy];
    }
    // 房间标题
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_title]) {
      _title = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_title] copy];
    }
    // 房间地址
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_address]) {
      _address = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_address] copy];
    }
    // 百度经度
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_len]) {
      _len = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_len] copy];
    }
    // 百度纬度
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_lat]) {
      _lat = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_lat] copy];
    }
    // 曾被预定
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_scheduled]) {
      _scheduled = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_scheduled] copy];
    }
    // 卧室数
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_bedRoom]) {
      _bedRoom = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_bedRoom] copy];
    }
    // 交易规则
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_ruleContent]) {
      _ruleContent = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_ruleContent] copy];
    }
    // 清洁服务类型
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_clean]) {
      _clean = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_clean] copy];
    }
    // 房间概括
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_roomDescription]) {
      _roomDescription = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_roomDescription] copy];
    }
    // 可入住人数
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_accommodates]) {
      _accommodates = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_accommodates] copy];
    }
    // 使用规则
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_roomRule]) {
      _roomRule = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_roomRule] copy];
    }
    // 卫浴类型
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_restRoom]) {
      _restRoom = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_restRoom] copy];
    }
    // 是否提供发票1为是,2为否
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_tickets]) {
      _tickets = [aDecoder decodeBoolForKey:k_RoomDetail_RespondKey_tickets];
    }
    // 退订条款
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_cancellation]) {
      _cancellation = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_cancellation] copy];
    }
    // 最少天数
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_minNights]) {
      _minNights = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_minNights] copy];
    }
    // 租住方式
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_privacy]) {
      _privacy = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_privacy] copy];
    }
    // 退房时间
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_checkOutTime]) {
      _checkOutTime = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_checkOutTime] copy];
    }
    // 最多天数
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_maxNights]) {
      _maxNights = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_maxNights] copy];
    }
    // 床数
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_beds]) {
      _beds = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_beds] copy];
    }
    // 房屋类型
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_propertyType]) {
      _propertyType = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_propertyType] copy];
    }
    // 床型
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_bedType]) {
      _bedType = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_bedType] copy];
    }
    // 卫生间数
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_bathRoomNum]) {
      _bathRoomNum = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_bathRoomNum] copy];
    }
    
    // 租客点评总分
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_review]) {
      _review = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_review] copy];
    }
    // 租客点评总条数
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_reviewCount]) {
      _reviewCount = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_reviewCount] copy];
    }
    // 租客点评列表，这里只显示1条记录
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_reviewContent]) {
      _reviewContent = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_reviewContent] copy];
    }
    
    // 是否是 "100%验证房"
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_isVerify]) {
      _isVerify = [aDecoder decodeBoolForKey:k_RoomDetail_RespondKey_isVerify];
    }
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_verifyDescription]) {
      _verifyDescription = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_verifyDescription] copy];
    }
    // 是否是 "特价房"
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_isSpecial]) {
      _isSpecial = [aDecoder decodeBoolForKey:k_RoomDetail_RespondKey_isSpecial];
    }
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_specialDescription]) {
      _specialDescription = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_specialDescription] copy];
    }
    // 是否是 "速定房"
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_isSpeed]) {
      _isSpeed = [aDecoder decodeBoolForKey:k_RoomDetail_RespondKey_isSpeed];
    }
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_speedDescription]) {
      _speedDescription = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_speedDescription] copy];
    }
    // 是否是 "精品房"
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_isBoutique]) {
      _isBoutique = [aDecoder decodeBoolForKey:k_RoomDetail_RespondKey_isBoutique];
    }
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_boutiqueDescription]) {
      _boutiqueDescription = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_boutiqueDescription] copy];
    }
    
    // 介绍字符串
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_introduction]) {
      _introduction = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_introduction] copy];
    }
    // 大图地址列表
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_imageM]) {
      _imageM = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_imageM] copy];
    }
    // 缩略图地址列表
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_imageS]) {
      _imageS = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_imageS] copy];
    }
    // 配套设施列表
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_equipmentList]) {
      _equipmentList = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_equipmentList] copy];
    }
    // 房间套数
    if ([aDecoder containsValueForKey:k_RoomDetail_RespondKey_roomNumber]) {
      _roomNumber = [[aDecoder decodeObjectForKey:k_RoomDetail_RespondKey_roomNumber] copy];
    }
  }
  
  return self;
}

@end