/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/datasources/cache/shared_pref.dart';
import 'state_management/follower_cubit.dart';
import 'state_management/follower_state.dart';

class FollowerCubitTestScreen extends StatelessWidget {
  const FollowerCubitTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Follower Cubit Test')),
      body: BlocProvider(
        create: (context) => FollowerCubit(),
        child: const FollowerCubitTester(),
      ),
    );
  }
}

class FollowerCubitTester extends StatefulWidget {
  const FollowerCubitTester({super.key});

  @override
  State<FollowerCubitTester> createState() => _FollowerCubitTesterState();
}

class _FollowerCubitTesterState extends State<FollowerCubitTester> {
  late String _token;
  final String testUserId =
      "6841da7b765a1597bf51f5d6"; // Replace with actual test user ID

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = (await CacheHelper.getData('token')) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FollowerCubit, FollowerState>(
      listener: (context, state) {
        if (state is FollowerError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
        if (state is FollowerActionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Test Follow/Unfollow User
                  ElevatedButton(
                    onPressed: () {
                      context.read<FollowerCubit>().followOrUnfollowUser(
                        _token,
                        testUserId,
                      );
                    },
                    child: const Text('Follow/Unfollow User'),
                  ),
                  const SizedBox(height: 16),

                  // Test Get All Followers
                  ElevatedButton(
                    onPressed: () {
                      context.read<FollowerCubit>().getAllFollowers(_token);
                    },
                    child: const Text('Get All Followers'),
                  ),
                  const SizedBox(height: 16),

                  // Test Get All Following
                  ElevatedButton(
                    onPressed: () {
                      context.read<FollowerCubit>().getAllFollowing(_token);
                    },
                    child: const Text('Get All Following'),
                  ),
                  const SizedBox(height: 32),

                  // Display current state
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current State:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(state.toString()),
                          if (state is FollowersLoaded) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Followers List:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...state.followers.map(
                              (user) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      user.profilePicture?.secureUrl != null
                                          ? NetworkImage(
                                            user.profilePicture!.secureUrl,
                                          )
                                          : null,
                                  child:
                                      user.profilePicture?.secureUrl == null
                                          ? const Icon(Icons.person)
                                          : null,
                                ),
                                title: Text(user.username),
                                subtitle: Text(
                                  '${user.firstName} ${user.lastName}'.trim(),
                                ),
                              ),
                            ),
                          ],
                          if (state is FollowingLoaded) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Following List:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...state.following.map(
                              (user) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      user.profilePicture?.secureUrl != null
                                          ? NetworkImage(
                                            user.profilePicture!.secureUrl,
                                          )
                                          : null,
                                  child:
                                      user.profilePicture?.secureUrl == null
                                          ? const Icon(Icons.person)
                                          : null,
                                ),
                                title: Text(user.username),
                                subtitle: Text(
                                  '${user.firstName} ${user.lastName}'.trim(),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
*/