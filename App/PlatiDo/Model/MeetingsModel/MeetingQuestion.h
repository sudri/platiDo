//
//  MeetingQuestion.h
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MeetingQuestionType){

    MeetingQuestionTypeNormal     = 0,
    MeetingQuestionTypeElection   = 1
};

@interface MeetingQuestion : NSObject

@property (strong, nonatomic) NSNumber * questionId;
@property (strong, nonatomic) NSString * title;
@property (assign) MeetingQuestionType   type;


+ (NSArray *)getQuestionsArrayFromDicts:(NSArray *)questionDictArray;


@end
