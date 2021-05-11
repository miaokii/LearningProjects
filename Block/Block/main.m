//
//  main.m
//  Block
//
//  Created by miaokii on 2021/4/19.
//

#import <Foundation/Foundation.h>
#import <math.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        
        __block int bla = 12;
        void (^blockBla)(void) = ^{
            NSLog(@"bla = %d", bla);
        };
        bla = 20;
        blockBla();
    }
    return 0;
}
 
