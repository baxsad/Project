//
//  YGBPacket.h
//  IDool
//
//  Created by jearoc on 2017/8/1.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (YGBPacket)
- (void)getMode:(nullable unsigned int *)mode
            ctr:(nullable unsigned int *)ctr
            tik:(nullable unsigned int *)tik
            red:(nullable unsigned int *)red
          green:(nullable unsigned int *)green
           blue:(nullable unsigned int *)blue;

- (void)getMode:(nullable unsigned int *)mode
            ctr:(nullable unsigned int *)ctr
            tik:(nullable unsigned int *)tik;
@end

@interface YGBPacket : NSObject


/**
 获取设备某个位置的图片 id

 @param position 位置
 @return NSData
 */
+ (  NSData *)packet_get_pic_id:(uint)position;

/**
 设置设备时间

 @param year 年
 @param month 月
 @param day 日
 @param hour 时
 @param min 分
 @param sec 秒
 @return NSData
 */
+ (  NSData *)packet_set_date_year:(uint)year
                             month:(uint)month
                               day:(uint)day
                              hour:(uint)hour
                               min:(uint)min
                               sec:(uint)sec;

/**
 设置基本信息

 @param gender 性别
 @param age 年龄
 @param height 身高
 @param weight 体重
 @return NSData
 */
+ (  NSData *)packet_set_inf:(uint)gender
                         age:(uint)age
                      height:(uint)height
                      weight:(uint)weight;

/**
 设置设备状态模式

 @param mode 模式
 @return NSData
 */
+ (  NSData *)packet_set_state_mode:(uint)mode
                                ctr:(uint)ctr
                                tik:(uint)tik
                                  R:(uint)R
                                  G:(uint)G
                                  B:(uint)B;

/**
 设置设备更新
 
 @param update 更新
 @return NSData
 */
+ (  NSData *)packet_set_update:(uint)update;

/**
 设置设备恢复出厂设置
 
 @param restore 更新
 @return NSData
 */
+ (  NSData *)packet_set_restore:(uint)restore;

/**
 控制设备闪烁方式

 @param mode 闪烁方式
 @param R R
 @param G G
 @param B B
 @return NSData
 */
+ (  NSData *)packet_set_tik_mode:(uint)mode
                                R:(uint)R
                                G:(uint)G
                                B:(uint)B;

/**
 控制设备切换图片

 @param mode 切换方式
 @return NSData
 */
+ (  NSData *)packet_set_switch_mode:(uint)mode;


/**
 发送图片

 @param index 包下标
 @param length 包长度
 @param picid 图片 id
 @param data 图片数据
 @param cs 校验码
 @return NSData
 */
+ (  NSData *)packet_save_pic:(uint)index
                       length:(uint)length
                        picid:(uint)picid
                         data:(NSData *)data
                           cs:(uint)cs;

/**
 获取设备基本信息（模式，状态，灯闪）

 @return NSData
 */
+ (  NSData *)packet_get_device_inf_one;

/**
 获取设备基本信息（设备id，固件版本，电池状态，电池电量）

 @return NSData
 */
+ (  NSData *)packet_get_device_inf_two;

/**
 获取设备中的图片数量

 @return NSData
 */
+ (  NSData *)packet_get_pic_num;

@end

NS_ASSUME_NONNULL_END
