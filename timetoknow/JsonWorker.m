//
//  JsonWorker.m
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "JsonWorker.h"
#import "Categoryy.h"
#import "Subject.h"
#import "Question.h"
#import "Answer.h"
#import "SplashScreenController.h"
#import "School.h"

@implementation JsonWorker

+(void)DownloadAndParseJson{
    
    NSError *error;
    
    NSString *urlString = @"http://mobile.t2ki.co.il/api/all/";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString* newStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //    NSString* path = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"txt"];
    //    NSString* newStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    NSString * strRR = [NSString stringWithFormat:@"%@%@%@", @"{\"categories\":", newStr, @"}"];
    
    NSData *data = [strRR dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* answer = [NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions
                                                             error:&error];
    NSMutableArray *array = [answer objectForKey:@"categories"];
    
    [JsonWorker ParseJson:array];
}

+(void)ParseJson:(NSMutableArray*)array{
    NSMutableArray* categories = [[NSMutableArray alloc]init];
    for (int i = 0; i < [array count]; i++) {//categores
        NSDictionary* dic = [array objectAtIndex:i];
        NSString* image_url = [dic objectForKey:@"image_url"];
        [Static downloadImage:image_url];
        NSString* subtitle = [dic objectForKey:@"subtitle"];
        long idd = [[dic objectForKey:@"id"]longValue];
        NSString* name = [dic objectForKey:@"name"];
        NSMutableArray* temp_subjects = [dic objectForKey:@"subjects"];
        NSMutableArray* subjects = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [temp_subjects count]; i++) {//subjects
            NSDictionary* dic = [temp_subjects objectAtIndex:i];
            NSString* image_url = [dic objectForKey:@"image_url"];
            [Static downloadImage:image_url];
            NSString* subtitle = [dic objectForKey:@"subtitle"];
            long idd = [[dic objectForKey:@"id"]longValue];
            NSString* name = [dic objectForKey:@"name"];
            NSMutableArray* temp_questions = [dic objectForKey:@"questions"];
            NSMutableArray* questions = [[NSMutableArray alloc]init];
            NSMutableArray* questions_vocab = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < [temp_questions count]; i++) {//questions
                NSDictionary* dic = [temp_questions objectAtIndex:i];
                NSString* image_url = [dic objectForKey:@"image_url"];
                [Static downloadImage:image_url];
                NSString* text = [dic objectForKey:@"text"];
                long idd = [[dic objectForKey:@"id"]longValue];
                NSString* kind = [dic objectForKey:@"kind"];
                NSString* failure_text = [dic objectForKey:@"failure_text"];
                NSString* success_text = [dic objectForKey:@"success_text"];
                int solution_number = [[dic objectForKey:@"solution_number"]intValue];
                NSMutableArray* temp_answers = [dic objectForKey:@"answers"];
                NSMutableArray* answers = [[NSMutableArray alloc]init];
                
                for (int i = 0; i < [temp_answers count]; i++) {//answers
                    NSDictionary* dic = [temp_answers objectAtIndex:i];
                    NSString* text = [dic objectForKey:@"text"];
                    NSString* chechedText = [self ValidateChars:text];
                    int number = [[dic objectForKey:@"number"]intValue];
                    Answer* answer = [[Answer alloc]init_with_text:chechedText number:number];
                    [answers addObject:answer];
                }
                
                Question* question = [[Question alloc]init_with_text:text image_url:image_url failure_text:failure_text id:idd success_text:success_text answers:answers solution_number:solution_number];
                if ([kind isEqualToString:@"speech"]) {
                    [questions addObject:question];
                }else{
                    [questions_vocab addObject:question];
                }
            }
            
            Subject* subject = [[Subject alloc]init_with_name:name subtitle:subtitle image_url:image_url id:idd questions:questions questions_vocab:questions_vocab];
            [subjects addObject:subject];
        }
        Categoryy* categoryy = [[Categoryy alloc]init_with_name:name subtitle:subtitle image_url:image_url id:idd subjects:subjects];
        [categories addObject:categoryy];
    }
    [Static setCategories:categories];
    //[self ValidateCategories];
}

+(NSString*)ValidateChars:(NSString*)string{
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char *bytePtr = (unsigned char *)[data bytes];
    NSInteger totalData = [data length] / sizeof(uint8_t);
    for(int i = 0; i < totalData; i++) {
        int asciiCode = bytePtr[i];
        if (asciiCode > 128 || asciiCode < 32) {
            NSLog(@"Fixed wrong char from TalkAbout Server(not onvego)");
            bytePtr[i] = 32;
        }
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+(void)ValidateCategories{
    NSMutableArray* realyCategories = [Static getCategories];
    
    NSError *error;
    
    NSString *urlString = @"http://3diz.com/Html/Demos/Customers/time2know/json/json.txt";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString* newStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSString * strRR = [NSString stringWithFormat:@"%@%@%@", @"{\"categories\":", newStr, @"}"];
    
    NSData *data = [strRR dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* answer = [NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions
                                                             error:&error];
    NSMutableArray *tempCategories = [answer objectForKey:@"categories"];
    for (int i = 0; i < [tempCategories count]; i++) {//categores
        NSDictionary* dic = [tempCategories objectAtIndex:i];
        NSString* name = [dic objectForKey:@"name"];
        
        for (Categoryy* category in realyCategories) {
            if ([name isEqualToString:[category getName]]) {
                NSMutableArray* tempSubjects = [dic objectForKey:@"subjects"];
               
                for (int i = 0; i < [tempSubjects count]; i++) {//subjects
                    NSDictionary* dic = [tempSubjects objectAtIndex:i];
                    NSString* name = [dic objectForKey:@"name"];
                    
                    for (Subject* subject in [category getSubjects]) {
                        if ([name isEqualToString:[subject getName]]) {
                            
                            NSMutableArray* questions_vocab = [[NSMutableArray alloc]init];
                            NSMutableArray* temp_questions_vocab = [dic objectForKey:@"questions_vocab"];
                            for (int i = 0; i < [temp_questions_vocab count]; i++) {//questions_vocab
                                NSDictionary* dic = [temp_questions_vocab objectAtIndex:i];
                                NSString* image_url = [dic objectForKey:@"image_url"];
                                [Static downloadImage:image_url];
                                NSString* text = [dic objectForKey:@"text"];
                                long idd = [[dic objectForKey:@"id"]longValue];
                                NSString* failure_text = [dic objectForKey:@"failure_text"];
                                NSString* success_text = [dic objectForKey:@"success_text"];
                                int solution_number = [[dic objectForKey:@"solution_number"]intValue];
                                NSMutableArray* temp_answers = [dic objectForKey:@"answers"];
                                NSMutableArray* answers = [[NSMutableArray alloc]init];
                                
                                for (int i = 0; i < [temp_answers count]; i++) {//answers
                                    NSDictionary* dic = [temp_answers objectAtIndex:i];
                                    NSString* text = [dic objectForKey:@"text"];
                                    int number = [[dic objectForKey:@"number"]intValue];
                                    Answer* answer = [[Answer alloc]init_with_text:text number:number];
                                    [answers addObject:answer];
                                }
                                
                                Question* question = [[Question alloc]init_with_text:text image_url:image_url failure_text:failure_text id:idd success_text:success_text answers:answers solution_number:solution_number];
                                [questions_vocab addObject:question];
                            }
                            [subject setVocabQuestions:questions_vocab];
                        }
                    }
                }
            }
        }
    }
}

+(void)DownloadAndParseJsonSchools{
    
    NSError *error;
    
    // NSString *urlString = @"http://mobile.t2ki.co.il/api/all/";
    
    NSString *urlString = @"http://3diz.com/Html/Demos/Customers/time2know/json/schools.txt";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString* newStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //        NSString* path = [[NSBundle mainBundle] pathForResource:@"json1" ofType:@"txt"];
    //        NSString* newStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    NSString * strRR = [NSString stringWithFormat:@"%@%@%@", @"{\"schools\":", newStr, @"}"];
    
    NSData *data = [strRR dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* answer = [NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions
                                                             error:&error];
    NSMutableArray *array = [answer objectForKey:@"schools"];
    
    [JsonWorker ParseJsonSchools:array];
}

+(void)ParseJsonSchools:(NSMutableArray*)array{
    NSMutableArray* schools = [[NSMutableArray alloc]init];
    for (int i = 0; i < [array count]; i++) {//schools
        NSDictionary* dic = [array objectAtIndex:i];
        NSString* nameSchool = [dic objectForKey:@"name"];
        NSMutableArray* temp_teachers = [dic objectForKey:@"teachers"];
        NSMutableArray* teachers = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [temp_teachers count]; i++) {//teachers
            NSDictionary* dic = [temp_teachers objectAtIndex:i];
            NSString* teacher = [dic objectForKey:@"name"];
            [teachers addObject:teacher];
        }
        School* school = [[School alloc]init_with_name:nameSchool teachers:teachers];
        [schools addObject:school];
    }
    [Static setSchools:schools];
}



@end
