import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/ui/widgets/effects_tab.dart';
import 'package:alchemy/ui/widgets/ingredients_tab.dart';
import 'package:alchemy/ui/widgets/potion_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return DefaultTabController(
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
              onPressed: () {},
            )
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).textTheme.body1.color,
            tabs: <Widget>[
              Tab(
                  child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Image.asset("assets/ingredient.png"),
              )),
              Tab(child: Image.asset("assets/efeito.webp")),
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
          children: <Widget>[IngredientsTab(), EffectsTab(), PotionTab()],
        ),
      ),
    );
  }
}
