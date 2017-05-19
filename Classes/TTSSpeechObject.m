//
//  TTSSpeechObject.m
//  SmartCity
//
//  Created by hoperun on 2017/3/24.
//  Copyright © 2017年 sea. All rights reserved.
//

#import "TTSSpeechObject.h"

static TTSSpeechObject *ttsObject = nil;
@implementation TTSSpeechObject

+ (instancetype)shareTTSSpeech{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ttsObject = [[TTSSpeechObject alloc]init];
    });
    
    return ttsObject;
}

//初始化
- (id)init{
    
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

//语音播报
+ (void)speechVoice:(NSString *)content{
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:content];
    
    utterance.pitchMultiplier = 0.7;//音调基准线。默认为1
    
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    
    utterance.voice = voice;
    
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc]init];
    
    [synth speakUtterance:utterance];
}

//后台语音播报配置
+ (void)backGroundVoiceConfig{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDuckOthers error:&error];
    
    [session setActive:YES error:&error];
}
@end
