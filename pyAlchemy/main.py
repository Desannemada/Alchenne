from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin
from bs4 import BeautifulSoup
import requests

# Configurando servidor
app = Flask("alchemy")
cors = CORS(app)
app.config["CORS_HEADERS"] = "Content-Type"

baseURL = "https://elderscrolls.fandom.com"
baseURL2 = "https://en.uesp.net"


@cross_origin()
@app.route("/ingredientes")
def getIngredientes():
    dog = BeautifulSoup(requests.get(
        f"{baseURL}/wiki/Ingredients_(Skyrim)").content, "html5lib")
    dogTable = dog.find("table", attrs={"id": "ingredientsTable", })
    tbody = dogTable.find("tbody")
    dogTable = tbody.findAll("tr")

    listaRetorno = []

    for i in range(1, len(dogTable)):
        listaDogis = dogTable[i].findAll("td")

        listaRetorno.append({
            "title": listaDogis[0].a["title"].replace(" (Skyrim)", "").replace(" (Dragonborn)", ""),
            "primaryEffect": {"title": listaDogis[1].a["title"], "url": listaDogis[1].a["href"]},
            "secondaryEffect": {"title": listaDogis[2].a["title"], "url": listaDogis[1].a["href"]},
            "tertiaryEffect": {"title": listaDogis[3].a["title"], "url": listaDogis[1].a["href"]},
            "quaternaryEffect": {"title": listaDogis[4].a["title"], "url": listaDogis[1].a["href"]},
            "weight": listaDogis[5].text.replace("\n", ""),
            "value": listaDogis[6].text.replace("\n", ""),
            "url": listaDogis[0].a["href"]
        })

    return jsonify(listaRetorno)


@cross_origin()
@app.route("/efeitos")
def getEffects():
    cat = BeautifulSoup(requests.get(
        f"{baseURL2}/wiki/Skyrim:Alchemy_Effects").content, "html5lib")
    catDiv = cat.find(
        "div", attrs={"id": "mw-content-text"})
    catTables = catDiv.findAll(
        "table")
    catTable = catTables[3]
    tbody2 = catTable.find("tbody")
    catTable = tbody2.findAll("tr")

    listaRetorno2 = []

    for j in range(1, len(catTable)):
        listaCatis = catTable[j].find("th")
        listaCatis2 = catTable[j].findAll("td")

        listaCatis3 = listaCatis2[0].findAll("a")

        listaRetorno2.append({
            "title": listaCatis.a.text,
            "ingredients": [],
            "icon": "",
            "description": listaCatis2[1].text.replace("<mag>% ", "").replace("<dur> seconds", "a certain amount of time").replace("<mag> points of", "a certain amount of").replace("<mag>", "a certain amount of")
        })

        tempIn = []
        for k in range(len(listaCatis3)):
            if listaCatis3[k].text in ["DB", "", "DG", "HF", "[1]"]:
                pass
            else:
                tempIn.append(listaCatis3[k].text)
        listaRetorno2[j-1].update(ingredients=tempIn)

    for i in range(len(listaRetorno2)):
        title = listaRetorno2[i]["title"]
        if "Fire" in title:
            listaRetorno2[i].update(icon="assets/effects/Fire.png")
        elif "Frost" in title or "Slow" in title:
            listaRetorno2[i].update(icon="assets/effects/Ice.png")
        elif "Shock" in title:
            listaRetorno2[i].update(icon="assets/effects/Shock.png")
        elif "Waterbreathing" in title:
            listaRetorno2[i].update(icon="assets/effects/Alteration.png")
        elif "Lingering" in title or "Paralyze" in title:
            listaRetorno2[i].update(icon="assets/effects/Paralyze.png")
        elif "Resist" in title or "Weakness" in title or "Fortify" in title:
            listaRetorno2[i].update(icon="assets/effects/Restoration.png")
        elif "Invisibility" in title:
            listaRetorno2[i].update(icon="assets/effects/Illusion.png")
        elif "Damage" in title or "Ravage" in title or "Fear" in title or "Frenzy" in title:
            listaRetorno2[i].update(icon="assets/effects/Illusion2.png")
        else:
            listaRetorno2[i].update(icon="assets/effects/Heal.png")

    for i in listaRetorno2:
        print(i)
        print("\n")


# Inicializando servidor
if __name__ == "__main__":
    app.run(host="10.1.3.87", port=5000)  # ip da maquina
