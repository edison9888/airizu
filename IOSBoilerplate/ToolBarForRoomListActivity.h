//
//  ToolBarForRoomListActivity.h
//  airizu
//
//  Created by 唐志华 on 12-12-27.
//
//

#import <UIKit/UIKit.h>

@interface ToolBarForRoomListActivity : UIView {
  
}

@property (retain, nonatomic) IBOutlet UIButton *filterButton;
@property (retain, nonatomic) IBOutlet UIButton *sortButton;
@property (retain, nonatomic) IBOutlet UIButton *mapButton;


+ (id) toolBar;

@end
