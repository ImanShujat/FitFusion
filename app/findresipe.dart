
import 'package:flutter/material.dart';
import 'package:fyp_1/Grocerylist.dart';
import 'fooditems.dart';

class RecipeListScreen extends StatelessWidget {
  final List<Map<String, String>> recipes = [
    {
      'title': 'Cheese Omelette',
      'image': 'images/chesseOmlete.jpg',
      'description': 'A quick and delicious cheese-filled omelette.',
      'ingredients': 'Eggs, cheese, butter, salt, black pepper, herbs (optional).',
      'instructions': '1. Whisk eggs with salt and pepper. 2. Heat butter in a pan. 3. Pour the egg mixture into the pan. 4. Add cheese on top. 5. Fold the omelette and cook until cheese melts.',
      'servingSize': '1 serving',
      'calories': '250 kcal per serving'
    },

    {
      'title': ' Egg',
      'image': 'images/egg.jpg',
      'description': 'A basic boiled egg, perfect for breakfast.',
      'ingredients': 'Egg, water, salt (optional).',
      'instructions': '1. Place egg in a pot and cover with water. 2. Bring to a boil and cook for 8-10 minutes. 3. Remove from water, peel, and serve with salt if desired.',
      'servingSize': '1 egg',
      'calories': '68 kcal per egg'
    },


    {
      'title': 'Chicken Biryani',
      'image': 'images/r1.jpg',
      'description': 'A flavorful chicken and rice dish.',
      'ingredients': 'Chicken, rice, spices, yogurt, onions, tomatoes.',
      'instructions': '1. Marinate chicken with spices and yogurt. 2. Fry onions and tomatoes. 3. Layer rice and chicken. 4. Cook on low flame.',
      'servingSize': '4 servings',
      'calories': '400 kcal per serving'
    },
    {
      'title': 'Pasta Alfredo',
      'image': 'images/pasta.jpg',
      'description': 'Creamy pasta with Alfredo sauce.',
      'ingredients': 'Pasta, cream, Parmesan cheese, garlic, butter.',
      'instructions': '1. Cook pasta. 2. Prepare Alfredo sauce with butter, garlic, cream, and cheese. 3. Mix pasta with sauce.',
      'servingSize': '2 servings',
      'calories': '600 kcal per serving'
    },
    {
      'title': 'Vegetable Salad',
      'image': 'images/salad.jpg',
      'description': 'A healthy mix of fresh vegetables.',
      'ingredients': 'Lettuce, tomatoes, cucumbers, carrots, olive oil, lemon.',
      'instructions': '1. Chop vegetables. 2. Mix with olive oil and lemon juice. 3. Serve fresh.',
      'servingSize': '2 servings',
      'calories': '150 kcal per serving'
    },
    {
      'title': 'Chicken Tikka',
      'image': 'images/tikka.jpg',
      'description': 'Grilled spiced chicken skewers.',
      'ingredients': 'Chicken, tikka spices, yogurt, lemon.',
      'instructions': '1. Marinate chicken in spices and yogurt. 2. Grill on skewers until cooked.',
      'servingSize': '3 servings',
      'calories': '300 kcal per serving'
    },

    {
      'title': 'Half-Fried Egg',
      'image': 'images/halfFried.jpg', // Replace with your image file in assets
      'description': 'A quick and easy sunny-side-up egg.',
      'ingredients': 'Egg, butter or oil, salt, black pepper.',
      'instructions': '1. Heat butter or oil in a pan. 2. Crack the egg into the pan without breaking the yolk. 3. Cook until the whites are set but the yolk remains runny. 4. Season with salt and black pepper and serve.',
      'servingSize': '1 egg',
      'calories': '92 kcal per egg'
    },

    {
      'title': 'Beef Kababs',
      'image': 'images/beefkabab.jpg',
      'description': 'Juicy minced beef kababs.',
      'ingredients': 'Minced beef, spices, onion, garlic.',
      'instructions': '1. Mix minced beef with spices and onion. 2. Shape into kababs. 3. Grill or fry until done.',
      'servingSize': '4 servings',
      'calories': '350 kcal per serving'
    },
    {
      'title': 'Fruit Chaat',
      'image': 'images/fruitchat.jpg',
      'description': 'A sweet and tangy fruit salad.',
      'ingredients': 'Mixed fruits, chaat masala, lemon juice.',
      'instructions': '1. Cut fruits into pieces. 2. Sprinkle chaat masala and lemon juice. 3. Mix and serve chilled.',
      'servingSize': '3 servings',
      'calories': '120 kcal per serving'
    },
    {
      'title': 'Paya Curry',
      'image': 'images/paye.jpg',
      'description': 'Traditional spiced goat trotters curry.',
      'ingredients': 'Goat trotters, spices, onion, garlic, ginger.',
      'instructions': '1. Cook trotters with spices. 2. Prepare curry with onion and garlic. 3. Simmer trotters in curry.',
      'servingSize': '4 servings',
      'calories': '450 kcal per serving'
    },
    {
      'title': 'Haleem',
      'image': 'images/haleem.jpg',
      'description': 'A thick lentil and meat stew.',
      'ingredients': 'Meat, lentils, wheat, spices, ginger.',
      'instructions': '1. Cook lentils and meat with spices. 2. Blend partially for thickness. 3. Garnish and serve.',
      'servingSize': '5 servings',
      'calories': '500 kcal per serving'
    },
    {
      'title': 'Shami Kababs',
      'image': 'images/shamiKabab.jpg',
      'description': 'Soft and flavorful meat patties.',
      'ingredients': 'Minced meat, lentils, onion, garlic, spices.',
      'instructions': '1. Boil meat and lentils with spices. 2. Blend and shape into patties. 3. Fry until golden.',
      'servingSize': '4 servings',
      'calories': '200 kcal per serving'
    },
    {
      'title': 'Nihari',
      'image': 'images/nihari.jpg',
      'description': 'Slow-cooked beef stew.',
      'ingredients': 'Beef, Nihari spices, onion, ginger.',
      'instructions': '1. Cook beef with Nihari spices. 2. Simmer until tender. 3. Garnish and serve hot.',
      'servingSize': '5 servings',
      'calories': '600 kcal per serving'
    },
    {
      'title': 'Seekh Kababs',
      'image': 'images/seekhkabab.jpg',
      'description': 'Spiced minced meat skewers.',
      'ingredients': 'Minced meat, spices, onion, garlic.',
      'instructions': '1. Marinate meat. 2. Shape onto skewers. 3. Grill or cook until done.',
      'servingSize': '4 servings',
      'calories': '250 kcal per serving'
    },
    {
      'title': 'Gajar Ka Halwa',
      'image': 'images/halwa.jpg',
      'description': 'A sweet carrot pudding.',
      'ingredients': 'Carrots, milk, sugar, ghee, nuts.',
      'instructions': '1. Cook grated carrots with milk. 2. Add sugar and ghee. 3. Garnish with nuts.',
      'servingSize': '6 servings',
      'calories': '300 kcal per serving'
    },
    {
      'title': 'Pakoras',
      'image': 'images/pakora.jpg',
      'description': 'Deep-fried vegetable fritters.',
      'ingredients': 'Chickpea flour, vegetables, spices.',
      'instructions': '1. Mix vegetables with batter. 2. Deep fry until golden.',
      'servingSize': '4 servings',
      'calories': '150 kcal per serving'
    },
    {
      'title': 'Fruit Smoothie',
      'image': 'images/smothie.jpg',
      'description': 'A refreshing fruit smoothie.',
      'ingredients': 'Bananas, strawberries, yogurt, honey.',
      'instructions': '1. Blend fruits with yogurt and honey. 2. Serve chilled.',
      'servingSize': '2 servings',
      'calories': '180 kcal per serving'
    },
    {
      'title': 'Cheese Burger',
      'image': 'images/chesseburger.jpg',
      'description': 'A juicy cheese burger.',
      'ingredients': 'Beef patty, cheese, lettuce, tomato, burger bun.',
      'instructions': '1. Grill the beef patty. 2. Assemble with cheese, lettuce, and tomato.',
      'servingSize': '1 serving',
      'calories': '500 kcal per serving'
    },
    {
      'title': 'Caesar Salad',
      'image': 'images/Caesarsalad.jpg',
      'description': 'Classic Caesar salad with a creamy dressing.',
      'ingredients': 'Lettuce, croutons, Parmesan cheese, Caesar dressing.',
      'instructions': '1. Toss lettuce with croutons and dressing. 2. Sprinkle with Parmesan cheese.',
      'servingSize': '2 servings',
      'calories': '300 kcal per serving'
    },
    {
      'title': 'Margarita Pizza',
      'image': 'images/margritaPizza.jpg',
      'description': 'Classic Margarita pizza.',
      'ingredients': 'Pizza dough, tomato sauce, mozzarella cheese, basil.',
      'instructions': '1. Spread tomato sauce on dough. 2. Add cheese and basil. 3. Bake until golden.',
      'servingSize': '2 servings',
      'calories': '400 kcal per serving'
    },
    {
      'title': 'Veggie Burger',
      'image': 'images/veggie.jpg',
      'description': 'Healthy veggie burger made with lentils.',
      'ingredients': 'Lentils, onions, garlic, spices, burger bun.',
      'instructions': '1. Cook lentils and mash them. 2. Mix with spices and form patties. 3. Grill and assemble.',
      'servingSize': '2 servings',
      'calories': '350 kcal per serving'
    },
    {
      'title': 'Fried Chicken',
      'image': 'images/fried.jpg',
      'description': 'Crispy fried chicken.',
      'ingredients': 'Chicken pieces, flour, spices, oil.',
      'instructions': '1. Coat chicken with seasoned flour. 2. Deep fry until golden and crispy.',
      'servingSize': '4 servings',
      'calories': '450 kcal per serving'
    },
    {
      'title': 'Ice Cream Sundae',
      'image': 'images/icecream.jpg',
      'description': 'A delicious ice cream sundae with chocolate sauce.',
      'ingredients': 'Vanilla ice cream, chocolate syrup, nuts, cherries.',
      'instructions': '1. Scoop ice cream into bowls. 2. Top with chocolate syrup, nuts, and cherries.',
      'servingSize': '2 servings',
      'calories': '350 kcal per serving'
    },
    {
      'title': 'Fruit Chiller',
      'image': 'images/chiller.jpg',
      'description': 'A cool and refreshing fruit drink.',
      'ingredients': 'Mixed fruits, soda water, lemon.',
      'instructions': '1. Blend fruits with soda water and lemon. 2. Serve chilled.',
      'servingSize': '3 servings',
      'calories': '150 kcal per serving'
    },
    {
      'title': 'Lemonade',
      'image': 'images/lemonade.jpg',
      'description': 'A refreshing lemonade.',
      'ingredients': 'Lemon, sugar, water.',
      'instructions': '1. Mix lemon juice with sugar and water. 2. Serve chilled.',
      'servingSize': '4 servings',
      'calories': '120 kcal per serving'
    },
    {
      'title': 'Chicken Nuggets',
      'image': 'images/nugguts.jpg',
      'description': 'Crispy chicken nuggets.',
      'ingredients': 'Chicken, breadcrumbs, eggs, oil.',
      'instructions': '1. Coat chicken pieces with breadcrumbs. 2. Deep fry until crispy.',
      'servingSize': '4 servings',
      'calories': '300 kcal per serving'
    },
    {
      'title': 'Hot Dog',
      'image': 'images/hotDog.jpg',
      'description': 'Classic hot dog with mustard and ketchup.',
      'ingredients': 'Sausage, hot dog bun, mustard, ketchup.',
      'instructions': '1. Grill sausage and place in bun. 2. Add mustard and ketchup.',
      'servingSize': '1 serving',
      'calories': '250 kcal per serving'
    },
    {
      'title': 'Guacamole',
      'image': 'images/guacamole.jpg',
      'description': 'A creamy avocado dip.',
      'ingredients': 'Avocados, lime, garlic, salt, cilantro.',
      'instructions': '1. Mash avocados and mix with lime, garlic, and salt. 2. Garnish with cilantro.',
      'servingSize': '4 servings',
      'calories': '200 kcal per serving'
    },
    {
      'title': 'Chocolate Cake',
      'image': 'images/cake.jpg',
      'description': 'A rich and moist chocolate cake.',
      'ingredients': 'Flour, cocoa powder, sugar, eggs, butter.',
      'instructions': '1. Mix ingredients and bake at 350°F. 2. Frost with chocolate icing.',
      'servingSize': '6 servings',
      'calories': '400 kcal per serving'
    },
    {
      'title': 'Tacos',
      'image': 'images/tacos.jpg',
      'description': 'Mexican tacos with beef and cheese.',
      'ingredients': 'Ground beef, taco shells, lettuce, cheese, salsa.',
      'instructions': '1. Cook beef with spices. 2. Assemble tacos with beef, lettuce, cheese, and salsa.',
      'servingSize': '3 servings',
      'calories': '350 kcal per serving'
    },
    {
      'title': 'Vegetable Wrap',
      'image': 'images/wrap.jpg',
      'description': 'Healthy vegetable wrap.',
      'ingredients': 'Whole wheat wrap, lettuce, tomato, cucumber, hummus.',
      'instructions': '1. Spread hummus on wrap. 2. Add vegetables and roll.',
      'servingSize': '2 servings',
      'calories': '250 kcal per serving'
    },
    {
      'title': 'Pineapple Salsa',
      'image': 'images/salsa.jpg',
      'description': 'Sweet and spicy pineapple salsa.',
      'ingredients': 'Pineapple, jalapeno, red onion, cilantro, lime.',
      'instructions': '1. Chop pineapple and mix with jalapeno, onion, and cilantro. 2. Add lime juice.',
      'servingSize': '3 servings',
      'calories': '120 kcal per serving'
    },
    {
      'title': 'French Fries',
      'image': 'images/fries.jpg',
      'description': 'Crispy golden French fries.',
      'ingredients': 'Potatoes, oil, salt.',
      'instructions': '1. Cut potatoes into fries. 2. Deep fry until golden and crispy.',
      'servingSize': '4 servings',
      'calories': '220 kcal per serving'
    },
    {
      'title': 'Milkshake',
      'image': 'images/milkshake.jpg',
      'description': 'A creamy milkshake.',
      'ingredients': 'Milk, ice cream, sugar.',
      'instructions': '1. Blend milk, ice cream, and sugar together. 2. Serve chilled.',
      'servingSize': '2 servings',
      'calories': '300 kcal per serving'
    },
    {
      'title': 'Cucumber Sandwich',
      'image': 'images/sandwich.jpg',
      'description': 'A light and refreshing cucumber sandwich.',
      'ingredients': 'Cucumber, bread, cream cheese.',
      'instructions': '1. Spread cream cheese on bread. 2. Add thin cucumber slices.',
      'servingSize': '2 servings',
      'calories': '150 kcal per serving'
    },
    {
      'title': 'Chicken Shawarma',
      'image': 'images/shawarma.jpg',
      'description': 'Spiced grilled chicken in a wrap.',
      'ingredients': 'Chicken, shawarma spices, garlic, yogurt, wrap.',
      'instructions': '1. Marinate chicken with spices and yogurt. 2. Grill and wrap in bread.',
      'servingSize': '2 servings',
      'calories': '450 kcal per serving'
    },
    {
      'title': 'Pineapple Smoothie',
      'image': 'images/pineapple.jpg',
      'description': 'A tropical pineapple smoothie.',
      'ingredients': 'Pineapple, coconut milk, honey.',
      'instructions': '1. Blend pineapple with coconut milk and honey.',
      'servingSize': '2 servings',
      'calories': '180 kcal per serving'
    },
    {
      'title': 'Fried Mozzarella Sticks',
      'image': 'images/sticks.jpg',
      'description': 'Crispy fried mozzarella sticks.',
      'ingredients': 'Mozzarella cheese, breadcrumbs, egg, oil.',
      'instructions': '1. Coat mozzarella with breadcrumbs and egg. 2. Deep fry until golden.',
      'servingSize': '4 servings',
      'calories': '250 kcal per serving'
    },
    {
      'title': 'Grilled Vegetables',
      'image': 'images/grilled.jpg',
      'description': 'Grilled mix of vegetables.',
      'ingredients': 'Zucchini, peppers, eggplant, olive oil.',
      'instructions': '1. Toss vegetables with olive oil. 2. Grill until tender.',
      'servingSize': '4 servings',
      'calories': '150 kcal per serving'
    },
    {
      'title': 'Avocado Toast',
      'image': 'images/toast.jpg',
      'description': 'Toast topped with mashed avocado.',
      'ingredients': 'Bread, avocado, lemon, salt, pepper.',
      'instructions': '1. Toast bread. 2. Spread mashed avocado and season with salt and pepper.',
      'servingSize': '2 servings',
      'calories': '220 kcal per serving'
    },
    {
      'title': 'Strawberry Jam',
      'image': 'images/jam.jpg',
      'description': 'Homemade strawberry jam.',
      'ingredients': 'Strawberries, sugar, lemon.',
      'instructions': '1. Cook strawberries with sugar and lemon until thickened.',
      'servingSize': '4 servings',
      'calories': '100 kcal per serving'
    },
    {
      'title': 'Cold Coffee',
      'image': 'images/coldcoffe.jpg',
      'description': 'Iced coffee with milk and sugar.',
      'ingredients': 'Coffee, milk, sugar, ice.',
      'instructions': '1. Brew coffee and cool. 2. Mix with milk, sugar, and ice.',
      'servingSize': '2 servings',
      'calories': '150 kcal per serving'
    },
    {
      'title': 'Grilled Cheese Sandwich',
      'image': 'images/chesseSandwich.jpg',
      'description': 'Classic grilled cheese sandwich.',
      'ingredients': 'Bread, cheese, butter.',
      'instructions': '1. Butter bread and add cheese. 2. Grill until golden.',
      'servingSize': '1 serving',
      'calories': '350 kcal per serving'
    },
    {
      'title': 'Kheer',
      'image': 'images/kheer.jpg',
      'description': 'Sweet rice pudding.',
      'ingredients': 'Rice, milk, sugar, cardamom, nuts.',
      'instructions': '1. Cook rice in milk. 2. Add sugar and cardamom. 3. Garnish with nuts.',
      'servingSize': '6 servings',
      'calories': '250 kcal per serving'
    },
    {
      'title': 'Chana Chaat',
      'image': 'images/channachat.jpg',
      'description': 'Spicy and tangy chickpea salad.',
      'ingredients': 'Chickpeas, spices, onions, tomatoes, lemon juice.',
      'instructions': '1. Mix boiled chickpeas with spices and vegetables. 2. Add lemon juice. 3. Serve fresh.',
      'servingSize': '3 servings',
      'calories': '180 kcal per serving'
    },
    {
      'title': 'Chapli Kababs',
      'image': 'images/chapli.jpg',
      'description': 'Flat minced meat kababs.',
      'ingredients': 'Minced meat, spices, tomato, onion.',
      'instructions': '1. Mix ingredients. 2. Shape into flat kababs. 3. Fry until cooked.',
      'servingSize': '4 servings',
      'calories': '350 kcal per serving'
    },
    {
      'title': 'Lassi',
      'image': 'images/lassi.jpg',
      'description': 'Refreshing yogurt drink.',
      'ingredients': 'Yogurt, water, sugar/salt.',
      'instructions': '1. Blend yogurt with water and sugar/salt. 2. Serve chilled.',
      'servingSize': '2 servings',
      'calories': '150 kcal per serving'
    },
    {
      'title': 'Aloo Paratha',
      'image': 'images/alooparatha.jpg',
      'description': 'Stuffed potato flatbread.',
      'ingredients': 'Potatoes, flour, spices, butter.',
      'instructions': '1. Prepare dough. 2. Fill with spiced mashed potatoes. 3. Cook on skillet with butter.',
      'servingSize': '3 servings',
      'calories': '300 kcal per serving'
    },
    {
      'title': 'Karahi Chicken',
      'image': 'images/karahi.jpg',
      'description': 'Spicy wok-cooked chicken.',
      'ingredients': 'Chicken, tomatoes, spices, ginger.',
      'instructions': '1. Cook chicken with tomatoes and spices. 2. Garnish with ginger.',
      'servingSize': '4 servings',
      'calories': '400 kcal per serving'
    },
    {
      'title': 'Sheer Khurma',
      'image': 'images/sheer.jpg',
      'description': 'Sweet vermicelli milk dessert.',
      'ingredients': 'Milk, vermicelli, sugar, nuts.',
      'instructions': '1. Cook vermicelli in milk. 2. Add sugar and nuts. 3. Serve warm.',
      'servingSize': '6 servings',
      'calories': '250 kcal per serving'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Recipes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: RecipeSearchDelegate(recipes));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(
                      recipe: recipe,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Image.asset(
                          recipe['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        recipe['title']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RecipeSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> recipes;

  RecipeSearchDelegate(this.recipes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = recipes
        .where((recipe) => recipe['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final recipe = searchResults[index];
        return ListTile(
          title: Text(recipe['title']!),
          onTap: () {
            close(context, null); // Close search
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipe: recipe),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = recipes
        .where((recipe) => recipe['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final recipe = searchResults[index];
        return ListTile(
          title: Text(recipe['title']!),
          onTap: () {
            query = recipe['title']!; // Set the query to the selected recipe
            showResults(context);
          },
        );
      },
    );
  }
}


class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Convert ingredients and instructions to lists if they're strings
    List<String> ingredientsList = recipe['ingredients'] is String
        ? recipe['ingredients'].split(', ') // Split the string by commas
        : List<String>.from(recipe['ingredients']);

    List<String> instructionsList = recipe['instructions'] is String
        ? recipe['instructions'].split(', ') // Split the string by commas
        : List<String>.from(recipe['instructions']);

    // Handle null or missing 'id' field in recipe
    int foodItemId = 0;  // Default value for foodItemId

    // Try to parse the id from the recipe
    if (recipe['id'] != null) {
      try {
        // Parse the id and assign to foodItemId if valid
        foodItemId = int.parse(recipe['id'].toString());
      } catch (e) {
        print('Error parsing id: $e');
        foodItemId = 0; // Set a default value if parsing fails
      }
    }

    print('FoodItemId: $foodItemId'); // Debugging line to check the id



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(recipe['title']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Use CachedNetworkImage to load image
              Image.asset(
                recipe['image'],
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,

              ),
              SizedBox(height: 16),
              Text(
                recipe['title'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                recipe['description'],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Calories: ${recipe['calories']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Serving Size: ${recipe['servingSize']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Ingredients:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Display ingredients using map
              ...ingredientsList.map<Widget>((ingredient) {
                return Text('- $ingredient', style: TextStyle(fontSize: 16));
              }).toList(),
              SizedBox(height: 16),
              Text(
                'Instructions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Display instructions using map
              ...instructionsList.map<Widget>((instruction) {
                return Text('- $instruction', style: TextStyle(fontSize: 16));
              }).toList(),

              SizedBox(height: 16),
              ElevatedButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> AddRecipeScreen(foodItemId: foodItemId),
                    ),
                );
              }, child: Text('Add Recipes')),

              SizedBox(height: 16),
              ElevatedButton(onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> GroceryList(),
                  ),
                );
              }, child: Text('Ingredients'))
            ],
          ),
        ),
      ),
    );
  }
}