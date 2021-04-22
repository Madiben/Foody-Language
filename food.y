%baseclass-preinclude "semantics.h"
%lsp-needed

%token ONE TWO THREE FIVE DOZEN
%token LIGHT
%token BURGER SANDWICH MUFFIN CAKE PIZZA
%left PLUS

%union {
    food* food_info;
    int amount;

}

%type<food_info> food;
%type<amount> amount;

%%

start:
    food
    {
        if($1->gluten)
        	std::cerr << "Beware! The food contains gluten." << std::endl;
        if($1->calories > 2000) {
            std::cerr << "That's a lot of calories, you cannot eat that much!" << std::endl;
            error();
        }
        if($1->sugar > 50) {
    	     std::cerr << "Sugar content exceeds the 50g limit!" << std::endl;
            error();
        }
        if($1->type == sweet) {
            std::cout << "OK, that's gonna be " << $1->calories << " sweet calories!" << std::endl;
        }
        else if($1->type == salty) {
            std::cout << "OK, that's gonna be " << $1->calories << " salty calories!" << std::endl;
        }
        else {
            std::cout << "OK, that's gonna be " << $1->calories << " balanced calories!" << std::endl;
        }
    }
;

food:
    amount BURGER
    {
        $$ = new food($1*500,$1*5, salty, true);
    }
|
    amount LIGHT BURGER
    {
        $$ = new food($1*500*0.5,$1*5 ,salty, true);
    }
|
    amount SANDWICH
    {
        $$ = new food($1*200,$1*5, salty, false);
    }
|
    amount LIGHT SANDWICH
    {
        $$ = new food($1*200*0.5,$1*5, salty, false);
    }
|
    amount MUFFIN
    {
        $$ = new food($1*100,$1*10,  sweet, true);
    }
|
    amount LIGHT MUFFIN
    {
        $$ = new food($1*100*0.5, $1*10, sweet, true);
    }
|
    amount CAKE
    {
    	if($1 > 1)
    	{
            std::cerr << "Sorry, but you cannot eat more than one cake at once." << std::endl;
            error();
    	}
        $$ = new food($1*500,$1*20, sweet, false);
    }
|
    amount LIGHT CAKE
    {
    	if($1 > 1)
    	{
            std::cerr << "Sorry, but you cannot eat more than one cake at once." << std::endl;
            error();
    	}
        $$ = new food($1*500*0.5,$1*20, sweet, false);
    }
|
    amount PIZZA
    {
        $$ = new food($1*200,$1*5,  salty, true);
    }
|
    amount LIGHT PIZZA
    {
        $$ = new food($1*200*0.5, $1*5, salty, true);
    }
|
    food PLUS food
    {
        if(($1->type == sweet || $1->type == mixed) && $3->type == salty) {
            std::cerr << "Really? No, you should not eat salty after the sweet..." << std::endl;
            error();
        }
        if($1->type == $3->type) {
            $$ = new food($1->calories + $3->calories,$1->sugar + $3->sugar, $1->type, $1->gluten || $3->gluten);
        }
        else {
            $$ = new food($1->calories + $3->calories,$1->sugar + $3->sugar, mixed, $1->gluten || $3->gluten);
        }
    }
;

amount:
    ONE     { $$ = 1; }
|
    TWO     { $$ = 2; }
|
    THREE   { $$ = 3; }
|
    FIVE    { $$ = 5; }
|
    DOZEN   { $$ = 12; }
;

