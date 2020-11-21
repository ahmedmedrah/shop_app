import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, OrdersProvider>(
          update: (ctx, auth, previous) => OrdersProvider(
              auth.token, auth.userId, previous == null ? [] : previous.orders),
          create: null,
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, auth, previous) => ProductsProvider(
              auth.token, auth.userId, previous == null ? [] : previous.items),
          create: null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop App',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              AuthScreen.ROUTENAME: (ctx) => AuthScreen(),
              ProductDetailsScreen.ROUTENAME: (ctx) => ProductDetailsScreen(),
              CartScreen.ROUTENAME: (ctx) => CartScreen(),
              OrdersScreen.ROUTENAME: (ctx) => OrdersScreen(),
              UserProductsScreen.ROUTENAME: (ctx) => UserProductsScreen(),
              EditProductScreen.ROUTENAME: (ctx) => EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
