import 'package:alchemy/core/models/efeitos.dart';
import 'package:alchemy/core/models/ingredientes.dart';
import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/ui/values/strings.dart';
import 'package:alchemy/ui/widgets/effect_info.dart';
import 'package:alchemy/ui/widgets/ingred_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends SearchDelegate {
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Theme.of(context).primaryColor,
      primaryIconTheme: Theme.of(context).iconTheme,
      primaryTextTheme: Theme.of(context).textTheme,
      cursorColor: Theme.of(context).cursorColor,
      inputDecorationTheme: Theme.of(context).inputDecorationTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    List results = [""];
    for (var item in homeViewModel.ingredientsEffects) {
      if (item.title.toUpperCase().contains(query.toUpperCase())) {
        results.add(item);
      }
    }
    return query == ""
        ? Center(child: Text("Search for ingredients and effects"))
        : Padding(
            padding: EdgeInsets.all(10),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.black,
                height: 5,
              ),
              itemCount: results.length + 1,
              itemBuilder: (BuildContext context, int i) => i == 0
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Opacity(
                        opacity: 0.7,
                        child: Text(
                          (results.length - 1).toString() + " results",
                          textAlign: TextAlign.end,
                        ),
                      ),
                    )
                  : i == results.length
                      ? Text("")
                      : FlatButton(
                          child: Text(
                            results[i].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.body1.color,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            if (results[i] is Ingredientes) {
                              homeViewModel.changeItem(results[i]);
                              homeViewModel.nulifyCurrentInfo();
                              homeViewModel.fecharInfos();
                              homeViewModel.getInfoI(INGREDIENT_URL +
                                  homeViewModel.currentIngredient.url);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IngredientInfo(),
                                ),
                              );
                            } else if (results[i] is Efeitos) {
                              homeViewModel.changeItem2(results[i]);
                              homeViewModel.nulifyCurrentInfo2();
                              homeViewModel.getInfoE(
                                  EFEITO_URL + homeViewModel.currentEffect.url);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EffectInfo(),
                                ),
                              );
                            }
                          },
                        ),
            ),
          );
  }
}
