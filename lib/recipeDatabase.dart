import 'package:Cookbook/recipe.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class RecipeDataBase {
  // private constructor
  RecipeDataBase._();
  static final RecipeDataBase instance = RecipeDataBase._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'recipe_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE recipe(title TEXT PRIMARY KEY, user TEXT, imageUrl TEXT, description TEXT, isFavorite INTEGER, favoriteCount INTEGER)",
        );
      },
      version: 1,
    );
  }



  void insertRecipe(Recipe recipe) async {
    final Database? db = await database;

    await db?.insert(
      'recipe',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateRecipe(Recipe recipe) async {
    final Database? db = await database;
    await db?.update("recipe", recipe.toMap(),
        where: "title = ?", whereArgs: [recipe.title]);
  }

  void deleteRecipe(String title) async {
    final Database? db = await database;
    db?.delete("recipe", where: "title = ?", whereArgs: [title]);
  }

  Future<List<Recipe>> recipes() async {
    final Database? db = await database;
    final List<Map<String, Object?>>? maps = await db?.query('recipe');
    List<Recipe> recipes = List.generate(maps!.length, (i) {
      return Recipe.fromMap(maps[i]);
    });

    if (recipes.isEmpty) {
      for (Recipe recipe in defaultRecipes) {
        insertRecipe(recipe);
      }
      recipes = defaultRecipes;
    }

    return recipes;
  }

  final List<Recipe> defaultRecipes = [ Recipe(
      "Pizza facile",
      "Par David Silvera",
      "https://assets.afcdn.com/recipe/20160519/15342_w600.jpg",
      "Faire cuire dans une po??le les lardons et les champignons.\n\nDans un bol, verser la bo??te de concentr?? de tomate, y ajouter un demi verre d'eau, ensuite mettre un carr?? de sucre (pour enlever l'acidit?? de la tomate) une pinc??e de sel, de poivre, et une pinc??e d'herbe de Provence.\n\nD??rouler la p??te ?? pizza sur le l??che frite de votre four, piquer-le.\n\nAvec une cuill??re ?? soupe, ??taler d??licatement la sauce tomate, ensuite y ajouter les lardons et les champignons bien dorer. Parsemer de fromage r??p??e.\n\nMettre au four ?? 220??, thermostat 7-8, pendant 20 min (ou lorsque le dessus de la pizza est dor??).Faire cuire dans une po??le les lardons et les champignons.\n\nDans un bol, verser la bo??te de concentr?? de tomate, y ajouter un demi verre d'eau, ensuite mettre un carr?? de sucre (pour enlever l'acidit?? de la tomate) une pinc??e de sel, de poivre, et une pinc??e d'herbe de Provence.\n\nD??rouler la p??te ?? pizza sur le l??che frite de votre four, piquer-le.\n\nAvec une cuill??re ?? soupe, ??taler d??licatement la sauce tomate, ensuite y ajouter les lardons et les champignons bien dorer. Parsemer de fromage r??p??e.\n\nMettre au four ?? 220??, thermostat 7-8, pendant 20 min (ou lorsque le dessus de la pizza est dor??).",
      false,
      50),
    Recipe(
        "Burger maison",
        "Par Cyril Lignac",
        "https://cac.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2Fcac.2F2018.2F09.2F25.2F03ab5e89-bad7-4a44-b952-b30c68934215.2Ejpeg/748x372/quality/90/crop-from/center/burger-maison.jpeg",
        "Pelez l???oignon rouge puis ??mincez-le. Rincez et essorez la roquette. Rincez la tomate puis coupez-la en rondelles.\nFaites chauffer l???huile dans une po??le et faites cuire les steaks 3 ?? 4 min de chaque c??t??, selon votre go??t. En fin de cuisson, salez, poivrez, disposez 1 tranche de cheddar sur chaque steak et laissez-la l??g??rement fondre.\nFendez les petits pains en 2 et toastez-les l??g??rement. Montez les burgers : tartinez chaque moiti?? de pain de sauce puis garnissez avec la viande, les rondelles de tomate, l???oignon cisel?? et les feuilles de roquette. Refermez les burgers et servez aussit??t.",
        true,
        33),
    Recipe(
        "Cr??pe comme chez nous",
        "Par Xouxou",
        "https://cac.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2Fcac.2F2018.2F09.2F25.2F830851b1-1f2a-4871-8676-6c06b0962938.2Ejpeg/748x372/quality/90/crop-from/center/crepes-comme-chez-nous.jpeg",
        "Versez la farine dans un grand saladier, creusez un puits. Cassez les ??ufs, d??layez petit ?? petit avec le lait sans former de grumeaux. Ajoutez l???huile et le sel et m??langez bien.\nLaissez reposer la p??te 1 h sous un torchon propre ?? temp??rature ambiante.\nHuilez l??g??rement une po??le ?? cr??pes, versez une demi-louche de p??te dans la po??le bien chaude, laissez cuire jusqu????? ce que les bords se d??tachent (30 sec environ). Retournez la cr??pe, faites cuire l???autre face et glissez-la sur une assiette.\nProc??dez ainsi pour toutes les cr??pes.",
        true,
        13),
    Recipe(
        "Cake nature sucr??",
        "Par Huguette",
        "https://cac.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2FCAC.2Fvar.2Fcui.2Fstorage.2Fimages.2Fdossiers-gourmands.2Ftendance-cuisine.2Fles-gateaux-du-gouter-45-recettes-gourmandes-en-diaporama-187414.2F1637287-1-fre-FR.2Fles-gateaux-du-gouter-45-recettes-gourmandes-en-diaporama.2Ejpg/748x372/quality/90/crop-from/center/cake-nature-sucre.jpeg",
        "Travaillez le beurre avec le sucre en poudre.\nIncorporez les ??ufs, 1 par 1. Ajoutez la farine.\nVersez dans un moule ?? empreinte rectangulaire en silicone. Faites cuire 45 ?? 50 min dans le four, pr??chauff?? ?? 180??C (th. 6).\nD??moulez et laissez refroidir avant de d??guster.",
        true,
        18),
    Recipe(
        "Donuts avec appareil ?? donuts",
        "Par Heud",
        "https://cac.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2Fcac.2F2018.2F09.2F25.2F80586d11-1f17-40ad-80ae-4cd9b5c42182.2Ejpeg/748x372/quality/90/crop-from/center/donuts-avec-appareil-a-donuts.jpeg",
        "D??layez la levure dans 2 cuil. ?? soupe de lait ti??de. R??servez 15 min. Fouettez les ??ufs avec les sucres. M??langez avec la farine et la levure. Incorporez le lait.\nLaissez la p??te reposer 1 h.\nFaites chauffer la machine et huilez les alv??oles avec un pinceau de cuisine. Versez des cuiller??es de p??te dans les alv??oles de la machine chaude, en ??vitant de mettre de la p??te au centre. Faites cuire 2 min environ.\nFaites fondre le chocolat. D??tendez-le avec un peu d'eau. Trempez-les beignets dans le chocolat. Parsemez de vermicelles. Laissez refroidir avant de d??guster.",
        true,
        109),
    Recipe(
        "Oreilles d'aman",
        "Par Esther",
        "https://2.bp.blogspot.com/-D9fvvQ1XyZk/WL7KSRDBe_I/AAAAAAAAhjI/udiioVWKJ20FV-P3WfW4V8TNXZDkQJ5bgCLcB/s1600/UNADJUSTEDNONRAW_thumb_3e0d.jpg",
        "Dans un saladier, battre l'??uf avec le sucre et le sucre vanill??.\nAjouter la farine et la levure et incorporer ?? la spatule.\nAjouter les morceaux de beurre et sabler avec les doigts comme quand on ??graine la semoule.\nMalaxer ensuite avec les mains pour obtenir une boule.\nLaisser reposer 1h au frigo.",
        true,
        55)
  ];
}