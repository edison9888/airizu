//
//  SystemMessageCenterActivity.h
//  airizu
//
//  Created by 唐志华 on 13-2-8.
//
//

#import "ListActivity.h"
#import "CustomControlDelegate.h"

@interface SystemMessageCenterActivity : ListActivity <UITableViewDelegate, UITableViewDataSource, IDomainNetRespondCallback, CustomControlDelegate> {
  
}


@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;



@end
