import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/datasources/cache/shared_pref.dart';
import '../../core/models/SearchProfileDTO.dart';
import 'state_management/search_users_cubit.dart';
import 'state_management/search_users_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchUsersCubit(),
      child: const SearchScreenContent(),
    );
  }
}

class SearchScreenContent extends StatefulWidget {
  const SearchScreenContent({super.key});

  @override
  _SearchScreenContentState createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<SearchScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  String? _token;
  List<UserProfile> _displayedUsers = []; // Local list for UI display

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  Future<void> _fetchToken() async {
    final token = await CacheHelper.getData('token');
    setState(() {
      _token = token;
    });
  }

  void _removeUser(String profileId) {
    setState(() {
      _displayedUsers = _displayedUsers.where((user) => user.profileId != profileId).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Header(
              searchController: _searchController,
              onSearchChanged: (query) {
                if (_token != null) {
                  if (query.isNotEmpty) {
                    context.read<SearchUsersCubit>().searchUsers(_token!, query);
                  } else {
                    context.read<SearchUsersCubit>().clearSearch();
                    setState(() {
                      _displayedUsers = [];
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please log in to search users')),
                  );
                }
              },
            ),
            Expanded(
              child: SearchResultsList(
                onRemoveUser: _removeUser,
                displayedUsers: _displayedUsers,
                updateDisplayedUsers: (users) {
                  setState(() {
                    _displayedUsers = users;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const Header({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

class SearchResultItem extends StatelessWidget {
  final UserProfile user;
  final Function(String) onRemove;

  const SearchResultItem({
    super.key,
    required this.user,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: user.profilePicture != null
                ? NetworkImage(user.profilePicture!.secureUrl)
                : null,
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.role == 'Company'
                      ? user.companyName ?? user.username
                      : '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.role == 'Company' ? 'Company' : 'Job Seeker',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => onRemove(user.profileId),
          ),
        ],
      ),
    );
  }
}

class SearchResultsList extends StatelessWidget {
  final Function(String) onRemoveUser;
  final List<UserProfile> displayedUsers;
  final Function(List<UserProfile>) updateDisplayedUsers;

  const SearchResultsList({
    super.key,
    required this.onRemoveUser,
    required this.displayedUsers,
    required this.updateDisplayedUsers,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchUsersCubit, SearchUsersState>(
      listener: (context, state) {
        if (state is SearchUsersLoaded) {
          updateDisplayedUsers(state.users);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Recent',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchUsersCubit, SearchUsersState>(
              builder: (context, state) {
                if (state is SearchUsersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchUsersLoaded) {
                  if (displayedUsers.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }
                  return ListView.builder(
                    itemCount: displayedUsers.length,
                    itemBuilder: (context, index) {
                      final user = displayedUsers[index];
                      return SearchResultItem(
                        user: user,
                        onRemove: onRemoveUser,
                      );
                    },
                  );
                } else if (state is SearchUsersError) {
                  return const Center(child: Text('No results found'));
                } else {
                  return const Center(child: Text('Start searching for users'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}