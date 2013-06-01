//
//  FreebookToolBar.h
//  airizu
//
//  Created by 唐志华 on 13-1-28.
//
//

#import <UIKit/UIKit.h>
#import "CustomControlDelegate.h"

typedef enum  {
  //
  kFreebookToolBarActionEnum_FreebookButtonClicked = 0
} FreebookToolBarActionEnum;

@interface FreebookToolBar : UIView {
  
}

@property (retain, nonatomic) IBOutlet UILabel *priceLabel;

//
@property (nonatomic, assign) id<CustomControlDelegate> delegate;

+(id)freebookToolBar;

-(void)setRoomPrice:(NSNumber *)price;

@end
