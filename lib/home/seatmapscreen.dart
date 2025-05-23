import 'package:flutter/material.dart';

class SeatMapScreen extends StatelessWidget {
  final List<int> bookedSeats;

  SeatMapScreen({Key? key, required this.bookedSeats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check your seat"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stream, size: 40, color: Colors.black),
                  SizedBox(width: 10),
                  Text("Driver", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, rowIndex) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(3, (seatIndex) {
                            int seatNumber = rowIndex * 5 + seatIndex + 1;
                            bool isBooked = bookedSeats.contains(seatNumber);
                            return _seatWidget(seatNumber, isBooked);
                          }),
                        ),
                        SizedBox(width: 20),
                        Row(
                          children: List.generate(2, (seatIndex) {
                            int seatNumber = rowIndex * 5 + seatIndex + 4;
                            bool isBooked = bookedSeats.contains(seatNumber);
                            return _seatWidget(seatNumber, isBooked);
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seatWidget(int seatNumber, bool isBooked) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: isBooked ? null : () {},
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isBooked ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              "$seatNumber",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}