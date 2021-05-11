//
//  ViewController.m
//  kvo
//
//  Created by miaokii on 2021/4/15.
//

#import "ViewController.h"
#import "KVOPerson.h"

@interface ViewController ()

@property (nonatomic, strong) KVOPerson * normalPerson;
@property (nonatomic, strong) KVOPerson * kvoPerson;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSButton * button = [NSButton buttonWithTitle:@"KVO Run" target:self action:@selector(changePerson)];
    
    button.frame = CGRectMake(20, 20, 200, 50);
    [self.view addSubview:button];
    
    self.normalPerson = [[KVOPerson alloc] init];
    self.normalPerson.name = @"Lucy";
    self.normalPerson.age = 20;
    
    self.kvoPerson = [[KVOPerson alloc] init];
    self.kvoPerson.name = @"Zhangfeng";
    self.kvoPerson.age = 20;
    
    NSLog(@"添加KVO前\n", nil);
    [self.kvoPerson objectInfo];
    [self.kvoPerson addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.kvoPerson addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.kvoPerson addObserver:self forKeyPath:@"friends" options:NSKeyValueObservingOptionNew context:nil];
    NSLog(@"添加KVO后\n", nil);
    [self.kvoPerson objectInfo];
}

- (void)changePerson {
    self.kvoPerson.age = 11;
//    [self.kvoPerson.friends addObject:self.normalPerson];
//    [self.kvoPerson setName:@"Lucy"];
//    [self.kvoPerson setValue:@"Lucy" forKey:@"name"];
//    [[self.kvoPerson mutableArrayValueForKey:@"friends"] addObject:self.normalPerson];
}

- (void)dealloc {
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"keypath: %@", keyPath);
    NSLog(@"change: %@", change);
    
}

@end
