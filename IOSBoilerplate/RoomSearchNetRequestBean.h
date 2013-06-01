//
//  RoomSearchNetRequestBean.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#import <Foundation/Foundation.h>

@interface RoomSearchNetRequestBean : NSObject {
  
}

// 二者必须有其一
@property (nonatomic, copy) NSString *cityId;// 城市id
@property (nonatomic, copy) NSString *cityName;// 城市名称

@property (nonatomic, copy) NSString *streetName;// 地标名 (从 2.4 房间推荐 接口 可以获取, 另外可以从搜索界面中获取用户手动输入的
@property (nonatomic, copy) NSString *checkinDate;// 入住时间(2012-01-01)
@property (nonatomic, copy) NSString *checkoutDate;// 退房时间(2012-01-02)
@property (nonatomic, copy) NSString *occupancyCount;// 入住人数(1~10, 10人以上传10)
@property (nonatomic, copy) NSString *roomNumber;// 房间编号
@property (nonatomic, copy) NSString *offset;// 查询从哪行开始
@property (nonatomic, copy) NSString *max;// 查询的数据条数
@property (nonatomic, copy) NSString *priceDifference;// 价格区间 (0-100, 100-200, 200-300, 300 :300以上传300)
@property (nonatomic, copy) NSString *districtName;// 区名称
@property (nonatomic, copy) NSString *districtId;// 区ID
@property (nonatomic, copy) NSString *roomType;// 房屋类型(可在 2.8 初始化字典 接口获取)
@property (nonatomic, copy) NSString *order;// 排序方式(爱日租推荐 "tja", 价格从高到低"jgd", 价格从低到高"jga", 评论从高到低"pjd", 距离由近到远"jla")
@property (nonatomic, copy) NSString *rentType;// 出租方式(可在 2.8 初始化字典接口获取)
@property (nonatomic, copy) NSString *tamenities;// 设施设备(可在 2.8 初始化字典接口获取)
@property (nonatomic, copy) NSString *distance;// 距离筛选( 500 , 1000,3000)

@property (nonatomic, copy) NSString *locationLat;// 纬度
@property (nonatomic, copy) NSString *locationLng;// 经度

@property (nonatomic, copy) NSString *nearby;// 是否是查询 "附近" 的房源(是就 传数字1)

#pragma mark -
#pragma mark 方便构造
+(id)roomSearchNetRequestBean;

@end
