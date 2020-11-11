//
//  KFLCHeartManager.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFLCHeartManager.h"
#import "KFLiveChatParmas.h"
#import "LiveChatRequestBase.h"
#import "KFLiveChatRequest.h"
#import "KFLiveChatMainVC.h"
#import "KFLiveChatManager.h"
#import "LiveChatManager.h"
#import "SPKFUtilities.h"
#import <AVFoundation/AVFoundation.h>
@implementation KFLCHeartManager

{
    NSTimer *timer;
    //创建信号量 设置最多访问资源
    dispatch_semaphore_t semaphore;
    dispatch_queue_t quene;
    int count;
    int interval;
}
+ (instancetype)installManager{
    static KFLCHeartManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KFLCHeartManager alloc] init];
    });
    return manager;
}

-(id)init{
    if (self = [super init]) {
        //创建信号量 设置最多访问资源
          semaphore = dispatch_semaphore_create(3);
          quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

#pragma mark timerAction
- (void)timerAction:(NSTimer *)timer{
    if (_delegate && [_delegate respondsToSelector:@selector(timerActionDelete)]) {
        [_delegate timerActionDelete];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(kfHeartRequestCallBack:)]) {
        dispatch_async(quene, ^{
                [self requestService];
        });
    }
}

#pragma mark 开启定时器
- (void)startTimer{
    if (timer && timer.isValid) {
        [timer invalidate];
    }
    count = 0;
    NSString *heartFeq = [KFLiveChatParmas installParmas].heartFeq;
    interval = [heartFeq intValue];
    if (interval == 0) {
        interval = 2;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
   
}

#pragma mark 关闭定时器
- (void)stopTimer{
    if (timer && timer.isValid) {
        [timer invalidate];
    }
     
        
}
- (void)requestService{
    
    if (interval>0 && count%interval == 0) {
         ++count;
        //设置10秒超时时间
            dispatch_semaphore_wait(semaphore, 10);
            //网络请求
        [KFLiveChatRequest kfLiveChatheartExParam:@"" Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
  
            if (isSuccess) {
                //释放信号量资源
                dispatch_semaphore_signal(semaphore);
                if (![SPKFUtilities isValidDictionary:response] ||
                    ![SPKFUtilities isValidDictionary:response[@"result"]] ||
                    ![SPKFUtilities isValidDictionary:response[@"result"][@"forStaff"]]) {
                    return ;
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(kfHeartRequestCallBack:)]) {
                    [self.delegate kfHeartRequestCallBack:response[@"result"]];
                }
            }else{
                //释放信号量资源
                dispatch_semaphore_signal(semaphore);
            }
        }];
    }else{
        ++count;
    }
    
    
    

    
//        NSString *url = [NSString stringWithFormat:@"%@/public/heart",baseUrl];
//        KFLiveChatParmas *parmas = [KFLiveChatParmas installParmas];
//        parmas.role = @"STAFF";
//        NSMutableDictionary *parmasDic = [parmas getParmas];
//
//        [LiveChatRequestBase AFNPostWihtRUL:url WithParmas:parmasDic success:^(id response) {
//
//            //释放信号量资源
//            dispatch_semaphore_signal(semaphore);
//        } fail:^(id response) {
//
//            //释放信号量资源
//            dispatch_semaphore_signal(semaphore);
//        }];
        
}


#pragma mark 心跳类型处理
+ (void)liveHeartDataType:(NSDictionary *)dic controller:(UIViewController *)controller{
    /**
     ALIDSIGN-数字签名验证；
VALIDSMS-服务码验证；
NOTIFY-通知；
USERHANGUP-客户挂断；
STAFFHANGUP-工作人员挂断；
QUEUE-排队中
CALL-叫号中
ONLINE-工作中
ERROR-系统异常
     */
    if (![SPKFUtilities isValidDictionary:dic]) {
        return;
    }
    NSDictionary *dataDic =  dic[@"forUser"];
    if (![SPKFUtilities isValidDictionary:dataDic]) {
        dataDic = dic[@"forStaff"];
    }
    //用户数据和客服数据都不存在，则return
    if (![SPKFUtilities isValidDictionary:dataDic]) {
        return;
    }
    //获取状态
    NSString *notifyType = dataDic[@"notifyType"];
    if (![SPKFUtilities isValidString:notifyType]) {
        //无对应状态
        return;
    }
    if ([notifyType isEqualToString:@"QUEUE"]) {
        //排队中
        
        
    }else if ([notifyType isEqualToString:@"VALIDSIGN"]){
        //数字签名验证  //改用了VALIDSIGNPLUS，移到H5上签名
        if ([controller respondsToSelector:@selector(showAlertWithType:str:)]) {
            NSString *isSignVertify = dataDic[@"isSignVertify"];
            if ([SPKFUtilities isValidString:isSignVertify] && [isSignVertify isEqualToString:@"1"]) {
               [controller performSelector:@selector(showAlertWithType:str:) withObject:@"1" withObject:@""];
            }
        }
    }else if ([notifyType isEqualToString:@"VALIDSIGNPLUS"]){ //在H5的签名
        if ([controller respondsToSelector:@selector(signwebLoad:)]) {
            NSString *h5url = dataDic[@"h5Url"];
            if ([SPKFUtilities  isValidString:h5url]) {
                [controller performSelector:@selector(signwebLoad:) withObject:h5url];
            }
        }
    }else if ([notifyType isEqualToString:@"VALIDSMS"]){
        //服务密码验证
        if ([controller respondsToSelector:@selector(showAlertWithType:str:)]) {
            NSString *isSignVertify = dataDic[@"isSmsVertify"];
            if ([SPKFUtilities isValidString:isSignVertify] && [isSignVertify isEqualToString:@"1"]) {
                NSString *mobile = dataDic[@"mobile"];
                if ([SPKFUtilities isValidString:mobile]) {
                    [controller performSelector:@selector(showAlertWithType:str:) withObject:@"2" withObject:mobile];
                }else{
                    [controller performSelector:@selector(showAlertWithType:str:) withObject:@"0" withObject:@""];
                }
                
            }
        }
    }else if ([notifyType isEqualToString:@"NOTIFY"]){
        //通知
    }else if ([notifyType isEqualToString:@"USERHANGUP"]){
        //客户挂断
        if ([controller respondsToSelector:@selector(closeLiveChat)]) {
                   
                   [controller performSelector:@selector(closeLiveChat)];
               }
    }else if ([notifyType isEqualToString:@"STAFFHANGUP"]){
        //工作人员挂断 closeLiveChat
       //客户挂断
       if ([controller respondsToSelector:@selector(closeLiveChat)]) {
                  NSString *isHangup = dataDic[@"isHangup"];
            if ([SPKFUtilities isValidString:isHangup] && [isHangup isEqualToString:@"1"]) {
                      [controller performSelector:@selector(closeLiveChat)];
            }        
        }
    }else if ([notifyType isEqualToString:@"CALL"]){
        //用户被呼叫，当客服取号后，用户变为此状态
        if ([controller respondsToSelector:@selector(showDDJTAlert)]) {
            [controller performSelector:@selector(showDDJTAlert)];
        }
    }else if ([notifyType isEqualToString:@"ONLINE"]){
        //上线
        
    }else if ([notifyType isEqualToString:@"OFFLINE"]){
        //下线
        
    }else if ([notifyType isEqualToString:@"DUTY"]){
        //客服等待用户接通，客服叫号后客服变为此状态
        
    }else if ([notifyType isEqualToString:@"BUSY"]){
        //客服接待中，当用户加入聊天室后变为此状态
        
    }else if ([notifyType isEqualToString:@"ERROR"]){
        //系统异常
        
    }else if ([notifyType isEqualToString:@"STAFFCHECK"]){//客服验证用户录入信息,客服显示用户的签名
         NSString *type = dataDic[@"type"];
        if ([SPKFUtilities isValidString:type] && [type isEqualToString:@"USERSIGN"]) {
            if ([controller respondsToSelector:@selector(showKHSignName:)]) {
                      NSDictionary *content = [SPKFUtilities isValidDictionary:dataDic[@"content"]]?dataDic[@"content"]:@{};
                      [controller performSelector:@selector(showKHSignName:) withObject:content];
                  }
        }
      
    } else{
        return;
    }
    
}

+(NSString *)checkAuthor{
    //   判断设备支持不支持照相机
     if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ])
     {
         //   判断设备后置摄像头是否可用
         if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear | UIImagePickerControllerCameraDeviceFront])
         {
            
             //   判断相机功能是否被禁用
             NSString *mediaType = AVMediaTypeVideo;
             
             AVAuthorizationStatus authStatus1 = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
             if(authStatus1 == AVAuthorizationStatusRestricted || authStatus1 == AVAuthorizationStatusDenied){
                 return @"您已禁止掌厅访问该设备的相机，请在设置-隐私-相机中允许掌厅访问相机功能";
                 
                  
             }

         }
         else
         {
             return @"您的设备后置摄像头不可用，请检查您的设备";
            
         }
     }
     else
     {
          return @"您的设备不支持照相机，因此无法使用该功能";
       
     }
        
    
    
    AVAuthorizationStatus authStatus2 = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
      
    if (authStatus2 == AVAuthorizationStatusRestricted ||
        authStatus2 == AVAuthorizationStatusDenied) {
        return @"请在系统设置中开启麦克风服务(设置>江苏掌上营业厅>麦克风>开启)";
    }
    
    
    return @"";
    
    
}


+(void)showToast:(NSString *)text duration:(NSInteger) duration
{
    UIWindow *window;
    if ([KFLiveChatManager installManager].liveWindow) {
        window = [KFLiveChatManager installManager].liveWindow;
    }else if([LiveChatManager installManager].liveWindow){
        window = [LiveChatManager installManager].liveWindow;
    }else{
        return;
    }
  
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]};
    CGSize size = [text boundingRectWithSize:CGSizeMake(kScreen_Width-40, 260) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(15+((kScreen_Width-40)-size.width)/2, (kScreen_Height -size.height-15)/2, size.width+10, size.height+15)];
    tView.userInteractionEnabled = NO;
    tView.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.95];
    tView.layer.cornerRadius = 2.0;
    tView.layer.shadowColor = [UIColor blackColor].CGColor;
    tView.layer.shadowOffset = CGSizeMake(2, 2);
    tView.layer.shadowRadius = 2.0;
    [window addSubview:tView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 7.5, size.width, size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12.0];
    label.text = text;
    [tView addSubview:label];
    [tView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:duration];
}

@end
