import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/ui/widgets/effect_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EffectItem extends StatelessWidget {
  const EffectItem({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Stack(
      children: <Widget>[
        SizedBox.expand(
          child: Card(
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
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    homeViewModel.efeitos[index].icon,
                    scale: 9,
                  ),
                  Text(
                    homeViewModel.efeitos[index].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    homeViewModel.efeitos[index].description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
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
            onPressed: () {
              homeViewModel.changeItem2(homeViewModel.efeitos[index]);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EffectInfo()));
            },
          ),
        )
      ],
    );
  }
}
