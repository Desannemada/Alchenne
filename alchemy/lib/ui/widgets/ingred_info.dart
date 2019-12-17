import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          homeViewModel.currentIngredient.title,
          style: TextStyle(color: Theme.of(context).textTheme.body1.color),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).textTheme.body1.color),
                    ),
                    child: Image.asset(
                      homeViewModel.currentBackground[0][3],
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.2,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).textTheme.body1.color),
                      borderRadius: BorderRadius.all(Radius.circular(80)),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.7),
                      child: Image.asset(
                        "assets/ingredients/${homeViewModel.currentIngredient.title}.png",
                        fit: BoxFit.contain,
                        scale: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 3,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(
              4,
              (int index) => Stack(
                children: <Widget>[
                  Card(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.black38),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          homeViewModel.getEfeitoImage(homeViewModel
                              .getIngredientsEffects()[index]
                              .title),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              homeViewModel
                                  .getIngredientsEffects()[index]
                                  .title,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).textTheme.body1.color),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
