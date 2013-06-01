//
//  ReviewSubmitNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 13-1-1.
//
//

#import <Foundation/Foundation.h>

@interface ReviewSubmitNetRequestBean : NSObject {
  
}

// 订单编号
@property (nonatomic, readonly) NSString *orderId;
// 评论内容
@property (nonatomic, readonly) NSString *reviewContent;
// 评论项打分
@property (nonatomic, readonly) NSDictionary *reviewItemScoreList;

#pragma mark -
#pragma mark 方便构造

+(id)reviewSubmitNetRequestBeanWithOrderId:(NSString *)orderId
                             reviewContent:(NSString *)reviewContent
                       reviewItemScoreList:(NSDictionary *)reviewItemScoreList;
@end
