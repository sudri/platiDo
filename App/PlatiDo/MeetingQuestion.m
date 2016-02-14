//
//  MeetingQuestion.m
//  PlatiDo
//
//  Created by Fedor Semenchenko on 28.10.15.
//  Copyright © 2015 Valera Voroshilov. All rights reserved.
//

#import "MeetingQuestion.h"


@implementation MeetingQuestion

- (MeetingQuestion *)initWithDict:(NSDictionary *)dict{

    MeetingQuestion *newQuestion = [[MeetingQuestion alloc] init];
    
    newQuestion.questionId  = [dict valueForKey:@"id"];
    newQuestion.title       = [dict valueForKey:@"title"];
    
    if ([[dict valueForKey:@"type"] isEqualToString:@"normal"]) {
        newQuestion.type = MeetingQuestionTypeNormal;
    }else{
        newQuestion.type = MeetingQuestionTypeElection;
    }
    
    return newQuestion;
}


+ (NSArray *)getQuestionsArrayFromDicts:(NSArray *)questionDictArray{

    NSMutableArray *resultQuestions = [NSMutableArray new];
    //self.questions = [[NSArray alloc] init]
    for (int i = 0; i < [questionDictArray count]; i++) {
        
        MeetingQuestion *newQuestion = [[MeetingQuestion alloc] initWithDict:questionDictArray[i]];
        [resultQuestions addObject:newQuestion];
    }

    return [[NSArray alloc] initWithArray:resultQuestions];
}

@end
