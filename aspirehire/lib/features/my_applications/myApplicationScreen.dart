import 'package:flutter/material.dart';

class Myapplicationscreen extends StatefulWidget {
  const Myapplicationscreen({super.key});

  @override
  _MyapplicationscreenState createState() => _MyapplicationscreenState();
}

class _MyapplicationscreenState extends State<Myapplicationscreen> {
    @override
    Widget build(BuildContext context) {
    return  DefaultTabController(
       length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text("My Application", style: TextStyle(color: Colors.white, fontFamily: "Poppins")),
          ),
          backgroundColor: const Color(0xFF013E5D),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Keep it up, Mostafa",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,),),
            ),
            const SizedBox(height: 15,),
            const TabBar(
                      labelColor: Color(0xFF013E5D),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFF013E5D),
                      tabs: [
                        Tab(text: "All"),
                        Tab(text: "In Review"),
                        Tab(text: "Interviewing"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  children: const [],
                                ),
                              ),
                            ],
                          ),
            
                          Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  children: const [],
                                ),
                              ),
                            ],
                          ),
            
                          const Center(
                            child: Text(
                              "Interviewing List",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}

