import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state_management/applications_cubit.dart';
import '../state_management/applications_state.dart';
import 'application_card.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  late ApplicationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ApplicationsCubit();
    _cubit.fetchApplications();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _cubit.fetchApplications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: const Color(0xFF044463), // Dark blue
                  child: const Row(
                    children: [
                       Expanded(
                        child: Center(
                          child: Text(
                            'My Application',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<ApplicationsCubit, ApplicationsState>(
          builder: (context, state) {
            if (state is ApplicationsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ApplicationsError) {
              return Center(child: Text(state.message));
            } else if (state is ApplicationsLoaded) {
              final applications = state.applications;
              if (applications.isEmpty) {
                return const Center(child: Text('No applications found.'));
              }
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    return ApplicationCard(application: applications[index]);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
