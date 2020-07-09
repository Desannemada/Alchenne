import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/information/measure.dart';
import 'package:alchemy/ui/widgets/effect_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EffectItem extends StatelessWidget {
  EffectItem({
    @required this.index,
    @required this.key,
  });

  final int index;
  final GlobalKey key;

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return MeasureSize(
      onChange: (size) {
        homeViewModel.updateContainerHeight(size.height);
      },
      child: Container(
        // key: !homeViewModel.aux ? key : null,
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: homeViewModel.favEfeitos.contains(index)
                          ? Theme.of(context).textTheme.bodyText2.color
                          : Colors.black38,
                      width: 2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 14),
                elevation: 30,
                color: Theme.of(context).canvasColor.withOpacity(0.78),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Image.asset(
                          homeViewModel.efeitos[index].icon,
                          scale: 9,
                        ),
                      ),
                      Text(
                        homeViewModel.efeitos[index].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *
                              0.042 /
                              MediaQuery.of(context).textScaleFactor,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            homeViewModel.efeitos[index].description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width *
                                  0.03 /
                                  MediaQuery.of(context).textScaleFactor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              child: FlatButton(
                child: Container(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                ),
                onLongPress: () => homeViewModel.updateEFavList(index),
                onPressed: () {
                  homeViewModel.changeItem2(homeViewModel.efeitos[index]);
                  homeViewModel.nulifyCurrentInfo2();
                  homeViewModel.getInfoE(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EffectInfo(),
                    ),
                  );
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 10),
            //   child: Align(
            //     alignment: Alignment.topRight,
            //     child: GestureDetector(
            //       onTap: () => homeViewModel.updateEFavList(index),
            //       child: Icon(
            //         homeViewModel.favEfeitos.contains(index)
            //             ? Icons.star
            //             : Icons.star_border,
            //         size: 30,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
