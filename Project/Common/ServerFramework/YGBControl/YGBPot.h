
/**
 Copyright (c) 2017-present, iDoool, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "YGBDefines.h"
#import <Foundation/Foundation.h>

#define YGB_HEAD                     0x18

#define YGB_CMD_SYS                  0x00
#define YGB_CMD_GET                  0x01
#define YGB_CMD_SET                  0x02
#define YGB_CMD_BIND                 0x03
#define YGB_CMD_NOTI                 0x04
#define YGB_CMD_APP_CTR              0x05
#define YGB_CMD_BLE_CTR              0x06
#define YGB_CMD_APP_DATA             0x07

#define YGB_FUNC_GET_INF1            0x01
#define YGB_FUNC_GET_INF2            0x02
#define YGB_FUNC_GET_PICNUM          0x03
#define YGB_FUNC_GET_PICID           0x04

#define YGB_FUNC_SET_DATE            0x01
#define YGB_FUNC_SET_INF             0x02
#define YGB_FUNC_SET_STATE_MODE      0x03
#define YGB_FUNC_SET_UPDATE          0xdf
#define YGB_FUNC_SET_RESTORE         0x10

#define YGB_FUNC_APP_CTR_TIK_MODE    0x01
#define YGB_FUNC_APP_CTR_SWITCH_MODE 0x02

#define YGB_FUNC_APP_DATA_SAVEPIC    0x6a

#ifdef __cplusplus
#include <iostream>

namespace YGB {
  
  //Base class
  class Pocket
  {
  private:
    uint8_t head;
    uint8_t cmd;
    uint8_t func;
    
  public:
    dispatch_data_t buffer;
    
  public:
    Pocket(uint8_t h,uint8_t c,uint8_t f) YGB_NOTHROW
    {
      head = h;
      cmd  = c;
      func = f;
    }

    virtual ~Pocket(){
      buffer = nil;
    }
    
    uint8_t H(){return this -> head;}
    uint8_t C(){return this -> cmd;}
    uint8_t F(){return this -> func;}
    
    void ConcatData(dispatch_data_t v){
      if(this -> buffer == nil)
      {
        if (v == nil) return;
        this -> buffer = v;
      }else{
        if (v == nil) return;
        this -> buffer = dispatch_data_create_concat(this -> buffer, v);
      }
    }
    void TD8(uint8_t v){
      dispatch_data_t da = dispatch_data_create(&v, sizeof(v), nil, nil);
      this -> ConcatData(da);
    }
    void TD16(uint16_t v){
      dispatch_data_t da = dispatch_data_create(&v, sizeof(v), nil, nil);
      this -> ConcatData(da);
    }
    void TDD(NSData *data){
      __block NSData *strongData = data;
      dispatch_data_t da = dispatch_data_create(data.bytes, data.length, nil, ^{
        strongData = nil;
      });
      this -> ConcatData(da);
    }
    
    NSData * _Transform(){
      __block NSInteger bytesWritten = 0;
      __block size_t totalLength = dispatch_data_get_size(this -> buffer);
      __block NSMutableData *data = [[NSMutableData alloc] initWithLength:0x00];
      dispatch_data_apply(this -> buffer, ^bool(dispatch_data_t region, size_t offset, const void *buffer, size_t size) {
        
        [data appendBytes:buffer length:(NSInteger)size];
        bytesWritten += size;
        return (bytesWritten < (NSInteger)totalLength);
      });
      
      return [data copy];
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> head);
      this -> TD8(this -> cmd);
      this -> TD8(this -> func);
      
      return this -> _Transform();
    }
    
  };
  
  //Get picture id
  class POTGetPicID: Pocket
  {
  public:
    uint8_t position;
    
    POTGetPicID() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_GET,YGB_FUNC_GET_PICID)
    {
      
    }
    
    ~POTGetPicID(){}
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C());
      this -> TD8(this -> F());
      this -> TD8(this -> position);
      
      return this -> _Transform();
    }
    
  };
  
  //Set date
  class POTSetDate: Pocket
  {
  public:
    uint16_t year;
    uint8_t month;
    uint8_t day;
    uint8_t hour;
    uint8_t min;
    uint8_t second;
    
    POTSetDate() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_SET,YGB_FUNC_SET_DATE)
    {
      
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C());
      this -> TD8(this -> F());
      this -> TD16(this -> year);
      this -> TD8(this -> month);
      this -> TD8(this -> day);
      this -> TD8(this -> hour);
      this -> TD8(this -> min);
      this -> TD8(this -> second);
      
      return this -> _Transform();
    }

    ~POTSetDate(){
      std::cout << "~POTSendData(): this has been deleted." << std::endl;
    }
  };
  
  //Set user info
  class POTSetInf: Pocket
  {
  public:
    uint8_t gender;
    uint8_t age;
    uint8_t height;
    uint8_t weight;
    
    POTSetInf() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_SET,YGB_FUNC_SET_INF)
    {
      
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C());
      this -> TD8(this -> F());
      this -> TD8(this -> gender);
      this -> TD8(this -> age);
      this -> TD8(this -> height);
      this -> TD8(this -> weight);
      
      return this -> _Transform();
    }
    
    ~POTSetInf(){}
  };
  
  //Set state mode
  class POTSetStateMode: Pocket
  {
  public:
    uint8_t ctr;
    uint8_t mode;
    uint8_t tik;
    uint8_t R;
    uint8_t G;
    uint8_t B;
    
    POTSetStateMode() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_SET,YGB_FUNC_SET_STATE_MODE)
    {
      
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C());
      this -> TD8(this -> F());
      this -> TD8(this -> ctr);
      this -> TD8(this -> mode);
      this -> TD8(this -> tik);
      this -> TD8(this -> R);
      this -> TD8(this -> G);
      this -> TD8(this -> B);
      
      return this -> _Transform();
    }
    
    ~POTSetStateMode(){}
  };
  
  //Set need update
  class POTSetUpdate: Pocket
  {
  public:
    uint8_t update;
    
    POTSetUpdate() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_SET,YGB_FUNC_SET_UPDATE)
    {
      
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C());
      this -> TD8(this -> F());
      this -> TD8(this -> update);
      
      return this -> _Transform();
    }
    
    ~POTSetUpdate(){}
  };
  
  //Set need update
  class POTSetRestore: Pocket
  {
  public:
    uint8_t restore;
    
    POTSetRestore() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_SET,YGB_FUNC_SET_RESTORE)
    {
      
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C());
      this -> TD8(this -> F());
      this -> TD8(this -> restore);
      
      return this -> _Transform();
    }
    
    ~POTSetRestore(){}
  };
  
  //Set tik mode
  class POTCtrTikMode: Pocket
  {
  public:
    uint8_t mode;
    uint8_t R;
    uint8_t G;
    uint8_t B;
    
    POTCtrTikMode() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_APP_CTR,YGB_FUNC_APP_CTR_TIK_MODE)
    {
      
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C());
      this -> TD8(this -> F());
      this -> TD8(this -> mode);
      this -> TD8(this -> R);
      this -> TD8(this -> G);
      this -> TD8(this -> B);
      
      return this -> _Transform();;
    }
    
    ~POTCtrTikMode(){}
  };
  
  //Switch picture
  class POTCtrSwitchMode: Pocket
  {
  public:
    uint8_t mode;
    
    POTCtrSwitchMode() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_APP_CTR,YGB_FUNC_APP_CTR_SWITCH_MODE)
    {
      
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C());
      this -> TD8(this -> F());
      this -> TD8(this -> mode);
      
      return this -> _Transform();
    }
    
    ~POTCtrSwitchMode(){}
  };
  
  //Send image
  class POTSendData: Pocket
  {
  public:
    uint16_t index;
    uint16_t length;
    uint16_t pic_id;
    NSData *data;
    uint16_t cs;
    
    POTSendData() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_APP_DATA,YGB_FUNC_APP_DATA_SAVEPIC)
    {
      length = 0x00;
      pic_id = 0x00;
      cs     = 0x00;
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C() + this -> F());
      this -> TD8(this -> index);
      if(this -> length != 0x00) this -> TD16(this -> length);
      if(this -> pic_id != 0x00) this -> TD16(this -> pic_id);
      if(this -> data   !=  nil) this -> TDD(this -> data);
      if(this -> cs     != 0x00) this -> TD16(this -> cs);
      
      return this -> _Transform();
    }
    
    ~POTSendData(){
      this -> data = nil;
      std::cout << "~POTSendData(): data has been deleted." << std::endl;
    }
  };
  
  //Get device info 1.
  class POTGetInfoOne: Pocket
  {
  public:
    POTGetInfoOne() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_GET,YGB_FUNC_GET_INF1)
    {
      
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C());
      this -> TD8(this -> F());
      
      return this -> _Transform();
    }
    
    ~POTGetInfoOne(){}
  };
  
  //Get device info 2.
  class POTGetInfoTwo: Pocket
  {
  public:
    POTGetInfoTwo() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_GET,YGB_FUNC_GET_INF2)
    {
      
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C());
      this -> TD8(this -> F());
      
      return this -> _Transform();
    }
    
    ~POTGetInfoTwo(){}
  };
  
  //Get picture num
  class POTGetPicNum: Pocket
  {
  public:
    POTGetPicNum() YGB_NOTHROW:
    Pocket(YGB_HEAD,YGB_CMD_GET,YGB_FUNC_GET_PICNUM)
    {
      
    }
    
    NSData * Transform(){
      
      this -> TD8(this -> H());
      this -> TD8(this -> C());
      this -> TD8(this -> F());
      
      return this -> _Transform();
    }
    
    ~POTGetPicNum(){}
  };
  
}

#endif
