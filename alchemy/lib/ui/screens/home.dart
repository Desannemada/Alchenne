import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/ui/screens/effects.dart';
import 'package:alchemy/ui/screens/ingredients.dart';
import 'package:alchemy/ui/screens/potions.dart';
import 'package:alchemy/ui/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          centerTitle: true,
          title: Text(
            "Skyrim: Alchenne",
            style: TextStyle(color: Theme.of(context).textTheme.body1.color),
          ),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.symmetric(horizontal: 15),
              icon: Icon(Icons.search),
              iconSize: MediaQuery.of(context).size.height * 0.04,
              onPressed: () => showSearch(
                context: context,
                delegate: SearchScreen(),
              ),
            )
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).textTheme.body1.color,
            tabs: <Widget>[
              Tab(child: Image.asset("assets/efeito.webp")),
              Tab(
                  child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Image.asset("assets/ingredient.png"),
              )),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Tab(child: Image.asset("assets/potion.png")),
              )
            ],
          ),
        ),
        body: TabBarView(
          physics: homeViewModel.errorResponse == -1
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          children: <Widget>[EffectsTab(), IngredientsTab(), PotionTab()],
        ),
      ),
    );
  }
}
