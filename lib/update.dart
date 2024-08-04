import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetdataPage extends StatefulWidget {
  @override
  _GetdataPageState createState() => _GetdataPageState();
}

class _GetdataPageState extends State<GetdataPage> {
  late Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchDataFromApi();
  }

  Future<List<Map<String, dynamic>>> fetchDataFromApi() async {
    try {
      final dio = Dio();

      final response = await dio.get('http://10.0.2.2:8081/getdta');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<Map<String, dynamic>> results = data.map((item) {
          return {
            'id': item['id'],
            'name': item['name'].toString(),
            'description': item['description'].toString(),
          };
        }).toList();
        return results;
      } else {
        print('Error: ${response.statusCode}');
        print('Error response: ${response.data}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch data. Check your internet connection.');
    }
  }

  Future<void> postDataToApi(String name, String description) async {
    try {
      final dio = Dio();

      final response = await dio.post(
        'http://10.0.2.2:8081/adddata',
        data: {
          'name': name,
          'description': description,
        },
      );

      if (response.statusCode == 200) {
        print('Data added successfully');

      } else {
        print('Error: ${response.statusCode}');
        print('Error response: ${response.data}');
        throw Exception('Failed to add data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to add data. Check your internet connection.');
    }
  }

  // Method to show a form in a dialog
  Future<void> _showAddDataForm() async {
    String name = '';
    String description = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 16.0.h),
                TextField(
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 16.0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Call the method to perform the POST request and add data
                        await postDataToApi(name, description);
                        // After posting data, you may choose to fetch the updated data
                        _dataFuture = fetchDataFromApi();
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Text('Add Data'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> updateDataToApi(int id, String name, String description) async {
    try {
      final dio = Dio();

      final response = await dio.put(
        'http://10.0.2.2:8081/updateuser/$id',
        data: {
          'name': name,
          'description': description,
        },
      );

      if (response.statusCode == 200) {
        print('Data updated successfully');

      } else {
        print('Error: ${response.statusCode}');
        print('Error response: ${response.data}');
        throw Exception('Failed to update data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update data. Check your internet connection.');
    }
  }

  // Method to show a form in a dialog
  // Future<void> _showUpdateDataForm() async {
  //   String name = '';
  //   String description = '';
  //
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Container(
  //           padding: EdgeInsets.all(16.0.h),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               TextField(
  //                 onChanged: (value) {
  //                   name = value;
  //                 },
  //                 decoration: InputDecoration(labelText: 'Name'),
  //               ),
  //               SizedBox(height: 16.0.h),
  //               TextField(
  //                 onChanged: (value) {
  //                   description = value;
  //                 },
  //                 decoration: InputDecoration(labelText: 'Description'),
  //               ),
  //               SizedBox(height: 16.0.h),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Text('Cancel'),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () async {
  //                       // Call the method to perform the PUT request and update data
  //                       await updateDataToApi(1, name, description); // replace 1 with the actual ID
  //                       // After updating data, you may choose to fetch the updated data
  //                       _dataFuture = fetchDataFromApi();
  //                       setState(() {
  //
  //                       });
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Text('Update Data'),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> deleteDataFromApi(int id) async {
    try {
      final dio = Dio();

      final response = await dio.delete(
        'http://10.0.2.2:8081/delete/$id',
      );

      if (response.statusCode == 200) {
        print('Data deleted successfully');

      } else {
        print('Error: ${response.statusCode}');
        print('Error response: ${response.data}');
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete data. Check your internet connection.');
    }
  }
  Future<void> _showEditDataForm(int id, String existingName, String existingDescription) async {
    String name = existingName;
    String description = existingDescription;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(text: name),
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 16.0.h),
                TextField(
                  controller: TextEditingController(text: description),
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 16.0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Call the method to perform the PUT request and update data
                        await updateDataToApi(id, name, description);
                        // After updating data, you may choose to fetch the updated data
                        List<Map<String, dynamic>> updatedData = await fetchDataFromApi();

                        // Update the state with the new data
                        setState(() {
                        _dataFuture = Future.value(updatedData);
                        });
                      },
                      child: Text('Update Data'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => Scaffold(
        appBar: AppBar(
          title: Text('Flutter Curd Application '),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final List<Map<String, dynamic>> data = snapshot.data ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Dismissible(
                          key: Key(item['id'].toString()),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            // Remove the item from the data source and make API delete request
                            setState(() {
                              data.removeAt(index);
                            });
                            deleteDataFromApi(item['id']);
                          },
                          background: Container(
                            color: Colors.transparent,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: Card(
                            margin: EdgeInsets.all(8.0.h),

                              child: InkWell(
                                onLongPress: () {
                                  // Show the edit data form when tapping on the ListTile
                                  _showEditDataForm(
                                    item['id'],
                                    item['name'],
                                    item['description'],
                                  );
                                },
                                child: ListTile(
                                  title: Text('Name: ${item['name']}'),
                                  subtitle: Text('Description: ${item['description']}'),
                                ),
                              ),

                            ),

                          );


                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        // Add your code to show the form or perform other actions
                        await _showAddDataForm();
                      },
                      tooltip: 'Add Data',
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
