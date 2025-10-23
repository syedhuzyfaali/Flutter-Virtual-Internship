import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'program_details_screen.dart';

class Course {
  final String id;
  final String courseName;
  final String lecturer;
  final String courseImage;
  final String courseDescription;
  final String summary;
  final DateTime enrollDeadline;

  Course({
    required this.id,
    required this.courseName,
    required this.lecturer,
    required this.courseImage,
    required this.courseDescription,
    required this.summary,
    required this.enrollDeadline,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      courseName: json['courseName'],
      lecturer: json['lecturer'],
      courseImage: json['courseImage'],
      courseDescription: json['courseDescription'],
      summary: json['summary'],
      enrollDeadline: DateTime.parse(json['enrollDeadline']),
    );
  }
}

class ProgramListing_Page extends StatefulWidget {
  @override
  _ProgramListing_PageState createState() => _ProgramListing_PageState();
}

class _ProgramListing_PageState extends State<ProgramListing_Page> {
  List<Course> courses = [];
  bool isLoading = true;
  int currentPage = 1;
  static const int itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse('https://68f92c82deff18f212b8dd59.mockapi.io/api/data/Courses?page=$currentPage&limit=$itemsPerPage'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          courses = data.map((json) => Course.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading courses: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF4C94DC),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        title: const Text(
          "Program Listing",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: SpinKitCubeGrid(
                color: Color(0xFF4C94DC),
                size: 50.0,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    physics: const ClampingScrollPhysics(),
                    itemCount: courses.length,
                    itemBuilder: (BuildContext context, int index) {
                      final course = courses[index];
                      return ListTile(
                        tileColor: Colors.white,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.courseName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              course.summary,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.lecturer,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Color.fromARGB(255, 158, 158, 158),
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Apply before: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${course.enrollDeadline.day}/${course.enrollDeadline.month}/${course.enrollDeadline.year}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        dense: false,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          side: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF8B8B8B),
                          size: 18,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProgramDetails_Screen(
                                courseId: course.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: currentPage > 1
                            ? () {
                                setState(() {
                                  currentPage--;
                                  fetchCourses();
                                });
                              }
                            : null,
                        child: Text('Previous'),
                      ),
                      SizedBox(width: 16),
                      Text('Page $currentPage'),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: courses.length == itemsPerPage
                            ? () {
                                setState(() {
                                  currentPage++;
                                  fetchCourses();
                                });
                              }
                            : null,
                        child: Text('Next'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
