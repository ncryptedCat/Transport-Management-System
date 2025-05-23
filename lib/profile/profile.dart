import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  String selectedGender = "Female";
  String selectedBranch = "CSE";
  String selectedYear = "3rd Year";
  String selectedSpecialization = "AI & ML";
  String selectedSemester = "6th Semester";
  String profileImage = '';

  final List<String> genderOptions = ["Male", "Female"];
  final List<String> branchOptions = ["CSE", "ECE"];
  final List<String> yearOptions = ["1st Year", "2nd Year", "3rd Year", "4th Year"];
  final List<String> specializationOptions = ["AI & ML", "Cybersecurity", "Data Science", "IoT"];
  final List<String> semesterOptions = [
    "1st Semester", "2nd Semester", "3rd Semester", "4th Semester",
    "5th Semester", "6th Semester", "7th Semester", "8th Semester"
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data() ?? {};

    setState(() {
      nameController.text = data['name'] ?? '-';
      emailController.text = data['email'] ?? '-';
      userNameController.text = data['userName'] ?? '-';
      phoneController.text = data['mobileNumber'] ?? '-';
      dobController.text = data['dateOfBirth'] ?? '-';
      selectedGender = data['gender'] ?? selectedGender;
      profileImage = data['profileImage'] ?? '';
      selectedBranch = data['branch'] ?? selectedBranch;
      selectedYear = data['year'] ?? selectedYear;
      selectedSpecialization = data['specialization'] ?? selectedSpecialization;
      selectedSemester = data['semester'] ?? selectedSemester;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2003, 3, 15),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> saveChanges() async {
    final fields = [
      nameController.text,
      emailController.text,
      userNameController.text,
      phoneController.text,
      dobController.text,
      selectedGender,
      selectedBranch,
      selectedYear,
      selectedSpecialization,
      selectedSemester,
    ];

    if (fields.any((field) => field.trim().isEmpty || field == '-')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields before saving.')),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final data = {
      'name': nameController.text,
      'email': emailController.text,
      'mobileNumber': phoneController.text,
      'userName': userNameController.text,
      'dateOfBirth': dobController.text,
      'gender': selectedGender,
      'branch': selectedBranch,
      'year': selectedYear,
      'specialization': selectedSpecialization,
      'semester': selectedSemester,
      'profileImage': profileImage,
    };

    await FirebaseFirestore.instance.collection('users').doc(uid).update(data);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully')),
    );
    getData();
    setState(() => isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFf7f7f7),
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit, color: Colors.purple),
            onPressed: () {
              setState(() => isEditing = !isEditing);
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: profileImage.isNotEmpty
                            ? FileImage(File(profileImage)) as ImageProvider
                            : null,
                        child: profileImage.isEmpty
                            ? Icon(Icons.person, size: 70, color: Colors.grey)
                            : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(nameController.text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Text("Personal Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildCard([
              _buildInfoRow("Full Name", nameController),
              _buildInfoRow("Email Address", emailController, isEditable: false),
              _buildInfoRow("UserName", userNameController),
              _buildInfoRow("Phone Number", phoneController),
              _buildDatePickerRow("Date of Birth", dobController),
              _buildDropdownRow("Gender", genderOptions, selectedGender, (value) {
                setState(() => selectedGender = value!);
              }),
            ]),
            SizedBox(height: 20),
            Text("Academic Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildCard([
              _buildDropdownRow("Branch", branchOptions, selectedBranch, (value) {
                setState(() => selectedBranch = value!);
              }),
              _buildDropdownRow("Current Year", yearOptions, selectedYear, (value) {
                setState(() => selectedYear = value!);
              }),
              _buildDropdownRow("Specialization", specializationOptions, selectedSpecialization, (value) {
                setState(() => selectedSpecialization = value!);
              }),
              _buildDropdownRow("Current Semester", semesterOptions, selectedSemester, (value) {
                setState(() => selectedSemester = value!);
              }),
            ]),
            SizedBox(height: 20),
            if (isEditing)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: saveChanges,
                  child: Text("Save Changes", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, TextEditingController controller, {bool isEditable = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
          SizedBox(height: 4),
          isEditing && isEditable
              ? TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ) : Text(
            controller.text.isEmpty ? '-' : controller.text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow(String title, List<String> options, String selectedValue, Function(String?) onChanged) {
    return _buildRow(
      title,
      isEditing
          ? DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
        items: options.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
        onChanged: onChanged,
      ) : Text(selectedValue, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildDatePickerRow(String title, TextEditingController controller) {
    return _buildRow(
      title,
      isEditing
          ? TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          suffixIcon: Icon(Icons.calendar_today),
        ),
      ) : Text(
        controller.text.isEmpty ? '-' : controller.text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildRow(String title, Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
          SizedBox(height: 4),
          child,
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
