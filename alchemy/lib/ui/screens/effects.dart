import 'package:alchemy/core/models/efeitos.dart';
import 'package:alchemy/ui/widgets/draggable_scrollbar.dart';
import 'package:alchemy/ui/widgets/item_efeito.dart';
import 'package:flutter/material.dart';

import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:provider/provider.dart';

class EffectsTab extends StatefulWidget {
  @override
  _EffectsTabState createState() => _EffectsTabState();
}

class _EffectsTabState extends State<EffectsTab> {
  ScrollController controller = new ScrollController();
  GlobalKey size = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 1.0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: homeViewModel.currentBackground[0][1],
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.fitWidth),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              key: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black54,
              ),
              width: MediaQuery.of(context).size.width * 0.04,
              child: ListView.builder(
                itemCount: 26,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    // onTapDown: (TapDownDetails detail) {
                    //   homeViewModel.getPosition(index, "efeito", controller);
                    // },
                    // onTapUp: (TapUpDetails detail) {
                    //   homeViewModel.changeBubble("");
                    // },
                    onTap: () {
                      homeViewModel.getPosition(index, "efeito", controller);
                    },
                    onVerticalDragUpdate: (DragUpdateDetails detail) {
                      var pos = detail.globalPosition.dy.toInt();
                      for (var i = 0; i < 26; i++) {
                        var start = 128 + (i * 23);
                        var end = start + 23;
                        if (pos >= start && pos <= end) {
                          if (homeViewModel.currentPositionOnAlphabetScroll2 !=
                              i) {
                            homeViewModel.getPosition(i, "efeito", controller);
                          }
                        }
                      }
                    },
                    onLongPress: () {
                      homeViewModel.getPosition(index, "efeito", controller);
                    },
                    // onLongPressEnd: (LongPressEndDetails detail) {
                    //   homeViewModel.changeBubble("");
                    // },
                    // onVerticalDragEnd: (DragEndDetails detail) {
                    //   homeViewModel.changeBubble("");
                    // },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.0028),
                      child: Text(
                        homeViewModel.isLetter(
                                String.fromCharCode(65 + index), "efeito")
                            ? String.fromCharCode(65 + index)
                            : "-",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
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
                    backgroundColor: Theme.of(context).textTheme.body1.color,
                    controller: controller,
                    child: GridView.count(
                      childAspectRatio: 0.99,
                      controller: controller,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      mainAxisSpacing: 20,
                      crossAxisCount: 2,
                      children: List.generate(homeViewModel.efeitos.length,
                          (int index) {
                        return EffectItem(index: index);
                      }),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: homeViewModel.alphabetBubble == "" ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 700),
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
                // homeViewModel.alphabetBubble == ""
                //     ? Text("")
                //     : Container(
                //         child: Container(
                //           width: MediaQuery.of(context).size.width * 0.2,
                //           height: MediaQuery.of(context).size.width * 0.2,
                //           child: Card(
                //             elevation: 1.5,
                //             color: Colors.black38,
                //             child: Center(
                //                 child: Text(
                //               homeViewModel.alphabetBubble,
                //               style: TextStyle(fontSize: 40),
                //             )),
                //           ),
                //         ),
                //       )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
