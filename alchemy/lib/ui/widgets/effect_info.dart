import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/ui/values/strings.dart';
import 'package:alchemy/ui/widgets/ingred_info.dart';
import 'package:alchemy/ui/widgets/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:html2md/html2md.dart' as html2md;

class EffectInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    if (homeViewModel.errorResponse == -1) {
      Future.delayed(Duration(seconds: 5), () {
        showDialog(
            context: context,
            builder: (BuildContext bc) => AlertDialog(
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
                          homeViewModel.getInfoE(
                              EFEITO_URL + homeViewModel.currentEffect.url);
                          Navigator.of(bc).pop();
                        },
                      ),
                    ],
                  ),
                ));
      });
    }

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
          homeViewModel.currentEffect.title,
          style: TextStyle(color: Theme.of(context).textTheme.body1.color),
        ),
      ),
      body: homeViewModel.currentEInfo == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).textTheme.body1.color,
                ),
              ),
            )
          : ListView(
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
                              homeViewModel.currentEffect.icon,
                              fit: BoxFit.contain,
                              scale: 1.1,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 10,
                            top: MediaQuery.of(context).size.height * 0.273,
                            right: 20,
                            left: 20),
                        child: Center(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "\"" +
                                  homeViewModel.currentEffect.description +
                                  "\"",
                              style: TextStyle(
                                  fontSize: 14 /
                                      MediaQuery.of(context).textScaleFactor,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: MarkdownBody(
                              shrinkWrap: true,
                              data: "School: " +
                                  html2md.convert(
                                      homeViewModel.currentEInfo.school),
                              onTapLink: (String url) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MyWebView(
                                      title: homeViewModel.returnURL(url)[1],
                                      selectedUrl: EFEITO_URL +
                                          homeViewModel.returnURL(url)[0],
                                    ),
                                  ),
                                );
                              },
                              styleSheet: MarkdownStyleSheet(
                                textAlign: WrapAlignment.center,
                                a: TextStyle(color: Colors.blue, fontSize: 20),
                                p: TextStyle(
                                    color:
                                        Theme.of(context).textTheme.body1.color,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Type: " + homeViewModel.currentEInfo.type,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 3),
                      GridView.count(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(
                          homeViewModel.currentEffect.ingredients.length,
                          (int index) => Stack(
                            children: <Widget>[
                              Card(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.black38),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Image.asset(
                                          "assets/ingredients/${homeViewModel.currentEffect.ingredients[index].replaceAll(" ", "")}.png"),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Text(
                                          homeViewModel
                                              .currentEffect.ingredients[index],
                                          softWrap: true,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 16 /
                                                  MediaQuery.of(context)
                                                      .textScaleFactor,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .body1
                                                  .color),
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
                                  onPressed: () {
                                    // Navigator.of(context).pop();
                                    homeViewModel.changeItem4(homeViewModel
                                        .currentEffect.ingredients[index]);
                                    homeViewModel.nulifyCurrentInfo();
                                    homeViewModel.fecharInfos();
                                    homeViewModel.getInfoI(INGREDIENT_URL +
                                        homeViewModel.currentIngredient.url);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IngredientInfo()));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
