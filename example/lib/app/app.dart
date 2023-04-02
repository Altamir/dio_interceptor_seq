import 'package:dio/dio.dart';
import 'package:dio_interceptor_seq/dio_interceptor_seq.dart';
import 'package:flutter/material.dart';

final seqLoggingInterceptor = SeqLoggingInterceptor(
  'http://localhost:5341',
  apiKey: "4HIZqcm9GtEvzyeNOf3f",
);

Dio? _dio;
Dio getDio() {
  if (_dio == null) {
    _dio = Dio();
    _dio!.interceptors.add(seqLoggingInterceptor);
  }
  return _dio!;
}

Future<List<dynamic>> searchGitHubUsers(String query) async {
  try {
    final response =
        await getDio().get('https://api.github.com/search/users?q=$query');
    return response.data['items'];
  } catch (e) {
    throw Exception('Failed to search GitHub users');
  }
}

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final searchController = TextEditingController();

  List<dynamic> users = [];

  void _searchGitHubUsers(String query) async {
    try {
      final results = await searchGitHubUsers(query);
      setState(() {
        users = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: (value) => _searchGitHubUsers(value),
          decoration: const InputDecoration(
            hintText: 'Search GitHub users',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading:
                CircleAvatar(backgroundImage: NetworkImage(user['avatar_url'])),
            title: Text(user['login']),
          );
        },
      ),
    );
  }
}
