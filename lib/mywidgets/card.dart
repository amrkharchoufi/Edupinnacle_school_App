import 'package:flutter/material.dart';

class PlanningItem extends StatelessWidget {
  final String day;
  final List<String> tasks;
  final List<String> time;

  const PlanningItem({
    required this.day,
    required this.tasks,
    required this.time,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]),
                  leading: Text(
                    time[index],
                    style: TextStyle(fontSize: 15),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class acard extends StatelessWidget {
  final String id;
  final String link;
  acard({super.key, required this.id, required this.link, });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 5,
          color: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Colors.blueGrey, // Border color
              width: 1, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.science,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      id,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "myfont1"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
