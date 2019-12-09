import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PotionTab extends StatelessWidget {
  const PotionTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: homeViewModel.currentBackground[0][2],
          alignment: Alignment.center,
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Text(""),
    );
  }
}
