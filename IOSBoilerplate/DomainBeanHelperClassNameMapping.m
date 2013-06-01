//
//  DomainBeanHelperClassNameMapping.m
//  airizu
//
//  Created by 唐志华 on 12-12-17.
//
//

#import "DomainBeanHelperClassNameMapping.h"

//

//
#import "RecommendNetRequestBean.h"
#import "RecommendDomainBeanToolsFactory.h"
//
#import "RoomSearchNetRequestBean.h"
#import "RoomSearchDomainBeanToolsFactory.h"

// 2.1 用户注册
#import "RegisterNetResquestBean.h"
#import "RegisterDomainBeanToolsFactory.h"
// 2.2 用户登录
#import "LogonNetRequestBean.h"
#import "LogonDomainBeanToolsFactory.h"
// 2.3 忘记密码
#import "ForgetPasswordNetRequestBean.h"
#import "ForgetPasswordDomainBeanToolsFactory.h"
// 2.4 房间推荐
#import "RecommendNetRequestBean.h"
#import "RecommendDomainBeanToolsFactory.h"
// 2.5 房间搜索
#import "RoomSearchNetRequestBean.h"
#import "RoomSearchDomainBeanToolsFactory.h"
// 2.6 搜索城市
#import "CitysNetRequestBean.h"
#import "CitysDomainBeanToolsFactory.h"
// 2.7 根据城市获取区县
#import "DistrictsNetRequestBean.h"
#import "DistrictsDomainBeanToolsFactory.h"
// 2.8 初始化字典
#import "DictionaryNetRequestBean.h"
#import "DictionaryDomainBeanToolsFactory.h"
// 2.12 房间详情
#import "RoomDetailNetRequestBean.h"
#import "RoomDetailDomainBeanToolsFactory.h"
// 2.14 修改用户信息
 
// 2.15 获取账号首页信息
#import "AccountIndexNetRequestBean.h"
#import "AccountIndexDomainBeanToolsFactory.h"
// 2.16 帮助
#import "HelpNetRequestBean.h"
#import "HelpDomainBeanToolsFactory.h"
// 2.17 登出
#import "LogoutNetRequestBean.h"
#import "LogoutDomainBeanToolsFactory.h"
// 2.18 获得系统通知
#import "SystemMessagesNetRequestBean.h"
#import "SystemMessagesDomainBeanToolsFactory.h"
// 2.19 版本更新

// 2.20 订单预订
#import "FreeBookNetRequestBean.h"
#import "FreeBookDomainBeanToolsFactory.h"
// 2.21 提交订单
#import "OrderSubmitNetRequestBean.h"
#import "OrderSubmitDomainBeanToolsFactory.h"
// 2.22 查看我的订单
#import "OrderOverviewListNetRequestBean.h"
#import "OrderOverviewListDomainBeanToolsFactory.h"
// 2.23 查看订单详情
#import "OrderDetailNetRequestBean.h"
#import "OrderDetailDomainBeanToolsFactory.h"
// 2.24 取消订单
#import "OrderCancelNetRequestBean.h"
#import "OrderCancelDomainBeanToolsFactory.h"
// 2.25 获得房间评论
#import "RoomReviewNetRequestBean.h"
#import "RoomReviewDomainBeanToolsFactory.h"
// 2.26 获取评论项(这个用于 写评论 界面)
#import "ReviewItemNetRequestBean.h"
#import "ReviewItemDomainBeanToolsFactory.h"
// 2.27 对房间进行评论
#import "ReviewSubmitNetRequestBean.h"
#import "ReviewSubmitDomainBeanToolsFactory.h"
// 2.28 房间日历
#import "RoomCalendarNetRequestBean.h"
#import "RoomCalendarDomainBeanToolsFactory.h"
// 2.31 支付
#import "PayInfoNetRequestBean.h"
#import "PayInfoDomainBeanToolsFactory.h"

static const NSString *const TAG = @"<DomainBeanHelperClassNameMapping>";

@implementation DomainBeanHelperClassNameMapping

- (id) init {
	
	if ((self = [super init])) {
		PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
    
    /**
		 * 2.1 用户注册
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([RegisterDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([RegisterNetResquestBean class])];
    
		
		/**
		 * 2.2 用户登录
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([LogonDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([LogonNetRequestBean class])];
    
		
		/**
		 * 2.3 忘记密码
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([ForgetPasswordDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([ForgetPasswordNetRequestBean class])];
    
		
		/**
		 * 2.4 房间推荐
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([RecommendDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([RecommendNetRequestBean class])];
    
		
		/**
		 * 2.5 房间搜索
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([RoomSearchDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([RoomSearchNetRequestBean class])];
    
		
		/**
		 * 2.6 搜索城市
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([CitysDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([CitysNetRequestBean class])];
    
		
		/**
		 * 2.7 根据城市获取区县
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([DistrictsDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([DistrictsNetRequestBean class])];
    
		
		/**
		 * 2.8 初始化字典
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([DictionaryDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([DictionaryNetRequestBean class])];
    
		
		/**
		 * 2.9 获取房屋类型(废弃)
		 */
		
		/**
		 * 2.10 获取出租方式(废弃)
		 */
		
		/**
		 * 2.11 获取房间设施(废弃)
		 */
		
		/**
		 * 2.12 房间详情
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([RoomDetailDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([RoomDetailNetRequestBean class])];
    
		
		/**
		 * 2.13 规则(废弃, 会在 房间详情接口 中返回)
		 */
		
		/**
		 * 2.14 修改用户信息(这个接口因为需要上传 图片, 所以不能使用本框架)
		 */
     		
		/**
		 * 2.15 获取账号首页信息
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([AccountIndexDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([AccountIndexNetRequestBean class])];
    
		
		/**
		 * 2.16 帮助
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([HelpDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([HelpNetRequestBean class])];
    
		
		/**
		 * 2.17 登出
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([LogoutDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([LogoutNetRequestBean class])];
    
		
		/**
		 * 2.18 获得系统通知
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([SystemMessagesDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([SystemMessagesNetRequestBean class])];
    
		
		/**
		 * 2.19 版本更新
		 */
   		
		/**
		 * 2.20 订单预订
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([FreeBookDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([FreeBookNetRequestBean class])];
    
		
		/**
		 * 2.21 提交订单
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([OrderSubmitDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([OrderSubmitNetRequestBean class])];
    
		
		/**
		 * 2.22 查看我的订单
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([OrderOverviewListDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([OrderOverviewListNetRequestBean class])];
    
		
		/**
		 * 2.23 查看订单详情
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([OrderDetailDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([OrderDetailNetRequestBean class])];
    
		
		/**
		 * 2.24 取消订单
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([OrderCancelDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([OrderCancelNetRequestBean class])];
    
		
		/**
		 * 2.25 获得房间评论
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([RoomReviewDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([RoomReviewNetRequestBean class])];
    
		
		/**
		 * 2.26 获取评论项(这个用于 写评论 界面)
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([ReviewItemDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([ReviewItemNetRequestBean class])];
    
		
		/**
		 * 2.27 对房间进行评论
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([ReviewSubmitDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([ReviewSubmitNetRequestBean class])];
    
		
		/**
		 * 2.28 房间日历
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([RoomCalendarDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([RoomCalendarNetRequestBean class])];
    
		
		/**
		 * 2.29 房间推荐(废弃, 统一使用 2.5房间搜索)
		 */
		
		/**
		 * 2.30 筛选和排序(废弃, 统一使用 2.5房间搜索)
		 */
		
		/**
		 * 2.31 地图(废弃, 统一使用 2.5房间搜索)
		 */
		
		/**
		 * 2.31 支付
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([PayInfoDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([PayInfoNetRequestBean class])];
    
	}
	
	return self;
}

- (void) dealloc {
	PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
	
	[super dealloc];
}

@end
