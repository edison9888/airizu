//
//  MacroConstantForThisProject.h
//  airizu
//
//  Created by 唐志华 on 12-12-27.
//
//

#ifndef airizu_MacroConstantForThisProject_h
#define airizu_MacroConstantForThisProject_h


/******************         服务器返回的错误枚举      *********************/
typedef NS_ENUM(NSInteger, NetErrorCodeWithServerEnum) {
  kNetErrorCodeWithServerEnum_Failed    = 1000, // "操作失败"
  kNetErrorCodeWithServerEnum_Exception = 2000, // "处理异常"
  kNetErrorCodeWithServerEnum_Noresult  = 3000, // "无结果返回"
  kNetErrorCodeWithServerEnum_Needlogin = 4000  // "需要登录"
};

typedef NS_ENUM(NSInteger, UserNotificationEnum) {
  // 用户登录 "成功"
  kUserNotificationEnum_UserLogonSuccess = 2012,
  // 用户已经退出登录
  kUserNotificationEnum_UserLoged,
  // 获取用户当前的坐标 "成功"
  kUserNotificationEnum_GetUserLocationSuccess,
  // 获取用户当前地址 "成功"
  kUserNotificationEnum_GetUserAddressSuccess,
  // 获取软件新版本信息 "成功"
  kUserNotificationEnum_GetNewAppVersionSuccess,
  // 跳转到 "推荐" 页面
  kUserNotificationEnum_GotoRecommendActivity,
  // 跳转到 "搜索" 页面
  kUserNotificationEnum_GotoSearchActivity,
  // 订单支付成功
  kUserNotificationEnum_OrderPaySucceed,
  // 订单支付失败
  kUserNotificationEnum_OrderPayFailed
  
};


typedef NS_ENUM(NSInteger, NewVersionDetectStateEnum) {
  // 还未进行 新版本 检测
  kNewVersionDetectStateEnum_NotYetDetected = 0,
  // 服务器端有新版本存在
  kNewVersionDetectStateEnum_HasNewVersion,
  // 本地已经是最新版本
  kNewVersionDetectStateEnum_LocalAppIsTheLatest
};

/******************         订单状态      *********************/
typedef NS_ENUM(NSInteger, OrderStateEnum) {
  kOrderStateEnum_WaitConfirm = 1, // "待确认"
  kOrderStateEnum_WaitPay     = 2, // "待支付"
  kOrderStateEnum_WaitLive    = 3, // "待入住"
  kOrderStateEnum_WaitComment = 4, // "待评价"
  kOrderStateEnum_HasEnded    = 5  // "已完成"
};


/******************         订单类型      *********************/

// 订单类型
typedef NS_ENUM(NSInteger, OrderTypeEnum) {
  kOrderTypeEnum_Ordinary = 0, // "普通订单"
  kOrderTypeEnum_QuickPay      // "快速支付订单"
};

// 普通订单
#define kOrderTypeEnumValue_Ordinary @"0"
// 快速支付订单
#define kOrderTypeEnumValue_QuickPay @"1"



/******************    房源搜索条件默认值   *********************/
#define kRoomSearchCriteriaDefaultValue_nearby   @"1"
#define kRoomSearchCriteriaDefaultValue_distance @"3000"

/******************    房源列表排序类型     *********************/
// 爱日租推荐
#define kRoomListOrderType_OrderByAirizuCommend    @"tja"
// 价格从高到低
#define kRoomListOrderType_OrderByPriceHeightToLow @"jgd"
// 价格从低到高
#define kRoomListOrderType_OrderByPriceLowToHeight @"jga"
// 评论数量从多到少
#define kRoomListOrderType_OrderByCommendNumber    @"pjd"
// 距离由近到远
#define kRoomListOrderType_OrderByDistance         @"jla"

/*******************       优惠卷类型      *********************/

typedef NS_ENUM(NSInteger, VoucherMethodEnum) {
  // 不使用优惠
  kVoucherMethodEnum_DoNotUsePromotions = 0,
  // VIP优惠
  kVoucherMethodEnum_VipPromotions      = 1,
  // 普通优惠卷
  kVoucherMethodEnum_OrdinaryCoupons    = 2,
  // 现金卷
  kVoucherMethodEnum_CashVolume         = 3,
  
  
  
  // 积分冲抵 (这是项目内自定义的, 跟后台协议无关, 因为目前优惠方式采用了互斥)
  kVoucherMethodEnum_UsePointsToOffset  = 1000
  
};
#endif
