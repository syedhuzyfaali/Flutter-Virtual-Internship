import 'package:flutter/material.dart';
import 'Program_details_Screen.dart'; 

class ProgramListing_Page extends StatelessWidget {
  final List<String> courses = <String>[
    'Python Beginner Course',
    'Flutter + Dart Intermediate Course',
    'Java Advanced Course',
    'Data Science with R',
    'Web Development with JavaScript',
    'Machine Learning Basics',
    'Cybersecurity Fundamentals',
    'Cloud Computing with AWS',
    'Mobile App Development with React Native',
    'Database Management with SQL'
  ];

  final List<String> courseInstructors = <String>[
    'Patricia Lopez',
    'Charles Gonzalez',
    'Jennifer Wilson',
    'Daniel Anderson',
    'Elizabeth Thomas',
    'Matthew Taylor',
    'Susan Moore',
    'Anthony Jackson',
    'Margaret White',
    'Mark Harris'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: true, // ✅ make the back arrow work
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
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        physics: const ClampingScrollPhysics(),
        itemCount: courses.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            tileColor: Colors.white,
            title: Text(
              courses[index],
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              courseInstructors[index],
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Color.fromARGB(255, 158, 158, 158),
              ),
            ),
            dense: false,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              side: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF8B8B8B),
              size: 18,
            ),

            // ✅ When user taps a course, navigate to details screen
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgramDetails_Screen(
                    title: courses[index],
                    instructor: courseInstructors[index],
                    description:
                        'This is a detailed description of ${courses[index]}. Here you can include what students will learn, prerequisites, and duration.',
                    imageUrl:
                        'https://via.placeholder.com/400x200?text=${Uri.encodeComponent(courses[index])}',
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 12),
      ),
    );
  }
}
