#ifndef SEMANTICS_H
#define SEMANTICS_H
#include<iostream>
#include<stdlib.h>

enum food_type { salty, sweet, mixed };

struct food {
    int sugar;
    int calories;
    food_type type;
    bool gluten;
    food() {}
    food(int c,int s, food_type t, bool g) : calories(c),sugar(s), type(t), gluten(g) {}
};

#endif
