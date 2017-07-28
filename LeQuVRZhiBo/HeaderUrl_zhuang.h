//
//  HeaderUrl_zhuang.h
//  LeQuVRZhiBo
//
//  Created by 李壮 on 2016/12/14.
//  Copyright © 2016年 lhb. All rights reserved.
//

#ifndef HeaderUrl_zhuang_h
#define HeaderUrl_zhuang_h


#endif /* HeaderUrl_zhuang_h */
///直播页
///获取礼物列表
#define GET_GIFT_LIST_URL @"http://139.224.43.42/funlive/index.php/ApiliveTwo/GiftList"
///获取用户头像昵称
#define GET_USER_NICK_URL @"http://139.224.43.42/funlive/index.php/Rong/headNick?id=%@"
///获取社区评论动态列表
#define GET_COMMUNITY_LIST_URL @"http://139.224.43.42/funlive/index.php/Admin/Apilive/dynCommetlist?did=%@&page=%ld&num=15"
///发表社区评论接口
#define SEND_COMMUNITY_URL @"http://139.224.43.42/funlive/index.php/Admin/Apilive/dynCommet"
///回复评论接口
#define REPLY_COMMUNITY_URL @"http://139.224.43.42/funlive/index.php/Admin/Apilive/reply"
///点赞接口
#define ADD_ZAN_URL @"http://139.224.43.42/funlive/index.php/Admin/Apilive/dynZan?uid=%@&did=%@"
///点赞列表接口
#define ADD_ZAN_LIST_URL @"http://139.224.43.42/funlive/index.php/Admin/Apilive/dynZanlist?did=%@"
///删除回复评论接口
#define DELETE_COMMUNITY_URL @"http://139.224.43.42/funlive/index.php/Admin/Apilive/dynCommetdel?id=%@&uid=%@&did=%@"
///获取关注用户个数
#define GET_CONCERN_URL @"http://139.224.43.42/funlive/index.php/Admin/Apilive/gzCount?fansid=%@"
///获取被关注用户
#define GET_CONCERN_FANS_URL @"http://139.224.43.42/funlive/index.php/Admin/Apilive/bgzCount?uid=%@"
///关注用户接口
#define CONCERN_USER_URL @"http://139.224.43.42/funlive/index.php/Admin/Apilive/fansAdd?uid=%@&fansid=%@"
///取消关注接口
#define CANCLE_CONCERN_URL @"http://139.224.43.42/funlive/index.php/Admin/Apilive/fansDel?uid=%@&fansid=%@"
///查询是否关注该用户接口
#define IS_CONCERN_URL @"http://139.224.43.42/funlive/index.php/Admin/Apilive/cxGz?uid=%@&fansid=%@"
///上传小视频获取七牛云token
#define GET_QINIU_TOKEN_URL @"http://139.224.43.42/funlive/index.php/Admin/Video/v_login"
///发表带小视频说说接口
#define SEND_TALK_URL @"http://139.224.43.42/funlive/index.php/Admin/Video/v_upload?key=%@&uid=%@&img=%@&content=%@"
///上传视频帧数截图
#define UPLOAD_VIDEO_IMAGE_URL @"http://139.224.43.42/funlive/index.php/Admin/Video/uploadios"
///小视频列表
#define SMALL_VIDEO_LIST_URL @"http://139.224.43.42/funlive/index.php/Admin/Video/V_list?uid=%@&page=%ld&num=1"
///删除小视频
#define DELEGATE_VIDEO_URL @"http://139.224.43.42/funlive/index.php/Admin/Video/v_delete?id=%@&key=%@"
///观看小视频增加人数代码
#define ADD_PEOPLE_VIDEO_URL @"http://139.224.43.42/funlive/index.php/Admin/Video/v_count?sid=%@&vid=%@"
