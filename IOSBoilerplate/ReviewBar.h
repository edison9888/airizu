//
//  ReviewBar.h
//  airizu
//
//  Created by 唐志华 on 13-2-27.
//
//

#import <UIKit/UIKit.h>

@class ReviewItemNetRespondBean;
@interface ReviewBar : UIView {
  
}

// 返回整个评论控件, 所有评论项的值, 字典构成是 (key:code value:分数)
-(NSDictionary *)reviewItemValueDictionary;

#pragma mark - 
#pragma mark 方便构造
+(id)reviewBarWithFrame:(CGRect)frame reviewItemNetRespondBean:(ReviewItemNetRespondBean *)reviewItemNetRespondBean;
@end
