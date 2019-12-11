import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientItem extends StatelessWidget {
  const IngredientItem({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black38, width: 2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(80),
          topRight: Radius.circular(80),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 14),
      elevation: 30,
      color: Theme.of(context).canvasColor.withOpacity(0.78),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              radius: 40,
              child: Image.asset(
                "assets/ingredients/${homeViewModel.ingredientes[index].title}.png",
                fit: BoxFit.contain,
                scale: 1.5,
              ),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset("assets/quill.webp", scale: 15),
                      SizedBox(width: 2),
                      Text(homeViewModel.ingredientes[index].weight),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset("assets/coin.png", scale: 9),
                      SizedBox(width: 5),
                      Text(homeViewModel.ingredientes[index].value),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              homeViewModel.ingredientes[index].title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
