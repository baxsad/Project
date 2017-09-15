//
//  YGBPacket.m
//  IDool
//
//  Created by jearoc on 2017/8/1.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "YGBPacket.h"
#import "YGBPot.h"

#define _delete(v) { delete v; v= NULL; }

using namespace YGB;

@implementation YGBPacket

+ (  NSData *)packet_get_pic_id:(uint)position
{
  YGB::POTGetPicID *p = new YGB::POTGetPicID();
  p -> position = (uint8_t)position;
  NSData *data = p -> Transform();
  _delete(p);
  
  return [data copy];
}
+ (  NSData *)packet_set_date_year:(uint)year
                             month:(uint)month
                               day:(uint)day
                              hour:(uint)hour
                               min:(uint)min
                               sec:(uint)sec
{
  YGB::POTSetDate *p = new YGB::POTSetDate();
  p -> year   = (uint16_t)year;
  p -> month  = (uint8_t)month;
  p -> day    = (uint8_t)day;
  p -> hour   = (uint8_t)hour;
  p -> min    = (uint8_t)min;
  p -> second = (uint8_t)sec;
  NSData *data = p -> Transform();
  _delete(p);
  
  return [data copy];
}
+ (  NSData *)packet_set_inf:(uint)gender
                         age:(uint)age
                      height:(uint)height
                      weight:(uint)weight
{
  YGB::POTSetInf *p = new YGB::POTSetInf();
  p -> gender = (uint8_t)gender;
  p -> age    = (uint8_t)age;
  p -> height = (uint8_t)height;
  p -> weight = (uint8_t)weight;
  NSData *data = p -> Transform();
  _delete(p);
  
  return [data copy];
}
+ (  NSData *)packet_set_state_mode:(uint)mode
{
  YGB::POTSetStateMode *p = new YGB::POTSetStateMode();
  p -> mode = (uint8_t)mode;
  NSData *data = p -> Transform();
  _delete(p);
  
  return [data copy];
}
+ (  NSData *)packet_set_update:(uint)update
{
  YGB::POTSetUpdate *p = new YGB::POTSetUpdate();
  p -> update = (uint8_t)update;
  NSData *data = p -> Transform();
  _delete(p);
  
  return [data copy];
}
+ (  NSData *)packet_set_restore:(uint)restore
{
  YGB::POTSetRestore *p = new YGB::POTSetRestore();
  p -> restore = (uint8_t)restore;
  NSData *data = p -> Transform();
  _delete(p);
  
  return [data copy];
}
+ (  NSData *)packet_set_tik_mode:(uint)mode
                                R:(uint)R
                                G:(uint)G
                                B:(uint)B
{
  YGB::POTCtrTikMode *p = new YGB::POTCtrTikMode();
  if(R > 255) R = 255;
  if(G > 255) G = 255;
  if(B > 255) B = 255;
  p -> mode = (uint8_t)mode;
  p -> R    = (uint8_t)R;
  p -> G    = (uint8_t)G;
  p -> B    = (uint8_t)B;
  NSData *data = p -> Transform();
  _delete(p);
  
  return [data copy];
}
+ (  NSData *)packet_set_switch_mode:(uint)mode
{
  YGB::POTCtrSwitchMode *p = new YGB::POTCtrSwitchMode();
  p -> mode = (uint8_t)mode;
  NSData *data = p -> Transform();
  _delete(p);
  
  return [data copy];
}
+ (  NSData *)packet_save_pic:(uint)index
                       length:(uint)length
                        picid:(uint)picid
                         data:(NSData *)data
                           cs:(uint)cs
{
  YGB::POTSendData *p = new YGB::POTSendData();
  p -> index  = (uint8_t)index;
  p -> length = (uint16_t)length;
  p -> pic_id = (uint16_t)picid;
  p -> data   = data;
  p -> cs     = (uint16_t)cs;
  NSData *d = p -> Transform();
  _delete(p);
  
  return [d copy];
}
+ (  NSData *)packet_get_device_inf_one
{
  YGB::POTGetInfoOne *p = new YGB::POTGetInfoOne();
  NSData *data = p -> Transform();
  _delete(p);
  
  return [data copy];
}
+ (  NSData *)packet_get_device_inf_two
{
  YGB::POTGetInfoTwo *p = new YGB::POTGetInfoTwo();
  NSData *data = p -> Transform();
  _delete(p);
  
  return [data copy];
}
+ (  NSData *)packet_get_pic_num
{
  YGB::POTGetPicNum *p = new YGB::POTGetPicNum();
  NSData *data = p -> Transform();
  _delete(p);
  
  return [data copy];
}

@end
