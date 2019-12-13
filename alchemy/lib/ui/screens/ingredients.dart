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
  GlobalKey size = GlobalKey();
  GlobalKey position = GlobalKey();

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

    void getPosition(int index) {
      if (index > 21) {
        controller.jumpTo((107 ~/ 2).toDouble() * 219.5);
      } else {
        int hasIndex = 0;
        for (var i = 0; i < homeViewModel.ingredientes.length; i++) {
          if (homeViewModel.ingredientes[i].title[0] ==
              String.fromCharCode(65 + index)) {
            //print(String.fromCharCode(65 + index));
            print(i);
            controller.jumpTo((i ~/ 2).toDouble() * 219.5);
            hasIndex = 1;
            break;
          }
        }
        if (hasIndex == 0) {
          hasIndex = index;
          while (hasIndex != -1) {
            hasIndex = hasIndex + 1;
            //print(hasIndex);
            if (hasIndex == homeViewModel.ingredientes.length) {
              controller.jumpTo((hasIndex ~/ 2).toDouble() * 219.5);
              //print(String.fromCharCode(65 + index));
              hasIndex = -1;
            } else {
              for (var i = 0; i < homeViewModel.ingredientes.length; i++) {
                if (homeViewModel.ingredientes[i].title[0] ==
                    String.fromCharCode(65 + hasIndex)) {
                  //print(String.fromCharCode(65 + index));
                  controller.jumpTo((i ~/ 2).toDouble() * 219.5);
                  hasIndex = -1;
                  break;
                }
              }
            }
          }
        }
      }
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
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).textTheme.body1.color),
                  ),
                ),
              )
            : Row(
                children: <Widget>[
                  Container(
                    key: size,
                    color: Colors.black54,
                    width: MediaQuery.of(context).size.width * 0.04,
                    child: ListView.builder(
                      itemCount: 26,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            getPosition(index);
                            homeViewModel.updatePosition(index);
                          },
                          onVerticalDragUpdate: (DragUpdateDetails detail) {
                            var pos = detail.globalPosition.dy.toInt();
                            for (var i = 0; i < 26; i++) {
                              var start = 128 + (i * 23);
                              var end = start + 23;
                              if (pos >= start && pos <= end) {
                                print(String.fromCharCode(65 + i));
                                if (homeViewModel
                                        .currentPositionOnAlphabetScroll !=
                                    i) {
                                  getPosition(i);
                                  homeViewModel.updatePosition(i);
                                }
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height *
                                    0.0028),
                            child: Text(
                              String.fromCharCode(65 + index),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: DraggableScrollbar.arrows(
                      backgroundColor: Theme.of(context).textTheme.body1.color,
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
                ],
              ),
        Center(
          child: Card(
            color: Colors.transparent,
            child: Text("oi"),
          ),
        )
      ],
    );
  }
}
