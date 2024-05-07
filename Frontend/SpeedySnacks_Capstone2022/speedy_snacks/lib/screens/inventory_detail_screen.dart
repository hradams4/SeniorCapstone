import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:speedy_snacks/screens/inventory_screen.dart';
import 'package:speedy_snacks/screens/menu_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class InventoryDetailScreen extends StatefulWidget {
  final String imgAmount;
  final String imgLabel;
  final String productLocation;
  const InventoryDetailScreen(
      {required this.imgAmount,
      required this.imgLabel,
      required this.productLocation});

  @override
  State<InventoryDetailScreen> createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends State<InventoryDetailScreen> {
  late WebSocketChannel channel;
  late StreamController streamController;
  var messageFromServer;
  final controller = TextEditingController();
  List<String> nameList = [];
  List<String> sizeList = [];
  List<String> imageList = [];
  List<String> costList = [];
  List<String> brandList = [];
  List<String> productIDList = [];
  List<String> availabilityList = [];
  int nameIdx = 0;
  int sizeIdx = 1;
  int imageIdx = 2;
  int costIdx = 3;
  int brandIdx = 4;
  int productIdx = 5;
  int availabilityIdx = 6;

  List<bool> availableList = [];

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
        Uri.parse('ws://asu.speedysnacks.co/ws/productDetail/'));
    streamController = StreamController.broadcast();
    streamController.addStream(channel.stream);

    streamController.stream.listen((channel) {
      var dataJson = json.decode(channel);
      messageFromServer = dataJson['message'];
      print(messageFromServer);

      int productAmount = int.parse(widget.imgAmount) - 1;

      for (int i = 0; i <= productAmount; i++) {
        nameList.add(messageFromServer[i][nameIdx].toString());
        sizeList.add(messageFromServer[i][sizeIdx].toString());
        imageList.add(messageFromServer[i][imageIdx].toString());
        costList.add(messageFromServer[i][costIdx].toString());
        brandList.add(messageFromServer[i][brandIdx].toString());
        productIDList.add(messageFromServer[i][productIdx].toString());
        availabilityList.add(messageFromServer[i][availabilityIdx].toString());
      }
      print(messageFromServer[0]);

      // availableList = List.filled(nameList.length, true);

      /**
       * Loops through the AvailabilityList String containing the current
       * availability of the menu items. It then adds them to availableList
       */
      for (int i = 0; i < availabilityList.length; i++) {
        bool availability = availabilityList[i] == 'True' ? true : false;
        availableList.add(availability);
      }

      setState(() {
        messageFromServer = messageFromServer;
      });
    });
  }

  sendDataToBackEnd(item, status) {
    print("test2");
    print(status);
    channel.sink.add(jsonEncode({
      'status': status,
      'id': item,
    }));
  }

  Widget listOfItems(int index, String nList, String sList, String iList,
      String cList, String bList, String pList, String pAvailable) {
    print("index: " + index.toString());
    bool available = availableList[index];
    print("available: " + available.toString());
    print("in List: " + availableList.toString());

    String message = available ? "available" : "not available";

    return GestureDetector(
      child: Opacity(
        opacity: available ? 1.0 : 0.4,
        child: Row(children: [
          Container(
            height: 300,
            width: 300,
            child: Image.network(
                "https://speedysnacks.s3.us-east-2.amazonaws.com/products/$iList"),
          ),
          Column(
            children: [
              Container(
                height: 100,
                width: 200,
                alignment: Alignment.center,
                child: Text(
                  nList,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 200,
                child: Text(
                  bList,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 200,
                child: Text(
                  "$sList grams",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                    // child: availableList[index]
                    //     ? Icon(Icons.check, color: Colors.green)
                    //     : Icon(Icons.close, color: Colors.red),
                    child: available
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                  ),
                  Container(
                    height: 80,
                    width: 120,
                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                    // child: availableList[index]
                    //     ? const Text("    Available")
                    //     : const Text("Out of Stock!"),
                    //child: Text("$pAvailable"),
                    child: Text(message),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                    child: Switch(
                      value: available,
                      onChanged: (bool value) {
                        // availableList[index] = Av;
                        setState(() {
                          print("~~~~~~~~~~~~~~~~~~~~~~in switch");
                          print(available);
                          availableList[index] = value;
                          sendDataToBackEnd(productIDList[index], value);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.fromLTRB(150, 40, 20, 20),
              child: Text(
                textAlign: TextAlign.center,
                "\$$cList",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(150, 170, 20, 10),
                  child: const Text("Edit"),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController controller =
                            TextEditingController(text: cList);
                        return AlertDialog(
                          title: const Text('Edit Price'),
                          content: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'Enter new cList value',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Save'),
                              onPressed: () {
                                setState(() {
                                  cList = controller.text;
                                  messageFromServer[0][3] = controller.text;
                                  messageFromServer = messageFromServer;
                                });

                                channel.sink.add(jsonEncode(
                                    {'new': controller.text, 'id': pList}));
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                }),
          ])
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: SideMenu(),
        appBar: AppBar(
          title: Text("${widget.imgLabel} Detail Screen"),
          backgroundColor: const Color.fromRGBO(212, 44, 37, 1.000),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InventoryScreen()));
              },
              icon: const Icon(Icons.backspace),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Inventory...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: nameList.length,
            itemBuilder: (BuildContext context, int index) {
              return listOfItems(
                index,
                nameList[index],
                sizeList[index],
                imageList[index],
                costList[index],
                brandList[index],
                productIDList[index],
                availabilityList[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              thickness: 2,
            ),
          );
        }));
  }
}
