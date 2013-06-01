//
//  RecommendCitiesActivity.h
//  airizu
//
//  Created by 唐志华 on 12-12-25.
//
//  修改记录:
//          1) 20130122 完成第一版本正式代码
//

#import <UIKit/UIKit.h>
#import "CustomControlDelegate.h"

@interface RecommendCitiesActivity : ListActivity <UITableViewDelegate, UITableViewDataSource, IDomainNetRespondCallback, CustomControlDelegate> {
  
}


@property (retain, nonatomic) IBOutlet UIView *bodyLayout;
@end
