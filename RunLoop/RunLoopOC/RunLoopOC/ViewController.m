//
//  ViewController.m
//  RunLoopOC
//
//  Created by miaokii on 2021/5/27.
//

#import "ViewController.h"

@interface ViewController ()<NSMachPortDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handlePortMessage:(NSPortMessage *)message {
    
}

@end
