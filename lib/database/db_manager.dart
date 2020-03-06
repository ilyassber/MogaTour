import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/model/event.dart';
import 'package:alpha_task/model/site.dart';
import 'package:sembast/sembast.dart';

import 'app_database.dart';

class DbManager {
  // ignore: constant_identifier_names
  static const String SITE_STORE_NAME = 'site';
  // ignore: constant_identifier_names
  static const String CIRCUIT_STORE_NAME = 'circuit';
  // ignore: constant_identifier_names
  static const String CATEGORY_STORE_NAME = 'category';
  // ignore: constant_identifier_names
  static const String EVENT_STORE_NAME = 'event';

  final _siteStore = intMapStoreFactory.store(SITE_STORE_NAME);
  final _circuitStore = intMapStoreFactory.store(CIRCUIT_STORE_NAME);
  final _categoryStore = intMapStoreFactory.store(CATEGORY_STORE_NAME);
  final _eventStore = intMapStoreFactory.store(EVENT_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  // Site Management Functions

  Future insertSite(Site site) async {
    await _siteStore.record(site.siteId).put(await _db, site.toMap());
  }

  Future updateSite(Site site) async {
    print(site.images[0].toMap());
    final finder = Finder(filter: Filter.byKey(site.siteId));
    await _siteStore.update(
      await _db,
      site.toMap(),
      finder: finder,
    );
  }

  Future deleteSite(Site site) async {
    final finder = Finder(filter: Filter.byKey(site.siteId));
    await _siteStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Site>> getAllSites() async {

    final recordSnapshots = await _siteStore.find(
      await _db,
    );

    List<Site> sites = recordSnapshots.map((snapshot) {
      final site = Site.fromMap(snapshot.value);
      site.key = snapshot.key;
      return site;
    }).toList();
    for (int i = 0; i < sites.length; i++) {
      sites[i].categories.add(new Category(
        categoryId: -1,
        categoryName: 'All',
        image: 'assets/images/sites/site2.jpg',
      ));
    }
    return sites;
  }

  Future deleteAllSite() async {
    final finder = Finder();
    await _siteStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Site>> getAllSortedClick() async {
    final finder = Finder(sortOrders: [
      SortOrder('nbr_clicks'),
    ]);

    final recordSnapshots = await _siteStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final site = Site.fromMap(snapshot.value);
      //site.siteId = snapshot.key;
      return site;
    }).toList();
  }

  // Circuit Management Functions

  Future insertCircuit(Circuit circuit) async {
    await _circuitStore.record(circuit.circuitId).put(await _db, circuit.toMap());
  }

  Future updateCircuit(Circuit circuit) async {
    final finder = Finder(filter: Filter.byKey(circuit.circuitId));
    print(finder.toString());
    await _circuitStore.update(
      await _db,
      circuit.toMap(),
      finder: finder,
    );
  }

  Future deleteCircuit(Circuit circuit) async {
    final finder = Finder(filter: Filter.byKey(circuit.circuitId));

    final recordSnapshots = await _circuitStore.find(
      await _db,
      finder: finder,
    );

    Circuit oldCircuit = recordSnapshots.map((snapshot) {
      final circuit = Circuit.fromMap(snapshot.value);
      circuit.key = snapshot.key;
      return circuit;
    }).toList()[0];

    print(oldCircuit.toMap());

    await _circuitStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Circuit>> getAllCircuits() async {

    final recordSnapshots = await _circuitStore.find(
      await _db,
    );

    return recordSnapshots.map((snapshot) {
      final circuit = Circuit.fromMap(snapshot.value);
      circuit.key = snapshot.key;
      return circuit;
    }).toList();
  }

  Future deleteAllCircuit() async {
    final finder = Finder();
    await _circuitStore.delete(
      await _db,
      finder: finder,
    );
  }

  // Category Management Functions

  Future insertCategory(Category category) async {
    //await _categoryStore.add(await _db, category.toMap());
    await _categoryStore.record(category.categoryId).put(await _db, category.toMap());
  }

  Future updateCategory(Category category) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(category.categoryId));
    await _categoryStore.update(
      await _db,
      category.toMap(),
      finder: finder,
    );
  }

  Future deleteCategory(Category category) async {
    final finder = Finder(filter: Filter.byKey(category.categoryId));
    await _categoryStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Category>> getAllCategories() async {
    final recordSnapshots = await _categoryStore.find(
      await _db,
    );

    return recordSnapshots.map((snapshot) {
      final category = Category.fromMap(snapshot.value);
      category.key = snapshot.key;
    }).toList();
  }

  Future deleteAllCategory() async {
    final finder = Finder();
    await _categoryStore.delete(
      await _db,
      finder: finder,
    );
  }

  // Event Management Functions

  Future insertEvent(Event event) async {
    //await _eventStore.add(await _db, event.toMap());
    await _eventStore.record(event.id).put(await _db, event.toMap());
  }

  Future updateEvent(Event event) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(event.id));
    await _eventStore.update(
      await _db,
      event.toMap(),
      finder: finder,
    );
  }

  Future deleteEvent(Event event) async {
    final finder = Finder(filter: Filter.byKey(event.id));
    await _eventStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Event>> getAllEvents() async {
    final recordSnapshots = await _eventStore.find(
      await _db,
    );

    return recordSnapshots.map((snapshot) {
      final event = Event.fromMap(snapshot.value);
      event.key = snapshot.key;
    }).toList();
  }

  Future deleteAllEvent() async {
    final finder = Finder();
    await _eventStore.delete(
      await _db,
      finder: finder,
    );
  }
}