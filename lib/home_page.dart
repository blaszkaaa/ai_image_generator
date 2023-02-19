import 'package:ai_image_generator/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //----------zamienne----------
  var sizes = ["Small", "Medium", "Large"];
  var values = ["256x256", "512x512", "1024x1024"];
  String? dropValue;
  var textController = TextEditingController();
  String image = "";
  var isLoaded = false;
  //----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [],
        centerTitle: true,
        title: const Text("AiGenerator"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: textController,
                            decoration: const InputDecoration(
                              hintText: "Write text",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: Icon(
                              Icons.expand_more,
                              color: Colors.grey[500],
                            ),
                            value: dropValue,
                            hint: const Text("Select size"),
                            items: List.generate(
                              sizes.length,
                              (index) => DropdownMenuItem(
                                value: values[index],
                                child: Text(sizes[index]),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                dropValue = value.toString();
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (textController.text.isNotEmpty &&
                          dropValue!.isNotEmpty) {
                        setState(() {
                          isLoaded = false;
                        });
                        image = await Api.generateImage(
                            textController.text, dropValue!);
                        setState(() {
                          isLoaded = true;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Please pass the query and select size"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Generate"),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: isLoaded
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.network(
                          image,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                  Icons.download_for_offline_rounded),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(8),
                                backgroundColor: Colors.grey[800],
                              ),
                              onPressed: () {
                                print("ZDJECIE: $image");
                                FileDownloader.downloadFile(
                                    url: image,
                                    name: image,
                                    onDownloadCompleted: (String path) {
                                      print('FILE DOWNLOADED TO PATH: $path');
                                    },
                                    onDownloadError: (String error) {
                                      print('DOWNLOAD ERROR: $error');
                                    });
                              },
                              label: const Text("Download"),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
