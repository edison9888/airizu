//
//  RoomDetailTenantReviewsActivity.h
//  airizu
//
//  Created by 唐志华 on 13-2-11.
//
//

#import "Activity.h"
#import "CustomControlDelegate.h"

UIKIT_EXTERN NSString *const kIntentExtraTagForRoomDetailTenantReviewsActivity_RoomDetailNetRespondBean;

@interface RoomDetailTenantReviewsActivity : Activity <UITableViewDelegate, UITableViewDataSource, IDomainNetRespondCallback, CustomControlDelegate> {
  
}


@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
@property (retain, nonatomic) IBOutlet UIView *bodyLayout;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *freebookToolBarPlaceholder;




@end
