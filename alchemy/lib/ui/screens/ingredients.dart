import 'package:alchemy/ui/widgets/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/ui/widgets/item_ingredient.dart';
import 'package:provider/provider.dart';

class IngredientsTab extends StatefulWidget {
  @override
  _IngredientsTabState createState() => _IngredientsTabState();
}

class _IngredientsTabState extends State<IngredientsTab> {
  ScrollController controller = new ScrollController();
  final sizeContainer = GlobalKey();

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

    Size getSizes() {
      final RenderBox alphaS = sizeContainer.currentContext.findRenderObject();
      final alphaSize = alphaS.size;
      print(alphaSize.toString());
      return alphaSize;
    }

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: homeViewModel.currentBackground[0][1],
                alignment: Alignment.centerLeft,
                fit: BoxFit.fitWidth),
          ),
        ),
        homeViewModel.ingredientes.isEmpty
            ? Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).textTheme.body1.color),
                  ),
                ),
              )
            : Row(
                children: <Widget>[
                  Container(
                    key: sizeContainer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black54,
                    ),
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width * 0.04,
                    child: ListView.builder(
                      itemCount: 26,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            homeViewModel.getPosition(
                                index, "ingrediente", controller);
                          },
                          onVerticalDragUpdate: (DragUpdateDetails detail) {
                            var pos = detail.globalPosition.dy.toInt();
                            for (var i = 0; i < 26; i++) {
                              var start = 128 + (i * 23);
                              var end = start + 23;
                              if (pos >= start && pos <= end) {
                                if (homeViewModel
                                        .currentPositionOnAlphabetScroll !=
                                    i) {
                                  homeViewModel.getPosition(
                                      i, "ingrediente", controller);
                                }
                              }
                            }
                          },
                          onLongPress: () {
                            homeViewModel.getPosition(
                                index, "ingrediente", controller);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.0028,
                            ),
                            child: Text(
                              homeViewModel.isLetter(
                                      String.fromCharCode(65 + index),
                                      "ingrediente")
                                  ? String.fromCharCode(65 + index)
                                  : "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: (MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.025) /
                                      MediaQuery.of(context).textScaleFactor),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.96,
                        child: DraggableScrollbar.arrows(
                          backgroundColor:
                              Theme.of(context).textTheme.body1.color,
                          controller: controller,
                          child: GridView.count(
                            childAspectRatio: 0.99,
                            controller: controller,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            mainAxisSpacing: 20,
                            crossAxisCount: 2,
                            children: List.generate(
                                homeViewModel.ingredientes.length, (int index) {
                              return IngredientItem(index: index);
                            }),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: homeViewModel.alphabetBubble == "" ? 0.0 : 1.0,
                        duration: Duration(seconds: 1),
                        onEnd: () {
                          homeViewModel.changeBubble("");
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          child: Card(
                            elevation: 1.5,
                            color: Colors.black38,
                            child: Center(
                                child: Text(
                              homeViewModel.alphabetBubble,
                              style: TextStyle(fontSize: 40),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ],
    );
  }
}
