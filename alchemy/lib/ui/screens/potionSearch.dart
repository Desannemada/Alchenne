import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PotionSearchScreen extends SearchDelegate {
  int slot = 0;
  PotionSearchScreen({@required this.slot});

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
    for (var item in homeViewModel.ingredientes) {
      if (item.title.toUpperCase().contains(query.toUpperCase())) {
        results.add(item);
      }
    }
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.black,
          height: MediaQuery.of(context).size.height * 0.003,
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
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width *
                          0.05 /
                          MediaQuery.of(context).textScaleFactor,
                    ),
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
                        fontSize: MediaQuery.of(context).size.width *
                            0.05 /
                            MediaQuery.of(context).textScaleFactor,
                      ),
                    ),
                    onPressed: () {
                      homeViewModel.updatePotionIngredients(slot, results[i]);
                      homeViewModel.updatePossiblePotions();
                      close(context, null);
                    },
                  ),
      ),
    );
  }
}
