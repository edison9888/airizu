//
//  OrderDetailBody.h
//  airizu
//
//  Created by 唐志华 on 13-2-3.
//
//

#import <UIKit/UIKit.h>

#import "CustomControlDelegate.h"

typedef enum  {
  // 支付订单
  kOrderDetailBodyActionEnum_ToPayButtonClicked = 0,
  // 评论订单
  kOrderDetailBodyActionEnum_ToReviewButtonClicked,
  // 管理订单
  kOrderDetailBodyActionEnum_ManageOrderButtonClicked,
  // 取消订单
  kOrderDetailBodyActionEnum_CancelOrderButtonClicked,
  // 跳转到房间详情
  kOrderDetailBodyActionEnum_ToRoomDetailButtonClicked,
  // 房东电话
  kOrderDetailBodyActionEnum_HostPhoneButtonClicked,
  // 房东备用电话
  kOrderDetailBodyActionEnum_HostBackupPhoneButtonClicked
  
} OrderDetailBodyActionEnum;

@class OrderDetailNetRespondBean;
@interface OrderDetailBody : UIView {
  
}

///
// 订单状态提示内容
@property (retain, nonatomic) IBOutlet UILabel *statusContentLabel;

///
// 功能按钮 1
@property (retain, nonatomic) IBOutlet UIButton *functionButton1;

///
// 房东信息 布局
@property (retain, nonatomic) IBOutlet UIView *hostInforLayout;
// 房东姓名
@property (retain, nonatomic) IBOutlet UILabel *hostNameLabel;
// 房东手机 布局
@property (retain, nonatomic) IBOutlet UIView *hostPhoneLayout;
// 房东手机
@property (retain, nonatomic) IBOutlet UILabel *hostPhoneLabel;
// 房东备用电话 布局
@property (retain, nonatomic) IBOutlet UIView *hostBackupPhoneLayout;
// 房东备用电话
@property (retain, nonatomic) IBOutlet UILabel *hostBackupPhoneLabel;

///
// 订单详情布局
@property (retain, nonatomic) IBOutlet UIView *orderDetailLayout;
// 房间默认照片
@property (retain, nonatomic) IBOutlet UIImageView *roomPhotoImageView;
// 房间标题
@property (retain, nonatomic) IBOutlet UILabel *roomTitleLabel;
// 房间地址
@property (retain, nonatomic) IBOutlet UILabel *roomAddressLabel;

///
// 订单编号
@property (retain, nonatomic) IBOutlet UILabel *orderIdLabel;
// 入住时间
@property (retain, nonatomic) IBOutlet UILabel *checkInDateLabel;
// 退房时间
@property (retain, nonatomic) IBOutlet UILabel *checkOutDateLabel;
// 入住人数
@property (retain, nonatomic) IBOutlet UILabel *guestNumberLabel;

///
// 预付定金
@property (retain, nonatomic) IBOutlet UILabel *pricePerNightLabel;
// 线下支付
@property (retain, nonatomic) IBOutlet UILabel *linePayLabel;
// 订单总额
@property (retain, nonatomic) IBOutlet UILabel *subPriceLabel;

///
// 功能按钮 2
@property (retain, nonatomic) IBOutlet UIButton *functionButton2;

//
@property (nonatomic, assign) id<CustomControlDelegate> delegate;

+(id)orderDetailBodyWithOrderDetailNetRespondBean:(OrderDetailNetRespondBean *)orderDetailNetRespondBean isNewOrder:(BOOL)isNewOrder;

@end
