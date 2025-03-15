import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/home_screen/components/HomeHeader.dart';
import 'package:aspirehire/features/home_screen/components/JobCard.dart';
import 'package:aspirehire/features/home_screen/components/MediaButtons.dart';
import 'package:aspirehire/features/home_screen/components/PostCard.dart';
import 'package:aspirehire/features/home_screen/components/PostJobButton.dart';
import '../../config/datasources/cache/shared_pref.dart';
import '../profile/state_management/profile_cubit.dart';
import '../profile/state_management/profile_state.dart';

class HomeScreenJobSeeker extends StatefulWidget {
  const HomeScreenJobSeeker({super.key});

  @override
  _HomeScreenJobSeekerState createState() => _HomeScreenJobSeekerState();
}

class _HomeScreenJobSeekerState extends State<HomeScreenJobSeeker> {
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final token = await CacheHelper.getData('token');
    if (token != null) {
      context.read<ProfileCubit>().getProfile(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return _buildSkeletonLoading();
        } else if (state is ProfileLoaded) {
          return _buildContent(state);
        } else if (state is ProfileError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('Initial State'));
        }
      },
    );
  }

  Widget _buildContent(ProfileLoaded state) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        HomeHeader(
          firstName: state.profile.firstName,
          lastName: state.profile.lastName,
          profilePicture: state.profile.profilePicture!.secureUrl,
        ),
        const SizedBox(height: 10),
        const PostJobButton(),
        const SizedBox(height: 10),
        const MediaButtons(),
        const SizedBox(height: 20),
        Container(height: 1, width: double.infinity, color: Color(0xFFFF804B)),
        const SizedBox(height: 20),
        SizedBox(
          height: 97,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              JobCard(
                jobTitle: 'Web Designer',
                company: 'hp',
                jobType: 'Part-time',
                location: 'Egypt, Cairo',
                logoPath: 'assets/logo.png',
                onClosePressed: null,
              ),
              SizedBox(width: 10),
              JobCard(
                jobTitle: 'Graphic Designer',
                company: 'Dell',
                jobType: 'Full-time',
                location: 'Egypt, Alexandria',
                logoPath: 'assets/logo.png',
                onClosePressed: null,
              ),
              SizedBox(width: 10),
              JobCard(
                jobTitle: 'UI/UX Designer',
                company: 'Google',
                jobType: 'Contract',
                location: 'Egypt, Giza',
                logoPath: 'assets/logo.png',
                onClosePressed: null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
        const PostCard(
          jobTitle: 'Mohannad Hossam',
          company: 'Dell',
          jobType: 'Full-time',
          location: 'Egypt, Cairo',
          description: """SOLID PRINCIPLES IN SOFTWARE DEVELOPMENT 

These principles establish practices for developing software with considerations for maintaining and extending it as the project grows. Adopting these practices can also help avoid code smells, refactor code, and develop Agile or Adaptive software.

SOLID stands for:

S - Single-responsibility Principle
O - Open-closed Principle
L - Liskov Substitution Principle
I - Interface Segregation Principle
D - Dependency Inversion Principle
In this article, you will be introduced to each principle individually to understand how SOLID can help make you a better developer.

Single-Responsibility Principle
Single-responsibility Principle (SRP) states:

A class should have one and only one reason to change, meaning that a class should have only one job.

For example, consider an application that takes a collection of shapes—circles and squares—and calculates the sum of the area of all the shapes in the collection.

First, create the shape classes and have the constructors set up the required parameters.

For squares, you will need to know the length of a side:
""",
        ),
      ],
    );
  }

  Widget _buildSkeletonLoading() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildShimmerEffect(height: 100),
        const SizedBox(height: 10),
        _buildShimmerEffect(height: 50),
        const SizedBox(height: 10),
        _buildShimmerEffect(height: 50),
        const SizedBox(height: 20),
        _buildShimmerEffect(height: 1),
        const SizedBox(height: 20),
        SizedBox(
          height: 97,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _buildShimmerEffect(width: 150, height: 97),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildShimmerEffect(height: 200),
        const SizedBox(height: 20),
        _buildShimmerEffect(height: 200),
      ],
    );
  }

  Widget _buildShimmerEffect({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
