//
//  RoomReviewDatabaseFieldsConstant.h
//  airizu
//
//  Created by 唐志华 on 12-12-28.
//
//

#ifndef airizu_RoomReviewDatabaseFieldsConstant_h
#define airizu_RoomReviewDatabaseFieldsConstant_h

/************      RequestBean       *************/


// 房间ID
#define k_RoomReview_RequestKey_roomId            @"roomId"
// 页数
#define k_RoomReview_RequestKey_pageNum           @"pageNum"




/************      RespondBean       *************/


//
// 评论总条数
#define k_RoomReview_RespondKey_reviewCount       @"reviewCount"
//
// 房间总的平均分
#define k_RoomReview_RespondKey_avgScore          @"avgScore"
//
// 当前房间的评论项
#define k_RoomReview_RespondKey_item              @"item"

//
// 评论列表
#define k_RoomReview_RespondKey_reviews           @"reviews"

// 用户名
#define k_RoomReview_RespondKey_userName          @"userName"
// 用户发表评论的时间
#define k_RoomReview_RespondKey_userReviewTime    @"userReviewTime"
// 评论内容
#define k_RoomReview_RespondKey_userReview        @"userReview"
// 房东回复评论的时间
#define k_RoomReview_RespondKey_hostReviewTime    @"hostReviewTime"
// 房东回复的内容
#define k_RoomReview_RespondKey_hostReview        @"hostReview"

#endif

