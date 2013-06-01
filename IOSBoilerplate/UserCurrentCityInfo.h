//
//  UserCurrentCityInfo.h
//  airizu
//
//  Created by 唐志华 on 13-2-26.
//
//

#import <UIKit/UIKit.h>

typedef enum  {
  // 搜索当前城市的房源信息
  kUserCurrentCityInfoActionEnum_SearchCurrentCityRoomInfo = 0
} UserCurrentCityInfoActionEnum;

@protocol CustomControlDelegate;
@interface UserCurrentCityInfo : UIView {
  
}

@property (retain, nonatomic) IBOutlet UILabel *cityNameLabel;

@property (nonatomic, assign) id<CustomControlDelegate> delegate;

-(void)setCityName:(NSString *)cityName;
+(id)userCurrentCityInfoWithCityName:(NSString *)cityName;
@end
