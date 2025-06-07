import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/features/community/state_management/friend_state.dart';

import '../../config/datasources/cache/shared_pref.dart';
import 'state_management/friend_cubit.dart';

class FriendCubitTestScreen extends StatelessWidget {
  const FriendCubitTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friend Cubit Test')),
      body: BlocProvider(
        create: (context) => FriendCubit(),
        child: const FriendCubitTester(),
      ),
    );
  }
}

class FriendCubitTester extends StatefulWidget {
  const FriendCubitTester({super.key});

  @override
  State<FriendCubitTester> createState() => _FriendCubitTesterState();
}

class _FriendCubitTesterState extends State<FriendCubitTester> {
  late String _token;
  final String testUserId = "6841da7b765a1597bf51f5d6"; // Replace with actual test user ID

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
    return BlocConsumer<FriendCubit, FriendState>(
      listener: (context, state) {
        if (state is FriendError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
        if (state is FriendRequestSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is FriendRequestApproved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is FriendUnfriended) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Test Send/Cancel Friend Request
              ElevatedButton(
                onPressed: () {
                  context.read<FriendCubit>().sendOrCancelFriendRequest(_token, testUserId);
                },
                child: const Text('Send Friend Request'),
              ),
              const SizedBox(height: 16),

              // Test Approve Friend Request
              ElevatedButton(
                onPressed: () {
                  context.read<FriendCubit>().approveOrDeclineFriendRequest(
                    _token, 
                    testUserId, 
                    true, // Approve
                  );
                },
                child: const Text('Approve Friend Request'),
              ),
              const SizedBox(height: 16),

              // Test Reject Friend Request
              ElevatedButton(
                onPressed: () {
                  context.read<FriendCubit>().approveOrDeclineFriendRequest(
                    _token, 
                    testUserId, 
                    false, // Reject
                  );
                },
                child: const Text('Reject Friend Request'),
              ),
              const SizedBox(height: 16),

              // Test Unfriend
              ElevatedButton(
                onPressed: () {
                  context.read<FriendCubit>().unfriendUser(_token, testUserId);
                },
                child: const Text('Unfriend User'),
              ),
              const SizedBox(height: 16),

              // Test Get All Friends
              ElevatedButton(
                onPressed: () {
                  context.read<FriendCubit>().getAllFriends(_token);
                },
                child: const Text('Get All Friends'),
              ),
              const SizedBox(height: 16),

              // Test Get All Friend Requests
              ElevatedButton(
                onPressed: () {
                  context.read<FriendCubit>().getAllFriendRequests(_token);
                },
                child: const Text('Get Friend Requests'),
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
                      if (state is FriendsLoaded) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Friends List:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...state.friends.map((user) => Text(
                          '${user.firstName} ${user.lastName} (${user.username})',
                        )).toList(),
                      ],
                      if (state is FriendRequestsLoaded) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Friend Requests:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...state.requests.map((req) => Text(
                          '${req.requester?.username} ${req.requester?.lastName}',
                        )).toList(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}