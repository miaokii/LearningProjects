//
//  ViewController.m
//  ClassTest
//
//  Created by miaokii on 2021/3/16.
//

#import "ViewController.h"
#import "runtime.h"
#import "Person.h"

#ifndef MKLog
#define MKLog(FORMAT, ...)\
fprintf(stderr,"%s:%d %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#endif

@interface ViewController ()

@end

@implementation ViewController

+ (void)load {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNumber *num1 = @0xff;
    NSNumber *num2 = @2;
    NSNumber *num3 = @3;
    NSNumber *num4 = @4;
    NSNumber *num5 = @5;
    NSNumber *num6 = @6;
    NSNumber *num7 = @7;
    NSNumber *num8 = @8;
    
    NSString * str1 = [NSString stringWithFormat:@"aaa"];
    NSString * str2 = [NSString stringWithFormat:@"bbbb"];
    NSString * str3 = [NSString stringWithFormat:@"cccc"];
    NSString * str4 = [NSString stringWithFormat:@"d"];
    NSString * str5 = [NSString stringWithFormat:@"e"];
    NSString * str6 = [NSString stringWithFormat:@"f"];
    NSString * str7 = [NSString stringWithFormat:@"g"];
    
    MKLog(@"%p", num1);
    MKLog(@"%p", num2);
    MKLog(@"%p", num3);
    MKLog(@"%p", num4);
    MKLog(@"%p", num5);
    MKLog(@"%p", num6);
    MKLog(@"%p", num7);
    MKLog(@"%p", num8);
    
    MKLog(@"")
    MKLog(@"%p", str1);
    MKLog(@"%p", str2);
    MKLog(@"%p", str3);
    MKLog(@"%p", str4);
    MKLog(@"%p", str5);
    MKLog(@"%p", str6);
    MKLog(@"%p", str7);

    //
    Person * p = [[Person alloc] init];
    p.name = @"康卡";
    p.age = 12;

//    Class pCLass = [Person class];
//
//    unsigned int varCount;
//    Ivar * varList = class_copyIvarList([p class], &varCount);
//    for (int i = 0 ; i < varCount; i++) {
//        Ivar var = varList[i];
//        NSString * name = [NSString stringWithFormat:@"%s", ivar_getName(var)];
//        NSLog(@"%@", name);
//    }

    unsigned int count;
    Method * methods = class_copyMethodList([p class], &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        NSLog(@"%s", sel_getName(method_getName(method)));

    }
}


@end
