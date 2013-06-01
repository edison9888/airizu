//
//  SupportingFacilitiyView.h
//  airizu
//
//  Created by 唐志华 on 13-2-12.
//
//

#import <UIKit/UIKit.h>

@interface SupportingFacilitiyView : UIView {
  
}


@property (retain, nonatomic) IBOutlet UILabel *supportingFacilityLabel;

+(id)supportingFacilitiyViewWithName:(NSString *)name;
@end
