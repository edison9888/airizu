//
//  PromoCodeDiscountControl.h
//  airizu
//
//  Created by 唐志华 on 13-3-3.
//
//

#import <UIKit/UIKit.h>

typedef enum  {
  //
  kPromoCodeDiscountControlActionEnum_UpdatePromoCode = 0
} PromoCodeDiscountControlActionEnum;

@protocol CustomControlDelegate;
@interface PromoCodeDiscountControl : UIView <UITextFieldDelegate>{
  
}

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UIView *textFieldLayout;

@property (retain, nonatomic) IBOutlet UITextField *promoCodeTextField;

//
@property (nonatomic, assign) id<CustomControlDelegate> delegate;
// 优惠码
@property (nonatomic, readonly) NSString *promoCode;

+(id)promoCodeDiscountControlWithPromoCode:(NSString *)promoCode;
@end
