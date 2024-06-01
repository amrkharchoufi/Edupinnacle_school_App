import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/registercard.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Ressourcedetail extends StatefulWidget {
  final id;
  const Ressourcedetail({super.key, required this.id});

  @override
  State<Ressourcedetail> createState() => _RessourcedetailState();
}

class _RessourcedetailState extends State<Ressourcedetail> {
  List<QueryDocumentSnapshot> data = [];
  bool isDataLoaded = false;

  void getdata() async {
    final classes;

    classes = FirebaseFirestore.instance
        .collection('reservation')
        .where('IDsalle', isEqualTo: widget.id);
    QuerySnapshot query = await classes.get();
    setState(() {
      data.clear();
      data.addAll(query.docs);
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Reservationadd(id: widget.id),
              ),
            );
            ;
            if (result == true) {
              getdata();
            }
          },
          child: FaIcon(FontAwesomeIcons.plus)),
      appBar: AppBar(
        title: Text(widget.id, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor:  AppColors.primaryColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'Reservations :',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    if (!isDataLoaded)
                      const Center(child: CircularProgressIndicator())
                    else if (data.isEmpty)
                      const Center(
                          child: Text(
                        "No Reservation found!",
                        style: TextStyle(fontSize: 17),
                      ))
                    else
                      for (int i = 0; i < data.length; i++)
                        Reservationcard(
                          start: data[i]['start'].toString(),
                          end: data[i]['end'].toString(),
                          date: data[i]['date'],
                          id: data[i]['IDreservateur'],
                          delete: () async {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: 'Delete Ressource',
                              desc:
                                  'Are you sure you want to delete this Ressource?',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('inventory')
                                      .doc(data[i].id)
                                      .delete();
                                      QuerySnapshot query = await FirebaseFirestore
                                .instance
                                .collection('reservation')
                                .where('IDsalle', isEqualTo: widget.id)
                                .get();
                            WriteBatch batch =
                                FirebaseFirestore.instance.batch();
                            for (var doc in query.docs) {
                              DocumentReference docToDelete = FirebaseFirestore
                                  .instance
                                  .collection('reservation')
                                  .doc(doc.id);
                              batch.delete(docToDelete);
                            }
                            await batch.commit(); // Await the batch commit
                                  getdata();
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.rightSlide,
                                    title: 'Success',
                                    desc: 'Ressource successfully deleted.',
                                    btnOkOnPress: () {
                                      // Optionally, you can also call Refresh() here
                                      // Refresh();
                                    },
                                  ).show();
                                } catch (e) {
                                  print('Error deleting document: $e');
                                }
                              },
                            ).show();
                          },
                        ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Reservationadd extends StatefulWidget {
  final id;
  const Reservationadd({super.key, this.id});

  @override
  State<Reservationadd> createState() => _ReservationaddState();
}

Future<bool> checkReservation(String date, int start, int end, String id) async {
  // Get a reference to the documents matching the date and room ID
  var query = await FirebaseFirestore.instance
      .collection('reservation')
      .where('date', isEqualTo: date)
      .where('IDsalle', isEqualTo: id)
      .get();

  // Loop through the documents to check for time conflicts
  for (var doc in query.docs) {
    int existingStart = doc['start'];
    int existingEnd = doc['end'];

    // Check if the desired reservation completely overlaps with an existing reservation
    if ((start <= existingStart && end >= existingEnd) ||
        (existingStart <= start && existingEnd >= end)) {
      // If there is a conflict, return true indicating that a reservation exists
      return true;
    }

    // Check if the desired reservation partially overlaps with an existing reservation
    if ((start >= existingStart && start < existingEnd) ||
        (end > existingStart && end <= existingEnd)) {
      // If there is a conflict, return true indicating that a reservation exists
      return true;
    }
  }

  // If no conflicts are found, return false indicating that no reservation exists
  return false;
}


class _ReservationaddState extends State<Reservationadd> {
  String? _selectedstart;
  String? _selectedend;
  final List<String> _dropdownItems = [
    '8',
    '9',
    '10',
    '11',
    '12',
    '14',
    '15',
    '16',
    '17',
    '18'
  ];
  TextEditingController date = TextEditingController();
  TextEditingController id = TextEditingController();
  GlobalKey<FormState> k = GlobalKey();
  void AddReservation(
      String date, int start, int end, String idsalle, String id) async {
    bool exist = await checkReservation(date, start, end, idsalle);
    if (!exist) {
      await FirebaseFirestore.instance.collection('reservation').doc().set({
        'IDsalle': idsalle,
        'date': date,
        'start': start,
        'end': end,
        'IDreservateur': id
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Success',
        desc: 'Reservatiom made with success !',
        btnOkOnPress: () {
          Navigator.pop(context, true);
        },
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'ERROR',
        desc: 'This time slot is not available. Existing reservation',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inventory",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor:  AppColors.primaryColor,
      ),
      body: Form(
        key: k,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Add Reservation",
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 80,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reservation for :",
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    Myinput(
                        label: 'Set Id ',
                        type: TextInputType.text,
                        obscure: false,
                        mycontrol: id),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Reservation date :",
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    Myinput1(
                        label: 'Set date',
                        type: TextInputType.datetime,
                        obscure: false,
                        mycontrol: date),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      " Start time :",
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 280,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: Colors.purple[50],
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        hint: Text('Select time'),
                        value: _selectedstart,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedstart = newValue;
                          });
                        },
                        items: _dropdownItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "End time :",
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 280,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: Colors.purple[50],
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        hint: Text('Select time'),
                        value: _selectedend,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedend = newValue;
                          });
                        },
                        items: _dropdownItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (k.currentState!.validate()) {
                        if (_selectedstart == null || _selectedend == null) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'ERROR',
                            desc: 'Please select both start time and end time',
                            btnOkOnPress: () {},
                          ).show();
                        } else {
                          int start = int.parse(_selectedstart!);
                          int end = int.parse(_selectedend!);

                          // Parse the input date
                          try {
                            DateTime inputDate =
                                DateFormat('yyyy-MM-dd').parse(date.text);
                            DateTime currentDate = DateTime.now();

                            // Check if the input date is not older than the current date
                            if (inputDate.isBefore(currentDate)) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'ERROR',
                                desc:
                                    'Please enter a date that is not in the past',
                                btnOkOnPress: () {},
                              ).show();
                            } else if (start >= end) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'ERROR',
                                desc: 'Start time should be before end time',
                                btnOkOnPress: () {},
                              ).show();
                            } else {
                              AddReservation(
                                  date.text, start, end, widget.id, id.text);
                            }
                          } catch (e) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'ERROR',
                              desc:
                                  'Invalid date format. Please use yyyy-MM-dd.',
                              btnOkOnPress: () {},
                            ).show();
                          }
                        }
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'ERROR',
                          desc: 'Please fill in all required fields',
                          btnOkOnPress: () {},
                        ).show();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Text("ADD"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
