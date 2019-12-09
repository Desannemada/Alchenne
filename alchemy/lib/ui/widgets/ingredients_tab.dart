import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientsTab extends StatelessWidget {
  const IngredientsTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    if (homeViewModel.errorResponse == -1 &&
        homeViewModel.ingredientes.isEmpty) {
      Future.delayed(Duration(seconds: 5), () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  elevation: 10,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Erro de Conexão >.<",
                        textAlign: TextAlign.center,
                      ),
                      FlatButton(
                        child: Text("Refresh"),
                        onPressed: () {
                          homeViewModel.refresh();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ));
      });
    }

    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 1.0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: homeViewModel.currentBackground[0][0],
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.fitWidth),
            ),
          ),
        ),
        homeViewModel.ingredientes.isEmpty
            ? Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.builder(
                itemCount: homeViewModel.ingredientes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      elevation: 10,
                      color: Theme.of(context).canvasColor,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 40,
                              child: Image.asset(
                                "assets/ingredients/${homeViewModel.ingredientes[index].title}.png",
                                fit: BoxFit.contain,
                                scale: 1.5,
                              ),
                              backgroundColor: Colors.red,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(homeViewModel.ingredientes[index].title),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Image.asset("assets/quill.webp",
                                              scale: 15),
                                          SizedBox(width: 2),
                                          Text(homeViewModel
                                              .ingredientes[index].weight),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Image.asset("assets/coin.png",
                                              scale: 9),
                                          SizedBox(width: 2),
                                          Text(homeViewModel
                                              .ingredientes[index].value),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
      ],
    );
  }
}
