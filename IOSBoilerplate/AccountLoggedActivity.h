//
//  AccountLoggedController.h
//  gameqa
//
//  Created by user on 12-9-11.
//
//

#import <UIKit/UIKit.h>
 

@interface AccountLoggedActivity : Activity <IDomainNetRespondCallback, UIAlertViewDelegate>{
  
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;


// 用户头像
@property (retain, nonatomic) IBOutlet UIImageView *userPhotoUIImageView;
// 用户姓名
@property (retain, nonatomic) IBOutlet UILabel *userNameUILabel;
// 用户积分
@property (retain, nonatomic) IBOutlet UILabel *userTotalPointUILabel;
// 当前app本地缓存大小
@property (retain, nonatomic) IBOutlet UILabel *localCacheSizeLabel;



// 订单数量
@property (retain, nonatomic) IBOutlet UILabel *waitConfirmCountUILabel;
@property (retain, nonatomic) IBOutlet UILabel *waitPayCountUILabel;
@property (retain, nonatomic) IBOutlet UILabel *waitLiveCountUILabel;
@property (retain, nonatomic) IBOutlet UILabel *waitReviewCountUILabel;

@end
