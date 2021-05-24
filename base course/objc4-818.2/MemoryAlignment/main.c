//
//  main.c
//  MemoryAlignment
//
//  Created by miaokii on 2021/3/10.
//

#include <stdio.h>
#include "struct.h"
#include <objc/message.h>
#include <objc/runtime.h>

int main(int argc, const char * argv[]) {
    
    printf("%lu\n", sizeof(Body));
    printf("%lu\n", sizeof(Stu));

    return 0;
}
