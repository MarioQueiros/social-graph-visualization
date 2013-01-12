/*
   ProWeb Meals Internet Example - Logic Programming Associates - 16-Jul-97
   ------------------------------------------------------------------------

   This program defines the ProWeb front-end for the MEALS.PL menu generation
   example.

*/

:- multifile( proweb_page      / 2 ).
:- multifile( proweb_form      / 2 ).
:- multifile( proweb_friends   / 2 ).
:- multifile( proweb_question  / 2 ).
:- multifile( proweb_help      / 3 ).
:- multifile( proweb_expansion / 3 ).

:- initialization( ensure_loaded( examples( 'meals\meals' ) ) ).

% the top-level meals goal

meals :-
   proweb_send_form( meals(input) ),
   proweb_returned_answer( meals_type, Meal ),
   proweb_post_reply( meals_type, Meal ),
   meal_type( Meal, Goal, _ ),
   solution( pw_menu(Goal,Starter,Main,Dessert,Wine,Cost,Calories), Nth ),
   \+ proweb_returned_form( meals(output(_,Nth)) ),
   gif( Starter, StarterGif ),
   gif( Main, MainGif ),
   gif( Dessert, DessertGif ),
   gif( Wine, WineGif ),
   proweb_post_reply( cost,         currency @ Cost ),
   proweb_post_reply( calories,     Calories ),
   expand_gif_name( StarterGif, Starter, FullStarterGif ),
   proweb_post_reply( starter_gif,  FullStarterGif ),
   proweb_post_reply( starter_name, Starter ),
   expand_gif_name( MainGif, Main, FullMainGif ),
   proweb_post_reply( main_gif,     FullMainGif ),
   proweb_post_reply( main_name,    Main ),
   expand_gif_name( DessertGif, Dessert, FullDessertGif ),
   proweb_post_reply( dessert_name, Dessert ),
   proweb_post_reply( dessert_gif,  FullDessertGif ),
   expand_gif_name( WineGif, Wine, FullWineGif ),
   proweb_post_reply( wine_name,    Wine ),
   proweb_post_reply( wine_gif,     FullWineGif ),
   proweb_send_form( meals(output(Meal,Nth)) ).

% when there are no more solutions send the finish form

meals :-
   proweb_send_form( meals(finish) ).

% expand the gif name to a full pathname

expand_gif_name( Gif, Name, Full ) :-
   ( write(`<IMG SRC="/proweb/images/meals/`),
     write(Gif),
     write(`" WIDTH=128 HEIGHT=128 ALT="`),
     write(Name),
     write(`">`)
   ) ~> Full.

% the meals interaction forms:
% get the type of meal required

proweb_form( meals(input), include('meals/meals1.htm') ).

% display a menu solution

proweb_form( meals(output(_,_)), include('meals/meals2.htm') ).

% terminate the example

proweb_form( meals(finish), include('meals/meals3.htm') ).

% the define the background for all the meals forms

proweb_page( meals(input),       include('meals/page.htm') ).
proweb_page( meals(output(_,_)), include('meals/page.htm') ).
proweb_page( meals(finish),      include('meals/page.htm') ).

/*
proweb_page( [ Form ],
             [ include('meals/head.htm'),
               Title,
               include('meals/body.htm'),
               proweb(Form),
               include('meals/foot.htm')
             ]
           ) :-
  (
    Form  = meals(input),     
    Title = `Meals Example - Choose a Meal`
  ;
    Form  = meals(finish),
    Title = `Meals Example - No More Meals`
  ).

proweb_page( [ Form ],
             [ include('meals/head.htm'),
               Title,
               include('meals/body.htm'),
               proweb(Form),
               include('meals/foot.htm')
             ]
           ) :-
  Form = meals(output(Meal,_)),
  write( Meal ) ~> MealString,
  cat( [`Meals Example - `,MealString,` Menu`], Title, _ ).
*/

% set all the meal types in a question

proweb_question( meals_type, [method = radio,select = Select,prefill = 'Any'] ) :-
   findall( [Type,font(size = 3) @ TypeText],
	    meal_type( Type, _, TypeText ),
	    Select
	  ).

% generate a menu and calculate the total cost and energy

pw_menu( Meal, Starter, Main, Dessert, Wine, Cost, Calories ) :-
   Meal( Starter, Main, Dessert, Wine ),
   cost( Starter, Main, Dessert, Wine, Cost ),
   energy( Starter, Main, Dessert, Wine, Calories ).


% The meal type/goal/description database

meal_type( 'Any',      any_meal,     'Any starter, main course, dessert and wine' ).
meal_type( 'Good',     good_meal,    'The starter, main course and wine are good together' ).
meal_type( 'Cheap',    cheap_meal,   'Any meal costing less than £15.00' ).
meal_type( 'Yuppie',   yuppie_meal,  'A good meal costing more than £30.00' ).
meal_type( 'Diet',     diet_meal,    'Any meal with less than 750 calories' ).
meal_type( 'Glutton',  glutton_meal, 'A good meal with more than 1500 calories' ).

% The meal description/GIF file database

gif( `Prawn Cocktail`,           'prawns.gif' ).
gif( `Pate Maison`,              'pate.gif' ).
gif( `Avocado Vinaigrette`,      'avocado.gif' ).
gif( `Stuffed Mushrooms`,        'mushroom.gif' ).
gif( `Parma Ham With Melon`,     'melon.gif' ).
gif( `Asparagus Soup`,           'soup.gif' ).
gif( `Dover Sole`,               'sole.gif' ).
gif( `Fillet Steak`,             'steak.gif' ).
gif( `Poached Salmon`,           'salmon.gif' ).
gif( `Calves Liver`,             'liver.gif' ).
gif( `Chicken Kiev`,             'chicken.gif' ).
gif( `Ragout Of Lamb`,           'lamb.gif' ).
gif( `Chocolate Fudge Cake`,     'cake.gif' ).
gif( `Vanilla Ice Cream`,        'icecream.gif' ).
gif( `Waffles With Maple Syrup`, 'waffle.gif' ).
gif( `Apple And Blackberry Pie`, 'pie.gif' ).
gif( `Peach Melba`,              'peach.gif' ).
gif( `Fresh Fruit Salad`,        'fruits.gif' ).
gif( Wine, ColourGif ) :-
   colour( Wine, Colour ),
   cat( [Colour,'.GIF'], ColourGif, _ ).


