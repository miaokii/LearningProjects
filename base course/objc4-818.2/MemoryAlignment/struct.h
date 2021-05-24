//
//  struct.h
//  MemoryAlignment
//
//  Created by miaokii on 2021/3/10.
//

#ifndef struct_h
#define struct_h

#include <stdio.h>

typedef struct Body {
    int id;         //  4字节   [0-3]
    double weight;  //  8字节   [8-15]
    float height;   //  4字节   [16-29] 对齐 [20-23]
} Body;

typedef struct Stu {
    char name[2];   // 2字节   [0-1]
    int id;         // 4字节   [4-7]
    double score;   // 8字节   [8-15]
    short grade;    // 2字节   [16-17]
    struct Body body;   // 24字节 [24-47]
} Stu;

#endif /* struct_h */
