//
//  CheckBoxPopupList.m
//  airizu
//
//  Created by 唐志华 on 13-3-4.
//
//

#import "CheckBoxPopupList.h"
#import "CheckBoxPopupListCell.h"






@interface CheckBoxPopupList()

@property (nonatomic, assign) id<CheckBoxPopupListDelegate> delegate;
@property (nonatomic, copy) NSArray *dataSource;


@end








@implementation CheckBoxPopupList
-(NSMutableArray *)selectedCellTexts{
  NSMutableArray *selectedCellTexts = [NSMutableArray array];
  NSArray *cells = [_cellScrollView subviews];
  for (id cell in cells) {
    if ([cell isKindOfClass:[CheckBoxPopupListCell class]]) {
      if (((CheckBoxPopupListCell *)cell).isSelected) {
        NSString *text = [NSString stringWithString:((CheckBoxPopupListCell *)cell).text];
        [selectedCellTexts addObject:text];
      }
    }
  }
  return selectedCellTexts;
}

- (void)dealloc {
  
  ///
  [_dataSource release];
  
  /// UI
  [_cancelButton release];
  [_okButton release];
  [_titleLabel release];
  [_cellScrollView release];
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (IBAction)cancelButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CheckBoxPopupListDelegate)]) {
    [_delegate closeCheckBoxPopupList:self];
  }
  
  [self removeFromSuperview];
}

- (IBAction)okButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(CheckBoxPopupListDelegate)]) {
    [_delegate checkBoxPopupList:self didSelectedCellTexts:self.selectedCellTexts];
  }
  
  [self removeFromSuperview];

}

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

-(void)initCellsFromDataSource:(NSArray *)dataSource{
  CGFloat yOffset = 0;
  int i = 0;
  for (NSString *cellText in dataSource) {
    CheckBoxPopupListCell *cell = [CheckBoxPopupListCell checkBoxPopupListCellWithText:cellText];
    cell.tag = i++;
    cell.delegate = self;
    cell.frame
    = CGRectMake(CGRectGetMinX(cell.frame),
                 yOffset,
                 CGRectGetWidth(cell.frame),
                 CGRectGetHeight(cell.frame));
    [_cellScrollView addSubview:cell];
    yOffset += CGRectGetHeight(cell.frame);
  }
  
  _cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(_cellScrollView.frame), yOffset);
}

#pragma mark -
#pragma mark 方便构造

+(id)checkBoxPopupListWithTitle:(NSString *)title
                     dataSource:(NSArray *)dataSource
                       delegate:(id<CheckBoxPopupListDelegate>)delegate {
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  
  CheckBoxPopupList *newObject = [nibObjects objectAtIndex:0];
  newObject.delegate = delegate;
  newObject.dataSource = [NSArray arrayWithArray:dataSource];
  newObject.titleLabel.text = title;
  
  [newObject initCellsFromDataSource:dataSource];
  return newObject;
}

// 统一设置处于选中状态的 cell 项
-(void)setSelectedCells:(NSArray *)dataSourceForSelectedCells {
  
  NSArray *cells = [_cellScrollView subviews];
  for (id cell in cells) {
    if ([cell isKindOfClass:[CheckBoxPopupListCell class]]) {
      ((CheckBoxPopupListCell *)cell).isSelected = NO;
    }
  }
  
  for (NSString *text in dataSourceForSelectedCells) {
    NSInteger index = [_dataSource indexOfObject:text];
    id cell = [cells objectAtIndex:index];
    if ([cell isKindOfClass:[CheckBoxPopupListCell class]]) {
      ((CheckBoxPopupListCell *)cell).isSelected = YES;
    }
  }
}

-(void)showInView:(UIView*)view{
  [view addSubview:self];
}

-(void)dismiss {
  [self cancelButtonOnClickListener:nil];
}

#pragma mark -
#pragma mark 实现 CustomControlDelegate 协议
-(void)customControl:(id)control onAction:(NSUInteger)action {
  if ([control isKindOfClass:[CheckBoxPopupListCell class]]) {
    CheckBoxPopupListCell *cell = (CheckBoxPopupListCell *)control;
    
    if (kCheckBoxPopupListCellActionEnum_Clicked == action) {
      
      if (0 == cell.tag && cell.isSelected) {
        [self setSelectedCells:[NSArray arrayWithObjects:@"不限", nil]];
      } else {
        id cell = [_cellScrollView.subviews objectAtIndex:0];
        if ([cell isKindOfClass:[CheckBoxPopupListCell class]]) {
          ((CheckBoxPopupListCell *)cell).isSelected = NO;
        }
      }
    }
  }
}
@end
