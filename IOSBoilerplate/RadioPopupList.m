//
//  RadioPopupList.m
//  airizu
//
//  Created by 唐志华 on 13-1-14.
//
//

#import "RadioPopupList.h"









static const NSString *const TAG = @"<RadioPopupList>";
// table cell 的高度
static const NSInteger kCellHeight = 40;
// table cell 被选中时的背景图片尺寸
static const NSInteger kSelectedBackgroundWidthForCell = 251;
static const NSInteger kSelectedBackgroundHeightForCell = 30;








@interface RadioPopupList()

@property (nonatomic, assign) id<RadioPopupListDelegate> delegate;
@property (nonatomic, copy) NSArray *dataSource;
// 当前处于选中状态的 cell 的 index
@property (nonatomic, retain) NSIndexPath *currentSelectedIndexPath;

// 用于设置 默认选中的 cell 的标志位
@property (nonatomic, assign) BOOL isDefaultSelectRowHasBeenSet;
@property (nonatomic, assign) NSInteger defaultSelectedIndex;

@end








@implementation RadioPopupList

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    PRPLog(@"init %@ [0x%x]", TAG, [self hash]);
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

- (void)dealloc {
  PRPLog(@"dealloc: %@ [0x%x]", TAG, [self hash]);
  
  ///
  [_dataSource release];
  [_currentSelectedIndexPath release];
  
  ///
  [_cancelButton release];
  [_okButton release];
  [_titleLabel release];
  [_listviewTable release];
  
  [super dealloc];
}

+ (NSString *) nibName {
  return NSStringFromClass([self class]);
}

+ (UINib *) nib {
  NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
  return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+(id)radioPopupListWithTitle:(NSString *)title
                  dataSource:(NSArray *)dataSource
                    delegate:(id<RadioPopupListDelegate>)delegate {
  
  NSArray *nibObjects = [[self nib] instantiateWithOwner:nil options:nil];
  
  RadioPopupList *newObject = [nibObjects objectAtIndex:0];
  newObject.delegate = delegate;
  newObject.dataSource = [NSArray arrayWithArray:dataSource];
  newObject.titleLabel.text = title;
  newObject.defaultSelectedIndex = 0;// 默认第一行是被选中的
  
  newObject.isDefaultSelectRowHasBeenSet = NO;
  return newObject;
}

-(void)showInView:(UIView*)view{
  [view addSubview:self];
}

-(void)dismiss {
  [self cancelButtonOnClickListener:nil];
}

-(void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex {
  if (defaultSelectedIndex >= [_dataSource count] || defaultSelectedIndex < 0) {
    // 入参错误
    PRPLog(@"%@ setDefaultSelectedIndex:入参错误", TAG);
    return;
  }
  
  _defaultSelectedIndex = defaultSelectedIndex;
}

- (IBAction)cancelButtonOnClickListener:(id)sender {
  if ([_delegate conformsToProtocol:@protocol(RadioPopupListDelegate)]) {
    if ([_delegate respondsToSelector:@selector(closeRadioPopupList:)]) {
      [_delegate closeRadioPopupList:self];
    }
  }
  
  [self removeFromSuperview];
}

- (IBAction)okButtonOnClickListener:(id)sender {
  
  if ([_delegate conformsToProtocol:@protocol(RadioPopupListDelegate)]) {
    if ([_delegate respondsToSelector:@selector(radioPopupList:didSelectRowAtIndex:)]) {
      [_delegate radioPopupList:self didSelectRowAtIndex:_currentSelectedIndexPath.row];
    }
  }
  
  [self removeFromSuperview];
}

- (id)objectAtIndex:(NSUInteger)index {
  if (index >= _dataSource.count) {
    // 访问数组越界
    return nil;
  }
  
  return [_dataSource objectAtIndex:index];
}


#pragma mark -
#pragma mark 实现 UITableViewDataSource 接口

- (NSString *)cellIdentifier {
  return NSStringFromClass([self class]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *) tableView
         cellForRowAtIndexPath:(NSIndexPath *) indexPath {
  
  NSString *cellID = [self cellIdentifier];
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellID] autorelease];
    
    // 设置 自定义的 被选中时的 背景View
    UIImage *backgroundImage = [UIImage imageNamed:@"item_focus_bg_for_popup_list.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    UIView *customSelectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    // 背景图片的坐标
    CGFloat x = (CGRectGetWidth(cell.frame) - kSelectedBackgroundWidthForCell) / 2;
    CGFloat y = (kCellHeight - kSelectedBackgroundHeightForCell) / 2;
    [backgroundImageView setFrame:CGRectMake(x, y, kSelectedBackgroundWidthForCell, kSelectedBackgroundHeightForCell)];
    [customSelectedBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [customSelectedBackgroundView addSubview:backgroundImageView];
    
    cell.selectedBackgroundView = customSelectedBackgroundView;
    [backgroundImageView release];
    [customSelectedBackgroundView release];
    
    
    // 设置自定义的 分割线
   
    UIImage *customSeparatorImage = [UIImage imageNamed:@"separator_for_popup_list.png"];
    UIImageView *customSeparatorView = [[UIImageView alloc] initWithImage:customSeparatorImage];
    customSeparatorView.frame
    = CGRectMake((CGRectGetWidth(cell.frame) - customSeparatorImage.size.width) / 2,
                 kCellHeight - 1,// 20130305 一定要高度减1, 否则会被下面的覆盖
                 customSeparatorImage.size.width,
                 1);
    [cell addSubview:customSeparatorView];
    [customSeparatorView release];
     
  }
  
  // 设置默认处于选中状态的 cell
  if (!_isDefaultSelectRowHasBeenSet) {
    
    _isDefaultSelectRowHasBeenSet = YES;
    
    // 默认选中第一行
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_defaultSelectedIndex inSection:0];
    [tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //
    self.currentSelectedIndexPath = [NSIndexPath indexPathForRow:_defaultSelectedIndex inSection:0];
  }
  
  //
  cell.selectionStyle = UITableViewCellSelectionStyleGray;
  cell.textLabel.textAlignment = UITextAlignmentCenter;
  cell.textLabel.font = [UIFont systemFontOfSize:15];
  cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
  
  return cell;
}

#pragma mark -
#pragma mark 实现 UITableViewDelegate 接口

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  self.currentSelectedIndexPath = indexPath;
  
}

// 这个方法是返回每个 item 的高度, 这里不能调用 [tableView numberOfRowsInSection:] 会引起死循环
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return kCellHeight;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *) tableView
            editingStyleForRowAtIndexPath:(NSIndexPath *) indexPath {
  
  // 去掉右边的 delete 按钮
  return UITableViewCellEditingStyleNone;
}

@end
