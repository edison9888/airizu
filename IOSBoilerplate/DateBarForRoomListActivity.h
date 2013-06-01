//
//  DateBarForRoomListActivity.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//  修改记录:
//          1) 20130122 完成第一版本正式代码
//

#import <UIKit/UIKit.h>

@interface DateBarForRoomListActivity : UIView {
  
}

@property (retain, nonatomic) IBOutlet UILabel *checkinDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *checkoutDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *roomTotalLabel;

+ (id) dateBar;

-(void)setCheckinDate:(NSString *)checkinDate;
-(void)setCheckoutDate:(NSString *)checkoutDate;
-(void)setRoomTotal:(NSString *)roomTotal;
@end
