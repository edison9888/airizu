//
//  CityListActivityViewController.h
//  airizu
//
//  Created by 唐志华 on 13-1-15.
//
//

#import "ListActivity.h"
#import "CustomControlDelegate.h"

// 选中城市列表 item 之后要进行的操作
UIKIT_EXTERN NSString *const kIntentExtraTagForCityListActivity_SelectTheCityAfterTheOperation;

typedef enum {
  // 立刻开始搜素目标城市的房源
  kSelectTheCityAfterTheOperationEnum_SearchingRoomWithCity = 0,
  // 返回搜索界面
  kSelectTheCityAfterTheOperationEnum_BackToSearchActivity
} SelectTheCityAfterTheOperationEnum;

@interface CityListActivity : ListActivity <IDomainNetRespondCallback, CustomControlDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
  
}

/// title bar
@property (retain, nonatomic) IBOutlet UIView *titleBarPlaceholder;
/// 
@property (retain, nonatomic) IBOutlet UIView *bodyLayout;
/// 城市搜索控件
@property (retain, nonatomic) IBOutlet UISearchBar *citySearchBar;
/// 用户当前所在城市信息 
@property (retain, nonatomic) IBOutlet UIView *userCurrentCityInfoPlaceholder;
/// 城市列表
@property (retain, nonatomic) IBOutlet UITableView *cityTableView;
///


@end
