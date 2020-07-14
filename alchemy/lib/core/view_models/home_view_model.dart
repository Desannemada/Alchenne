import 'dart:convert';

import 'package:alchemy/core/models/efeitos.dart';
import 'package:alchemy/core/models/infoE.dart';
import 'package:alchemy/core/models/infoI.dart';
import 'package:alchemy/core/models/ingredientes.dart';
import 'package:alchemy/core/view_models/base_view_model.dart';
import 'package:alchemy/information/all_info_json.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends BaseViewModel {
  // List backgrounds = List();
  // List currentBackground = [0];
  // bool bgColor = true;

  List<Ingredientes> ingredientes = List();
  List<Efeitos> efeitos = List();
  List ingredientsEffects = List();

  List<IngredienteInfo> iInfos = List();
  List<EfeitoInfo> eInfos = List();

  List<Ingredientes> potionIngredients = List();
  List possiblePotions = List();

  Ingredientes currentIngredient;
  Efeitos currentEffect;
  IngredienteInfo currentIInfo;
  EfeitoInfo currentEInfo;

  int errorResponse = 0;

  int currentPositionOnAlphabetScroll = -1;
  int currentPositionOnAlphabetScroll2 = -1;
  int currentPositionOnAlphabetScroll3 = -1;
  int currentPositionOnAlphabetScroll4 = -1;
  String alphabetBubble = "";

  bool mostrarBackground;
  bool mostrarLocations;

  GlobalKey sizeC = GlobalKey();
  GlobalKey sizeC2 = GlobalKey();
  GlobalKey sizeC3 = GlobalKey();
  GlobalKey sizeC4 = GlobalKey();

  double heightOfItem;
  bool aux = false;

  List<int> favIngredientes = [];
  List<int> favIColors = [];
  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.blue[900],
    Colors.purple,
    Color(0xFFfddfc0),
  ];
  List<int> favEfeitos = [];
  bool currentFav = true;

  List<List> recentes = [];

  HomeViewModel() {
    mostrarBackground = false;
    mostrarLocations = false;
    getIngredients();
    getEffects();
    getFavs();
    getRecentes();

    potionIngredients = [null, null, null];

    // backgrounds = [
    //   [
    //     AssetImage("assets/bg/b1_1.jpg"),
    //     AssetImage("assets/bg/b1_2.jpg"),
    //     AssetImage("assets/bg/b1_3.jpg"),
    //     AssetImage("assets/bg/b1_4.jpg"),
    //     "assets/bg/background1.jpg"
    //   ],
    //   [
    //     AssetImage("assets/bg/b3_1.jpg"),
    //     AssetImage("assets/bg/b3_2.jpg"),
    //     AssetImage("assets/bg/b3_3.jpg"),
    //     AssetImage("assets/bg/b3_4.jpg"),
    //     "assets/bg/background3.jpg"
    //   ],
    //   [
    //     AssetImage("assets/bg/b4_1.jpg"),
    //     AssetImage("assets/bg/b4_2.jpg"),
    //     AssetImage("assets/bg/b4_3.jpg"),
    //     AssetImage("assets/bg/b4_4.jpg"),
    //     "assets/bg/background4.jpg"
    //   ],
    //   [
    //     AssetImage("assets/bg/b5_1.jpg"),
    //     AssetImage("assets/bg/b5_2.jpg"),
    //     AssetImage("assets/bg/b5_3.jpg"),
    //     AssetImage("assets/bg/b5_4.jpg"),
    //     "assets/bg/background5.jpg"
    //   ],
    //   [
    //     AssetImage("assets/bg/b6_1.jpg"),
    //     AssetImage("assets/bg/b6_2.jpg"),
    //     AssetImage("assets/bg/b6_3.jpg"),
    //     AssetImage("assets/bg/b6_4.jpg"),
    //     "assets/bg/background6.jpg"
    //   ]
    // ];
    // chooseBackground();
  }

  void getIngredients() async {
    // try {
    //   var response = await api.getIngredientsFromJson();
    //   if (response is List<Ingredientes>) {
    //     ingredientes = response;
    //     for (var item in ingredientes) {
    //       ingredientsEffects.add(item);
    //       ingredientsEffects.sort((a, b) => a.title.compareTo(b.title));
    //     }
    //   } else if (response is int) {
    //     errorResponse = -1;
    //   }
    // } catch (e) {
    //   errorResponse = -1;
    //   throw e;
    // }
    ingredientes = ingredientesFromJson(jsonEncode(AllInfo().ingredientes));
    for (var item in ingredientes) {
      ingredientsEffects.add(item);
      ingredientsEffects.sort((a, b) => a.title.compareTo(b.title));
    }
    iInfos = [];
    for (var item in AllInfo().ingredientesInfo) {
      iInfos.add(ingredienteInfoFromJson(json.encode(item)));
    }
    notifyListeners();
  }

  void getEffects() async {
    // try {
    //   var response = await api.getEffectsFromJson();
    //   if (response is List<Efeitos>) {
    //     efeitos = response;
    //     for (var item in efeitos) {
    //       ingredientsEffects.add(item);
    //       ingredientsEffects.sort((a, b) => a.title.compareTo(b.title));
    //     }
    //   } else if (response is int) {
    //     errorResponse = -1;
    //   }
    // } catch (e) {
    //   errorResponse = -1;
    //   throw e;
    // }
    efeitos = efeitosFromJson(jsonEncode(AllInfo().efeitos));
    eInfos = [];
    for (var item in AllInfo().efeitosInfo) {
      eInfos.add(efeitoInfoFromJson(json.encode(item)));
    }
    for (var item in efeitos) {
      ingredientsEffects.add(item);
      ingredientsEffects.sort((a, b) => a.title.compareTo(b.title));
    }
    notifyListeners();
  }

  void nulifyCurrentInfo() {
    currentIInfo = null;
    notifyListeners();
  }

  void nulifyCurrentInfo2() {
    currentEInfo = null;
    notifyListeners();
  }

  void getInfoI(var index) async {
    // try {
    //   var response = await api.getURLFromJson(url);
    //   if (response is IngredienteInfo) {
    //     currentIInfo = response;
    //     errorResponse = 0;
    //   } else if (response is int) {
    //     errorResponse = -1;
    //   }
    // } catch (e) {
    //   errorResponse = -1;
    //   throw e;
    // }
    if (index is int) {
      currentIInfo = iInfos[index];
    } else {
      for (var i = 0; i < ingredientes.length; i++) {
        if (ingredientes[i].title == index) {
          currentIInfo = iInfos[i];
          break;
        }
      }
    }
    notifyListeners();
  }

  void getInfoE(var index) async {
    // try {
    //   var response = await api.getURL2FromJson(url);
    //   if (response is EfeitoInfo) {
    //     currentEInfo = response;
    //     errorResponse = 0;
    //   } else if (response is int) {
    //     errorResponse = -1;
    //   }
    // } catch (e) {
    //   errorResponse = -1;
    //   throw e;
    // }
    if (index is int) {
      currentEInfo = eInfos[index];
    } else {
      for (var i = 0; i < efeitos.length; i++) {
        if (efeitos[i].title == index) {
          currentEInfo = eInfos[i];
          break;
        }
      }
    }
    notifyListeners();
  }

  // void chooseBackground() {
  //   var chosen = new Random();
  //   int c = 1 + chosen.nextInt(5);
  //   currentBackground[0] = backgrounds[c - 1];
  //   if (c == 2 || c == 4) {
  //     bgColor = false;
  //   }
  //   notifyListeners();
  // }

  void refresh() {
    errorResponse = 0;
    getIngredients();
    getEffects();
    notifyListeners();
  }

  void changeItem(Ingredientes item) {
    currentIngredient = item;
    notifyListeners();
  }

  void changeItem2(Efeitos item) {
    currentEffect = item;
    notifyListeners();
  }

  void changeItem3(String title) {
    for (var item in efeitos) {
      if (item.title == title) {
        currentEffect = item;
        notifyListeners();
        break;
      }
    }
  }

  void changeItem4(String title) {
    for (var item in ingredientes) {
      if (item.title == title) {
        currentIngredient = item;
        notifyListeners();
        break;
      }
    }
  }

  void updatePosition(int i) {
    currentPositionOnAlphabetScroll = i;
    notifyListeners();
  }

  void updatePosition2(int i) {
    currentPositionOnAlphabetScroll2 = i;
    notifyListeners();
  }

  void updatePosition3(int i) {
    currentPositionOnAlphabetScroll3 = i;
    notifyListeners();
  }

  void updatePosition4(int i) {
    currentPositionOnAlphabetScroll4 = i;
    notifyListeners();
  }

  void changeBubble(String b) {
    alphabetBubble = b;
    notifyListeners();
  }

  returnLi(int index) {
    for (var i = 0; i < currentIInfo.innerLocations.indexes.length; i++) {
      if (currentIInfo.innerLocations.indexes[i] == index) {
        return i;
      }
    }
  }

  void changeMostrarBackground() {
    mostrarBackground = !mostrarBackground;
    notifyListeners();
  }

  void changeMostrarLocations() {
    mostrarLocations = !mostrarLocations;
    notifyListeners();
  }

  void fecharInfos() {
    mostrarLocations = false;
    mostrarBackground = false;
    notifyListeners();
  }

  void updatePotionIngredients(int slot, Ingredientes ingredient) {
    potionIngredients[slot - 1] = ingredient;
    notifyListeners();
  }

  void updateContainerHeight(double height) {
    if (heightOfItem == null) {
      heightOfItem = height;
      notifyListeners();
    }
  }

  void updateCurrentFav(bool aux) {
    currentFav = aux;
    notifyListeners();
  }

  void updateIFavList(int index, int color) {
    if (favIngredientes.contains(index)) {
      for (var i = 0; i < favIngredientes.length; i++) {
        if (favIngredientes[i] == index) {
          favIColors.removeAt(i);
        }
      }
      favIngredientes.remove(index);
    } else {
      favIngredientes.add(index);
      favIngredientes.sort();
      for (var i = 0; i < favIngredientes.length; i++) {
        if (favIngredientes[i] == index) {
          favIColors.insert(i, color);
        }
      }
    }
    saveFavs(true);
    notifyListeners();
  }

  void updateEFavList(int index) {
    if (favEfeitos.contains(index)) {
      favEfeitos.remove(index);
    } else {
      favEfeitos.add(index);
      favEfeitos.sort();
    }
    saveFavs(false);
    notifyListeners();
  }

  int getColor(int index) {
    for (var i = 0; i < favIngredientes.length; i++) {
      if (favIngredientes[i] == index) {
        return i;
      }
    }
    return 0;
  }

  void updatePossiblePotions() {
    Ingredientes i1 = potionIngredients[0];
    Ingredientes i2 = potionIngredients[1];
    Ingredientes i3 = potionIngredients[2];
    possiblePotions = List();
    if (i1 != null && i2 != null && i3 != null) {
      for (var item in efeitos) {
        if (item.ingredients.contains(i1.title) &&
            item.ingredients.contains(i2.title) &&
            item.ingredients.contains(i3.title)) {
          possiblePotions.add([item, "[1] [2] [3]"]);
        } else if (item.ingredients.contains(i1.title) &&
            item.ingredients.contains(i2.title)) {
          possiblePotions.add([item, "[1] [2]"]);
        } else if (item.ingredients.contains(i1.title) &&
            item.ingredients.contains(i3.title)) {
          possiblePotions.add([item, "[1] [3]"]);
        } else if (item.ingredients.contains(i2.title) &&
            item.ingredients.contains(i3.title)) {
          possiblePotions.add([item, "[2] [3]"]);
        }
      }
    } else if (i1 != null && i2 != null) {
      for (var item in efeitos) {
        if (item.ingredients.contains(i1.title) &&
            item.ingredients.contains(i2.title)) {
          possiblePotions.add([item, "[1] [2]"]);
        }
      }
    }
    notifyListeners();
  }

  returnURL(String url) {
    String aux;
    String aux2;
    int aux3 = 0;
    for (var i = 0; i < url.length; i++) {
      if (url[i] + url[i + 1] == "i/") {
        aux = url.substring(i + 2);
        for (var j = 0; j < aux.length; j++) {
          if (aux[j] == "_") {
            aux3 = aux3 + 1;
          }
          if (aux[j] == "%") {
            aux3 = aux3 + 2;
          }
        }
        aux2 = aux
            .substring(0, (aux.length + aux3) ~/ 2)
            .replaceAll("_", " ")
            .replaceAll("%27", "'");
        aux = url.substring(0, 6) + aux.substring(0, (aux.length + aux3) ~/ 2);
        return [aux, aux2];
      }
    }
  }

  getEfeitoImage(String nomeEfeito) {
    for (var item in efeitos) {
      if (nomeEfeito == "Paralyze" && item.title == "Paralysis") {
        return item.icon;
      }
      if (item.title == nomeEfeito) {
        return item.icon;
      }
    }
  }

  List<AryEffect> getIngredientsEffects() {
    List<AryEffect> temp = List<AryEffect>();
    temp.add(currentIngredient.primaryEffect);
    temp.add(currentIngredient.secondaryEffect);
    temp.add(currentIngredient.tertiaryEffect);
    temp.add(currentIngredient.quaternaryEffect);
    return temp;
  }

  isLetter(String letter, String tab) {
    if (tab == "ingrediente") {
      for (var i = 0; i < ingredientes.length; i++) {
        if (ingredientes[i].title[0] == letter) {
          return true;
        }
      }
      return false;
    } else if (tab == "efeito") {
      for (var i = 0; i < efeitos.length; i++) {
        if (efeitos[i].title[0] == letter) {
          return true;
        }
      }
      return false;
    } else if (tab == "favEfeito") {
      for (var i = 0; i < favEfeitos.length; i++) {
        if (efeitos[favEfeitos[i]].title[0] == letter) {
          return true;
        }
      }
      return false;
    } else if (tab == "favIngrediente") {
      for (var i = 0; i < favIngredientes.length; i++) {
        if (ingredientes[favIngredientes[i]].title[0] == letter) {
          return true;
        }
      }
      return false;
    }
  }

  void getPosition(int index, String tab, ScrollController c) {
    if (tab == "ingrediente") {
      if (String.fromCharCode(65 + index) == "Y") {
        c.jumpTo(c.position.maxScrollExtent);
        updatePosition(index);
        changeBubble(String.fromCharCode(65 + index));
      } else {
        for (var i = 0; i < ingredientes.length; i++) {
          if (ingredientes[i].title[0] == String.fromCharCode(65 + index)) {
            c.jumpTo((i ~/ 2).toDouble() * (heightOfItem + 20));
            updatePosition(index);
            changeBubble(String.fromCharCode(65 + index));
            break;
          }
        }
      }
    } else if (tab == "efeito") {
      for (var i = 0; i < efeitos.length; i++) {
        if (efeitos[i].title[0] == String.fromCharCode(65 + index)) {
          c.jumpTo((i ~/ 2).toDouble() * (heightOfItem + 20));
          updatePosition2(index);
          changeBubble(String.fromCharCode(65 + index));
          break;
        }
      }
    } else if (tab == "favEfeito") {
      for (var i = 0; i < favEfeitos.length; i++) {
        if (efeitos[favEfeitos[i]].title[0] ==
            String.fromCharCode(65 + index)) {
          if (((i ~/ 2).toDouble() * (heightOfItem + 20)) >=
              c.position.maxScrollExtent) {
            c.jumpTo(c.position.maxScrollExtent);
          } else {
            c.jumpTo((i ~/ 2).toDouble() * (heightOfItem + 20));
          }
          updatePosition3(index);
          changeBubble(String.fromCharCode(65 + index));
          break;
        }
      }
    } else if (tab == "favIngrediente") {
      for (var i = 0; i < favIngredientes.length; i++) {
        if (ingredientes[favIngredientes[i]].title[0] ==
            String.fromCharCode(65 + index)) {
          if (((i ~/ 2).toDouble() * (heightOfItem + 20)) >=
              c.position.maxScrollExtent) {
            c.jumpTo(c.position.maxScrollExtent);
          } else {
            c.jumpTo((i ~/ 2).toDouble() * (heightOfItem + 20));
          }
          updatePosition4(index);
          changeBubble(String.fromCharCode(65 + index));
          break;
        }
      }
    }
  }

  saveFavs(bool choice) async {
    print("Saving");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (choice) {
      List<String> favI = [];
      List<String> favIC = [];
      for (var i = 0; i < favIngredientes.length; i++) {
        favI.add(favIngredientes[i].toString());
        favIC.add(favIColors[i].toString());
      }
      prefs.setStringList('favI', favI);
      prefs.setStringList('favIC', favIC);
    } else {
      List<String> favE = [];
      for (var item in favEfeitos) {
        favE.add(item.toString());
      }
      prefs.setStringList('favE', favE);
    }
  }

  getFavs() async {
    print("Getting Info");
    favIngredientes = [];
    favIColors = [];
    favEfeitos = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favI = prefs.getStringList('favI') ?? [];
    List<String> favIC = prefs.getStringList('favIC') ?? [];
    List<String> favE = prefs.getStringList('favE') ?? [];

    for (var i = 0; i < favI.length; i++) {
      favIngredientes.add(int.parse(favI[i]));
      favIColors.add(int.parse(favIC[i]));
    }
    for (var item in favE) {
      favEfeitos.add(int.parse(item));
    }

    notifyListeners();
  }

  void updateRecentes(var item, bool type) {
    if (item is Ingredientes) {
      for (var i = 0; i < ingredientes.length; i++) {
        if (ingredientes[i] == item) {
          recentes.removeWhere((element) => element[0] == i && element[1] == 0);
          if (type) {
            if (recentes.length == 10) {
              recentes.removeLast();
            }
            // print(item.title);
            recentes.insert(0, [i, 0]);
          }
          saveRecentes();
          break;
        }
      }
    } else if (item is Efeitos) {
      for (var i = 0; i < efeitos.length; i++) {
        if (efeitos[i] == item) {
          recentes.removeWhere((element) => element[0] == i && element[1] == 1);
          if (type) {
            if (recentes.length == 10) {
              recentes.removeLast();
            }
            recentes.insert(0, [i, 1]);
          }
          saveRecentes();
          break;
        }
      }
    }

    notifyListeners();
  }

  void clearRecentes() {
    recentes = [];
    saveRecentes();
    notifyListeners();
  }

  saveRecentes() async {
    print("Saving Recentes");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> rec = [];
    for (var i = 0; i < recentes.length; i++) {
      rec.add(recentes[i].toString());
    }
    prefs.setStringList('recentes', rec);
  }

  getRecentes() async {
    print("Getting Recentes");
    recentes = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> rec = prefs.getStringList('recentes') ?? [];
    for (var i = 0; i < rec.length; i++) {
      recentes.add(jsonDecode(rec[i]));
    }
    notifyListeners();
  }
}
