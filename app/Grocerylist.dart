import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a class to hold the image path and description
class ShoppingItem {
  final String imagePath;
  final String description;

  ShoppingItem({required this.imagePath, required this.description});
}

// Create a list of ShoppingItem objects
final List<ShoppingItem> shoppingItems = [
  ShoppingItem(imagePath: "images/salsa.jpg", description: "Apple"),
  ShoppingItem(imagePath: "images/pasta.jpg", description: "cheese"),
  ShoppingItem(imagePath: "images/margritaPizza.jpg", description: "Chicken "),
  ShoppingItem(imagePath: "images/salad.jpg", description: "Salad"),
  ShoppingItem(imagePath: "images/milkshake.jpg", description: "butter"),
  ShoppingItem(imagePath: "images/nihari.jpg", description: "salt"),
  ShoppingItem(imagePath: "images/salad.jpg", description: "Onion "),
  ShoppingItem(imagePath: "images/karahi.jpg", description: "Yougurt"),
  ShoppingItem(imagePath: "images/pasta.jpg", description: "pasta"),
  ShoppingItem(imagePath: "images/4.jpg", description: "cream"),
  ShoppingItem(imagePath: "images/icecream.jpg", description: "Orange"),
  ShoppingItem(imagePath: "images/sheer.jpg", description: "carrots "),
  ShoppingItem(imagePath: "images/8.jpg", description: "Oil"),
  ShoppingItem(imagePath: "images/salad.jpg", description: "cucumber"),
  ShoppingItem(imagePath: "images/lemonade.jpg", description: "lemon"),
  ShoppingItem(imagePath: "images/nugguts.jpg", description: "rice"),
  ShoppingItem(imagePath: "images/salad.jpg", description: "Tomatoes "),
  ShoppingItem(imagePath: "images/tacos.jpg", description: "Garlic"),
  ShoppingItem(imagePath: "images/smothie.jpg", description: "Mayonese"),
  ShoppingItem(imagePath: "images/tikka.jpg", description: "Sauce"),
  ShoppingItem(imagePath: "images/sticks.jpg", description: "minced beef"),
  ShoppingItem(imagePath: "images/tacos.jpg", description: "ginger "),
  ShoppingItem(imagePath: "images/taost.jpg", description: "Meat"),
  ShoppingItem(imagePath: "images/veggie.jpg", description: "lentils"),
  ShoppingItem(imagePath: "images/wrap.jpg", description: "Beef"),
  ShoppingItem(imagePath: "images/jam.jpg", description: "nuts"),
  ShoppingItem(imagePath: "images/haleem.jpg", description: "vegetables "),
  ShoppingItem(imagePath: "images/icecream.jpg", description: "strawberries"),
  ShoppingItem(imagePath: "images/pineapple.jpg", description: "cherries"),



];

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<ShoppingItem> cartItems = [];  // List to hold cart items

  @override
  void initState() {
    super.initState();
    _loadCartItems();  // Load saved cart items when the app starts
  }

  // Load cart items from SharedPreferences
  _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedItems = prefs.getStringList('cartItems');
    if (savedItems != null) {
      setState(() {
        cartItems = savedItems
            .map((item) => ShoppingItem(imagePath: item.split(',')[0], description: item.split(',')[1]))
            .toList();
      });
    }
  }

  // Add item to the cart and save it
  _addToCart(ShoppingItem item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cartItems.add(item);  // Add item to the list
    });
    // Save the cart items
    List<String> cartData = cartItems
        .map((item) => '${item.imagePath},${item.description}')
        .toList();
    prefs.setStringList('cartItems', cartData);
  }

  // Clear the cart
  _clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cartItems.clear();
    });
    prefs.remove('cartItems');  // Remove cart items from SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Grocery List'),
        centerTitle: false,
        actions: [
          // Clear cart button
          IconButton(
            icon: const Icon(Icons.cancel_presentation),
            onPressed: _clearCart,
          ),
          const SizedBox(width: 15),
          // Shopping cart icon
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 8,
                      child: Text(
                        cartItems.length.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              // Navigate to Cart screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartItems: cartItems),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        itemCount: shoppingItems.length,
        itemBuilder: (context, index) => Column(
          children: [
            // Shopping list item
            ShoppingListItem(
              onClick: () => _addToCart(shoppingItems[index]),
              item: shoppingItems[index],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class ShoppingListItem extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onClick;

  ShoppingListItem({required this.onClick, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onClick,
      leading: Container(
        width: 55,
        height: 55,
        color: Colors.transparent,
        child: Image.asset(
          item.imagePath,
          width: 55,
          height: 55,
        ),
      ),
      title: Text(item.description),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<ShoppingItem> cartItems;

  CartScreen({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) => ListTile(
          leading: Container(
            width: 55,
            height: 55,
            child: Image.asset(cartItems[index].imagePath),
          ),
          title: Text(cartItems[index].description),
        ),
      ),
    );
  }
}
