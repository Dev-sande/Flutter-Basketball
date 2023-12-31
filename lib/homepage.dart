// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model.dart';

class HomePage extends StatelessWidget {
  List<Team> teams = [];

  Future allTeams() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));

    var apiData = jsonDecode(response.body);

    for (var oneTeam in apiData['data']) {
      final team = Team(
        abbreviation: oneTeam['abbreviation'],
        city: oneTeam['city'],
      );
      teams.add(team);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: allTeams(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: teams.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                            title: Text(teams[index].abbreviation),
                            subtitle: Text(teams[index].city)),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
