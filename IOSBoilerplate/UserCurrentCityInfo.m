//
//  UserCurrentCityInfo.m
//  airizu
//
//  Created by 唐志华 on 13-2-26.
//
//

#import "UserCurrentCityInfo.h"
#import "CustomControlDelegate.h"

@interface UserCurrentCityInfo ()
@property (nonatomic, assign) BOOL isLoadingView;
@end

@implementation UserCurrentCityInfo

- (void)dealloc {
  [_cityNameLabel release];
  [super dealloc];
}

- (IBAction)searchCurrentCityRoomInfoButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CustomControlDelegate)]) {
    if ([_delegate respondsToSelector:@selector(customControl:onAction:)]) {
      [_delegate customControl:self onAction:kUserCurrentCityInfoActionEnum_SearchCurrentCityRoomInfo];
    }
  }
  
}

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

-(void)setCityName:(NSString *)cityName {
  self.cityNameLabel.text = cityName;
}

+(id)userCurrentCityInfoWithCityName:(NSString *)cityName {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  UserCurrentCityInfo *newControl = [nibObjects objectAtIndex:0];
  newControl.cityNameLabel.text = cityName;
  return newControl;
}


@end
