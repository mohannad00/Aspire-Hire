import 'package:flutter/material.dart';
import '../../../core/models/UserProfile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state_management/profile_cubit.dart';
import '../../../core/models/UpdateProfileRequest.dart';
import 'package:aspirehire/config/datasources/cache/shared_pref.dart';

class AddLinksScreen extends StatefulWidget {
  final String? github;
  final String? twitter;
  const AddLinksScreen({Key? key, this.github, this.twitter}) : super(key: key);

  @override
  State<AddLinksScreen> createState() => _AddLinksScreenState();
}

class _AddLinksScreenState extends State<AddLinksScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _githubController;
  late TextEditingController _twitterController;
  bool _loading = false;
  String? _error;
  late String? _githubError;
  late String? _twitterError;

  @override
  void initState() {
    super.initState();
    _githubController = TextEditingController(text: widget.github ?? '');
    _twitterController = TextEditingController(text: widget.twitter ?? '');
    _githubError = null;
    _twitterError = null;
    _githubController.addListener(_validateFields);
    _twitterController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _githubController.dispose();
    _twitterController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _githubError = _validateUrl(_githubController.text.trim(), 'GitHub');
      _twitterError = _validateUrl(_twitterController.text.trim(), 'X');
    });
  }

  Future<void> _saveLinks() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cubit = context.read<ProfileCubit>();
      final token = await _getToken();
      if (token == null) throw Exception('No auth token');
      final req = UpdateProfileRequest(
        github:
            _githubController.text.trim().isEmpty
                ? null
                : _githubController.text.trim(),
        twitter:
            _twitterController.text.trim().isEmpty
                ? null
                : _twitterController.text.trim(),
      );
      await cubit.updateProfile(token, req);
      // Wait for success state
      if (!mounted) return;
      Navigator.of(context).pop(true); // Return true to trigger refresh
    } catch (e) {
      setState(() {
        _error = 'Failed to update links.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<String?> _getToken() async {
    return await CacheHelper.getData('token');
  }

  String? _validateUrl(String? value, String type) {
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !(uri.isAbsolute && (uri.scheme == 'https' || uri.scheme == 'http'))) {
      return 'Enter a valid $type URL';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = (_githubError == null && _twitterError == null);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Add Web Links',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF013E5D),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add or Edit Web Links',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _githubController,
                          decoration: InputDecoration(
                            labelText: 'GitHub Link',
                            prefixIcon: const Icon(Icons.code),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorText: _githubError,
                          ),
                          onChanged: (_) => _validateFields(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _twitterController,
                          decoration: InputDecoration(
                            labelText: 'X (Twitter) Link',
                            prefixIcon: const Icon(Icons.alternate_email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorText: _twitterError,
                          ),
                          onChanged: (_) => _validateFields(),
                        ),
                        const SizedBox(height: 20),
                        if (_githubController.text.isNotEmpty ||
                            _twitterController.text.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Preview:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              if (_githubController.text.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.code,
                                      color: Color(0xFF24292F),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        _githubController.text,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (_twitterController.text.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.alternate_email,
                                      color: Color(0xFF1DA1F2),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        _twitterController.text,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                (_loading || !isFormValid) ? null : _saveLinks,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF013E5D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                _loading
                                    ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      'Save',
                                      style: TextStyle(fontSize: 18),
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
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
