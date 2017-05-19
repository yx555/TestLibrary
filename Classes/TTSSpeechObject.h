//
//  TTSSpeechObject.h
//  SmartCity
//
//  Created by hoperun on 2017/3/24.
//  Copyright © 2017年 sea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TTSSpeechObject : NSObject

/**
 *  单例类
 */
+ (instancetype)shareTTSSpeech;

/**
 *  语音播报
 */
+ (void)speechVoice:(NSString *)content;

/**
 *  后台播放语音配置
 */
+ (void)backGroundVoiceConfig;
@end
