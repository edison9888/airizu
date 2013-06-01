//
//  WriteReviewActivity.h
//  airizu
//
//  Created by 唐志华 on 13-2-26.
//
//

#import "Activity.h"
#import "CustomControlDelegate.h"

UIKIT_EXTERN NSString *const kIntentExtraTagForWriteReviewActivity_OrderID;

@interface WriteReviewActivity : Activity <IDomainNetRespondCallback, CustomControlDelegate, UITextViewDelegate, UIAlertViewDelegate> {
  
}


@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
@property (retain, nonatomic) IBOutlet UIView *bodyLayout;

@property (retain, nonatomic) IBOutlet UIScrollView *bodyScrollView;

// 评论项控件占位容器
@property (retain, nonatomic) IBOutlet UIView *reviewItemControlPlaceholder;
// 写评论控件占位容器(包含 UITextView 和 确定按钮)
@property (retain, nonatomic) IBOutlet UIView *writeReviewControlPlaceholder;
// 写评论 UITextView
@property (retain, nonatomic) IBOutlet UITextView *writeReviewTextView;
// 提交评论按钮
@property (retain, nonatomic) IBOutlet UIButton *submitButton;

@end
