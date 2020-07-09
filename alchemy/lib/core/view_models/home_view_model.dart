import 'dart:convert';
import 'dart:math';

import 'package:alchemy/core/models/efeitos.dart';
import 'package:alchemy/core/models/infoE.dart';
import 'package:alchemy/core/models/infoI.dart';
import 'package:alchemy/core/models/ingredientes.dart';
import 'package:alchemy/core/services/custom_api.dart';
import 'package:alchemy/core/view_models/base_view_model.dart';
import 'package:alchemy/information/all_info_json.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends BaseViewModel {
  CustomAPI api = CustomAPI();
  static HomeViewModel homeViewModel;
  static HomeViewModel instance() {
    if (homeViewModel == null) {
      homeViewModel = HomeViewModel();
    }
    return homeViewModel;
  }

  List backgrounds = List();
  List currentBackground = [0];
  bool bgColor = true;

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

  HomeViewModel() {
    mostrarBackground = false;
    mostrarLocations = false;
    getIngredients();
    getEffects();
    getFavs();

    potionIngredients = [null, null, null];

    backgrounds = [
      [
        AssetImage("assets/bg/b1_1.jpg"),
        AssetImage("assets/bg/b1_2.jpg"),
        AssetImage("assets/bg/b1_3.jpg"),
        AssetImage("assets/bg/b1_4.jpg"),
        "assets/bg/background1.jpg"
      ],
      [
        AssetImage("assets/bg/b3_1.jpg"),
        AssetImage("assets/bg/b3_2.jpg"),
        AssetImage("assets/bg/b3_3.jpg"),
        AssetImage("assets/bg/b3_4.jpg"),
        "assets/bg/background3.jpg"
      ],
      [
        AssetImage("assets/bg/b4_1.jpg"),
        AssetImage("assets/bg/b4_2.jpg"),
        AssetImage("assets/bg/b4_3.jpg"),
        AssetImage("assets/bg/b4_4.jpg"),
        "assets/bg/background4.jpg"
      ],
      [
        AssetImage("assets/bg/b5_1.jpg"),
        AssetImage("assets/bg/b5_2.jpg"),
        AssetImage("assets/bg/b5_3.jpg"),
        AssetImage("assets/bg/b5_4.jpg"),
        "assets/bg/background5.jpg"
      ],
      [
        AssetImage("assets/bg/b6_1.jpg"),
        AssetImage("assets/bg/b6_2.jpg"),
        AssetImage("assets/bg/b6_3.jpg"),
        AssetImage("assets/bg/b6_4.jpg"),
        "assets/bg/background6.jpg"
      ]
    ];
    chooseBackground();
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

  void chooseBackground() {
    var chosen = new Random();
    int c = 1 + chosen.nextInt(5);
    currentBackground[0] = backgrounds[c - 1];
    if (c == 2 || c == 4) {
      bgColor = false;
    }
    notifyListeners();
  }

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
    heightOfItem = height;
    notifyListeners();
  }

  void updateCurrentFav(bool aux) {
    currentFav = aux;
    notifyListeners();
  }

  void updateIFavList(int index, int color) {
    if (favIngredientes.contains(index)) {
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
    print("Getting info");
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

  // void precacheImages(BuildContext context) {
  //   for (var i = 0; i < images.length; i++) {
  //     for (var j = 0; j < images[i].length; j++) {
  //       if (i == 0) {
  //         precacheImage(AssetImage("assets/${images[i][j]}"), context);
  //       } else if (i == 1) {
  //         precacheImage(AssetImage("assets/bg/${images[i][j]}"), context);
  //       } else if (i == 2) {
  //         precacheImage(AssetImage("assets/effects/${images[i][j]}"), context);
  //       } else if (i == 3) {
  //         precacheImage(
  //             AssetImage("assets/ingredients/${images[i][j]}"), context);
  //       }
  //     }
  //   }
  // }

  // List<List<String>> images = [
  //   [
  //     "coin.png",
  //     "efeito.webp",
  //     "flask.png",
  //     "ingredient.png",
  //     "loading.gif",
  //     "potion.png",
  //     "quill.webp",
  //     "star.png",
  //   ],
  //   [
  //     "b1_1.jpg",
  //     "b1_2.jpg",
  //     "b1_3.jpg",
  //     "b1_4.jpg",
  //     "b3_1.jpg",
  //     "b3_2.jpg",
  //     "b3_3.jpg",
  //     "b3_4.jpg",
  //     "b4_1.jpg",
  //     "b4_2.jpg",
  //     "b4_3.jpg",
  //     "b4_4.jpg",
  //     "b5_1.jpg",
  //     "b5_2.jpg",
  //     "b5_3.jpg",
  //     "b5_4.jpg",
  //     "b6_1.jpg",
  //     "b6_2.jpg",
  //     "b6_3.jpg",
  //     "b6_4.jpg",
  //     "background1.jpg",
  //     "background3.jpg",
  //     "background4.jpg",
  //     "background5.jpg",
  //     "background6.jpg",
  //   ],
  //   [
  //     "Alteration.png",
  //     "Fire.png",
  //     "Heal.png",
  //     "Ice.png",
  //     "Illusion.png",
  //     "Illusion2.png",
  //     "Paralyze.png",
  //     "Restoration.png",
  //     "Shock.png",
  //   ],
  //   [
  //     "AbeceanLongfin.png",
  //     "AncestorMothWing.png",
  //     "AshCreepCluster.png",
  //     "AshenGrassPod.png",
  //     "AshHopperJelly.png",
  //     "BearClaws.png",
  //     "Bee.png",
  //     "BeehiveHusk.png",
  //     "Berit'sAshes.png",
  //     "BleedingCrown.png",
  //     "Blisterwort.png",
  //     "BlueButterflyWing.png",
  //     "BlueDartwing.png",
  //     "BlueMountainFlower.png",
  //     "BoarTusk.png",
  //     "BoneMeal.png",
  //     "BriarHeart.png",
  //     "BurntSprigganWood.png",
  //     "ButterflyWing.png",
  //     "CanisRoot.png",
  //     "CharredSkeeverHide.png",
  //     "ChaurusEggs.png",
  //     "ChaurusHunterAntennae.png",
  //     "Chicken'sEgg.png",
  //     "CreepCluster.png",
  //     "CrimsonNirnroot.png",
  //     "CyrodilicSpadetail.png",
  //     "DaedraHeart.png",
  //     "Deathbell.png",
  //     "Dragon'sTongue.png",
  //     "DwarvenOil.png",
  //     "Ectoplasm.png",
  //     "ElvesEar.png",
  //     "EmperorParasolMoss.png",
  //     "EyeofSabreCat.png",
  //     "FalmerEar.png",
  //     "FelsaadTernFeathers.png",
  //     "FireSalts.png",
  //     "FlyAmanita.png",
  //     "FrostMirriam.png",
  //     "FrostSalts.png",
  //     "Garlic.png",
  //     "Giant'sToe.png",
  //     "GiantLichen.png",
  //     "Gleamblossom.png",
  //     "GlowDust.png",
  //     "GlowingMushroom.png",
  //     "GrassPod.png",
  //     "HagravenClaw.png",
  //     "HagravenFeathers.png",
  //     "HangingMoss.png",
  //     "Hawk'sEgg.png",
  //     "HawkBeak.png",
  //     "HawkFeathers.png",
  //     "Histcarp.png",
  //     "Honeycomb.png",
  //     "HumanFlesh.png",
  //     "HumanHeart.png",
  //     "IceWraithTeeth.png",
  //     "ImpStool.png",
  //     "JarrinRoot.png",
  //     "JazbayGrapes.png",
  //     "JuniperBerries.png",
  //     "LargeAntlers.png",
  //     "Lavender.png",
  //     "LunaMothWing.png",
  //     "MoonSugar.png",
  //     "MoraTapinella.png",
  //     "MudcrabChitin.png",
  //     "Namira'sRot.png",
  //     "NetchJelly.png",
  //     "Nightshade.png",
  //     "Nirnroot.png",
  //     "NordicBarnacle.png",
  //     "OrangeDartwing.png",
  //     "Pearl.png",
  //     "PineThrushEgg.png",
  //     "PoisonBloom.png",
  //     "PowderedMammothTusk.png",
  //     "PurpleMountainFlower.png",
  //     "RedMountainFlower.png",
  //     "RiverBetty.png",
  //     "RockWarblerEgg.png",
  //     "SabreCatTooth.png",
  //     "SalmonRoe.png",
  //     "SaltPile.png",
  //     "ScalyPholiota.png",
  //     "Scathecraw.png",
  //     "SilversidePerch.png",
  //     "SkeeverTail.png",
  //     "SlaughterfishEgg.png",
  //     "SlaughterfishScales.png",
  //     "SmallAntlers.png",
  //     "SmallPearl.png",
  //     "Snowberries.png",
  //     "SpawnAsh.png",
  //     "SpiderEgg.png",
  //     "SprigganSap.png",
  //     "SwampFungalPod.png",
  //     "Taproot.png",
  //     "ThistleBranch.png",
  //     "TorchbugThorax.png",
  //     "TramaRoot.png",
  //     "TrollFat.png",
  //     "TundraCotton.png",
  //     "VampireDust.png",
  //     "VoidSalts.png",
  //     "Wheat.png",
  //     "WhiteCap.png",
  //     "WispWrappings.png",
  //     "YellowMountainFlower.png",
  //   ],
  // ];
}
