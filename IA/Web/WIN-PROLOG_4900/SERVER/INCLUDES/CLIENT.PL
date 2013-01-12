/*
   Meal Selection Example - (c) Brian D Steel, Jan 1988 / 10 Apr 06
   ----------------------------------------------------------------

   This program is designed to help you select meals of various sorts from
   a database of dishes. The normal interface to the programs is via the
   front-end relation 'menu', which is called as follows:

      ?- menu(type_of_meal).

   where 'type_of_meal' is one of:

      any_meal     - any combination of starter, main course, dessert and wine
      good_meal    - starter, main course and wine which complement each other
      cheap_meal   - any meal costing less than £15
      yuppie_meal  - a good meal costing more than £30
      diet_meal    - any meal containing fewer than 650 calories
      glutton_meal - a good meal containing more than 1500 calories
*/

% use the INT386W predicate input/2 to read a type of meal

menu :-
  input( `Do you want meals of type:`, Input ),
  read( Meal ) <~ Input,
  menu( Meal ).

% display a meal of the given type at the console

menu( Meal ) :-
  Meal( Starter, Main, Dessert, Wine ),
  cost( Starter, Main, Dessert, Wine, Cost ),
  energy( Starter, Main, Dessert, Wine, Calories ),
  write( `~M~JToday's delicious choice of ` ),
  write( Meal ),
  write( ` menus` ),
  write( `~M~J~M~JStarter:~I~I` ),
  write( Starter ),
  write( `~M~J~I-oOo-~M~JMain Course:~I` ),
  write( Main ),
  write( `~M~J~I-oOo-~M~JDessert:~I~I` ),
  write( Dessert ),
  write( `~M~J~I-oOo-~M~JWine:~I~I` ),
  write( Wine ),
  write( `~M~J~M~Jprice:~I£` ),
  fwrite( f, 5, 2, Cost ),
  write( `~Icalories:~I` ),
  fwrite( i, 5, 0, Calories ),
  write( `~M~J` ).

% any old meal consists of a starter, main dish, dessert and wine

any_meal( Starter, Main, Dessert, Wine ) :-
  starter( Starter ),
  main( Main ),
  dessert( Dessert ),
  wine( Wine ).

% a good meal is one where the starter and wine are ok with the main dish

good_meal( Starter, Main, Dessert, Wine ) :-
  any_meal( Starter, Main, Dessert, Wine ),
  starter_ok( Starter, Main ),
  wine_ok( Wine, Main ).

% a cheap meal is any meal costing less than £15

cheap_meal( Starter, Main, Dessert, Wine ) :-
  any_meal( Starter, Main, Dessert, Wine ),
  cost( Starter, Main, Dessert, Wine, Cost ),
  Cost < 15.

% a yuppie meal must be a good meal costing more than £30

yuppie_meal( Starter, Main, Dessert, Wine ) :-
  good_meal( Starter, Main, Dessert, Wine ),
  cost( Starter, Main, Dessert, Wine, Cost ),
  Cost > 30.

% a diet meal is any meal with fewer than 650 calories

diet_meal( Starter, Main, Dessert, Wine ) :-
  any_meal( Starter, Main, Dessert, Wine ),
  energy( Starter, Main, Dessert, Wine, Calories ),
  Calories < 650.

% a glutton meal must be a good one with over 1500 calories

glutton_meal( Starter, Main, Dessert, Wine ) :-
  good_meal( Starter, Main, Dessert, Wine ),
  energy( Starter, Main, Dessert, Wine, Calories ),
  Calories > 1500.

% a starter is ok if it is not the same type of dish as the main course

starter_ok( Starter, Main ) :-
  dish_type( Starter, Type ),
  not dish_type( Main, Type ).

% white wines are ok with fish and poultry, and red ones with meat

wine_ok( Wine, Main ) :-
  colour( Wine, white ),
  dish_type( Main, poultry ).

wine_ok( Wine, Main ) :-
  colour( Wine, white ),
  dish_type( Main, fish ).

wine_ok( Wine, Main ) :-
  colour( Wine, red ),
  dish_type( Main, meat ).

% the cost of a meal is the price plus 17.5% vat and 10% service charge

cost( Starter, Main, Dessert, Wine, Cost ) :-
  price( Starter, Prc1 ),
  price( Main, Prc2 ),
  price( Dessert, Prc3 ),
  price( Wine, Prc4 ),
  Cost is ( Prc1 + Prc2 + Prc3 + Prc4 ) * 1.175 * 1.10.

% the number of calories in a meal is the total energy of the four parts

energy( Starter, Main, Dessert, Wine, Calories ) :-
  calories( Starter, Cal1 ),
  calories( Main, Cal2 ),
  calories( Dessert, Cal3 ),
  calories( Wine, Cal4 ),
  Calories is Cal1 + Cal2 + Cal3 + Cal4.

% these are the starters

starter( 'Prawn Cocktail' ).
starter( 'Pate Maison' ).
starter( 'Avocado Vinaigrette' ).
starter( 'Stuffed Mushrooms' ).
starter( 'Parma Ham With Melon' ).
starter( 'Asparagus Soup' ).

% and here are the main courses (vegetables are included!)

main( 'Dover Sole' ).
main( 'Fillet Steak' ).
main( 'Calves Liver' ).
main( 'Chicken Kiev' ).
main( 'Ragout Of Lamb' ).
main( 'Poached Salmon' ).

% the desserts follow here

dessert( 'Chocolate Fudge Cake' ).
dessert( 'Vanilla Ice Cream' ).
dessert( 'Peach Melba' ).
dessert( 'Waffles With Maple Syrup' ).
dessert( 'Fresh Fruit Salad' ).
dessert( 'Apple And Blackberry Pie' ).

% and these are the wines

wine( 'Chablis' ).
wine( 'Muscadet Sur Lie' ).
wine( 'Beaujolais Nouveau' ).
wine( 'Nuits Saint George' ).
wine( 'Gewurztraminer' ).
wine( 'Cabernet Shiraz' ).

% the various meal item's prices (before service and vat) are listed here

price( 'Chablis', 10.95 ).
price( 'Muscadet Sur Lie', 5.45 ).
price( 'Beaujolais Nouveau', 4.75 ).
price( 'Nuits Saint George', 12.75 ).
price( 'Gewurztraminer', 9.25 ).
price( 'Cabernet Shiraz', 8.65 ).
price( 'Chocolate Fudge Cake', 1.75 ).
price( 'Vanilla Ice Cream', 0.95 ).
price( 'Peach Melba', 1.55 ).
price( 'Waffles With Maple Syrup', 1.35 ).
price( 'Fresh Fruit Salad', 1.95 ).
price( 'Apple And Blackberry Pie', 1.75 ).
price( 'Dover Sole', 8.75 ).
price( 'Fillet Steak', 6.50 ).
price( 'Calves Liver', 4.95 ).
price( 'Chicken Kiev', 3.65 ).
price( 'Ragout Of Lamb', 5.25 ).
price( 'Poached Salmon', 7.25 ).
price( 'Prawn Cocktail', 2.25 ).
price( 'Pate Maison', 1.45 ).
price( 'Avocado Vinaigrette', 1.55 ).
price( 'Stuffed Mushrooms', 1.15 ).
price( 'Parma Ham With Melon', 2.75 ).
price( 'Asparagus Soup', 1.95 ).

% the energy content of each meal item is listed here in kilocalories

calories( 'Chablis', 125 ).
calories( 'Muscadet Sur Lie', 100 ).
calories( 'Beaujolais Nouveau', 150 ).
calories( 'Nuits Saint George', 225 ).
calories( 'Gewurztraminer', 125 ).
calories( 'Cabernet Shiraz', 200 ).
calories( 'Chocolate Fudge Cake', 450 ).
calories( 'Vanilla Ice Cream', 325 ).
calories( 'Peach Melba', 375 ).
calories( 'Waffles With Maple Syrup', 425 ).
calories( 'Fresh Fruit Salad', 175 ).
calories( 'Apple And Blackberry Pie', 250 ).
calories( 'Dover Sole', 250 ).
calories( 'Fillet Steak', 650 ).
calories( 'Calves Liver', 425 ).
calories( 'Chicken Kiev', 450 ).
calories( 'Ragout Of Lamb', 500 ).
calories( 'Poached Salmon', 225 ).
calories( 'Prawn Cocktail', 175 ).
calories( 'Pate Maison', 150 ).
calories( 'Avocado Vinaigrette', 275 ).
calories( 'Stuffed Mushrooms', 200 ).
calories( 'Parma Ham With Melon', 100 ).
calories( 'Asparagus Soup', 125 ).

% here is a list of the colours of the various wines

colour( 'Beaujolais Nouveau', red ).
colour( 'Nuits Saint George', red ).
colour( 'Cabernet Shiraz', red ).
colour( 'Chablis', white ).
colour( 'Muscadet Sur Lie', white ).
colour( 'Gewurztraminer', white ).

% this classifies the main type of ingredients in each starter and main dish

dish_type( 'Pate Maison', poultry ).
dish_type( 'Chicken Kiev', poultry ).
dish_type( 'Avocado Vinaigrette', vegetable ).
dish_type( 'Stuffed Mushrooms', vegetable ).
dish_type( 'Asparagus Soup', vegetable ).
dish_type( 'Parma Ham With Melon', meat ).
dish_type( 'Fillet Steak', meat ).
dish_type( 'Calves Liver', meat ).
dish_type( 'Ragout Of Lamb', meat ).
dish_type( 'Prawn Cocktail', fish ).
dish_type( 'Dover Sole', fish ).
dish_type( 'Poached Salmon', fish ).
